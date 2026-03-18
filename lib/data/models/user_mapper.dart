import '../../data/models/login_model.dart';
import '../../domain/entities/user.dart';

class UserMapper {
  static User fromModel(UserModel model) {
    return User(
      id: model.id,
      username: model.username,
      status: model.status,
      profile: model.profile != null
          ? UserProfile(
              id: model.profile!.id,
              firstName: model.profile!.firstName,
              lastName: model.profile!.lastName,
              pob: model.profile!.pob,
              dob: model.profile!.dob,
              nationality: model.profile!.nationality,
              religion: model.profile!.religion,
            )
          : null,
    );
  }
}
