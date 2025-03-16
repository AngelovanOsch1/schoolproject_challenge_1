<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // First, create the 'sport_teams' table
        Schema::create('sport_teams', function (Blueprint $table) {
            $table->id();
            $table->string('team_name');
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // User who created the team
            $table->timestamps();
        });

        // Now, modify the 'users' table to include 'sport_team_id'
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('sport_team_id')->nullable()->constrained()->onDelete('cascade'); 
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // First, drop the foreign key and column in 'users' table
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['sport_team_id']);
            $table->dropColumn('sport_team_id');
        });

        // Then, drop the 'sport_teams' table
        Schema::dropIfExists('sport_teams');
    }
};
