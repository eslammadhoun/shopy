import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/use_cases/get_saved_products.dart';
import 'package:shopy/features/home/presentation/cubit/saved_cubit/saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  final GetSavedProducts getSavedProductsUsecase;
  Stream<List<Product>>? savedProductsStream;
  SavedCubit({required this.getSavedProductsUsecase})
    : super(SavedState.initial());

  Future<void> getSavedProducts() async {
    emit(state.copyWith(savedPageState: SavedPageState.loading));
    final Either<Failure, Stream<List<Product>>> result =
        await getSavedProductsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          savedPageState: SavedPageState.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        savedProductsStream = success;
        emit(state.copyWith(savedPageState: SavedPageState.success));
      },
    );
  }
}
