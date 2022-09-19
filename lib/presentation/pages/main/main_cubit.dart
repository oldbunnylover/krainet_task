import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krainet_task/domain/entities/user.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_authentication_repository.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_firebase_image_repository.dart';

class MainCubit extends Cubit<MainState> {
  final IAuthenticationRepository _authenticationRepository;
  final IFirebaseImageRepository _firebaseImageRepository;

  MainCubit(this._authenticationRepository, this._firebaseImageRepository) : super(MainState());

  void init() async {
    final user = await _authenticationRepository.currentUser;
    final images = await _firebaseImageRepository.fetchImageUrls(user.id);
    emit(state.newState(user: user, images: images));
  }

  void changePageIndex(int index) {
    emit(state.newState(currentPageIndex: index));
  }

  void logOut() {
    _authenticationRepository.logOut();
  }

  void pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      final url = await _firebaseImageRepository.uploadImage(image.name, imageBytes, state.user.id);
      emit(state.newState(images: [...state.images, url]));
    }
  }

  void removeImage(String url) async {
    await _firebaseImageRepository.removeImage(url, state.user.id);
    emit(state.newState(images: state.images..remove(url)));
  }
}

class MainState {
  final int currentPageIndex;
  final User user;
  final List<String> images;

  MainState({
    this.currentPageIndex = 0,
    this.user = User.empty,
    this.images = const [],
  });

  MainState newState({
    int? currentPageIndex,
    User? user,
    List<String>? images,
  }) {
    return MainState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      user: user ?? this.user,
      images: images ?? this.images,
    );
  }
}
