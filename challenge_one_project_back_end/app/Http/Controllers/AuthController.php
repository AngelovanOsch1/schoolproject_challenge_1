<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;


class AuthController extends Controller
{
    public function signup(Request $request)
    {
        // Validate the incoming data for the user
        $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'date_of_birth' => 'required|string|max:255',
            'phone_number' => 'required|unique:users,phone_number',
            'email' => 'required|email|unique:authentication,email',  // Ensure email is unique
            'password' => 'required|min:8',  // Ensure password is at least 8 characters
        ]);

        // Insert the user's data into the 'users' table
        $userId = DB::table('users')->insertGetId([
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'date_of_birth' => $request->date_of_birth,
            'phone_number' => $request->phone_number,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Hash the password
        $hashedPassword = Hash::make($request->password);

        // Insert the authentication data into the 'authentication' table
        DB::table('authentication')->insert([
            'email' => $request->email,
            'password' => $hashedPassword,
            'user_id' => $userId, // Use the user ID from the users table
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'User registered successfully!']);
    }

        public function login(Request $request)
    {
        // Validate the request data
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:8',
        ]);

        // Fetch the user from the 'authentication' table
        $user = DB::table('authentication')->where('email', $request->email)->first();

        // Check if user exists and the password matches
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Invalid credentials'], 401);
        }

        // Authentication successful
        return response()->json(['message' => 'Login successful', 'user_id' => $user->user_id]);
    }
}
