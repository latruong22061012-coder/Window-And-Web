USE QL_PHONGKHAMDALIEU;
GO

PRINT N'======================================================';
PRINT N'   XEM TOÀN BỘ DỮ LIỆU PHÒNG KHÁM SAU KHI RÀNG BUỘC   ';
PRINT N'======================================================';


-- 1. NHÓM DANH MỤC CƠ SỞ & CON NGƯỜI

SELECT N'Bảng: Vai Trò' AS [Bảng], * FROM VaiTro;
SELECT N'Bảng: Ca Làm Việc' AS [Bảng], * FROM CaLamViec;
SELECT N'Bảng: Dịch Vụ' AS [Bảng], * FROM DichVu;
SELECT N'Bảng: Nhà Cung Cấp' AS [Bảng], * FROM NhaCungCap;
SELECT N'Bảng: Nhân Viên' AS [Bảng], * FROM NhanVien;
SELECT N'Bảng: Bệnh Nhân' AS [Bảng], * FROM BenhNhan;


-- 2. NHÓM QUẢN LÝ KHO BÃI (Đã chạy Trigger & FIFO)

-- Chú ý cột SoLuongTon: Thuốc số 2 đã cộng trừ tự động sau các đợt test
SELECT N'Bảng: Thuốc (Dược Mỹ Phẩm)' AS [Bảng], * FROM Thuoc; 
SELECT N'Bảng: Phiếu Nhập Kho' AS [Bảng], * FROM PhieuNhapKho;
-- Chú ý cột SoLuongConLai: Các lô cũ đã về 0, lô mới bị trừ dần (FEFO)
SELECT N'Bảng: Chi Tiết Nhập Kho' AS [Bảng], * FROM ChiTietNhapKho; 


-- 3. NHÓM NGHIỆP VỤ KHÁM BỆNH & LỊCH HẸN

SELECT N'Bảng: Phân Công Ca' AS [Bảng], * FROM PhanCongCa;
-- Chú ý: Có thêm lịch hẹn lúc 08:00 (Kịch bản chống trùng lịch thành công)
SELECT N'Bảng: Lịch Hẹn' AS [Bảng], * FROM LichHen; 
-- Chú ý: Phiếu khám số 1 có chẩn đoán là "Dị ứng mỹ phẩm nhẹ" (đã bị sửa)
-- Chú ý: Có thêm Phiếu khám mới tạo từ Transaction TiepNhanBenhNhan
SELECT N'Bảng: Phiếu Khám' AS [Bảng], * FROM PhieuKham; 
SELECT N'Bảng: Chi Tiết Dịch Vụ' AS [Bảng], * FROM ChiTietDichVu;
SELECT N'Bảng: Chi Tiết Đơn Thuốc' AS [Bảng], * FROM ChiTietDonThuoc;


-- 4. NHÓM TÀI CHÍNH & KẾ TOÁN

SELECT N'Bảng: Chi Phí Hoạt Động' AS [Bảng], * FROM ChiPhiHoatDong;
-- Chú ý: Hóa đơn 1 hiển thị số tiền đã bị sửa (800k). Có thêm Hóa đơn mới từ Transaction.
SELECT N'Bảng: Hóa Đơn' AS [Bảng], * FROM HoaDon; 


-- 5. NHÓM LƯU VẾT BẢO MẬT (AUDIT TRAIL)

-- Chứa chẩn đoán gốc "Mụn trứng cá cấp độ 3"
SELECT N'LỊCH SỬ: Phiếu Khám' AS [Bảng], * FROM PhieuKham_LichSu; 
-- Chứa số tiền thu gốc "1.080.000" trước khi nhân viên gian lận
SELECT N'LỊCH SỬ: Hóa Đơn' AS [Bảng], * FROM HoaDon_LichSu; 
GO