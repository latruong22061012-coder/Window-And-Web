document.addEventListener('DOMContentLoaded', function () {
    // 1. Hiệu ứng đổi màu header khi cuộn trang
    const header = document.getElementById('header');
    window.addEventListener('scroll', function () {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });

    // 2. Hiệu ứng cuộn mượt (Smooth Scroll) cho các liên kết menu
    const links = document.querySelectorAll('.nav-links a, .hero-buttons a, .footer-links a, .product-text a, .btn-primary');
    for (const link of links) {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const href = this.getAttribute('href');
            if (href === "#") return;
            const target = document.querySelector(href);
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    }
});