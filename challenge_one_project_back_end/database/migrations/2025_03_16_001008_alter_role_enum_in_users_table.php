<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Alter the 'role' enum in the 'users' table
        DB::statement("ALTER TABLE users CHANGE COLUMN role role ENUM('user', 'trainer', 'boardMember') DEFAULT 'user'");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Revert the 'role' column to the previous enum values
        DB::statement("ALTER TABLE users CHANGE COLUMN role role ENUM('user', 'trainer', 'board_member') DEFAULT 'user'");
    }
};
