document.addEventListener('DOMContentLoaded', function() {
    
    // 1. Kích hoạt hiệu ứng Scroll Animation (AOS)
    AOS.init({
        once: true,       // Hiệu ứng chỉ chạy 1 lần khi cuộn xuống
        offset: 80,       // Bắt đầu hiệu ứng cách viền dưới màn hình 80px
        duration: 800,    // Thời gian hiệu ứng (0.8s)
        easing: 'ease-out-cubic',
    });

    // 2. Hiệu ứng thu gọn và đổ bóng Navbar khi cuộn trang
    const navbar = document.getElementById('mainNav');
    
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // 3. (Mới) Tự động đóng Menu Mobile khi bấm vào link
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
    const menuToggle = document.getElementById('navbarResponsive');
    
    // Kiểm tra xem Bootstrap có sẵn sàng chưa
    if (typeof bootstrap !== 'undefined') {
        const bsCollapse = new bootstrap.Collapse(menuToggle, { toggle: false });
        
        navLinks.forEach(function(link) {
            link.addEventListener('click', function() {
                // Nếu menu đang mở (có class 'show'), thì đóng lại
                if (menuToggle.classList.contains('show')) {
                    bsCollapse.toggle();
                }
            });
        });
    }
});