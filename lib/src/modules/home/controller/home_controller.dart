import 'package:fast_location/src/modules/home/model/address_model.dart';
import 'package:fast_location/src/modules/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  final HomeService _service = HomeService();

  @observable
  bool isLoading = false;

  @observable
  bool hasAddress = false;

  @observable
  bool hasError = false;

  @observable
  bool hasRouteError = false;

  @observable
  AddressModel? lastAddress;

  @observable
  List<AddressModel> addressRecentList = [];

  @action
  Future<void> loadData() async {
    isLoading = true;
    try {
      addressRecentList = await _service.getAddresRecentList();
    } catch (ex) {
      hasError = true;
      debugPrint('HomeController.loadData --> ${ex.toString()}');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> getAddress(String cep) async {
    try {
      isLoading = true;
      lastAddress = await _service.getAddres(cep);
      await upDateAddressRecent(lastAddress!);
      await incrementAddressHistory(lastAddress!);
      hasAddress = true;
    } catch (ex) {
      hasError = true;
      debugPrint('HomeController.getAddress --> ${ex.toString()}');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> upDateAddressRecent(AddressModel address) async {
    try {
      await _service.updateAddressRecentList(address);
      addressRecentList = await _service.getAddresRecentList();
    } catch (ex) {
      debugPrint('HomeController.upDateAddressRecent --> ${ex.toString()}');
    }
  }

  @action
  Future<void> incrementAddressHistory(AddressModel address) async {
    try {
      await _service.incrrementeAddressHistoryList(address);
    } catch (ex) {
      debugPrint('HomeController.incrementAddressHistory --> ${ex.toString()}');
    }
  }

  @action
  Future<void> route(BuildContext context) async {
    try {
      isLoading = true;
      if (lastAddress != null) {
        await _service.openMap(context,
            '${lastAddress?.publicPlace}, ${lastAddress?.neighborhood}');
      } else {
        hasRouteError = true;
      }
    } catch (ex) {
      hasRouteError = true;
      debugPrint('HomeController.route --> ${ex.toString()}');
    } finally {
      isLoading = false;
    }
  }
}
