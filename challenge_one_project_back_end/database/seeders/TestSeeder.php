<?php

namespace Database\Seeders;

use Illuminate\Support\Facades\DB;
use Illuminate\Database\Seeder;

class TestSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('tests')->insert([
            ['name' => 'Test 1', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Test 2', 'created_at' => now(), 'updated_at' => now()]
        ]);
    }
}
