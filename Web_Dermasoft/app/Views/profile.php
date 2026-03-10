<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân | DramaSoft Clinic</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <link rel="stylesheet" href="public/assets/css/style.css">
    <link rel="stylesheet" href="public/assets/css/profile.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm transition-all" id="mainNav">
        <div class="container-fluid px-4 px-lg-5">
            <a class="navbar-brand logo-wrapper" href="index.php?route=home">
                <img src="public/assets/images/logo.png" alt="DramaSoft" class="img-fluid logo-img">
            </a>
            
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0 text-uppercase fw-medium" style="font-family: var(--font-body); font-size: 0.9rem;">
                    <li class="nav-item px-2"><a class="nav-link" href="index.php?route=home#about">Không gian</a></li>
                    <li class="nav-item px-2"><a class="nav-link" href="index.php?route=home#doctor">Chuyên gia</a></li>
                    <li class="nav-item px-2"><a class="nav-link" href="index.php?route=home#process">Quy trình</a></li>
                    <li class="nav-item px-2"><a class="nav-link" href="index.php?route=home#products">Sản phẩm</a></li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <a href="index.php?route=home#booking" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">Đặt Lịch</a>
                    <div class="dropdown">
                        <a href="#" class="text-dark fs-4 dropdown-toggle icon-link" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle text-primary"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3">
                            <li><a class="dropdown-item active bg-light-mint text-primary fw-bold" href="index.php?route=profile"><i class="bi bi-person-vcard me-2"></i>Hồ sơ của tôi</a></li>
                            <li><a class="dropdown-item" href="index.php?route=profile#v-pills-appointments"><i class="bi bi-clock-history me-2"></i>Lịch sử khám</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="index.php?route=home"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <section class="mt-5 pt-5 pb-4 bg-light-mint border-bottom">
        <div class="container pt-4">
            <div class="d-flex align-items-center gap-4" data-aos="fade-up">
                <div class="position-relative">
                    <img src="https://ui-avatars.com/api/?name=Nguyen+Van+A&background=0F5C4D&color=fff&size=100" alt="Avatar" class="rounded-circle shadow border border-3 border-white">
                    <span class="position-absolute bottom-0 end-0 bg-warning border border-2 border-white rounded-circle p-2" title="Thành viên Vàng">
                        <i class="bi bi-star-fill text-white fs-6"></i>
                    </span>
                </div>
                <div>
                    <?php 
                        // Biến PHP demo
                        $customerName = "Nguyễn Văn A";
                        $customerPhone = "0987 654 321";
                    ?>
                    <h2 class="font-heading fw-bold mb-1"><?php echo $customerName; ?></h2>
                    <p class="text-muted mb-0"><i class="bi bi-telephone-fill text-primary me-2"></i><?php echo $customerPhone; ?></p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row g-4">
                
                <div class="col-lg-3" data-aos="fade-right">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <div class="card-body p-0">
                            <div class="nav flex-column nav-pills custom-nav-pills p-3" id="v-pills-tab" role="tablist">
                                <button class="nav-link active text-start mb-2 rounded-3 fw-medium py-3" id="v-pills-membership-tab" data-bs-toggle="pill" data-bs-target="#v-pills-membership" type="button">
                                    <i class="bi bi-award-fill me-2 fs-5"></i> Hạng Thành Viên
                                </button>
                                <button class="nav-link text-start mb-2 rounded-3 fw-medium py-3" id="v-pills-appointments-tab" data-bs-toggle="pill" data-bs-target="#v-pills-appointments" type="button">
                                    <i class="bi bi-calendar-check-fill me-2 fs-5"></i> Lịch Hẹn Khám
                                </button>
                                <button class="nav-link text-start rounded-3 fw-medium py-3" id="v-pills-profile-tab" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button">
                                    <i class="bi bi-person-lines-fill me-2 fs-5"></i> Chỉnh Sửa Hồ Sơ
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-9" data-aos="fade-left">
                    <div class="tab-content" id="v-pills-tabContent">
                        
                        <div class="tab-pane fade show active" id="v-pills-membership">
                            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 mb-4">
                                <h4 class="fw-bold text-primary mb-4 font-heading">Hạng Thành Viên Của Bạn</h4>
                                
                                <div class="bg-light rounded-4 p-4 text-center mb-5 border">
                                    <h5 class="text-muted mb-2">Hạng hiện tại</h5>
                                    <h2 class="text-warning fw-bold mb-3"><i class="bi bi-star-fill me-2"></i>THÀNH VIÊN VÀNG</h2>
                                    <p class="mb-0">Bạn cần tích lũy thêm <strong>1,500 điểm</strong> để thăng hạng <strong>Thành Viên Đen (Kim Cương)</strong>.</p>
                                </div>

                                <div class="membership-tracker mt-5 mb-4 position-relative">
                                    <div class="progress position-absolute top-50 start-0 w-100 translate-middle-y" style="height: 4px; z-index: 1;">
                                        <div class="progress-bar bg-warning" role="progressbar" style="width: 75%;"></div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between position-relative" style="z-index: 2;">
                                        <div class="tier-step text-center active">
                                            <div class="tier-icon bg-danger text-white rounded-circle shadow-sm border border-4 border-white mx-auto d-flex align-items-center justify-content-center">
                                                <i class="bi bi-heart-fill"></i>
                                            </div>
                                            <div class="mt-2 fw-bold text-danger">Thẻ Đỏ</div>
                                        </div>
                                        <div class="tier-step text-center active">
                                            <div class="tier-icon bg-secondary text-white rounded-circle shadow-sm border border-4 border-white mx-auto d-flex align-items-center justify-content-center">
                                                <i class="bi bi-shield-fill"></i>
                                            </div>
                                            <div class="mt-2 fw-bold text-secondary">Thẻ Bạc</div>
                                        </div>
                                        <div class="tier-step text-center current">
                                            <div class="tier-icon bg-warning text-white rounded-circle shadow border border-4 border-white mx-auto d-flex align-items-center justify-content-center">
                                                <i class="bi bi-star-fill"></i>
                                            </div>
                                            <div class="mt-2 fw-bold text-warning">Thẻ Vàng</div>
                                        </div>
                                        <div class="tier-step text-center">
                                            <div class="tier-icon bg-dark text-white rounded-circle shadow-sm border border-4 border-white mx-auto d-flex align-items-center justify-content-center" style="opacity: 0.5;">
                                                <i class="bi bi-gem"></i>
                                            </div>
                                            <div class="mt-2 fw-bold text-dark" style="opacity: 0.5;">Thẻ Đen</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="v-pills-appointments">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="fw-bold text-primary font-heading mb-0">Lịch Hẹn Sắp Tới</h4>
                                <a href="index.php?route=home#booking" class="btn btn-primary rounded-pill btn-sm px-3"><i class="bi bi-plus-lg me-1"></i>Đặt lịch mới</a>
                            </div>
                            
                            <div class="card border-0 shadow-sm rounded-4 p-4 mb-5 border-start border-4 border-warning">
                                <div class="row align-items-center">
                                    <div class="col-md-3 text-center border-end mb-3 mb-md-0">
                                        <h3 class="text-primary fw-bold mb-0">15</h3>
                                        <p class="text-muted mb-0 fw-medium">Tháng 11, 2026</p>
                                        <div class="badge bg-light-mint text-primary mt-2">09:30 SA</div>
                                    </div>
                                    <div class="col-md-6 ps-md-4 mb-3 mb-md-0">
                                        <h5 class="fw-bold mb-2">Trị liệu công nghệ cao (Laser)</h5>
                                        <p class="text-muted mb-1"><i class="bi bi-person-badge text-primary me-2"></i>Bác sĩ phụ trách: BS. Trần Thị B</p>
                                        <p class="text-muted mb-0"><i class="bi bi-geo-alt-fill text-primary me-2"></i>Cơ sở 123 Đường Láng</p>
                                    </div>
                                    <div class="col-md-3 text-md-end">
                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill mb-2">Chờ xác nhận</span><br>
                                        <button class="btn btn-outline-danger btn-sm rounded-pill mt-2">Hủy lịch</button>
                                    </div>
                                </div>
                            </div>

                            <h4 class="fw-bold text-primary font-heading mb-4 mt-5">Lịch Sử Khám Bệnh</h4>
                            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="bg-light text-muted">
                                            <tr>
                                                <th class="py-3 px-4">Ngày khám</th>
                                                <th class="py-3">Dịch vụ</th>
                                                <th class="py-3">Bác sĩ</th>
                                                <th class="py-3 text-end px-4">Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="py-3 px-4">10/10/2026</td>
                                                <td class="py-3 fw-medium">Tư vấn da chuyên sâu 1:1</td>
                                                <td class="py-3">BS. Nguyễn Văn C</td>
                                                <td class="py-3 text-end px-4"><span class="badge bg-success bg-opacity-10 text-success px-2 py-1">Đã hoàn thành</span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="v-pills-profile">
                            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5">
                                <h4 class="fw-bold text-primary mb-4 font-heading">Chỉnh Sửa Thông Tin Cá Nhân</h4>
                                
                                <form action="index.php?route=profile" method="POST" enctype="multipart/form-data">
                                    
                                    <div class="d-flex align-items-center gap-4 mb-5">
                                        <img src="https://ui-avatars.com/api/?name=Nguyen+Van+A&background=0F5C4D&color=fff&size=80" id="avatarPreview" alt="Avatar" class="rounded-circle shadow-sm" style="width: 80px; height: 80px; object-fit: cover;">
                                        <div>
                                            <label for="avatarUpload" class="btn btn-outline-primary rounded-pill btn-sm mb-2"><i class="bi bi-camera me-2"></i>Thay đổi ảnh đại diện</label>
                                            <input type="file" id="avatarUpload" name="avatar" class="d-none" accept="image/*">
                                            <p class="text-muted small mb-0">Định dạng JPEG, PNG. Tối đa 2MB.</p>
                                        </div>
                                    </div>

                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label class="form-label fw-medium text-muted">Họ và Tên</label>
                                            <input type="text" name="fullname" class="form-control form-control-lg border-primary border-opacity-50" value="<?php echo $customerName; ?>">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-medium text-muted">Số điện thoại</label>
                                            <input type="tel" name="phone" class="form-control form-control-lg border-primary border-opacity-50" value="<?php echo $customerPhone; ?>">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-medium text-muted">Email</label>
                                            <input type="email" name="email" class="form-control form-control-lg border-primary border-opacity-50" value="nguyenvana@gmail.com">
                                        </div>
                                    </div>
                                    
                                    <hr class="my-5 opacity-10">
                                    
                                    <div class="d-flex justify-content-end gap-3">
                                        <button type="button" class="btn btn-light rounded-pill px-4">Hủy Bỏ</button>
                                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold"><i class="bi bi-save me-2"></i>Lưu Thay Đổi</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="py-5 bg-white border-top">
        <div class="container">
            <div class="row g-4 justify-content-between mb-4">
                <div class="col-lg-5">
                    <img src="public/assets/images/logo.png" alt="DramaSoft" class="img-fluid mb-4" style="height: 45px;">
                    <p class="text-muted mb-4 pe-lg-4">DramaSoft Clinic tự hào là hệ thống phòng khám chuyên khoa da liễu hàng đầu, nơi kiến tạo và tôn vinh vẻ đẹp nguyên bản thông qua các giải pháp thẩm mỹ an toàn, cá nhân hóa và chuẩn y khoa.</p>
                    
                    <div class="d-flex align-items-center mb-3 text-muted">
                        <i class="bi bi-geo-alt-fill text-primary fs-5 me-3"></i>
                        <span>123 Đường Láng, Quận Đống Đa, Hà Nội</span>
                    </div>
                    <div class="d-flex align-items-center mb-3 text-muted">
                        <i class="bi bi-telephone-fill text-primary fs-5 me-3"></i>
                        <span>Hotline CSKH: <strong class="text-primary">1800 xxxx</strong> (Miễn phí)</span>
                    </div>
                    <div class="d-flex align-items-center text-muted">
                        <i class="bi bi-envelope-fill text-primary fs-5 me-3"></i>
                        <span>Email: cskh@dramasoft.vn</span>
                    </div>
                </div>
                
                <div class="col-lg-5">
                    <h5 class="text-primary fw-bold mb-4 font-heading">Thời gian hoạt động</h5>
                    <p class="text-muted mb-4">
                        <i class="bi bi-clock-fill text-primary me-2"></i> Thứ Hai - Chủ Nhật: <strong>08:30 - 20:00</strong><br>
                        <span class="ms-4 small">(Phòng khám mở cửa xuyên suốt các ngày lễ)</span>
                    </p>
                    
                    <h5 class="text-primary fw-bold mb-3 font-heading mt-5">Kết nối với chúng tôi</h5>
                    <div class="d-flex gap-3 mb-4">
                        <a href="#" class="btn btn-outline-primary rounded-circle" style="width: 40px; height: 40px; padding: 6px;"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="btn btn-outline-primary rounded-circle" style="width: 40px; height: 40px; padding: 6px;"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="btn btn-outline-primary rounded-circle" style="width: 40px; height: 40px; padding: 6px;"><i class="bi bi-tiktok"></i></a>
                    </div>

                    <ul class="list-inline mb-0">
                        <li class="list-inline-item me-3"><a href="index.php?route=home#about" class="text-decoration-none text-muted hover-primary">Về DramaSoft</a></li>
                        <li class="list-inline-item me-3"><a href="#" class="text-decoration-none text-muted hover-primary">Chính sách bảo mật</a></li>
                        <li class="list-inline-item"><a href="#" class="text-decoration-none text-muted hover-primary">Điều khoản dịch vụ</a></li>
                    </ul>
                </div>
            </div>
            
            <hr class="text-muted opacity-25 my-4">
            
            <div class="text-center">
                <p class="mb-0 small text-muted">&copy; 2026 DramaSoft Clinic. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <script src="public/assets/js/script.js"></script>
    <script src="public/assets/js/profile.js"></script>
</body>
</html>
