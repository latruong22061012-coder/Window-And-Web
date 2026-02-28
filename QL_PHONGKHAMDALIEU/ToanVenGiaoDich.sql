USE QL_PHONGKHAMDALIEU;
GO

CREATE PROCEDURE SP_TiepNhanBenhNhan_AnToan
    @MaBenhNhan INT,
    @MaBacSi INT,
    @TrieuChung NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- Bắt đầu khối TRY...CATCH để bẫy lỗi
    BEGIN TRY
        -- KÍCH HOẠT TÍNH NĂNG GIAO DỊCH (TRANSACTION)
        BEGIN TRAN; 

        -- BƯỚC 1: TẠO PHIẾU KHÁM MỚI
        INSERT INTO PhieuKham (MaBenhNhan, MaBacSi, NgayKham, TrieuChung)
        VALUES (@MaBenhNhan, @MaBacSi, GETDATE(), @TrieuChung);

        -- Lấy ra Mã Phiếu Khám vừa được hệ thống tự động sinh ra
        DECLARE @MaPhieuKhamMoi INT = SCOPE_IDENTITY();

        -- BƯỚC 2: TỰ ĐỘNG THÊM DỊCH VỤ "KHÁM CƠ BẢN"
        -- Giả sử MaDichVu = 1 là Khám da liễu tổng quát, giá 150.000đ
        INSERT INTO ChiTietDichVu (MaPhieuKham, MaDichVu, SoLuong, ThanhTien)
        VALUES (@MaPhieuKhamMoi, 1, 1, 150000);

        -- BƯỚC 3: KHỞI TẠO HÓA ĐƠN CHỜ THANH TOÁN
        INSERT INTO HoaDon (MaPhieuKham, TongTien, GiamGia, TienKhachTra, TrangThai)
        VALUES (@MaPhieuKhamMoi, 150000, 0, 150000, 0); -- TrangThai 0 = C	hưa thanh toán

        -- NẾU MỌI THỨ SUÔN SẺ LỌT XUỐNG ĐẾN ĐÂY -> CHỐT DỮ LIỆU!
        COMMIT TRAN;
        
        SELECT N'Tiếp nhận bệnh nhân thành công! Đã tạo hồ sơ và hóa đơn.' AS ThongBao;

    END TRY
    BEGIN CATCH
        -- NẾU CÓ BẤT KỲ LỖI GÌ (MẤT ĐIỆN, LỖI KHÓA NGOẠI, DỮ LIỆU SAI...)
        -- LẬP TỨC QUAY NGƯỢC THỜI GIAN, HỦY BỎ MỌI THAY ĐỔI TRƯỚC ĐÓ!
        ROLLBACK TRAN; 

        -- Báo lỗi chi tiết về cho phần mềm Windows
        DECLARE @Loi NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Loi, 16, 1);
    END CATCH
END;
GO


--	TEST TÍNH NĂNG
USE QL_PHONGKHAMDALIEU;
GO

PRINT N'--- BẮT ĐẦU KIỂM THỬ TRANSACTION ---';


-- KỊCH BẢN 1: HỢP LỆ (Mọi thứ suôn sẻ)
-- Khách số 1 đến khám Bác sĩ số 2 vì bị mụn.

PRINT N'';
PRINT N'Đang chạy Kịch bản 1 (Hợp lệ)...';
BEGIN TRY
    EXEC SP_TiepNhanBenhNhan_AnToan 
        @MaBenhNhan = 1, 
        @MaBacSi = 2, 
        @TrieuChung = N'Nổi mụn bọc ở cằm';
    PRINT N'-> KẾT QUẢ 1: Thành công! Dữ liệu đã được chốt (COMMIT).';
END TRY
BEGIN CATCH
    PRINT N'Lỗi: ' + ERROR_MESSAGE();
END CATCH

-- KỊCH BẢN 2: LỖI GIỮA CHỪNG (Mô phỏng sự cố)
-- Cố tình truyền vào MaBacSi = 999 (Bác sĩ không tồn tại)
-- Lỗi sẽ xảy ra ở Bước 1, kéo theo Bước 2 và 3 không được phép chạy.

PRINT N'';
PRINT N'Đang chạy Kịch bản 2 (Cố tình tạo lỗi)...';
BEGIN TRY
    EXEC SP_TiepNhanBenhNhan_AnToan 
        @MaBenhNhan = 1, 
        @MaBacSi = 999, -- Mã này không có trong bảng NhanVien
        @TrieuChung = N'Khám định kỳ';
    PRINT N'-> KẾT QUẢ 2: Nếu thấy dòng này là code sai!';
END TRY
BEGIN CATCH
    PRINT N'-> KẾT QUẢ 2 (Hệ thống đã ROLLBACK): ' + ERROR_MESSAGE();
END CATCH
GO