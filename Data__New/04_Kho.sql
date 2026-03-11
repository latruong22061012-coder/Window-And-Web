USE QL_PHONGKHAMDALIEU_New;
GO

-- ============================================================
-- SP: KÊ ĐƠN THUỐC THEO THUẬT TOÁN FIFO/FEFO
-- Gọi từ: frmKeDonThuoc (Bác sĩ)
-- Thuật toán: Xuất lô gần hết hạn nhất trước (FEFO = FIFO theo HanSuDung ASC)
-- ============================================================
CREATE PROCEDURE SP_KeDonThuoc_FIFO
    @MaPhieuKham  INT,
    @MaThuoc      INT,
    @SoLuongKe    INT,
    @LieuDung     NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. KIỂM TRA TỒN KHO TỔNG (Chặn bán âm)
    DECLARE @TonKhoHienTai INT;
    SELECT @TonKhoHienTai = SoLuongTon FROM Thuoc WHERE MaThuoc = @MaThuoc;

    IF @TonKhoHienTai IS NULL
    BEGIN
        RAISERROR(N'Thuốc có mã %d không tồn tại trong hệ thống.', 16, 1, @MaThuoc);
        RETURN;
    END

    IF @TonKhoHienTai < @SoLuongKe
    BEGIN
        DECLARE @Loi NVARCHAR(200) =
            N'Thuốc chỉ còn tồn ' + CAST(@TonKhoHienTai AS NVARCHAR) +
            N' đơn vị, không đủ để kê ' + CAST(@SoLuongKe AS NVARCHAR) + N' đơn vị!';
        RAISERROR(@Loi, 16, 1);
        RETURN;
    END

    -- [MỚI] 2. KIỂM TRA CÁC LÔ CHƯA HẾT HẠN
    -- Đảm bảo không xuất lô đã hết hạn cho bệnh nhân
    DECLARE @TonKhoConHan INT;
    SELECT @TonKhoConHan = ISNULL(SUM(SoLuongConLai), 0)
    FROM ChiTietNhapKho
    WHERE MaThuoc = @MaThuoc
      AND SoLuongConLai > 0
      AND HanSuDung > GETDATE();

    IF @TonKhoConHan < @SoLuongKe
    BEGIN
        DECLARE @LoiHan NVARCHAR(300) =
            N'Chỉ còn ' + CAST(@TonKhoConHan AS NVARCHAR) +
            N' đơn vị chưa hết hạn. Không đủ để kê ' + CAST(@SoLuongKe AS NVARCHAR) + N' đơn vị!';
        RAISERROR(@LoiHan, 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;

        -- 3. GHI NHẬN VÀO CHI TIẾT ĐƠN THUỐC
        INSERT INTO ChiTietDonThuoc (MaPhieuKham, MaThuoc, SoLuong, LieuDung)
        VALUES (@MaPhieuKham, @MaThuoc, @SoLuongKe, @LieuDung);

        -- 4. TRỪ TỒN KHO TỔNG
        UPDATE Thuoc
        SET SoLuongTon = SoLuongTon - @SoLuongKe
        WHERE MaThuoc = @MaThuoc;

        -- 5. THUẬT TOÁN FEFO (FIFO theo HanSuDung ASC — xuất lô cận date trước)
        DECLARE @SoLuongCanTru  INT = @SoLuongKe;
        DECLARE @CurPhieuNhap   INT;
        DECLARE @CurSoLuongLo   INT;

        -- [SỬA] Chỉ lấy các lô CHƯA hết hạn, ưu tiên cận date nhất
        DECLARE Cur_FEFO CURSOR FOR
        SELECT MaPhieuNhap, SoLuongConLai
        FROM   ChiTietNhapKho
        WHERE  MaThuoc = @MaThuoc
          AND  SoLuongConLai > 0
          AND  HanSuDung > GETDATE()       -- Bỏ qua lô đã hết hạn
        ORDER BY HanSuDung ASC;            -- Cận date nhất lên đầu

        OPEN Cur_FEFO;
        FETCH NEXT FROM Cur_FEFO INTO @CurPhieuNhap, @CurSoLuongLo;

        WHILE @@FETCH_STATUS = 0 AND @SoLuongCanTru > 0
        BEGIN
            IF @CurSoLuongLo >= @SoLuongCanTru
            BEGIN
                -- Lô này đủ hàng → trừ xong, dừng vòng lặp
                UPDATE ChiTietNhapKho
                SET    SoLuongConLai = SoLuongConLai - @SoLuongCanTru
                WHERE  MaPhieuNhap = @CurPhieuNhap AND MaThuoc = @MaThuoc;

                SET @SoLuongCanTru = 0;
            END
            ELSE
            BEGIN
                -- Lô này không đủ → vét sạch lô, chuyển sang lô tiếp theo
                UPDATE ChiTietNhapKho
                SET    SoLuongConLai = 0
                WHERE  MaPhieuNhap = @CurPhieuNhap AND MaThuoc = @MaThuoc;

                SET @SoLuongCanTru = @SoLuongCanTru - @CurSoLuongLo;
            END

            FETCH NEXT FROM Cur_FEFO INTO @CurPhieuNhap, @CurSoLuongLo;
        END

        CLOSE Cur_FEFO;
        DEALLOCATE Cur_FEFO;

        COMMIT TRAN;
        SELECT N'Kê đơn thành công theo thuật toán FEFO!' AS ThongBao;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO


-- ============================================================
-- SP: CẬP NHẬT TRẠNG THÁI PHIẾU KHÁM  [MỚI]
-- Gọi từ: frmDanhSachChoKham (Bác sĩ), frmThanhToan (Lễ tân)
-- Bảo đảm trạng thái chuyển đúng thứ tự: 0→1→2→3
-- ============================================================
CREATE PROCEDURE SP_CapNhatTrangThaiPhieuKham
    @MaPhieuKham   INT,
    @TrangThaiMoi  TINYINT
    -- 0: Chờ khám | 1: Đang khám | 2: Chờ thanh toán | 3: Hoàn thành
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TrangThaiHienTai TINYINT;
    SELECT @TrangThaiHienTai = TrangThai FROM PhieuKham WHERE MaPhieuKham = @MaPhieuKham;

    IF @TrangThaiHienTai IS NULL
    BEGIN
        RAISERROR(N'Phiếu khám %d không tồn tại.', 16, 1, @MaPhieuKham);
        RETURN;
    END

    -- Chặn chuyển ngược hoặc bỏ bước
    IF @TrangThaiMoi <> @TrangThaiHienTai + 1
    BEGIN
        RAISERROR(N'Chuyển trạng thái không hợp lệ. Hiện tại: %d, Cố chuyển sang: %d.', 16, 1, @TrangThaiHienTai, @TrangThaiMoi);
        RETURN;
    END

    UPDATE PhieuKham SET TrangThai = @TrangThaiMoi WHERE MaPhieuKham = @MaPhieuKham;

    -- Khi hoàn thành (TrangThai = 3), cập nhật TrangThai LichHen sang 2 (Đã xong)
    IF @TrangThaiMoi = 3
    BEGIN
        UPDATE LichHen SET TrangThai = 2
        FROM   LichHen lh
        INNER JOIN PhieuKham pk ON lh.MaLichHen = pk.MaLichHen
        WHERE  pk.MaPhieuKham = @MaPhieuKham;
    END

    SELECT N'Cập nhật trạng thái thành công.' AS ThongBao;
END;
GO


-- ============================================================
-- KIỂM TRA FIFO/FEFO
-- ============================================================
PRINT N'--- TEST FEFO ---';

-- Nhập 2 lô thêm cho thuốc số 2
INSERT INTO PhieuNhapKho (MaNhaCungCap, MaNhanVien, TongGiaTri) VALUES (2, 1, 2000000);
DECLARE @Lo1 INT = SCOPE_IDENTITY();
INSERT INTO ChiTietNhapKho (MaPhieuNhap, MaThuoc, SoLuong, SoLuongConLai, GiaNhap, HanSuDung)
VALUES (@Lo1, 2, 10, 10, 200000, '2026-06-01');  -- Cận date

INSERT INTO PhieuNhapKho (MaNhaCungCap, MaNhanVien, TongGiaTri) VALUES (2, 1, 4000000);
DECLARE @Lo2 INT = SCOPE_IDENTITY();
INSERT INTO ChiTietNhapKho (MaPhieuNhap, MaThuoc, SoLuong, SoLuongConLai, GiaNhap, HanSuDung)
VALUES (@Lo2, 2, 20, 20, 200000, '2028-12-01'); -- Date xa

-- Kịch bản 1: Bán âm kho → Phải bị chặn
PRINT N'KB1: Cố kê 200 tuýp (quá tồn kho)...';
BEGIN TRY
    EXEC SP_KeDonThuoc_FIFO @MaPhieuKham=3, @MaThuoc=2, @SoLuongKe=200, @LieuDung=N'Test';
    PRINT N'-> FAIL: Hệ thống không chặn bán âm!';
END TRY
BEGIN CATCH
    PRINT N'-> PASS (Đã chặn): ' + ERROR_MESSAGE();
END CATCH

-- Kịch bản 2: Kê 15 tuýp → FEFO: lấy 10 lô cận date + 5 lô mới
PRINT N'KB2: Kê 15 tuýp (FEFO)...';
BEGIN TRY
    EXEC SP_KeDonThuoc_FIFO @MaPhieuKham=3, @MaThuoc=2, @SoLuongKe=15, @LieuDung=N'Bôi tối';
    PRINT N'-> PASS: Kê đơn thành công!';
END TRY
BEGIN CATCH
    PRINT N'-> FAIL: ' + ERROR_MESSAGE();
END CATCH

-- Kiểm tra kết quả các lô
PRINT N'Kết quả các lô thuốc số 2 sau FEFO:';
SELECT MaPhieuNhap AS MaLo, HanSuDung, SoLuong AS SLBanDau, SoLuongConLai AS SLConLai
FROM ChiTietNhapKho WHERE MaThuoc = 2 ORDER BY HanSuDung;
-- Kỳ vọng: Lô 2026 → SLConLai = 0, Lô 2028 → SLConLai = 15
GO
