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
        Schema::create('playing_fields', function (Blueprint $table) {
            $table->id();
            $table->string('field_name');
            $table->integer('capacity'); // Fixed column definition
        });

        Schema::create('trainings', function (Blueprint $table) {
            $table->id();
            $table->date('training_date');
            $table->time('training_time');
            $table->foreignId('playing_field_id')->constrained();
            $table->foreignId('sport_team_id')->constrained();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Drop trainings first to avoid foreign key constraint issues
        Schema::dropIfExists('trainings');

        // Then drop playing_fields
        Schema::dropIfExists('playing_fields');
    }
};
