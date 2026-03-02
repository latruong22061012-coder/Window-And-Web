PRINT N'--- BẮT ĐẦU KIỂM TRA BÁN THUỐC ÂM & FIFO ---';

-- GIẢ LẬP NHẬP KHO THÊM 2 LÔ KHÁC NHAU CỦA THUỐC SỐ 2 (Kem trị mụn Differin)
-- Lô 1: Nhập 10 tuýp, Cận date (Hết hạn 2026-06-01)
INSERT INTO PhieuNhapKho (MaNhaCungCap, MaNhanVien, TongGiaTri) VALUES (2, 1, 2000000);
DECLARE @ID_Nhap1 INT = SCOPE_IDENTITY();
INSERT INTO ChiTietNhapKho (MaPhieuNhap, MaThuoc, SoLuong, GiaNhap, HanSuDung, SoLuongConLai)
VALUES (@ID_Nhap1, 2, 0, 200000, '2026-06-01', 0);

-- Lô 2: Nhập 20 tuýp, Date mới (Hết hạn 2028-12-01)
INSERT INTO PhieuNhapKho (MaNhaCungCap, MaNhanVien, TongGiaTri) VALUES (2, 1, 4000000);
DECLARE @ID_Nhap2 INT = SCOPE_IDENTITY();
INSERT INTO ChiTietNhapKho (MaPhieuNhap, MaThuoc, SoLuong, GiaNhap, HanSuDung, SoLuongConLai)
VALUES (@ID_Nhap2, 2, 0, 200000, '2028-12-01', 0);

-- Cập nhật tổng số lượng tồn của thuốc số 2 lên (30 cũ + 10 + 20 = 60 tuýp)
UPDATE Thuoc SET SoLuongTon = 60 WHERE MaThuoc = 2;



-- KỊCH BẢN 1: BÁN ÂM KHO (Cố tình xuất 100 tuýp)

PRINT N'Kịch bản 1: Cố tình xuất 100 tuýp (Trong khi kho chỉ có 60)...';
BEGIN TRY
    EXEC SP_KeDonThuoc_FIFO @MaPhieuKham = 3, @MaThuoc = 2, @SoLuongKe = 100, @LieuDung = N'Dùng dần';
END TRY
BEGIN CATCH
    PRINT N'-> KẾT QUẢ 1 (Đã chặn): ' + ERROR_MESSAGE();
END CATCH



-- KỊCH BẢN 2: TRỪ KHO FIFO (Bác sĩ kê 15 tuýp)
-- Kỳ vọng: Hệ thống sẽ lấy sạch 10 tuýp của Lô cận date (2026) 
-- và lấy thêm 5 tuýp của Lô date mới (2028).

PRINT N'';
PRINT N'Kịch bản 2: Bác sĩ kê 15 tuýp. Đang tiến hành trừ FIFO...';
BEGIN TRY
    EXEC SP_KeDonThuoc_FIFO @MaPhieuKham = 3, @MaThuoc = 2, @SoLuongKe = 15, @LieuDung = N'Bôi tối';
    PRINT N'-> KẾT QUẢ 2: Kê đơn thành công!';
END TRY
BEGIN CATCH
    PRINT N'Lỗi: ' + ERROR_MESSAGE();
END CATCH

PRINT N'';
PRINT N'--- XEM DỮ LIỆU CÁC LÔ HÀNG SAU KHI TRỪ ---';
SELECT 
    MaPhieuNhap, 
    MaThuoc, 
    SoLuong AS SL_BanDau, 
    SoLuongConLai AS SL_SauKhiTru, 
    HanSuDung 
FROM ChiTietNhapKho 
WHERE MaThuoc = 2 AND MaPhieuNhap IN (@ID_Nhap1, @ID_Nhap2)
ORDER BY HanSuDung ASC;
GO

-- 1. Xóa dòng dữ liệu test cũ (nếu có) để tránh lỗi vi phạm Khóa chính
DELETE FROM ChiTietDonThuoc WHERE MaPhieuKham = 3 AND MaThuoc = 2;
GO

-- 2. Chạy lại thuật toán kê đơn (Kê 15 tuýp)
EXEC SP_KeDonThuoc_FIFO @MaPhieuKham = 3, @MaThuoc = 2, @SoLuongKe = 15, @LieuDung = N'Bôi tối';
GO

---Xem toàn bộ ChiTietPhiuNhap 
SELECT 
    MaPhieuNhap AS [Mã Lô Hàng], 
    HanSuDung AS [Hạn Sử Dụng],
    SoLuong AS [Số Lượng Ban Đầu], 
    SoLuongConLai AS [Số Lượng Còn Lại]
FROM ChiTietNhapKho 
WHERE MaThuoc = 2
ORDER BY HanSuDung ASC;
GO