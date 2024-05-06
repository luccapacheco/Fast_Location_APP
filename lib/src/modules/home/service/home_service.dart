import 'package:dio/dio.dart';
import 'package:fast_location/src/modules/home/repositories/home_local_repository.dart';
import 'package:fast_location/src/modules/home/repositories/home_repository.dart';
import 'package:fast_location/src/modules/home/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';

class HomeService {
  final HomeRepository _repository = HomeRepository();
  final HomeLocalRepository _localRepository = HomeLocalRepository();
  Future<AddressModel> getAddres(String cep) async {
    try {
      Response response = await _repository.getAddressViaCep(cep);

      // Verifique se a resposta foi bem-sucedida (status code 200)
      if (response.statusCode == 200) {
        // Se sim, mapeie os dados da resposta para um objeto AddressModel
        return AddressModel.fromJson(response.data);
      } else {
        // Se não, lance uma exceção com o status code
        throw Exception("HTTP status error ${response.statusCode}");
      }
    } catch (ex) {
      debugPrint('HomeService.getAddress --> ${ex.toString()}');
      rethrow;
    }
  }

  Future<List<AddressModel>> getAddresRecentList() async {
    try {
      List<AddressModel>? addressRecentList =
          await _localRepository.getAddressRecent();
      return addressRecentList ?? <AddressModel>[];
    } catch (ex) {
      debugPrint('HomeService.getAddressRecentList --> ${ex.toString()}');
      rethrow;
    }
  }

  Future<void> updateAddressRecentList(AddressModel address) async {
    await _localRepository.addAddressRecent(address);
  }

  Future<List<AddressModel>> getAddressHistoryList() async {
    try {
      List<AddressModel>? addressHistoryList =
          await _localRepository.getAddressHistory();
      return addressHistoryList ?? <AddressModel>[];
    } catch (ex) {
      debugPrint('HomeService.getAddressHistoryList --> ${ex.toString()}');
      rethrow;
    }
  }

  Future<void> incrrementeAddressHistoryList(AddressModel address) async {
    await _localRepository.addAddressHistory(address);
  }

  Future<void> openMap(BuildContext context, String address) async {
    try {
      Map<String, double>? location = await getGeoLocation(address);
      double? latitude = location?["latitude"] ?? 0;
      double? longitude = location?["longitude"] ?? 0;

      final List<AvailableMap> avaliableMap = await MapLauncher.installedMaps;

      if (avaliableMap.isNotEmpty) {
        await avaliableMap.first.showDirections(
          destinationTitle: 'Destino:',
          destination: Coords(latitude, longitude),
        );
      }
    } on Exception {
      rethrow;
    }
  }

  Future<Map<String, double>?> getGeoLocation(String address) async {
    List<Location> locations = await locationFromAddress(address);

    return {
      "latitude": locations.first.latitude,
      "longitude": locations.first.longitude,
    };
  }
}
