import 'package:shopy/features/auth/Data/models/user_model.dart';
import 'package:shopy/features/auth/Domain/entites/user.dart';

class UserMapper {
  // From Model => Entity
  static UserEntity toUserEntity(UserModel userModel) {
    return UserEntity(
      id: userModel.id,
      email: userModel.email,
      name: userModel.name,
    );
  }

  // From Entity => Model
  static UserModel toUserModel(UserEntity userEntity) {
    return UserModel(
      id: userEntity.id,
      email: userEntity.email,
      name: userEntity.name,
    );
  }
}
