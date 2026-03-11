USE QL_PHONGKHAMDALIEU_New;
GO

-- ============================================================
-- 1. TEMPORAL TABLE CHO PhieuKham
--    Chống sửa lén chẩn đoán / hồ sơ bệnh án
-- ============================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE Name = N'ThoiGianBatDau'
      AND Object_ID = OBJECT_ID(N'PhieuKham')
)
BEGIN
    ALTER TABLE PhieuKham
    ADD
        ThoiGianBatDau DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
            CONSTRAINT DF_PhieuKham_BatDau DEFAULT SYSUTCDATETIME(),
        ThoiGianKetThuc DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
            CONSTRAINT DF_PhieuKham_KetThuc DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
        PERIOD FOR SYSTEM_TIME (ThoiGianBatDau, ThoiGianKetThuc);

    ALTER TABLE PhieuKham
    SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PhieuKham_LichSu));

    PRINT N'[OK] Đã bật Temporal Table cho PhieuKham';
END
ELSE
    PRINT N'[SKIP] PhieuKham đã có Temporal Table';
GO

-- ============================================================
-- 2. TEMPORAL TABLE CHO HoaDon
--    Chống gian lận tài chính
-- ============================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE Name = N'ThoiGianBatDau'
      AND Object_ID = OBJECT_ID(N'HoaDon')
)
BEGIN
    ALTER TABLE HoaDon
    ADD
        ThoiGianBatDau DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN
            CONSTRAINT DF_HoaDon_BatDau DEFAULT SYSUTCDATETIME(),
        ThoiGianKetThuc DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN
            CONSTRAINT DF_HoaDon_KetThuc DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
        PERIOD FOR SYSTEM_TIME (ThoiGianBatDau, ThoiGianKetThuc);

    ALTER TABLE HoaDon
    SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.HoaDon_LichSu));

    PRINT N'[OK] Đã bật Temporal Table cho HoaDon';
END
ELSE
    PRINT N'[SKIP] HoaDon đã có Temporal Table';
GO

-- ============================================================
-- 3. CÁC KỊCH BẢN KIỂM TRA AUDIT TRAIL
-- ============================================================

-- Kịch bản A: Bác sĩ sửa chẩn đoán
PRINT N'--- Kịch bản A: Bác sĩ sửa chẩn đoán ---';
SELECT MaPhieuKham, ChanDoan AS [Trước khi sửa] FROM PhieuKham WHERE MaPhieuKham = 1;

UPDATE PhieuKham SET ChanDoan = N'Dị ứng mỹ phẩm nhẹ' WHERE MaPhieuKham = 1;

SELECT MaPhieuKham, ChanDoan AS [Sau khi sửa] FROM PhieuKham WHERE MaPhieuKham = 1;

PRINT N'Lịch sử chỉnh sửa PhieuKham:';
SELECT
    MaPhieuKham,
    ChanDoan              AS [Chẩn Đoán Cũ],
    ThoiGianBatDau        AS [Bắt đầu lưu],
    ThoiGianKetThuc       AS [Thời điểm bị sửa]
FROM PhieuKham_LichSu WHERE MaPhieuKham = 1;
GO

-- Kịch bản B: Nhân viên gian lận hóa đơn
PRINT N'--- Kịch bản B: Nhân viên sửa hóa đơn ---';
SELECT MaHoaDon, TongTien, GiamGia, TienKhachTra AS [Trước gian lận] FROM HoaDon WHERE MaHoaDon = 1;

UPDATE HoaDon SET GiamGia = 280000, TienKhachTra = 800000 WHERE MaHoaDon = 1;

PRINT N'Bằng chứng gian lận (từ bảng lịch sử):';
SELECT
    MaHoaDon,
    TongTien              AS [Tổng Tiền Gốc],
    GiamGia               AS [Giảm Giá Cũ],
    TienKhachTra          AS [Tiền Thu Thực Tế],
    ThoiGianBatDau        AS [Bắt đầu lưu],
    ThoiGianKetThuc       AS [Thời điểm bị sửa]
FROM HoaDon_LichSu WHERE MaHoaDon = 1;
GO
