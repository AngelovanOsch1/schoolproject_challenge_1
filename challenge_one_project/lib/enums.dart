enum Role { user, trainer, boardMember }

extension RoleExtension on Role {
  String get name {
    switch (this) {
      case Role.user:
        return 'User';
      case Role.trainer:
        return 'Trainer';
      case Role.boardMember:
        return 'Bestuurslid';
    }
  }

  static Role fromString(String role) {
    switch (role) {
      case 'user':
        return Role.user;
      case 'trainer':
        return Role.trainer;
      case 'boardMember':
        return Role.boardMember;
      default:
        return Role.user;
    }
  }
}
