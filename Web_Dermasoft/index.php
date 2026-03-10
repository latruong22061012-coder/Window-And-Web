<?php

declare(strict_types=1);

require_once __DIR__ . '/app/Core/Controller.php';
require_once __DIR__ . '/app/Controllers/HomeController.php';
require_once __DIR__ . '/app/Controllers/AuthController.php';
require_once __DIR__ . '/app/Controllers/ProfileController.php';

$route = $_GET['route'] ?? 'home';

switch ($route) {
    case 'home':
        (new HomeController())->index();
        break;
    case 'login':
        (new AuthController())->login();
        break;
    case 'register':
        (new AuthController())->register();
        break;
    case 'forgot-password':
        (new AuthController())->forgotPassword();
        break;
    case 'profile':
        (new ProfileController())->index();
        break;
    default:
        http_response_code(404);
        echo '404 - Trang khong ton tai';
        break;
}
