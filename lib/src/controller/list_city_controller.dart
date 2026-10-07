import 'dart:async';
import 'dart:io';

import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:climapp_cc20262/src/services/device_info_service.dart';
import 'package:climapp_cc20262/src/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListCityController extends ChangeNotifier {
  ListCityController({
    required this.deviceInfoService,
    required this.weatherService,
  });

  final WeatherService weatherService;
  final DeviceInfoService deviceInfoService;

  String _deviceCountry = '';
  String get deviceCountry => _deviceCountry;
  List<WeatherForecastModel> allCities = [];
  List<WeatherForecastModel> filteredCities = [];
  bool isLoading = true;
  String errorMessage = '';
  bool hasConnectionError = false;

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];
  Future<void> loadCities() async {
    isLoading = true;
    errorMessage = '';
    hasConnectionError = false;
    notifyListeners();

    _deviceCountry = await deviceInfoService.getDeviceCountry();

    try {
      allCities = await weatherService.getWeatherForecast(listCitySearch);
      filteredCities = List.from(allCities);
    } on SocketException catch (_) {
      hasConnectionError = true;
    } on http.ClientException catch (_) {
      hasConnectionError = true;
    } on TimeoutException catch (e) {
      errorMessage = e.message ?? 'Tempo de resposta esgotado';
      hasConnectionError = true;
    } on HttpException catch (e) {
      errorMessage = e.message;
      hasConnectionError = true;
    } catch (e) {
      // Resposta inválida: mostra a tela de tentar novamente.
      debugPrint(e.toString());
      hasConnectionError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities = List.from(allCities);
    } else {
      filteredCities = allCities
          .where(
            (city) => city.cityName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
