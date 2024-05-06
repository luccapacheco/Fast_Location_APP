import 'dart:convert';

import 'package:fast_location/src/modules/home/model/address_model.dart';
import 'package:hive/hive.dart';

class HomeLocalRepository {
  final String boxAddressHistory = 'addressHistory';
  final String boxAddressRecent = 'addressRecent';
  late Box<String> addressBox;

  Future<void> addAddressHistory(AddressModel address) async {
    try {
      addressBox = await Hive.openBox(boxAddressHistory);

      List<AddressModel> addressList = await getAddressHistory() ?? [];

      addressList.add(address);

      final localAddressList = jsonEncode(addressList.reversed.toList());
      await addressBox.put(boxAddressHistory, localAddressList);
    } catch (e) {
      throw Exception('Falha ao adicionar endereço ao historico: $e');
    }
  }

  Future<void> addAddressRecent(AddressModel address) async {
    try {
      addressBox = await Hive.openBox(boxAddressRecent);

      List<AddressModel> addressList = await getAddressRecent() ?? [];

      // Remove duplicates if address already exists in list
      addressList.removeWhere((addr) => addr == address);

      // Limit the recent address list to 3
      if (addressList.length >= 3) {
        addressList.removeAt(0);
      }

      addressList.add(address);

      final localAddressList = jsonEncode(addressList.reversed.toList());
      await addressBox.put(boxAddressRecent, localAddressList);
    } catch (e) {
      throw Exception('Failed to add address to recent: $e');
    }
  }

  Future<List<AddressModel>?> getAddressHistory() async {
    try {
      addressBox = await Hive.openBox(boxAddressHistory);
      final localData = addressBox.get(boxAddressHistory);

      if (localData != null) {
        final localList = jsonDecode(localData) as List<dynamic>;
        return localList
            .map((data) => AddressModel.fromJsonLocal(data))
            .toList();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get address history: $e');
    }
  }

  Future<List<AddressModel>?> getAddressRecent() async {
    try {
      addressBox = await Hive.openBox(boxAddressRecent);
      final localData = addressBox.get(boxAddressRecent);

      if (localData != null) {
        final localList = jsonDecode(localData) as List<dynamic>;
        return localList
            .map((data) => AddressModel.fromJsonLocal(data))
            .toList();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get recent addresses: $e');
    }
  }
}
