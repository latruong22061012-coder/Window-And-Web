USE QL_PHONGKHAMDALIEU_New;
GO

-- ============================================================
-- CONSTRAINTS
-- ============================================================

-- Giờ kết thúc ca bắt buộc sau giờ bắt đầu
ALTER TABLE CaLamViec
ADD CONSTRAINT CHK_ThoiGianCa CHECK (GioKetThuc > GioBatDau);

-- Số tiền & đơn giá không âm
ALTER TABLE DichVu           ADD CONSTRAINT CHK_DichVu_Gia    CHECK (DonGia >= 0);
ALTER TABLE Thuoc            ADD CONSTRAINT CHK_Thuoc_Gia     CHECK (DonGia >= 0);
ALTER TABLE Thuoc            ADD CONSTRAINT CHK_Thuoc_TonKho  CHECK (SoLuongTon >= 0);
ALTER TABLE ChiPhiHoatDong   ADD CONSTRAINT CHK_ChiPhi_SoTien CHECK (SoTien > 0);

-- SoLuongConLai không âm (bảo vệ FIFO)
ALTER TABLE ChiTietNhapKho
ADD CONSTRAINT CHK_SoLuongConLai CHECK (SoLuongConLai >= 0);

-- Trạng thái lịch hẹn (0: Hủy, 1: Chờ khám, 2: Đã xong)
ALTER TABLE LichHen
ADD CONSTRAINT CHK_TrangThaiLich CHECK (TrangThai IN (0, 1, 2));

-- Trạng thái phiếu khám (0-3)
ALTER TABLE PhieuKham
ADD CONSTRAINT CHK_TrangThaiPhieuKham CHECK (TrangThai IN (0, 1, 2, 3));

-- Ngày tái khám phải sau hoặc bằng ngày khám
ALTER TABLE PhieuKham
ADD CONSTRAINT CHK_NgayTaiKham CHECK (NgayTaiKham IS NULL OR NgayTaiKham >= CAST(NgayKham AS DATE));

-- TrangThaiTK chỉ là 0 hoặc 1
ALTER TABLE NhanVien
ADD CONSTRAINT CHK_TrangThaiTK CHECK (TrangThaiTK IN (0, 1));
GO


-- ============================================================
-- TRIGGER
-- ============================================================

-- Trigger: Tự động CỘNG tồn kho khi có lô hàng mới nhập
-- (Giữ nguyên — đây là trigger hợp lệ, không xung đột)
CREATE TRIGGER TRG_NhapKho_CapNhatTon
ON ChiTietNhapKho
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Thuoc
    SET    SoLuongTon = Thuoc.SoLuongTon + i.SoLuong
    FROM   Thuoc
    INNER JOIN inserted i ON Thuoc.MaThuoc = i.MaThuoc;
END;
GO

-- ⚠️ LƯU Ý QUAN TRỌNG: TRG_KeDon_TruTonKho đã bị XÓA HOÀN TOÀN.
-- Lý do: SP_KeDonThuoc_FIFO (file 04_Kho_Fixed.sql) đã tự trừ SoLuongTon
-- bên trong transaction. Nếu giữ trigger này, mỗi lần kê đơn sẽ trừ kho 2 lần.
-- Việc xóa trigger và để SP xử lý là thiết kế ĐÚNG và an toàn hơn.


-- ============================================================
-- VIEWS
-- ============================================================

-- View 1: Hồ sơ bệnh án toàn diện
CREATE VIEW VW_HoSoBenhAn AS
SELECT
    pk.MaPhieuKham,
    pk.TrangThai,
    bn.MaBenhNhan,
    bn.HoTen         AS TenBenhNhan,
    bn.SoDienThoai,
    bn.TienSuBenhLy,
    pk.NgayKham,
    nv.HoTen         AS BacSiDieuTri,
    pk.TrieuChung,
    pk.ChanDoan,
    pk.NgayTaiKham,
    lh.ThoiGianHen   AS ThoiGianHenTruoc  -- Lịch hẹn gốc (nếu có)
FROM PhieuKham pk
INNER JOIN BenhNhan bn  ON pk.MaBenhNhan = bn.MaBenhNhan
INNER JOIN NhanVien nv  ON pk.MaBacSi    = nv.MaNhanVien
LEFT  JOIN LichHen  lh  ON pk.MaLichHen  = lh.MaLichHen;
GO

-- View 2: Báo cáo doanh thu theo hóa đơn
CREATE VIEW VW_BaoCaoDoanhThu AS
SELECT
    hd.MaHoaDon,
    pk.NgayKham,
    bn.HoTen              AS TenKhachHang,
    hd.TongTien,
    hd.GiamGia,
    hd.TienKhachTra,
    hd.PhuongThucThanhToan,
    hd.NgayThanhToan,
    CASE
        WHEN hd.TrangThai = 1 THEN N'Đã thu tiền'
        ELSE N'Chưa thanh toán'
    END AS TinhTrang
FROM HoaDon     hd
INNER JOIN PhieuKham pk ON hd.MaPhieuKham = pk.MaPhieuKham
INNER JOIN BenhNhan  bn ON pk.MaBenhNhan   = bn.MaBenhNhan;
GO

-- [MỚI] View 3: Tồn kho theo từng lô (hỗ trợ màn hình frmQuanLyKho)
-- Hiển thị các lô còn hàng, sắp xếp theo HanSuDung để Admin dễ kiểm tra
CREATE VIEW VW_TonKhoTheoLo AS
SELECT
    t.MaThuoc,
    t.TenThuoc,
    t.DonViTinh,
    nk.MaPhieuNhap    AS MaLo,
    nk.SoLuong        AS SLBanDau,
    nk.SoLuongConLai  AS SLConLai,
    nk.HanSuDung,
    nk.GiaNhap,
    ncc.TenNhaCungCap,
    CASE
        WHEN nk.HanSuDung <= DATEADD(MONTH, 3, GETDATE()) THEN N'⚠ Sắp hết hạn'
        WHEN nk.SoLuongConLai = 0                         THEN N'Hết hàng'
        ELSE N'Còn hàng'
    END AS TrangThaiLo
FROM ChiTietNhapKho nk
INNER JOIN Thuoc        t   ON nk.MaThuoc        = t.MaThuoc
INNER JOIN PhieuNhapKho pn  ON nk.MaPhieuNhap    = pn.MaPhieuNhap
INNER JOIN NhaCungCap   ncc ON pn.MaNhaCungCap   = ncc.MaNhaCungCap
WHERE nk.SoLuongConLai > 0  -- Chỉ lấy lô còn hàng
ORDER BY nk.HanSuDung ASC;  -- Ưu tiên lô cận date lên đầu
GO

-- [MỚI] View 4: Danh sách tài khoản nhân viên (dành cho frmQuanLyTaiKhoan)
CREATE VIEW VW_DanhSachTaiKhoan AS
SELECT
    nv.MaNhanVien,
    nv.HoTen,
    nv.SoDienThoai,
    nv.Email,
    nv.TenDangNhap,
    vt.TenVaiTro,
    CASE WHEN nv.TrangThaiTK = 1 THEN N'Hoạt động' ELSE N'Bị khóa' END AS TrangThaiTK,
    CASE WHEN nv.DoiMatKhau  = 1 THEN N'Chưa đổi'  ELSE N'Đã đổi'  END AS TrangThaiMatKhau
FROM  NhanVien nv
INNER JOIN VaiTro vt ON nv.MaVaiTro = vt.MaVaiTro;
GO

PRINT N'Constraints, Triggers và Views đã được thiết lập thành công!';
GO
