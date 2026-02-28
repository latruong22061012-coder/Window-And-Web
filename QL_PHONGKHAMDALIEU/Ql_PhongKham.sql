CREATE DATABASE QL_PHONGKHAMDALIEU
GO
USE QL_PHONGKHAMDALIEU
GO


-- Bảng Vai Trò
CREATE TABLE VaiTro (
    MaVaiTro INT IDENTITY(1,1) PRIMARY KEY,
    TenVaiTro NVARCHAR(50) NOT NULL -- VD: Quan tri vien, Bac si, Le tan
);

-- Bảng Dịch Vụ
CREATE TABLE DichVu (
    MaDichVu INT IDENTITY(1,1) PRIMARY KEY,
    TenDichVu NVARCHAR(100) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL DEFAULT 0
);

-- Bảng Thuốc / Dược mỹ phẩm
CREATE TABLE Thuoc (
    MaThuoc INT IDENTITY(1,1) PRIMARY KEY,
    TenThuoc NVARCHAR(100) NOT NULL,
    DonViTinh NVARCHAR(20) NOT NULL, -- Tuyp, Vien, Lo
    DonGia DECIMAL(18,2) NOT NULL DEFAULT 0,
    SoLuongTon INT NOT NULL DEFAULT 0
);

-- Bảng Bệnh Nhân
CREATE TABLE BenhNhan (
    MaBenhNhan INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh BIT, -- 1: Nam, 0: Nu
    SoDienThoai VARCHAR(15) NOT NULL UNIQUE,
    TienSuBenhLy NVARCHAR(500) -- Tien su di ung
);

-- Bảng Nhà Cung Cấp (Dành cho kho)
CREATE TABLE NhaCungCap (
    MaNhaCungCap INT IDENTITY(1,1) PRIMARY KEY,
    TenNhaCungCap NVARCHAR(100) NOT NULL,
    SoDienThoaiLienHe VARCHAR(15),
    DiaChi NVARCHAR(200)
);

-- Bảng Ca Làm Việc (Dành cho xếp lịch)
CREATE TABLE CaLamViec (
    MaCa INT IDENTITY(1,1) PRIMARY KEY,
    TenCa NVARCHAR(50) NOT NULL, -- Sang, Chieu, Toi
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL
);

-- Bảng Nhân Viên (Phụ thuộc VaiTro)
CREATE TABLE NhanVien (
    MaNhanVien INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) NOT NULL,
    Email VARCHAR(100),
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    MaVaiTro INT NOT NULL,
    FOREIGN KEY (MaVaiTro) REFERENCES VaiTro(MaVaiTro)
);

-- Bảng Lịch Hẹn
CREATE TABLE LichHen (
    MaLichHen INT IDENTITY(1,1) PRIMARY KEY,
    MaBenhNhan INT NOT NULL,
    MaBacSi INT NOT NULL,
    ThoiGianHen DATETIME NOT NULL,
    TrangThai TINYINT DEFAULT 1, -- 0: Huy, 1: Cho kham, 2: Da hoan thanh
    FOREIGN KEY (MaBenhNhan) REFERENCES BenhNhan(MaBenhNhan),
    FOREIGN KEY (MaBacSi) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng Phiếu Khám
CREATE TABLE PhieuKham (
    MaPhieuKham INT IDENTITY(1,1) PRIMARY KEY,
    MaBenhNhan INT NOT NULL,
    MaBacSi INT NOT NULL,
    NgayKham DATETIME DEFAULT GETDATE(),
    TrieuChung NVARCHAR(500),
    ChanDoan NVARCHAR(500),
    NgayTaiKham DATE,
    FOREIGN KEY (MaBenhNhan) REFERENCES BenhNhan(MaBenhNhan),
    FOREIGN KEY (MaBacSi) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng Phân Công Ca Làm Việc
CREATE TABLE PhanCongCa (
    MaPhanCong INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien INT NOT NULL,
    MaCa INT NOT NULL,
    NgayLamViec DATE NOT NULL,
    TrangThaiDiemDanh TINYINT DEFAULT 1, -- 0: Nghi, 1: Co mat
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaCa) REFERENCES CaLamViec(MaCa)
);

-- Bảng Phiếu Nhập Kho
CREATE TABLE PhieuNhapKho (
    MaPhieuNhap INT IDENTITY(1,1) PRIMARY KEY,
    MaNhaCungCap INT NOT NULL,
    MaNhanVien INT NOT NULL, -- Nguoi nhap kho
    NgayNhap DATETIME DEFAULT GETDATE(),
    TongGiaTri DECIMAL(18,2) DEFAULT 0,
    FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng Chi Phí Hoạt Động (Kế toán nhập tay)
CREATE TABLE ChiPhiHoatDong (
    MaChiPhi INT IDENTITY(1,1) PRIMARY KEY,
    LoaiChiPhi NVARCHAR(100) NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL,
    NgayChi DATETIME DEFAULT GETDATE(),
    GhiChu NVARCHAR(255),
    NguoiTao INT NOT NULL, -- Nhan vien nao da nhap khoan chi nay
    FOREIGN KEY (NguoiTao) REFERENCES NhanVien(MaNhanVien)
);

-- Chi Tiết Dịch Vụ (Thuộc Phiếu Khám)
CREATE TABLE ChiTietDichVu (
    MaPhieuKham INT NOT NULL,
    MaDichVu INT NOT NULL,
    SoLuong INT DEFAULT 1,
    ThanhTien DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (MaPhieuKham, MaDichVu),
    FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKham(MaPhieuKham),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu)
);

-- Chi Tiết Đơn Thuốc (Thuộc Phiếu Khám)
CREATE TABLE ChiTietDonThuoc (
    MaPhieuKham INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLuong INT DEFAULT 1,
    LieuDung NVARCHAR(100),
    PRIMARY KEY (MaPhieuKham, MaThuoc),
    FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKham(MaPhieuKham),
    FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc)
);

-- Chi Tiết Nhập Kho (Thuộc Phiếu Nhập Kho)
CREATE TABLE ChiTietNhapKho (
    MaPhieuNhap INT NOT NULL,
    MaThuoc INT NOT NULL,
    SoLuong INT NOT NULL,
    GiaNhap DECIMAL(18,2) NOT NULL,
    HanSuDung DATE NOT NULL,
    PRIMARY KEY (MaPhieuNhap, MaThuoc),
    FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhapKho(MaPhieuNhap),
    FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc)
);

-- Bảng Hóa Đơn (Thanh toán cho Phiếu khám)
CREATE TABLE HoaDon (
    MaHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuKham INT NOT NULL UNIQUE, -- 1 Phieu kham co 1 Hoa don
    TongTien DECIMAL(18,2) NOT NULL,
    GiamGia DECIMAL(18,2) DEFAULT 0,
    TienKhachTra DECIMAL(18,2) NOT NULL,
    PhuongThucThanhToan NVARCHAR(50), -- Tien mat, Chuyen khoan
    NgayThanhToan DATETIME,
    TrangThai BIT DEFAULT 0, -- 0: Chua thanh toan, 1: Da thanh toan
    FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKham(MaPhieuKham)
);
GO

-- 1. Bảng VaiTro
INSERT INTO VaiTro (TenVaiTro) VALUES 
(N'Quản trị viên'), 
(N'Bác sĩ da liễu'), 
(N'Lễ tân');

-- 2. Bảng DichVu
INSERT INTO DichVu (TenDichVu, DonGia) VALUES 
(N'Khám da liễu tổng quát', 150000),
(N'Lấy nhân mụn chuẩn y khoa', 300000),
(N'Peel da sinh học trị mụn', 800000);

-- 3. Bảng Thuoc (Dược mỹ phẩm)
INSERT INTO Thuoc (TenThuoc, DonViTinh, DonGia, SoLuongTon) VALUES 
(N'Sữa rửa mặt Cetaphil 500ml', N'Chai', 350000, 50),
(N'Kem bôi trị mụn Differin 0.1%', N'Tuýp', 280000, 30),
(N'Kem chống nắng La Roche-Posay', N'Tuýp', 450000, 20);

-- 4. Bảng BenhNhan
INSERT INTO BenhNhan (HoTen, NgaySinh, GioiTinh, SoDienThoai, TienSuBenhLy) VALUES 
(N'Nguyễn Văn An', '1995-05-12', 1, '0901234567', N'Dị ứng hải sản'),
(N'Trần Thị Bích', '2000-08-24', 0, '0912345678', N'Da nhạy cảm, dễ kích ứng cồn'),
(N'Lê Hoàng Nam', '1998-11-30', 1, '0923456789', N'Không');

-- 5. Bảng NhaCungCap
INSERT INTO NhaCungCap (TenNhaCungCap, SoDienThoaiLienHe, DiaChi) VALUES 
(N'Công ty Dược phẩm Eco', '0283123456', N'Quận 1, TP. HCM'),
(N'Nhà phân phối Mỹ phẩm Galderma', '0283654321', N'Quận 3, TP. HCM'),
(N'L oreal Việt Nam', '0283999999', N'Quận 7, TP. HCM');

-- 6. Bảng CaLamViec
INSERT INTO CaLamViec (TenCa, GioBatDau, GioKetThuc) VALUES 
(N'Ca Sáng', '08:00:00', '12:00:00'),
(N'Ca Chiều', '13:00:00', '17:00:00'),
(N'Ca Tối', '17:00:00', '21:00:00');



-- 7. Bảng NhanVien 
-- (MaVaiTro 1: Admin, 2: Bác sĩ, 3: Lễ tân)
INSERT INTO NhanVien (HoTen, SoDienThoai, Email, TenDangNhap, MatKhau, MaVaiTro) VALUES 
(N'Phạm Quản Trị', '0987654321', 'admin@phongkham.com', 'admin', 'hashed_pass_1', 1),
(N'BS. Đinh Thị Hoa', '0977777777', 'bshoa@phongkham.com', 'bshoa', 'hashed_pass_2', 2),
(N'Lý Lễ Tân', '0966666666', 'letan@phongkham.com', 'letan1', 'hashed_pass_3', 3);


-- 8. Bảng LichHen (Bác sĩ có MaNhanVien = 2)
INSERT INTO LichHen (MaBenhNhan, MaBacSi, ThoiGianHen, TrangThai) VALUES 
(1, 2, '2026-03-01 09:00:00', 2), -- Đã hoàn thành
(2, 2, '2026-03-01 14:00:00', 1), -- Chờ khám
(3, 2, '2026-03-02 18:00:00', 1);

-- 9. Bảng PhieuKham
INSERT INTO PhieuKham (MaBenhNhan, MaBacSi, NgayKham, TrieuChung, ChanDoan, NgayTaiKham) VALUES 
(1, 2, '2026-03-01 09:15:00', N'Nổi nhiều mụn viêm sưng đỏ ở má', N'Mụn trứng cá cấp độ 3', '2026-03-15'),
(2, 2, '2026-03-01 14:30:00', N'Da mặt sạm nám, không đều màu', N'Nám nội tiết', '2026-04-01'),
(3, 2, '2026-03-02 18:20:00', N'Da đổ nhiều dầu, có mụn ẩn', N'Viêm nang lông nhẹ', NULL);

-- 10. Bảng PhanCongCa
INSERT INTO PhanCongCa (MaNhanVien, MaCa, NgayLamViec, TrangThaiDiemDanh) VALUES 
(3, 1, '2026-03-01', 1), -- Lễ tân trực ca sáng
(2, 1, '2026-03-01', 1), -- Bác sĩ trực ca sáng
(2, 2, '2026-03-01', 1); -- Bác sĩ trực ca chiều

-- 11. Bảng PhieuNhapKho (Nhân viên 1 là admin tiến hành nhập)
INSERT INTO PhieuNhapKho (MaNhaCungCap, MaNhanVien, NgayNhap, TongGiaTri) VALUES 
(1, 1, '2026-02-25 10:00:00', 10000000),
(2, 1, '2026-02-26 14:00:00', 5000000),
(3, 1, '2026-02-28 09:00:00', 15000000);

-- 12. Bảng ChiPhiHoatDong (Nhân viên 1 nhập chi phí)
INSERT INTO ChiPhiHoatDong (LoaiChiPhi, SoTien, NgayChi, GhiChu, NguoiTao) VALUES 
(N'Mặt bằng', 20000000, '2026-02-01', N'Tiền thuê nhà tháng 2', 1),
(N'Điện nước', 3500000, '2026-02-28', N'Thanh toán điện nước tháng 2', 1),
(N'Marketing', 5000000, '2026-02-15', N'Chạy quảng cáo Facebook', 1);


-- 13. Bảng ChiTietDichVu 
-- Khách 1 dùng dịch vụ 1 và 2. Khách 2 dùng dịch vụ 1 và 3. Khách 3 dùng dịch vụ 1.
INSERT INTO ChiTietDichVu (MaPhieuKham, MaDichVu, SoLuong, ThanhTien) VALUES 
(1, 1, 1, 150000),  -- Phiếu 1, Khám
(1, 2, 1, 300000),  -- Phiếu 1, Lấy nhân mụn
(2, 3, 1, 800000);  -- Phiếu 2, Peel da

-- 14. Bảng ChiTietDonThuoc
INSERT INTO ChiTietDonThuoc (MaPhieuKham, MaThuoc, SoLuong, LieuDung) VALUES 
(1, 1, 1, N'Rửa mặt ngày 2 lần sáng tối'), -- Khách 1 mua sữa rửa mặt
(1, 2, 1, N'Chấm mụn buổi tối trước khi ngủ'), -- Khách 1 mua kem mụn
(2, 3, 1, N'Thoa buổi sáng trước khi ra ngoài 20p'); -- Khách 2 mua KCN

-- 15. Bảng ChiTietNhapKho
INSERT INTO ChiTietNhapKho (MaPhieuNhap, MaThuoc, SoLuong, GiaNhap, HanSuDung) VALUES 
(1, 1, 50, 250000, '2028-01-01'), -- Nhập 50 chai srm
(2, 2, 30, 200000, '2027-06-01'), -- Nhập 30 tuýp differin
(3, 3, 20, 320000, '2027-12-01'); -- Nhập 20 tuýp KCN

-- 16. Bảng HoaDon
-- Tổng tiền = Tổng ThanhTien (ChiTietDichVu) + (Đơn giá thuốc * Số lượng)
INSERT INTO HoaDon (MaPhieuKham, TongTien, GiamGia, TienKhachTra, PhuongThucThanhToan, NgayThanhToan, TrangThai) VALUES 
(1, 1080000, 0, 1080000, N'Chuyển khoản', '2026-03-01 10:00:00', 1), -- Đã thanh toán
(2, 1250000, 50000, 1200000, N'Tiền mặt', '2026-03-01 15:30:00', 1), -- Đã thanh toán (có giảm giá)
(3, 150000, 0, 150000, NULL, NULL, 0); -- Chưa thanh toán
GO
SELECT *
FROM Thuoc