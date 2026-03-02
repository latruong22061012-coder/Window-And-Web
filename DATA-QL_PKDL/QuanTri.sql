USE QL_PHONGKHAMDALIEU;
GO

-- 1. Giờ kết thúc ca làm việc bắt buộc phải sau Giờ bắt đầu
ALTER TABLE CaLamViec
ADD CONSTRAINT CHK_ThoiGianCa CHECK (GioKetThuc > GioBatDau);

-- 2. Số lượng và Đơn giá không bao giờ được phép âm
ALTER TABLE DichVu ADD CONSTRAINT CHK_DichVu_Gia CHECK (DonGia >= 0);
ALTER TABLE Thuoc ADD CONSTRAINT CHK_Thuoc_Gia CHECK (DonGia >= 0);
ALTER TABLE Thuoc ADD CONSTRAINT CHK_Thuoc_TonKho CHECK (SoLuongTon >= 0);
ALTER TABLE ChiPhiHoatDong ADD CONSTRAINT CHK_ChiPhi_SoTien CHECK (SoTien > 0);

-- 3. Trạng thái lịch hẹn chỉ được nằm trong các mức quy định (0: Hủy, 1: Chờ khám, 2: Đã xong)
ALTER TABLE LichHen
ADD CONSTRAINT CHK_TrangThaiLich CHECK (TrangThai IN (0, 1, 2));

-- 4. Ngày tái khám phải sau hoặc bằng Ngày khám hiện tại
ALTER TABLE PhieuKham
ADD CONSTRAINT CHK_NgayTaiKham CHECK (NgayTaiKham IS NULL OR NgayTaiKham >= CAST(NgayKham AS DATE));
GO


-- Trigger 1: Tự động CỘNG tồn kho khi có lô hàng mới nhập vào kho
CREATE TRIGGER TRG_NhapKho_CapNhatTon
ON ChiTietNhapKho
AFTER INSERT
AS
BEGIN
    -- Cập nhật bảng Thuoc, lấy số lượng nhập từ bảng ảo 'inserted' cộng vào SoLuongTon
    UPDATE Thuoc
    SET SoLuongTon = Thuoc.SoLuongTon + i.SoLuong
    FROM Thuoc
    INNER JOIN inserted i ON Thuoc.MaThuoc = i.MaThuoc;
END;
GO

-- Trigger 2: Tự động TRỪ tồn kho khi Bác sĩ kê đơn thuốc cho bệnh nhân
CREATE TRIGGER TRG_KeDon_TruTonKho
ON ChiTietDonThuoc
AFTER INSERT
AS
BEGIN
    UPDATE Thuoc
    SET SoLuongTon = Thuoc.SoLuongTon - i.SoLuong
    FROM Thuoc
    INNER JOIN inserted i ON Thuoc.MaThuoc = i.MaThuoc;
END;
GO

-- View 1: Khai phá Hồ Sơ Bệnh Án Toàn Diện
-- Giúp Bác sĩ xem ngay lịch sử khám bệnh, triệu chứng và ai là người khám
CREATE VIEW VW_HoSoBenhAn AS
SELECT 
    pk.MaPhieuKham,
    bn.MaBenhNhan,
    bn.HoTen AS TenBenhNhan,
    bn.SoDienThoai,
    pk.NgayKham,
    nv.HoTen AS BacSiDieuTri,
    pk.TrieuChung,
    pk.ChanDoan,
    pk.NgayTaiKham
FROM PhieuKham pk
INNER JOIN BenhNhan bn ON pk.MaBenhNhan = bn.MaBenhNhan
INNER JOIN NhanVien nv ON pk.MaBacSi = nv.MaNhanVien;
GO

-- View 2: Khai phá Báo Cáo Doanh Thu Theo Hóa Đơn
-- Cung cấp cho Quản trị viên cái nhìn tức thời về dòng tiền vào
CREATE VIEW VW_BaoCaoDoanhThu AS
SELECT 
    hd.MaHoaDon,
    pk.NgayKham,
    bn.HoTen AS TenKhachHang,
    hd.TongTien,
    hd.GiamGia,
    hd.TienKhachTra,
    hd.PhuongThucThanhToan,
    CASE 
        WHEN hd.TrangThai = 1 THEN N'Đã thu tiền'
        ELSE N'Chưa thanh toán'
    END AS TinhTrang
FROM HoaDon hd
INNER JOIN PhieuKham pk ON hd.MaPhieuKham = pk.MaPhieuKham
INNER JOIN BenhNhan bn ON pk.MaBenhNhan = bn.MaBenhNhan;
GO