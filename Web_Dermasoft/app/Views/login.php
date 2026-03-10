<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | DramaSoft Clinic</title>

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
                <a href="index.php?route=register" class="btn btn-primary rounded-pill px-4">Đăng ký</a>
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
                                    <div class="auth-eyebrow">Member Access</div>
                                    <h1 class="auth-title h2">Đăng nhập tài khoản</h1>
                                    <div class="auth-separator"></div>
                                    <p class="auth-hint">Chào mừng bạn quay lại DramaSoft. Vui lòng nhập thông tin để tiếp tục.</p>

                                    <form>
                                        <div class="mb-3">
                                            <label class="form-label fw-medium text-muted">Email hoặc Số điện thoại</label>
                                            <input type="text" class="form-control" placeholder="example@gmail.com hoặc 09xx xxx xxx" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label fw-medium text-muted">Mật khẩu</label>
                                            <input type="password" class="form-control" placeholder="Nhập mật khẩu" required>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="rememberMe">
                                                <label class="form-check-label text-muted" for="rememberMe">Ghi nhớ đăng nhập</label>
                                            </div>
                                            <a href="index.php?route=forgot-password" class="auth-alt-link">Quên mật khẩu?</a>
                                        </div>
                                        <button class="btn btn-primary w-100 py-3 rounded-pill fw-bold" type="submit">Đăng nhập</button>
                                    </form>

                                    <p class="text-muted mb-0 mt-4">Bạn chưa có tài khoản? <a href="index.php?route=register" class="auth-alt-link">Đăng ký ngay</a></p>
                                </div>
                            </div>
                            <div class="col-lg-5 auth-brand-box">
                                <div class="h-100 d-flex flex-column justify-content-center p-4 p-md-5 auth-brand-content">
                                    <img src="public/assets/images/logo.png" alt="DramaSoft" class="mb-4 auth-brand-logo">
                                    <h2 class="font-heading h4 mb-3">Nâng tầm vẻ đẹp chuẩn y khoa</h2>
                                    <ul class="list-unstyled auth-brand-list mb-0">
                                        <li><i class="bi bi-shield-check text-primary me-2"></i>Bác sĩ chuyên khoa đồng hành 1:1</li>
                                        <li><i class="bi bi-stars text-primary me-2"></i>Phác đồ cá nhân hóa theo làn da</li>
                                        <li><i class="bi bi-heart-pulse text-primary me-2"></i>Công nghệ chuẩn FDA, an toàn</li>
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

