<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::post('/signup', [AuthController::class, 'signup']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/users', [UserController::class, 'getAllUsers']);
Route::delete('/deleteUser/{userId}', [UserController::class, 'deleteUser']);
Route::put('/updateUser', [UserController::class, 'updateUser']);