document.addEventListener("DOMContentLoaded", function () {
  // Nghiệp vụ: Xem trước ảnh đại diện (Avatar Preview) ngay khi chọn file
  const avatarUpload = document.getElementById("avatarUpload");
  const avatarPreview = document.getElementById("avatarPreview");

  if (avatarUpload && avatarPreview) {
    avatarUpload.addEventListener("change", function (event) {
      const file = event.target.files[0];

      // Nếu người dùng có chọn file
      if (file) {
        const reader = new FileReader();

        // Khi đọc file xong, đổi src của ảnh đại diện thành ảnh vừa tải lên
        reader.onload = function (e) {
          avatarPreview.src = e.target.result;
        };

        reader.readAsDataURL(file);
      }
    });
  }

  // Mở đúng tab khi URL có hash (ví dụ: #v-pills-appointments)
  const activateTabFromHash = function () {
    const hash = window.location.hash;
    if (!hash || typeof bootstrap === "undefined") {
      return;
    }

    const targetPane = document.querySelector(hash);
    if (!targetPane || !targetPane.classList.contains("tab-pane")) {
      return;
    }

    const trigger = document.querySelector('[data-bs-target="' + hash + '"]');
    if (!trigger) {
      return;
    }

    bootstrap.Tab.getOrCreateInstance(trigger).show();
  };

  activateTabFromHash();

  window.addEventListener("hashchange", activateTabFromHash);
});
