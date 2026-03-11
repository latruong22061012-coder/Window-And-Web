USE QL_PHONGKHAMDALIEU_New;
GO

-- ============================================================
-- SP 1: TẠO TÀI KHOẢN NHÂN VIÊN MỚI
-- Gọi từ: frmTaoTaiKhoan (Admin)
-- Logic:
--   - Kiểm tra TenDangNhap không được trùng
--   - Kiểm tra SoDienThoai không được trùng
--   - Chèn NhanVien với DoiMatKhau = 1 (bắt đổi MK lần đầu)
--   - Trả về MaNhanVien vừa tạo
-- ============================================================
CREATE PROCEDURE SP_TaoTaiKhoan
    @HoTen        NVARCHAR(100),
    @SoDienThoai  VARCHAR(15),
    @Email        VARCHAR(100),
    @TenDangNhap  VARCHAR(50),
    @MatKhauHash  VARCHAR(255),   -- Đã hash BCrypt từ phía C#
    @MaVaiTro     INT             -- 2: Bác sĩ, 3: Lễ tân
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Kiểm tra tên đăng nhập trùng
    IF EXISTS (SELECT 1 FROM NhanVien WHERE TenDangNhap = @TenDangNhap)
    BEGIN
        RAISERROR(N'Tên đăng nhập "%s" đã tồn tại. Vui lòng chọn tên khác.', 16, 1, @TenDangNhap);
        RETURN;
    END

    -- 2. Kiểm tra số điện thoại trùng
    IF EXISTS (SELECT 1 FROM NhanVien WHERE SoDienThoai = @SoDienThoai)
    BEGIN
        RAISERROR(N'Số điện thoại "%s" đã được đăng ký cho nhân viên khác.', 16, 1, @SoDienThoai);
        RETURN;
    END

    -- 3. Kiểm tra vai trò hợp lệ (chỉ cho phép tạo Bác sĩ và Lễ tân, không tạo Admin thêm)
    IF @MaVaiTro NOT IN (2, 3)
    BEGIN
        RAISERROR(N'Vai trò không hợp lệ. Chỉ có thể tạo Bác sĩ (2) hoặc Lễ tân (3).', 16, 1);
        RETURN;
    END

    -- 4. Tạo tài khoản
    INSERT INTO NhanVien (HoTen, SoDienThoai, Email, TenDangNhap, MatKhau, MaVaiTro, TrangThaiTK, DoiMatKhau)
    VALUES (@HoTen, @SoDienThoai, @Email, @TenDangNhap, @MatKhauHash, @MaVaiTro, 1, 1);
    -- TrangThaiTK = 1: Hoạt động ngay
    -- DoiMatKhau  = 1: Bắt buộc đổi MK khi đăng nhập lần đầu

    DECLARE @MaVuaTao INT = SCOPE_IDENTITY();

    SELECT @MaVuaTao AS MaNhanVienMoi,
           N'Tài khoản đã được tạo. Nhân viên cần đổi mật khẩu khi đăng nhập lần đầu.' AS ThongBao;
END;
GO


-- ============================================================
-- SP 2: KHÓA TÀI KHOẢN
-- Gọi từ: frmQuanLyTaiKhoan (Admin)
-- Dùng khi: Nhân viên nghỉ việc, hoặc vi phạm nội quy
-- ============================================================
CREATE PROCEDURE SP_KhoaTaiKhoan
    @MaNhanVien  INT,
    @LyDo        NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Không cho phép khóa tài khoản Admin
    IF EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien AND MaVaiTro = 1)
    BEGIN
        RAISERROR(N'Không thể khóa tài khoản Admin.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR(N'Không tìm thấy nhân viên với mã %d.', 16, 1, @MaNhanVien);
        RETURN;
    END

    UPDATE NhanVien SET TrangThaiTK = 0 WHERE MaNhanVien = @MaNhanVien;

    SELECT N'Tài khoản đã bị khóa thành công.' AS ThongBao;
END;
GO


-- ============================================================
-- SP 3: MỞ KHÓA TÀI KHOẢN
-- Gọi từ: frmQuanLyTaiKhoan (Admin)
-- ============================================================
CREATE PROCEDURE SP_MoKhoaTaiKhoan
    @MaNhanVien INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR(N'Không tìm thấy nhân viên với mã %d.', 16, 1, @MaNhanVien);
        RETURN;
    END

    UPDATE NhanVien SET TrangThaiTK = 1 WHERE MaNhanVien = @MaNhanVien;

    SELECT N'Tài khoản đã được mở khóa.' AS ThongBao;
END;
GO


-- ============================================================
-- SP 4: ĐẶT LẠI MẬT KHẨU (Admin thực hiện cho nhân viên)
-- Gọi từ: frmQuanLyTaiKhoan (Admin)
-- Đặt lại về MK tạm, bắt đổi MK lần đăng nhập tiếp theo
-- ============================================================
CREATE PROCEDURE SP_ResetMatKhau
    @MaNhanVien      INT,
    @MatKhauTamHash  VARCHAR(255)  -- Admin đặt MK tạm, đã hash từ C#
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR(N'Không tìm thấy nhân viên với mã %d.', 16, 1, @MaNhanVien);
        RETURN;
    END

    UPDATE NhanVien
    SET MatKhau   = @MatKhauTamHash,
        DoiMatKhau = 1               -- Bắt buộc nhân viên đổi MK khi đăng nhập lại
    WHERE MaNhanVien = @MaNhanVien;

    SELECT N'Mật khẩu đã được đặt lại. Nhân viên cần đổi mật khẩu khi đăng nhập lần tới.' AS ThongBao;
END;
GO


-- ============================================================
-- SP 5: ĐĂNG NHẬP
-- Gọi từ: frmDangNhap
-- Trả về thông tin nhân viên nếu hợp lệ, hoặc mã lỗi cụ thể
-- Note: So sánh hash MatKhau nên thực hiện ở tầng C# (BCrypt.Verify)
--       SP này chỉ trả dữ liệu, C# tự kiểm tra hash
-- ============================================================
CREATE PROCEDURE SP_DangNhap
    @TenDangNhap VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        nv.MaNhanVien,
        nv.HoTen,
        nv.TenDangNhap,
        nv.MatKhau,      -- C# sẽ dùng BCrypt.Verify để so sánh
        nv.MaVaiTro,
        vt.TenVaiTro,
        nv.TrangThaiTK,
        nv.DoiMatKhau
    FROM NhanVien nv
    INNER JOIN VaiTro vt ON nv.MaVaiTro = vt.MaVaiTro
    WHERE nv.TenDangNhap = @TenDangNhap;
    -- Nếu không có dòng nào trả về → TenDangNhap không tồn tại
    -- C# xử lý logic: TrangThaiTK=0 → báo bị khóa, DoiMatKhau=1 → chuyển đổi MK
END;
GO


-- ============================================================
-- SP 6: ĐỔI MẬT KHẨU (Nhân viên tự đổi — lần đầu hoặc tùy ý)
-- Gọi từ: frmDoiMatKhau, frmDoiMatKhau_TuNguyen
-- ============================================================
CREATE PROCEDURE SP_DoiMatKhau
    @MaNhanVien    INT,
    @MatKhauMoiHash VARCHAR(255)  -- Hash BCrypt từ C#
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR(N'Không tìm thấy nhân viên.', 16, 1);
        RETURN;
    END

    UPDATE NhanVien
    SET MatKhau    = @MatKhauMoiHash,
        DoiMatKhau = 0              -- Đã đổi MK thành công
    WHERE MaNhanVien = @MaNhanVien;

    SELECT N'Mật khẩu đã được cập nhật thành công.' AS ThongBao;
END;
GO


-- ============================================================
-- KIỂM TRA
-- ============================================================
PRINT N'--- TEST: Tạo tài khoản ---';

-- Test 1: Tạo tài khoản hợp lệ
BEGIN TRY
    EXEC SP_TaoTaiKhoan
        @HoTen       = N'BS. Nguyễn Minh Khoa',
        @SoDienThoai = '0955000111',
        @Email       = 'khoa@phongkham.com',
        @TenDangNhap = 'bskhoa',
        @MatKhauHash = 'hashed_temp_123',
        @MaVaiTro    = 2;
    PRINT N'-> Test 1 PASS: Tạo tài khoản thành công';
END TRY
BEGIN CATCH
    PRINT N'-> Test 1 FAIL: ' + ERROR_MESSAGE();
END CATCH

-- Test 2: Tạo trùng TenDangNhap
BEGIN TRY
    EXEC SP_TaoTaiKhoan
        @HoTen       = N'Người Trùng Tên',
        @SoDienThoai = '0955999000',
        @Email       = 'trung@phongkham.com',
        @TenDangNhap = 'bskhoa',   -- Trùng với test 1
        @MatKhauHash = 'hash_xxx',
        @MaVaiTro    = 3;
    PRINT N'-> Test 2 FAIL: Hệ thống không chặn trùng TenDangNhap!';
END TRY
BEGIN CATCH
    PRINT N'-> Test 2 PASS (Đã chặn): ' + ERROR_MESSAGE();
END CATCH

-- Test 3: Khóa tài khoản
BEGIN TRY
    EXEC SP_KhoaTaiKhoan @MaNhanVien = 3;
    PRINT N'-> Test 3 PASS: Khóa TK lễ tân thành công';
END TRY
BEGIN CATCH
    PRINT N'-> Test 3 FAIL: ' + ERROR_MESSAGE();
END CATCH

-- Test 4: Mở khóa lại
BEGIN TRY
    EXEC SP_MoKhoaTaiKhoan @MaNhanVien = 3;
    PRINT N'-> Test 4 PASS: Mở khóa TK lễ tân thành công';
END TRY
BEGIN CATCH
    PRINT N'-> Test 4 FAIL: ' + ERROR_MESSAGE();
END CATCH

PRINT N'--- KIỂM TRA HOÀN TẤT ---';
GO
