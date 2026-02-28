USE QL_PHONGKHAMDALIEU;
GO

PRINT N'--- BẮT ĐẦU KIỂM TRA LOGIC ĐẶT LỊCH HẸN ---';
PRINT N'';


-- KỊCH BẢN 1: ĐẶT LỊCH HỢP LỆ (HAPPY PATH)
-- Lễ tân đặt cho Bệnh nhân 1 khám Bác sĩ 2 vào lúc 08:00 sáng ngày 05/03/2026.

PRINT N'Đang chạy Kịch bản 1: Đặt lịch lúc 08:00...';
BEGIN TRY
    EXEC SP_DatLichHenMoi 
        @MaBenhNhan = 1, 
        @MaBacSi = 2, 
        @ThoiGianHen = '2026-03-05 09:00:00';
    PRINT N'-> KẾT QUẢ 1: Thành công! Lịch hẹn 08:00 đã được lưu.';
END TRY
BEGIN CATCH
    PRINT N'-> KẾT QUẢ 1 (Lỗi): ' + ERROR_MESSAGE();
END CATCH
PRINT N'--------------------------------------------------';


-- KỊCH BẢN 2: CỐ TÌNH ĐẶT LỊCH TRÙNG (VI PHẠM QUY TẮC 30 PHÚT)
-- Lễ tân cố tình đặt cho Bệnh nhân 3 khám Bác sĩ 2 vào lúc 08:15 sáng cùng ngày.
-- (Chỉ cách ca trước 15 phút -> Kỳ vọng: Hệ thống phải chặn lại)

PRINT N'Đang chạy Kịch bản 2: Cố tình chèn thêm lịch lúc 08:15...';
BEGIN TRY
    EXEC SP_DatLichHenMoi 
        @MaBenhNhan = 3, 
        @MaBacSi = 2, 
        @ThoiGianHen = '2026-03-05 08:15:00';
    PRINT N'-> KẾT QUẢ 2: Lỗi rò rỉ! Lịch hẹn 08:15 vẫn được lưu (Logic sai).';
END TRY
BEGIN CATCH
    -- Bắt lỗi từ lệnh RAISERROR trong Stored Procedure và in ra màn hình
    PRINT N'-> KẾT QUẢ 2 (Hệ thống đã chặn thành công): ' + ERROR_MESSAGE();
END CATCH
PRINT N'--------------------------------------------------';


-- KIỂM TRA LẠI TRONG BẢNG DỮ LIỆU

PRINT N'Dữ liệu thực tế trong bảng LichHen ngày 05/03/2026:';
SELECT MaLichHen, MaBenhNhan, MaBacSi, ThoiGianHen, TrangThai 
FROM LichHen 
WHERE CAST(ThoiGianHen AS DATE) = '2026-03-05'
ORDER BY ThoiGianHen;
GO