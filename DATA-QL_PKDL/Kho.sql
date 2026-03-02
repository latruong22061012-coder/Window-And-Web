USE QL_PHONGKHAMDALIEU;
GO

-- 1. Hủy Trigger trừ kho cũ (vì SP mới sẽ đảm nhiệm việc này an toàn hơn)
IF OBJECT_ID('TRG_KeDon_TruTonKho', 'TR') IS NOT NULL
    DROP TRIGGER TRG_KeDon_TruTonKho;
GO

-- 2. Thêm cột 'SoLuongConLai' vào bảng ChiTietNhapKho để theo dõi FIFO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'SoLuongConLai' AND Object_ID = Object_ID(N'ChiTietNhapKho'))
BEGIN
    ALTER TABLE ChiTietNhapKho ADD SoLuongConLai INT DEFAULT 0;
END
GO

-- Cập nhật dữ liệu cũ: Số lượng còn lại = Số lượng ban đầu
UPDATE ChiTietNhapKho SET SoLuongConLai = SoLuong;
GO

--Bán thuốc âm kho & Xuất kho theo hạn sử dụng (FIFO)
CREATE PROCEDURE SP_KeDonThuoc_FIFO
    @MaPhieuKham INT,
    @MaThuoc INT,
    @SoLuongKe INT,
    @LieuDung NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. KIỂM TRA TỒN KHO TỔNG (Chống xuất âm)
    DECLARE @TonKhoHienTai INT;
    SELECT @TonKhoHienTai = SoLuongTon FROM Thuoc WHERE MaThuoc = @MaThuoc;

    IF @TonKhoHienTai < @SoLuongKe
    BEGIN
        DECLARE @Loi NVARCHAR(200) = N'Lỗi: Thuốc này chỉ còn tồn ' + CAST(@TonKhoHienTai AS NVARCHAR) + N' đơn vị, không đủ để kê đơn!';
        RAISERROR(@Loi, 16, 1);
        RETURN;
    END

    -- Bắt đầu Transaction (Đảm bảo dữ liệu toàn vẹn)
    BEGIN TRY
        BEGIN TRAN;

        -- 2. GHI NHẬN VÀO CHI TIẾT ĐƠN THUỐC
        INSERT INTO ChiTietDonThuoc(MaPhieuKham, MaThuoc, SoLuong, LieuDung)
        VALUES (@MaPhieuKham, @MaThuoc, @SoLuongKe, @LieuDung);

        -- 3. TRỪ TỒN KHO TỔNG Ở BẢNG THUỐC
        UPDATE Thuoc 
        SET SoLuongTon = SoLuongTon - @SoLuongKe 
        WHERE MaThuoc = @MaThuoc;

        -- 4. THUẬT TOÁN FIFO: QUÉT VÀ TRỪ TỪNG LÔ HÀNG
        DECLARE @SoLuongCanTru INT = @SoLuongKe;
        DECLARE @MaPhieuNhap INT;
        DECLARE @SoLuongTrongLo INT;

        -- Khai báo con trỏ: Lấy ra các lô của loại thuốc này, còn hàng, ưu tiên Hạn Sử Dụng gần nhất (ASC)
        DECLARE Cur_FIFO CURSOR FOR
        SELECT MaPhieuNhap, SoLuongConLai
        FROM ChiTietNhapKho
        WHERE MaThuoc = @MaThuoc AND SoLuongConLai > 0
        ORDER BY HanSuDung ASC;

        OPEN Cur_FIFO;
        FETCH NEXT FROM Cur_FIFO INTO @MaPhieuNhap, @SoLuongTrongLo;

        -- Vòng lặp chạy cho đến khi trừ hết số lượng kê đơn
        WHILE @@FETCH_STATUS = 0 AND @SoLuongCanTru > 0
        BEGIN
            IF @SoLuongTrongLo >= @SoLuongCanTru
            BEGIN
                -- Lô này chứa đủ lượng cần thiết -> Trừ hết phần cần thiết và dừng vòng lặp
                UPDATE ChiTietNhapKho 
                SET SoLuongConLai = SoLuongConLai - @SoLuongCanTru
                WHERE MaPhieuNhap = @MaPhieuNhap AND MaThuoc = @MaThuoc;
                
                SET @SoLuongCanTru = 0; 
            END
            ELSE
            BEGIN
                -- Lô này không đủ -> Trừ sạch lô này về 0, và giữ lại phần còn thiếu để tìm lô tiếp theo
                UPDATE ChiTietNhapKho 
                SET SoLuongConLai = 0
                WHERE MaPhieuNhap = @MaPhieuNhap AND MaThuoc = @MaThuoc;
                
                SET @SoLuongCanTru = @SoLuongCanTru - @SoLuongTrongLo;
            END

            -- Chuyển sang lô tiếp theo
            FETCH NEXT FROM Cur_FIFO INTO @MaPhieuNhap, @SoLuongTrongLo;
        END

        CLOSE Cur_FIFO;
        DEALLOCATE Cur_FIFO;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        -- Nếu có bất kỳ lỗi gì xảy ra (ví dụ đứt kết nối), Rollback lại toàn bộ
        ROLLBACK TRAN;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO
