<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DramaSoft Clinic - Nâng Tầm Vẻ Đẹp Chuẩn Y Khoa</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <link rel="stylesheet" href="public/assets/css/style.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm transition-all" id="mainNav">
        <div class="container-fluid px-4 px-lg-5">
            <a class="navbar-brand logo-wrapper" href="#">
                <img src="public/assets/images/logo.png" alt="DramaSoft" class="img-fluid logo-img">
            </a>
            
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0 text-uppercase fw-medium" style="font-family: var(--font-body); font-size: 0.9rem;">
                    <li class="nav-item px-2"><a class="nav-link" href="#about">Không gian</a></li>
                    <li class="nav-item px-2"><a class="nav-link" href="#doctor">Chuyên gia</a></li>
                    <li class="nav-item px-2"><a class="nav-link" href="#process">Quy trình</a></li>
                    <li class="nav-item px-2"><a class="nav-link" href="#products">Sản phẩm</a></li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <a href="#booking" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">Đặt Lịch</a>
                    <div class="dropdown">
                        <a href="#" class="text-dark fs-4 dropdown-toggle icon-link" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-person-circle text-primary"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3">
                            <li><a class="dropdown-item" href="index.php?route=login"><i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập</a></li>
                            <li><a class="dropdown-item" href="index.php?route=profile"><i class="bi bi-person-vcard me-2"></i>Hồ sơ của tôi</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="index.php?route=profile"><i class="bi bi-clock-history me-2"></i>Lịch sử khám</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <section id="home" class="mt-5 pt-5">
        <div class="container-fluid p-0 overflow-hidden" data-aos="fade-in" data-aos-duration="1500">
            <div class="image-wrapper hover-zoom-slow">
                <img src="public/assets/images/banner.png" alt="DramaSoft - Nâng tầm vẻ đẹp chuẩn y khoa" class="w-100 img-fluid">
            </div>
        </div>
    </section>

    <section id="about" class="py-5 bg-light-mint">
        <div class="container py-5">
            <div class="row align-items-center mb-5" data-aos="fade-up">
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <h2 class="section-title">Ấn tượng<br>từ cái nhìn đầu tiên.</h2>
                    <p class="text-muted">Không gian tiếp đón sang trọng, hiện đại với tông màu thư giãn, mang lại cảm giác bình yên ngay khi bạn bước qua cánh cửa DramaSoft.</p>
                </div>
                <div class="col-lg-6">
                    <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom">
                        <img src="public/assets/images/welcome3.png" alt="Lễ tân DramaSoft" class="w-100 img-fluid">
                    </div>
                </div>
            </div>
            
            <div class="row align-items-center flex-column-reverse flex-lg-row" data-aos="fade-up" data-aos-delay="200">
                <div class="col-lg-7">
                    <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom">
                        <img src="public/assets/images/Phongcho.png" alt="Phòng chờ thư giãn" class="w-100 img-fluid">
                    </div>
                </div>
                <div class="col-lg-5 ps-lg-5 mb-4 mb-lg-0">
                    <h2 class="section-title">Thư thái<br>trước mọi liệu trình.</h2>
                    <p class="text-muted">Khu vực chờ chuẩn VIP với ghế thư giãn, âm nhạc trị liệu và không gian tinh tế, giúp bạn rũ bỏ mọi căng thẳng.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="doctor" class="py-5">
        <div class="container py-5 text-center" data-aos="fade-up">
            <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom mb-5 mx-auto" style="max-width: 1000px;">
                <img src="public/assets/images/doctor.png" alt="Chuyên gia đầu ngành" class="w-100 img-fluid">
            </div>
            <h2 class="section-title">Đội ngũ chuyên gia đầu ngành</h2>
            <p class="text-muted mx-auto fs-5" style="max-width: 800px;">Tại DramaSoft, 100% đội ngũ bác sĩ đều có chuyên môn cao, nhiều năm kinh nghiệm trong lĩnh vực da liễu thẩm mỹ. Chúng tôi cam kết đồng hành cùng bạn trên con đường tìm lại vẻ đẹp nguyên bản và sự tự tin.</p>
        </div>
    </section>

    <section id="consultation" class="py-5 bg-light-mint">
        <div class="container py-5">
            <div class="row align-items-center" data-aos="fade-up">
                <div class="col-lg-6 mb-4 mb-lg-0 pe-lg-5">
                    <h2 class="section-title">Cá nhân hóa<br>mọi phác đồ.</h2>
                    <p class="text-muted fs-5 mb-4">Sự khác biệt của DramaSoft nằm ở sự thấu hiểu. Bác sĩ chuyên khoa sẽ trực tiếp thăm khám, lắng nghe và thiết lập một phác đồ trị liệu dành riêng cho làn da của bạn.</p>
                    <a href="#booking" class="btn btn-outline-primary rounded-pill px-4 py-2">Nhận Tư Vấn Ngay</a>
                </div>
                <div class="col-lg-6">
                    <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom">
                        <img src="public/assets/images/TuVan.png" alt="Bác sĩ tư vấn 1:1" class="w-100 img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="process" class="py-5">
        <div class="container py-5 text-center" data-aos="fade-up">
            <h2 class="section-title mb-5">Quy trình chuẩn Y khoa</h2>
            <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom mx-auto mb-5">
                <img src="public/assets/images/quytrinh.png" alt="Khám - Trị liệu - Tái tạo" class="w-100 img-fluid">
            </div>
            
            <div class="row g-4 text-start">
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <h4 class="fw-bold text-primary mb-3"><span class="fs-2 me-2">01</span>Khám & Phân tích</h4>
                    <p class="text-muted">Ứng dụng công nghệ soi da đa tầng tiên tiến, bác sĩ sẽ đánh giá chính xác tình trạng da hiện tại, từ đó tìm ra căn nguyên của vấn đề.</p>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <h4 class="fw-bold text-primary mb-3"><span class="fs-2 me-2">02</span>Trị liệu cá nhân hóa</h4>
                    <p class="text-muted">Mỗi khách hàng sở hữu một phác đồ chuyên biệt. Quá trình điều trị kết hợp tay nghề bác sĩ và hệ thống máy móc chuẩn FDA.</p>
                </div>
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                    <h4 class="fw-bold text-primary mb-3"><span class="fs-2 me-2">03</span>Tái tạo & Phục hồi</h4>
                    <p class="text-muted">Bước đệm hoàn hảo để nuôi dưỡng làn da khỏe mạnh từ sâu bên trong, duy trì kết quả thẩm mỹ lâu dài bằng dược mỹ phẩm cao cấp.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="facilities" class="py-5 bg-light-mint">
        <div class="container py-5">
            <div class="text-center mb-5" data-aos="fade-down">
                <h2 class="section-title">Hệ thống trang thiết bị & Không gian VIP</h2>
            </div>
            
            <div class="row align-items-center mb-5" data-aos="fade-up">
                <div class="col-lg-6 mb-4 mb-lg-0 pe-lg-5">
                    <h3 class="fw-bold text-primary mb-3">Công nghệ chuyển giao<br>chính hãng</h3>
                    <p class="text-muted">DramaSoft tự hào sở hữu hệ thống trang thiết bị nhập khẩu 100% từ các quốc gia đi đầu về thẩm mỹ. Mọi công nghệ đều được kiểm định khắt khe, đảm bảo an toàn tuyệt đối và mang lại hiệu quả tối ưu.</p>
                </div>
                <div class="col-lg-6">
                    <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom">
                        <img src="public/assets/images/ThietBi.png" alt="Thiết bị công nghệ cao" class="w-100 img-fluid">
                    </div>
                </div>
            </div>
            
            <div class="row align-items-center flex-column-reverse flex-lg-row" data-aos="fade-up" data-aos-delay="200">
                <div class="col-lg-7">
                    <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom">
                        <img src="public/assets/images/VIP.png" alt="Phòng điều trị VIP" class="w-100 img-fluid">
                    </div>
                </div>
                <div class="col-lg-5 ps-lg-5 mb-4 mb-lg-0">
                    <h3 class="fw-bold text-primary mb-3">Không gian VIP<br>đề cao sự riêng tư</h3>
                    <p class="text-muted">Trải nghiệm dịch vụ làm đẹp trong không gian phòng VIP khép kín, sang trọng. Mùi hương tinh dầu dịu nhẹ cùng sự chăm sóc tận tình sẽ giúp bạn có những phút giây thư giãn trọn vẹn nhất.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="products" class="py-5">
        <div class="container py-5">
            <div class="row align-items-center" data-aos="fade-up">
                <div class="col-lg-6 mb-4 mb-lg-0 pe-lg-5">
                    <h2 class="section-title">Dược mỹ phẩm<br>chuyên sâu.</h2>
                    <p class="text-muted fs-5 mb-4">Để duy trì và tối ưu hóa kết quả điều trị, DramaSoft cung cấp các dòng dược mỹ phẩm độc quyền, được tinh tuyển khắt khe bởi các chuyên gia da liễu hàng đầu.</p>
                    <ul class="list-unstyled text-muted mb-4 fs-5">
                        <li class="mb-3"><i class="bi bi-shield-check text-primary me-2"></i> Bảng thành phần an toàn, lành tính.</li>
                        <li class="mb-3"><i class="bi bi-droplet-half text-primary me-2"></i> Tương thích hoàn hảo sau trị liệu công nghệ cao.</li>
                        <li class="mb-3"><i class="bi bi-stars text-primary me-2"></i> Nuôi dưỡng và bảo vệ hàng rào tự nhiên của da.</li>
                    </ul>
                    <a href="#booking" class="btn btn-outline-primary rounded-pill px-4 py-2 mt-2">Khám phá bộ sản phẩm</a>
                </div>
                <div class="col-lg-6">
                    <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom">
                        <img src="public/assets/images/Product.png" alt="Khu vực trưng bày sản phẩm DramaSoft" class="w-100 img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="booking" class="py-5 bg-light position-relative">
        <div class="container py-5 position-relative z-1">
            <div class="row justify-content-center" data-aos="fade-up">
                <div class="col-lg-8 text-center">
                    <h2 class="font-heading fw-bold display-5 mb-3 text-primary">Bắt đầu hành trình của bạn.</h2>
                    <p class="mb-5 text-muted fs-5">Để lại thông tin, chuyên viên tư vấn của DramaSoft sẽ liên hệ với bạn trong vòng 30 phút.</p>
                    
                    <form class="bg-white p-4 p-md-5 rounded-4 shadow-sm border text-start">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <input type="text" class="form-control form-control-lg border-primary" placeholder="Họ và Tên (*)" required>
                            </div>
                            <div class="col-md-6">
                                <input type="tel" class="form-control form-control-lg border-primary" placeholder="Số điện thoại (*)" required>
                            </div>
                            <div class="col-12">
                                <select class="form-select form-select-lg border-primary">
                                    <option selected>Bạn đang quan tâm dịch vụ nào?</option>
                                    <option value="1">Tư vấn da cùng Bác sĩ</option>
                                    <option value="2">Trị liệu công nghệ cao</option>
                                    <option value="3">Chăm sóc & Phục hồi da</option>
                                </select>
                            </div>
                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold">GỬI YÊU CẦU ĐẶT LỊCH</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="container mt-5 pt-3" data-aos="fade-up">
            <div class="image-wrapper rounded-4 overflow-hidden shadow-lg hover-zoom">
                <img src="public/assets/images/footer.png" alt="DramaSoft - Trải nghiệm trọn vẹn" class="w-100 img-fluid">
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
                        <li class="list-inline-item me-3"><a href="#about" class="text-decoration-none text-muted hover-primary">Về DramaSoft</a></li>
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
</body>
</html>
