USE QL_PHONGKHAMDALIEU_New;
GO

-- ============================================================
-- SP 1: TIẾP NHẬN BỆNH NHÂN AN TOÀN (ACID TRANSACTION)
-- Gọi từ: frmTiepNhanBenhNhan (Lễ tân)
-- Bao gồm 3 bước nguyên tử:
--   B1: INSERT PhieuKham (TrangThai = 0 — Chờ khám)
--   B2: INSERT ChiTietDichVu (lấy giá động từ DichVu)
--   B3: INSERT HoaDon (TrangThai = 0 — Chưa thanh toán)
-- Rollback 100% nếu bất kỳ bước nào thất bại
-- ============================================================
CREATE PROCEDURE SP_TiepNhanBenhNhan_AnToan
    @MaBenhNhan     INT,
    @MaBacSi        INT,
    @TrieuChung     NVARCHAR(500),
    @MaDichVuCoBan  INT  = 1,    -- [SỬA] Tham số, mặc định DV khám tổng quát
    @MaLichHen      INT  = NULL  -- [MỚI] Liên kết lịch hẹn nếu BN đã đặt trước
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra bác sĩ tồn tại và đúng vai trò
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaBacSi AND MaVaiTro = 2)
        BEGIN
            RAISERROR(N'Không tìm thấy bác sĩ có mã %d.', 16, 1, @MaBacSi);
            RETURN;
        END

        -- Kiểm tra bệnh nhân tồn tại
        IF NOT EXISTS (SELECT 1 FROM BenhNhan WHERE MaBenhNhan = @MaBenhNhan)
        BEGIN
            RAISERROR(N'Không tìm thấy bệnh nhân có mã %d.', 16, 1, @MaBenhNhan);
            RETURN;
        END

        -- [SỬA] Lấy giá dịch vụ cơ bản ĐỘNG từ bảng DichVu (không hardcode)
        DECLARE @GiaDichVuCoBan DECIMAL(18,2);
        SELECT  @GiaDichVuCoBan = DonGia FROM DichVu WHERE MaDichVu = @MaDichVuCoBan;

        IF @GiaDichVuCoBan IS NULL
        BEGIN
            RAISERROR(N'Dịch vụ mã %d không tồn tại. Kiểm tra lại MaDichVuCoBan.', 16, 1, @MaDichVuCoBan);
            RETURN;
        END

        BEGIN TRAN;

        -- BƯỚC 1: TẠO PHIẾU KHÁM
        INSERT INTO PhieuKham (MaBenhNhan, MaBacSi, MaLichHen, NgayKham, TrieuChung, TrangThai)
        VALUES (@MaBenhNhan, @MaBacSi, @MaLichHen, GETDATE(), @TrieuChung, 0);
        -- TrangThai = 0: Chờ khám

        DECLARE @MaPhieuKhamMoi INT = SCOPE_IDENTITY();

        -- BƯỚC 2: THÊM DỊCH VỤ CƠ BẢN (giá lấy từ DB)
        INSERT INTO ChiTietDichVu (MaPhieuKham, MaDichVu, SoLuong, ThanhTien)
        VALUES (@MaPhieuKhamMoi, @MaDichVuCoBan, 1, @GiaDichVuCoBan);

        -- BƯỚC 3: KHỞI TẠO HÓA ĐƠN CHỜ THANH TOÁN
        -- TongTien = giá dịch vụ cơ bản, sẽ được cập nhật khi bác sĩ thêm dịch vụ/thuốc
        INSERT INTO HoaDon (MaPhieuKham, TongTien, GiamGia, TienKhachTra, TrangThai)
        VALUES (@MaPhieuKhamMoi, @GiaDichVuCoBan, 0, 0, 0);
        -- TienKhachTra = 0 vì chưa thu tiền, sẽ cập nhật lúc thanh toán

        -- Nếu có lịch hẹn, cập nhật TrangThai lịch hẹn sang "Đang khám" (tránh đặt trùng)
        IF @MaLichHen IS NOT NULL
        BEGIN
            UPDATE LichHen SET TrangThai = 2 WHERE MaLichHen = @MaLichHen;
        END

        COMMIT TRAN;

        SELECT
            @MaPhieuKhamMoi    AS MaPhieuKham,
            @GiaDichVuCoBan    AS GiaDichVuCoBan,
            N'Tiếp nhận thành công! Phiếu khám và hóa đơn đã được tạo.' AS ThongBao;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @Loi NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Loi, 16, 1);
    END CATCH
END;
GO


-- ============================================================
-- SP 2: ĐẶT LỊCH HẸN (CHỐNG TRÙNG ±29 PHÚT)
-- Gọi từ: frmDatLichHen (Lễ tân)
-- ============================================================
CREATE PROCEDURE SP_DatLichHenMoi
    @MaBenhNhan  INT,
    @MaBacSi     INT,
    @ThoiGianHen DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra bác sĩ tồn tại
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaBacSi AND MaVaiTro = 2)
    BEGIN
        RAISERROR(N'Không tìm thấy bác sĩ có mã %d.', 16, 1, @MaBacSi);
        RETURN;
    END

    -- Kiểm tra lịch trùng: Bác sĩ đã có lịch trong ±29 phút?
    DECLARE @SoLichTrung INT;
    SELECT @SoLichTrung = COUNT(*)
    FROM   LichHen
    WHERE  MaBacSi   = @MaBacSi
      AND  TrangThai IN (1, 2)    -- 1: Chờ khám, 2: Đã xong (vẫn chiếm slot)
      AND  ThoiGianHen >= DATEADD(MINUTE, -29, @ThoiGianHen)
      AND  ThoiGianHen <= DATEADD(MINUTE,  29, @ThoiGianHen);

    IF @SoLichTrung > 0
    BEGIN
        RAISERROR(N'Bác sĩ đã có lịch hẹn trong khung giờ này. Vui lòng chọn giờ khác (cách ít nhất 30 phút).', 16, 1);
        RETURN;
    END

    -- Đặt lịch thành công
    INSERT INTO LichHen (MaBenhNhan, MaBacSi, ThoiGianHen, TrangThai)
    VALUES (@MaBenhNhan, @MaBacSi, @ThoiGianHen, 1);
    -- TrangThai = 1: Chờ khám

    DECLARE @MaLichMoi INT = SCOPE_IDENTITY();
    SELECT @MaLichMoi AS MaLichHen, N'Đặt lịch hẹn thành công!' AS ThongBao;
END;
GO


-- ============================================================
-- SP 3: THANH TOÁN HÓA ĐƠN  [MỚI]
-- Gọi từ: frmThanhToan (Lễ tân)
-- Tính lại TongTien từ ChiTietDichVu + ChiTietDonThuoc (không trust số cũ)
-- Cập nhật HoaDon và chuyển TrangThai PhieuKham sang 3 (Hoàn thành)
-- ============================================================
CREATE PROCEDURE SP_ThanhToan
    @MaPhieuKham            INT,
    @GiamGia                DECIMAL(18,2) = 0,
    @TienKhachTra           DECIMAL(18,2),
    @PhuongThucThanhToan    NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra hóa đơn tồn tại và chưa thanh toán
    DECLARE @MaHoaDon INT;
    DECLARE @TrangThaiHD BIT;
    SELECT @MaHoaDon = MaHoaDon, @TrangThaiHD = TrangThai
    FROM   HoaDon WHERE MaPhieuKham = @MaPhieuKham;

    IF @MaHoaDon IS NULL
    BEGIN
        RAISERROR(N'Không tìm thấy hóa đơn cho phiếu khám %d.', 16, 1, @MaPhieuKham);
        RETURN;
    END

    IF @TrangThaiHD = 1
    BEGIN
        RAISERROR(N'Hóa đơn này đã được thanh toán rồi.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;

        -- Tính lại TongTien động từ dịch vụ + thuốc thực tế
        DECLARE @TongDichVu DECIMAL(18,2) = 0;
        DECLARE @TongThuoc  DECIMAL(18,2) = 0;

        SELECT @TongDichVu = ISNULL(SUM(ThanhTien), 0)
        FROM ChiTietDichVu WHERE MaPhieuKham = @MaPhieuKham;

        SELECT @TongThuoc = ISNULL(SUM(t.DonGia * ctd.SoLuong), 0)
        FROM ChiTietDonThuoc ctd
        INNER JOIN Thuoc t ON ctd.MaThuoc = t.MaThuoc
        WHERE ctd.MaPhieuKham = @MaPhieuKham;

        DECLARE @TongTienThucTe DECIMAL(18,2) = @TongDichVu + @TongThuoc;

        -- Cập nhật hóa đơn
        UPDATE HoaDon
        SET TongTien              = @TongTienThucTe,
            GiamGia               = @GiamGia,
            TienKhachTra          = @TienKhachTra,
            PhuongThucThanhToan   = @PhuongThucThanhToan,
            NgayThanhToan         = GETDATE(),
            TrangThai             = 1
        WHERE MaHoaDon = @MaHoaDon;

        -- Cập nhật trạng thái phiếu khám sang Hoàn thành (3)
        UPDATE PhieuKham SET TrangThai = 3 WHERE MaPhieuKham = @MaPhieuKham;

        -- Cập nhật lịch hẹn liên kết sang Đã hoàn thành (2)
        UPDATE LichHen SET TrangThai = 2
        FROM   LichHen lh
        INNER JOIN PhieuKham pk ON lh.MaLichHen = pk.MaLichHen
        WHERE  pk.MaPhieuKham = @MaPhieuKham;

        COMMIT TRAN;

        SELECT
            @TongTienThucTe AS TongTien,
            @GiamGia        AS GiamGia,
            @TongTienThucTe - @GiamGia AS ThucThu,
            @TienKhachTra   - (@TongTienThucTe - @GiamGia) AS TienThua,
            N'Thanh toán thành công!' AS ThongBao;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @Loi NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Loi, 16, 1);
    END CATCH
END;
GO


-- ============================================================
-- KIỂM TRA
-- ============================================================
PRINT N'--- TEST SP NGHIỆP VỤ ---';

-- Test 1: Tiếp nhận hợp lệ (tham số đầy đủ, giá lấy động)
PRINT N'Test 1: Tiếp nhận bệnh nhân...';
BEGIN TRY
    EXEC SP_TiepNhanBenhNhan_AnToan
        @MaBenhNhan    = 1,
        @MaBacSi       = 2,
        @TrieuChung    = N'Nổi mụn cằm sau kỳ kinh',
        @MaDichVuCoBan = 1;
    PRINT N'-> PASS';
END TRY
BEGIN CATCH
    PRINT N'-> FAIL: ' + ERROR_MESSAGE();
END CATCH

-- Test 2: Tiếp nhận với bác sĩ không tồn tại
PRINT N'Test 2: Bác sĩ mã 999...';
BEGIN TRY
    EXEC SP_TiepNhanBenhNhan_AnToan @MaBenhNhan=1, @MaBacSi=999, @TrieuChung=N'Test';
    PRINT N'-> FAIL: Không nên thành công!';
END TRY
BEGIN CATCH
    PRINT N'-> PASS (Đã chặn): ' + ERROR_MESSAGE();
END CATCH

-- Test 3: Đặt lịch hẹn
PRINT N'Test 3: Đặt lịch hẹn hợp lệ...';
BEGIN TRY
    EXEC SP_DatLichHenMoi @MaBenhNhan=1, @MaBacSi=2, @ThoiGianHen='2026-04-01 09:00:00';
    PRINT N'-> PASS';
END TRY
BEGIN CATCH
    PRINT N'-> FAIL: ' + ERROR_MESSAGE();
END CATCH

-- Test 4: Đặt trùng lịch (cách 10 phút)
PRINT N'Test 4: Đặt lịch trùng (09:10 cùng bác sĩ)...';
BEGIN TRY
    EXEC SP_DatLichHenMoi @MaBenhNhan=2, @MaBacSi=2, @ThoiGianHen='2026-04-01 09:10:00';
    PRINT N'-> FAIL: Hệ thống không chặn trùng!';
END TRY
BEGIN CATCH
    PRINT N'-> PASS (Đã chặn): ' + ERROR_MESSAGE();
END CATCH

PRINT N'--- HOÀN TẤT TEST ---';
GO
