import 'dart:async';
import 'dart:ffi';

import 'package:city_guide/domain/model/detail_store.dart';
import 'package:city_guide/domain/usecase/store_detail_usecase.dart';
import 'package:city_guide/presentation/base/base_view_model.dart';
import 'package:city_guide/presentation/common/state_renderer/state_renderer.dart';
import 'package:city_guide/presentation/common/state_renderer/state_renderer_implementer.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailViewModel extends BaseViewModel with StoreDetailViewModelInput,
    StoreDetailViewModelOutput {
  final StoreDetailUseCase _storeDetailUseCase;
  final StreamController _dataStreamController = BehaviorSubject<StoreDetail>();

  StoreDetailViewModel(this._storeDetailUseCase);

  // Input ---------------------------------------------------------------------
  @override
  void start() {
    // View tells state to show content of the screen --------------------------
    _getStoreDetail();
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputStoreDetail => _dataStreamController.sink;

  // Output --------------------------------------------------------------------
  @override
  Stream<StoreDetail> get outputStoreDetail => _dataStreamController.stream
      .map((data) => data);

  // Private function ----------------------------------------------------------
  _getStoreDetail() async {
    inputState.add(LoadingState(stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _storeDetailUseCase.execute(Void)).fold(
            (failure) {
              // Failure -------------------------------------------------------
              inputState.add(ErrorState(StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
            },
            (storeDetail) {
              // Store detail --------------------------------------------------
              inputState.add(ContentState());
              // Data inside store detail --------------------------------------
              inputStoreDetail.add(storeDetail);
            },
    );
  }
}

// Input means order that view model will receive from view --------------------
abstract class StoreDetailViewModelInput {
  // 1 sink for stream ---------------------------------------------------------
  Sink get inputStoreDetail;
}

// Output means data/result that will be sent from view to view ----------------
abstract class StoreDetailViewModelOutput {
  // 1 stream for validation ---------------------------------------------------
  Stream<StoreDetail> get outputStoreDetail;
}