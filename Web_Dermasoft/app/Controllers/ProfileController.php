<?php

declare(strict_types=1);

class ProfileController extends Controller
{
    public function index(): void
    {
        $this->render('profile');
    }
}
