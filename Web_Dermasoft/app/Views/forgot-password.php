<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu | DramaSoft Clinic</title>

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
                <div class="col-lg-8 col-xl-7">
                    <div class="card auth-card">
                        <div class="card-body p-4 p-md-5 text-center">
                            <div class="auth-eyebrow">Password Recovery</div>
                            <h1 class="auth-title h2">Khôi phục mật khẩu</h1>
                            <div class="auth-separator mx-auto"></div>
                            <p class="auth-hint">Nhập email hoặc số điện thoại đã đăng ký. Chúng tôi sẽ gửi hướng dẫn đặt lại mật khẩu cho bạn.</p>

                            <form class="text-start">
                                <div class="mb-4">
                                    <label class="form-label fw-medium text-muted">Email hoặc Số điện thoại</label>
                                    <input type="text" class="form-control" placeholder="name@example.com hoặc 09xx xxx xxx" required>
                                </div>
                                <button class="btn btn-primary w-100 py-3 rounded-pill fw-bold" type="submit">Gửi yêu cầu khôi phục</button>
                            </form>

                            <div class="mt-4 d-flex flex-wrap justify-content-center gap-3">
                                <a href="index.php?route=login" class="auth-alt-link"><i class="bi bi-arrow-left me-1"></i>Quay lại đăng nhập</a>
                                <a href="index.php?route=register" class="auth-alt-link">Tạo tài khoản mới</a>
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

