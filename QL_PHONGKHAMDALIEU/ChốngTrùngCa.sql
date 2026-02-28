USE QL_PHONGKHAMDALIEU;
GO

CREATE PROCEDURE SP_DatLichHenMoi
    @MaBenhNhan INT,
    @MaBacSi INT,
    @ThoiGianHen DATETIME
AS
BEGIN
    -- Thiết lập môi trường an toàn cho Transaction
    SET NOCOUNT ON;
    
    -- Khai báo biến để kiểm tra xem có lịch trùng hay không
    DECLARE @SoLichTrung INT;
    
    -- Quy ước: 1 ca khám da liễu mặc định kéo dài 30 phút.
    -- Ta quét xem trong khoảng [ThoiGianHen - 29 phút] đến [ThoiGianHen + 29 phút]
    -- bác sĩ này có lịch hẹn nào đang ở trạng thái 1 (Chờ khám) hoặc 2 (Đã hoàn thành) không.
    SELECT @SoLichTrung = COUNT(*)
    FROM LichHen
    WHERE MaBacSi = @MaBacSi
      AND TrangThai IN (1, 2)
      AND ThoiGianHen >= DATEADD(MINUTE, -29, @ThoiGianHen) 
      AND ThoiGianHen <= DATEADD(MINUTE, 29, @ThoiGianHen);

    -- Nếu phát hiện có lịch trùng
    IF @SoLichTrung > 0
    BEGIN
        -- Bắn ra một lỗi tùy chỉnh (Custom Error) về cho phần mềm Windows
        -- Số 16 là mức độ nghiêm trọng (Severity) đủ để phần mềm catch được exception
        RAISERROR(N'Lỗi: Bác sĩ này đã có lịch hẹn trong khung giờ này. Vui lòng chọn giờ khác cách ít nhất 30 phút!', 16, 1);
        RETURN; -- Dừng thủ tục ngay lập tức
    END

    -- Nếu không trùng lịch, tiến hành thêm mới vào cơ sở dữ liệu
    INSERT INTO LichHen (MaBenhNhan, MaBacSi, ThoiGianHen, TrangThai)
    VALUES (@MaBenhNhan, @MaBacSi, @ThoiGianHen, 1);

    -- Trả về thông báo thành công (tùy chọn)
    SELECT N'Đặt lịch hẹn thành công!' AS ThongBao;
END;
GO