<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký | DramaSoft Clinic</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <link rel="stylesheet" href="public/assets/css/style.css">
    <link rel="stylesheet" href="public/assets/css/auth.css">
</head>
<body class="auth-page">
    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm" id="mainNav">
        <div class="container-fluid px-4 px-lg-5">
            <a class="navbar-brand logo-wrapper" href="index.php?route=home">
                <img src="public/assets/images/logo.png" alt="DramaSoft" class="img-fluid logo-img">
            </a>
            <div class="ms-auto d-flex align-items-center gap-3">
                <a href="index.php?route=home" class="btn btn-outline-primary rounded-pill px-4">Trang chủ</a>
                <a href="index.php?route=login" class="btn btn-primary rounded-pill px-4">Đăng nhập</a>
            </div>
        </div>
    </nav>

    <main class="auth-main">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-xl-10">
                    <div class="card auth-card">
                        <div class="row g-0">
                            <div class="col-lg-7">
                                <div class="card-body p-md-5">
                                    <div class="auth-eyebrow">Create Account</div>
                                    <h1 class="auth-title h2">Tạo tài khoản mới</h1>
                                    <div class="auth-separator"></div>
                                    <p class="auth-hint">Đăng ký ngay để theo dõi lịch hẹn, hồ sơ điều trị và ưu đãi dành riêng cho thành viên.</p>

                                    <form>
                                        <div class="mb-3">
                                            <label class="form-label fw-medium text-muted">Họ và tên</label>
                                            <input type="text" class="form-control" placeholder="Nguyễn Văn A" required>
                                        </div>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label fw-medium text-muted">Số điện thoại</label>
                                                <input type="tel" class="form-control" placeholder="09xx xxx xxx" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label fw-medium text-muted">Email</label>
                                                <input type="email" class="form-control" placeholder="name@example.com" required>
                                            </div>
                                        </div>
                                        <div class="row g-3 mt-1">
                                            <div class="col-md-6">
                                                <label class="form-label fw-medium text-muted">Mật khẩu</label>
                                                <input type="password" class="form-control" placeholder="Tối thiểu 8 ký tự" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label fw-medium text-muted">Xác nhận mật khẩu</label>
                                                <input type="password" class="form-control" placeholder="Nhập lại mật khẩu" required>
                                            </div>
                                        </div>
                                        <div class="form-check mt-4 mb-4">
                                            <input class="form-check-input" type="checkbox" id="agreePolicy" required>
                                            <label class="form-check-label text-muted" for="agreePolicy">Tôi đồng ý với chính sách bảo mật và điều khoản dịch vụ của DramaSoft.</label>
                                        </div>
                                        <button class="btn btn-primary w-100 py-3 rounded-pill fw-bold" type="submit">Đăng ký tài khoản</button>
                                    </form>

                                    <p class="text-muted mb-0 mt-4">Đã có tài khoản? <a href="index.php?route=login" class="auth-alt-link">Đăng nhập ngay</a></p>
                                </div>
                            </div>
                            <div class="col-lg-5 auth-brand-box">
                                <div class="h-100 d-flex flex-column justify-content-center p-4 p-md-5 auth-brand-content">
                                    <img src="public/assets/images/logo.png" alt="DramaSoft" class="mb-4 auth-brand-logo">
                                    <h2 class="font-heading h4 mb-3">Trở thành thành viên DramaSoft</h2>
                                    <ul class="list-unstyled auth-brand-list mb-0">
                                        <li><i class="bi bi-award text-primary me-2"></i>Tích lũy điểm nâng hạng thành viên</li>
                                        <li><i class="bi bi-calendar-check text-primary me-2"></i>Ưu tiên lịch hẹn khung giờ đẹp</li>
                                        <li><i class="bi bi-gift text-primary me-2"></i>Nhận ưu đãi độc quyền mỗi tháng</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

