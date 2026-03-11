CREATE DATABASE QL_PHONGKHAMDALIEU_New;
GO
USE QL_PHONGKHAMDALIEU_New;
GO

-- ============================================================
-- NHÓM 1: DANH MỤC & CON NGƯỜI
-- ============================================================

CREATE TABLE VaiTro (
    MaVaiTro   INT IDENTITY(1,1) PRIMARY KEY,
    TenVaiTro  NVARCHAR(50) NOT NULL  -- 1:Quản trị, 2:Bác sĩ, 3:Lễ tân
);

CREATE TABLE DichVu (
    MaDichVu   INT IDENTITY(1,1) PRIMARY KEY,
    TenDichVu  NVARCHAR(100) NOT NULL,
    DonGia     DECIMAL(18,2) NOT NULL DEFAULT 0
);

CREATE TABLE NhaCungCap (
    MaNhaCungCap       INT IDENTITY(1,1) PRIMARY KEY,
    TenNhaCungCap      NVARCHAR(100) NOT NULL,
    SoDienThoaiLienHe  VARCHAR(15),
    DiaChi             NVARCHAR(200)
);

CREATE TABLE CaLamViec (
    MaCa        INT IDENTITY(1,1) PRIMARY KEY,
    TenCa       NVARCHAR(50) NOT NULL,
    GioBatDau   TIME NOT NULL,
    GioKetThuc  TIME NOT NULL
);

-- [SỬA] Thêm TrangThaiTK và DoiMatKhau để hỗ trợ luồng Admin tạo TK
CREATE TABLE NhanVien (
    MaNhanVien    INT IDENTITY(1,1) PRIMARY KEY,
    HoTen         NVARCHAR(100) NOT NULL,
    SoDienThoai   VARCHAR(15)   NOT NULL UNIQUE,
    Email         VARCHAR(100),
    TenDangNhap   VARCHAR(50)   NOT NULL UNIQUE,
    MatKhau       VARCHAR(255)  NOT NULL,         -- Lưu dạng hash BCrypt
    MaVaiTro      INT           NOT NULL,
    TrangThaiTK   BIT           NOT NULL DEFAULT 1, -- 1: Hoạt động, 0: Bị khóa
    DoiMatKhau    BIT           NOT NULL DEFAULT 1, -- 1: Phải đổi MK lần đầu đăng nhập
    FOREIGN KEY (MaVaiTro) REFERENCES VaiTro(MaVaiTro)
);

CREATE TABLE BenhNhan (
    MaBenhNhan    INT IDENTITY(1,1) PRIMARY KEY,
    HoTen         NVARCHAR(100) NOT NULL,
    NgaySinh      DATE,
    GioiTinh      BIT,                            -- 1: Nam, 0: Nữ
    SoDienThoai   VARCHAR(15)   NOT NULL UNIQUE,
    TienSuBenhLy  NVARCHAR(500)
);

-- ============================================================
-- NHÓM 2: KHO BÃI (DƯỢC - MỸ PHẨM)
-- ============================================================

CREATE TABLE Thuoc (
    MaThuoc      INT IDENTITY(1,1) PRIMARY KEY,
    TenThuoc     NVARCHAR(100) NOT NULL,
    DonViTinh    NVARCHAR(20)  NOT NULL,
    DonGia       DECIMAL(18,2) NOT NULL DEFAULT 0,
    SoLuongTon   INT           NOT NULL DEFAULT 0
);

CREATE TABLE PhieuNhapKho (
    MaPhieuNhap   INT IDENTITY(1,1) PRIMARY KEY,
    MaNhaCungCap  INT           NOT NULL,
    MaNhanVien    INT           NOT NULL,
    NgayNhap      DATETIME      DEFAULT GETDATE(),
    TongGiaTri    DECIMAL(18,2) DEFAULT 0,
    FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap),
    FOREIGN KEY (MaNhanVien)   REFERENCES NhanVien(MaNhanVien)
);

-- [SỬA] SoLuongConLai có ngay trong CREATE TABLE, không cần ALTER sau
CREATE TABLE ChiTietNhapKho (
    MaPhieuNhap    INT           NOT NULL,
    MaThuoc        INT           NOT NULL,
    SoLuong        INT           NOT NULL,
    SoLuongConLai  INT           NOT NULL DEFAULT 0, -- FIFO tracking, = SoLuong khi mới nhập
    GiaNhap        DECIMAL(18,2) NOT NULL,
    HanSuDung      DATE          NOT NULL,
    PRIMARY KEY (MaPhieuNhap, MaThuoc),
    FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhapKho(MaPhieuNhap),
    FOREIGN KEY (MaThuoc)     REFERENCES Thuoc(MaThuoc)
);

-- ============================================================
-- NHÓM 3: NGHIỆP VỤ KHÁM CHỮA BỆNH
-- ============================================================

CREATE TABLE LichHen (
    MaLichHen    INT IDENTITY(1,1) PRIMARY KEY,
    MaBenhNhan   INT      NOT NULL,
    MaBacSi      INT      NOT NULL,
    ThoiGianHen  DATETIME NOT NULL,
    TrangThai    TINYINT  DEFAULT 1, -- 0: Hủy, 1: Chờ khám, 2: Đã hoàn thành
    FOREIGN KEY (MaBenhNhan) REFERENCES BenhNhan(MaBenhNhan),
    FOREIGN KEY (MaBacSi)    REFERENCES NhanVien(MaNhanVien)
);

-- [SỬA] Thêm TrangThai để theo dõi trạng thái phiếu khám
-- [SỬA] Thêm MaLichHen (nullable) để liên kết với lịch hẹn đã đặt trước
CREATE TABLE PhieuKham (
    MaPhieuKham  INT IDENTITY(1,1) PRIMARY KEY,
    MaBenhNhan   INT          NOT NULL,
    MaBacSi      INT          NOT NULL,
    MaLichHen    INT          NULL,           -- [MỚI] Liên kết lịch hẹn nếu có
    NgayKham     DATETIME     DEFAULT GETDATE(),
    TrieuChung   NVARCHAR(500),
    ChanDoan     NVARCHAR(500),
    NgayTaiKham  DATE,
    TrangThai    TINYINT      NOT NULL DEFAULT 0,
    -- 0: Chờ khám | 1: Đang khám | 2: Chờ thanh toán | 3: Hoàn thành
    FOREIGN KEY (MaBenhNhan) REFERENCES BenhNhan(MaBenhNhan),
    FOREIGN KEY (MaBacSi)    REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaLichHen)  REFERENCES LichHen(MaLichHen)
);

CREATE TABLE PhanCongCa (
    MaPhanCong         INT IDENTITY(1,1) PRIMARY KEY,
    MaNhanVien         INT  NOT NULL,
    MaCa               INT  NOT NULL,
    NgayLamViec        DATE NOT NULL,
    TrangThaiDiemDanh  TINYINT DEFAULT 1, -- 0: Nghỉ, 1: Có mặt
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaCa)       REFERENCES CaLamViec(MaCa)
);

CREATE TABLE ChiTietDichVu (
    MaPhieuKham  INT           NOT NULL,
    MaDichVu     INT           NOT NULL,
    SoLuong      INT           DEFAULT 1,
    ThanhTien    DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (MaPhieuKham, MaDichVu),
    FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKham(MaPhieuKham),
    FOREIGN KEY (MaDichVu)    REFERENCES DichVu(MaDichVu)
);

CREATE TABLE ChiTietDonThuoc (
    MaPhieuKham  INT           NOT NULL,
    MaThuoc      INT           NOT NULL,
    SoLuong      INT           DEFAULT 1,
    LieuDung     NVARCHAR(100),
    PRIMARY KEY (MaPhieuKham, MaThuoc),
    FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKham(MaPhieuKham),
    FOREIGN KEY (MaThuoc)     REFERENCES Thuoc(MaThuoc)
);

-- [MỚI] Bảng lưu đường dẫn ảnh bệnh lý (da trước/sau điều trị)
CREATE TABLE HinhAnhBenhLy (
    MaHinhAnh    INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuKham  INT            NOT NULL,
    DuongDanAnh  NVARCHAR(500)  NOT NULL, -- Path tương đối, VD: images\2026\03\pk1_truoc.jpg
    GhiChu       NVARCHAR(200),           -- VD: "Trước điều trị", "Sau 1 tuần"
    NgayChup     DATETIME       DEFAULT GETDATE(),
    FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKham(MaPhieuKham)
);

-- ============================================================
-- NHÓM 4: TÀI CHÍNH
-- ============================================================

CREATE TABLE ChiPhiHoatDong (
    MaChiPhi   INT IDENTITY(1,1) PRIMARY KEY,
    LoaiChiPhi NVARCHAR(100) NOT NULL,
    SoTien     DECIMAL(18,2) NOT NULL,
    NgayChi    DATETIME      DEFAULT GETDATE(),
    GhiChu     NVARCHAR(255),
    NguoiTao   INT           NOT NULL,
    FOREIGN KEY (NguoiTao) REFERENCES NhanVien(MaNhanVien)
);

CREATE TABLE HoaDon (
    MaHoaDon               INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuKham            INT           NOT NULL UNIQUE, -- 1 PhieuKham = 1 HoaDon
    TongTien               DECIMAL(18,2) NOT NULL,
    GiamGia                DECIMAL(18,2) DEFAULT 0,
    TienKhachTra           DECIMAL(18,2) NOT NULL,
    PhuongThucThanhToan    NVARCHAR(50),
    NgayThanhToan          DATETIME,
    TrangThai              BIT           DEFAULT 0, -- 0: Chưa TT, 1: Đã TT
    FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKham(MaPhieuKham)
);
GO

-- ============================================================
-- DỮ LIỆU MẪU (SEED DATA)
-- ============================================================

INSERT INTO VaiTro (TenVaiTro) VALUES
(N'Quản trị viên'),
(N'Bác sĩ da liễu'),
(N'Lễ tân');

INSERT INTO DichVu (TenDichVu, DonGia) VALUES
(N'Khám da liễu tổng quát',    150000),
(N'Lấy nhân mụn chuẩn y khoa', 300000),
(N'Peel da sinh học trị mụn',   800000);

INSERT INTO Thuoc (TenThuoc, DonViTinh, DonGia, SoLuongTon) VALUES
(N'Sữa rửa mặt Cetaphil 500ml',     N'Chai', 350000, 50),
(N'Kem bôi trị mụn Differin 0.1%',  N'Tuýp', 280000, 30),
(N'Kem chống nắng La Roche-Posay',  N'Tuýp', 450000, 20);

INSERT INTO BenhNhan (HoTen, NgaySinh, GioiTinh, SoDienThoai, TienSuBenhLy) VALUES
(N'Nguyễn Văn An',  '1995-05-12', 1, '0901234567', N'Dị ứng hải sản'),
(N'Trần Thị Bích',  '2000-08-24', 0, '0912345678', N'Da nhạy cảm, dễ kích ứng cồn'),
(N'Lê Hoàng Nam',   '1998-11-30', 1, '0923456789', N'Không');

INSERT INTO NhaCungCap (TenNhaCungCap, SoDienThoaiLienHe, DiaChi) VALUES
(N'Công ty Dược phẩm Eco',         '0283123456', N'Quận 1, TP. HCM'),
(N'Nhà phân phối Galderma',        '0283654321', N'Quận 3, TP. HCM'),
(N'L Oreal Việt Nam',              '0283999999', N'Quận 7, TP. HCM');

INSERT INTO CaLamViec (TenCa, GioBatDau, GioKetThuc) VALUES
(N'Ca Sáng',  '08:00:00', '12:00:00'),
(N'Ca Chiều', '13:00:00', '17:00:00'),
(N'Ca Tối',   '17:00:00', '21:00:00');

-- [SỬA] Thêm TrangThaiTK=1 (hoạt động), DoiMatKhau=0 (Admin không phải đổi MK)
-- Admin gốc được tạo thủ công qua script, không cần đổi MK
INSERT INTO NhanVien (HoTen, SoDienThoai, Email, TenDangNhap, MatKhau, MaVaiTro, TrangThaiTK, DoiMatKhau) VALUES
(N'Phạm Quản Trị',  '0987654321', 'admin@phongkham.com',  'admin',  'hashed_pass_1', 1, 1, 0),
(N'BS. Đinh Thị Hoa','0977777777', 'bshoa@phongkham.com',  'bshoa',  'hashed_pass_2', 2, 1, 0),
(N'Lý Lễ Tân',      '0966666666', 'letan@phongkham.com',  'letan1', 'hashed_pass_3', 3, 1, 0);

INSERT INTO LichHen (MaBenhNhan, MaBacSi, ThoiGianHen, TrangThai) VALUES
(1, 2, '2026-03-01 09:00:00', 2),
(2, 2, '2026-03-01 14:00:00', 1),
(3, 2, '2026-03-02 18:00:00', 1);

-- [SỬA] Thêm TrangThai và liên kết MaLichHen cho PhieuKham
INSERT INTO PhieuKham (MaBenhNhan, MaBacSi, MaLichHen, NgayKham, TrieuChung, ChanDoan, NgayTaiKham, TrangThai) VALUES
(1, 2, 1, '2026-03-01 09:15:00', N'Nổi nhiều mụn viêm sưng đỏ ở má', N'Mụn trứng cá cấp độ 3', '2026-03-15', 3),
(2, 2, 2, '2026-03-01 14:30:00', N'Da mặt sạm nám, không đều màu',    N'Nám nội tiết',          '2026-04-01', 2),
(3, 2, 3, '2026-03-02 18:20:00', N'Da đổ nhiều dầu, có mụn ẩn',       N'Viêm nang lông nhẹ',    NULL,         1);

INSERT INTO PhanCongCa (MaNhanVien, MaCa, NgayLamViec, TrangThaiDiemDanh) VALUES
(3, 1, '2026-03-01', 1),
(2, 1, '2026-03-01', 1),
(2, 2, '2026-03-01', 1);

INSERT INTO PhieuNhapKho (MaNhaCungCap, MaNhanVien, NgayNhap, TongGiaTri) VALUES
(1, 1, '2026-02-25 10:00:00', 10000000),
(2, 1, '2026-02-26 14:00:00',  5000000),
(3, 1, '2026-02-28 09:00:00', 15000000);

INSERT INTO ChiPhiHoatDong (LoaiChiPhi, SoTien, NgayChi, GhiChu, NguoiTao) VALUES
(N'Mặt bằng',  20000000, '2026-02-01', N'Tiền thuê nhà tháng 2',        1),
(N'Điện nước',  3500000, '2026-02-28', N'Thanh toán điện nước tháng 2', 1),
(N'Marketing',  5000000, '2026-02-15', N'Chạy quảng cáo Facebook',      1);

INSERT INTO ChiTietDichVu (MaPhieuKham, MaDichVu, SoLuong, ThanhTien) VALUES
(1, 1, 1, 150000),
(1, 2, 1, 300000),
(2, 3, 1, 800000);

INSERT INTO ChiTietDonThuoc (MaPhieuKham, MaThuoc, SoLuong, LieuDung) VALUES
(1, 1, 1, N'Rửa mặt ngày 2 lần sáng tối'),
(1, 2, 1, N'Chấm mụn buổi tối trước khi ngủ'),
(2, 3, 1, N'Thoa buổi sáng trước khi ra ngoài 20 phút');

-- [SỬA] SoLuongConLai = SoLuong ngay khi INSERT (không cần UPDATE riêng)
INSERT INTO ChiTietNhapKho (MaPhieuNhap, MaThuoc, SoLuong, SoLuongConLai, GiaNhap, HanSuDung) VALUES
(1, 1, 50, 50, 250000, '2028-01-01'),
(2, 2, 30, 30, 200000, '2027-06-01'),
(3, 3, 20, 20, 320000, '2027-12-01');

INSERT INTO HoaDon (MaPhieuKham, TongTien, GiamGia, TienKhachTra, PhuongThucThanhToan, NgayThanhToan, TrangThai) VALUES
(1, 1080000, 0,      1080000, N'Chuyển khoản', '2026-03-01 10:00:00', 1),
(2, 1250000, 50000,  1200000, N'Tiền mặt',     '2026-03-01 15:30:00', 1),
(3,  150000, 0,       150000, NULL, NULL, 0);
GO

PRINT N'Schema và dữ liệu mẫu đã được tạo thành công!';
GO
