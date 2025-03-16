<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UserController extends Controller
{

    // get all users
    public function getAllUsers()
    {
        $users = DB::table('users')
            ->leftJoin('sport_teams', 'users.sport_team_id', '=', 'sport_teams.id')
            ->select(
                'users.id as user_id',
                'users.first_name',
                'users.last_name',
                'users.role',
                'sport_teams.team_name'
            )
            ->get();

        return response()->json($users);
    }

     // delete user
    public function deleteUser($userId)
    {
        DB::table('users')->where('id', $userId)->delete();

        return response()->json(['message' => 'User deleted successfully']);
    }

    public function updateUser(Request $request)
    {   
        DB::table('users')
            ->where('id', $request['user_id'])
            ->update([
                'first_name' => $request['first_name'],
                'last_name' => $request['last_name'],
                'role' => $request['role'],
                'updated_at' => now(),
            ]);

        if(!empty($request['team_name'])) {
            DB::table('sport_teams')
            ->where('team_name', $request['team_name'])
            ->update([
                'team_name' => $request['team_name'],
                'updated_at' => now(),
            ]);
        }    
    
        return response()->json(['message' => 'User updated successfully']);   
    }    
 }
