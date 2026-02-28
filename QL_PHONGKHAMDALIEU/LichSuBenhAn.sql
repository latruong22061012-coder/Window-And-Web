USE QL_PHONGKHAMDALIEU;
GO

-- 1. Thêm 2 cột thời gian ẩn vào bảng PhieuKham để SQL Server làm mốc theo dõi
ALTER TABLE PhieuKham
ADD 
    ThoiGianBatDau DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN 
        CONSTRAINT DF_PhieuKham_BatDau DEFAULT SYSUTCDATETIME(),
    ThoiGianKetThuc DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN 
        CONSTRAINT DF_PhieuKham_KetThuc DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
    PERIOD FOR SYSTEM_TIME (ThoiGianBatDau, ThoiGianKetThuc);
GO

-- 2. Bật công tắc System Versioning và tự động tạo Bảng Lịch Sử
ALTER TABLE PhieuKham
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PhieuKham_LichSu));
GO

PRINT N'Đã kích hoạt thành công tính năng Lưu vết cho bảng PhieuKham!';
GO

USE QL_PHONGKHAMDALIEU;
GO

PRINT N'--- DỮ LIỆU BAN ĐẦU ---';
SELECT MaPhieuKham, MaBenhNhan, ChanDoan FROM PhieuKham WHERE MaPhieuKham = 1;


-- KỊCH BẢN: Bác sĩ sửa nội dung chẩn đoán của Phiếu khám số 1 
-- từ "Mụn trứng cá cấp độ 3" thành "Dị ứng mỹ phẩm nhẹ"

PRINT N'';
PRINT N'Đang thực hiện lệnh UPDATE thay đổi chẩn đoán...';
UPDATE PhieuKham 
SET ChanDoan = N'Dị ứng mỹ phẩm nhẹ' 
WHERE MaPhieuKham = 1;

PRINT N'';
PRINT N'--- DỮ LIỆU HIỆN TẠI (Sau khi sửa) ---';
SELECT MaPhieuKham, MaBenhNhan, ChanDoan FROM PhieuKham WHERE MaPhieuKham = 1;


-- TRUY XUẤT LỊCH SỬ: Tìm lại bằng chứng

PRINT N'';
PRINT N'--- TRÍCH XUẤT LỊCH SỬ BỊ CHỈNH SỬA TỪ BẢNG LƯU VẾT ---';
SELECT 
    MaPhieuKham, 
    ChanDoan AS [Chẩn Đoán Cũ (Bị Ghi Đè)], 
    ThoiGianBatDau AS [Thời Gian Bắt Đầu Lưu], 
    ThoiGianKetThuc AS [Thời Điểm Bị Sửa/Xóa]
FROM PhieuKham_LichSu
WHERE MaPhieuKham = 1;
GO