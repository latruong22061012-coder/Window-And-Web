USE QL_PHONGKHAMDALIEU;
GO

-- 1. Thêm 2 cột thời gian ẩn vào bảng HoaDon để SQL Server tự động làm mốc theo dõi
ALTER TABLE HoaDon
ADD 
    ThoiGianBatDau DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN 
        CONSTRAINT DF_HoaDon_BatDau DEFAULT SYSUTCDATETIME(),
    ThoiGianKetThuc DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN 
        CONSTRAINT DF_HoaDon_KetThuc DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
    PERIOD FOR SYSTEM_TIME (ThoiGianBatDau, ThoiGianKetThuc);
GO

-- 2. Bật công tắc System Versioning và tự động tạo Bảng Lịch Sử cho Hóa Đơn
ALTER TABLE HoaDon
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.HoaDon_LichSu));
GO

PRINT N'Đã kích hoạt thành công tính năng Lưu vết bảo mật cho bảng HoaDon!';
GO


USE QL_PHONGKHAMDALIEU
GO

PRINT N'--- 1. DỮ LIỆU GỐC TRƯỚC KHI BỊ SỬA ---';
SELECT MaHoaDon, TongTien, GiamGia, TienKhachTra 
FROM HoaDon WHERE MaHoaDon = 1;


-- KỊCH BẢN GIAN LẬN: Nhân viên lén sửa Hóa đơn số 1
-- Tự ý thêm GiamGia = 280.000 và hạ TienKhachTra xuống còn 800.000

PRINT N'';
PRINT N'Đang thực hiện hành vi UPDATE gian lận...';
UPDATE HoaDon 
SET GiamGia = 280000, 
    TienKhachTra = 800000 
WHERE MaHoaDon = 1;

PRINT N'';
PRINT N'--- 2. DỮ LIỆU HIỆN TẠI TỚI THỜI ĐIỂM NÀY (Bị sai lệch) ---';
SELECT MaHoaDon, TongTien, GiamGia, TienKhachTra 
FROM HoaDon WHERE MaHoaDon = 1;


-- QUẢN LÝ KIỂM TRA LẠI BẰNG BẢNG LỊCH SỬ

PRINT N'';
PRINT N'--- 3. TRÍCH XUẤT BẰNG CHỨNG TỪ BẢNG LỊCH SỬ (HoaDon_LichSu) ---';
SELECT 
    MaHoaDon, 
    TongTien AS [Tổng Tiền Gốc],
    GiamGia AS [Giảm Giá Cũ (Bị Ghi Đè)], 
    TienKhachTra AS [Tiền Khách Trả Cũ (Thực Tế Đã Thu)],
    ThoiGianBatDau AS [Thời Gian Bắt Đầu Lưu], 
    ThoiGianKetThuc AS [Thời Điểm Bị Sửa/Xóa]
FROM HoaDon_LichSu
WHERE MaHoaDon = 1;
GO