import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListCityController extends ChangeNotifier {
  List<WeatherForecastModel> allCities = [];
  List<WeatherForecastModel> filteredCities = [];
  bool isLoading = true;
  bool hasConnectionError = false;

  static const _requestTimeout = Duration(seconds: 10);

  final listCitySearch = [
    'Aracaju,SE',
    'Itabaiana,SE',
    'Salvador,BA',
    'Curitiba,PR',
  ];

  Future<void> loadCities() async {
    isLoading = true;
    hasConnectionError = false;
    notifyListeners();
    try {
      allCities = await getWeatherForecast();
      filteredCities = List.from(allCities);
    } on SocketException catch (_) {
      hasConnectionError = true;
    } on http.ClientException catch (_) {
      hasConnectionError = true;
    } on TimeoutException catch (_) {
      hasConnectionError = true;
    } catch (e) {
      // Resposta inválida ou erro do servidor: mostra a tela de tentar novamente.
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

  Future<List<WeatherForecastModel>> getWeatherForecast() async {
    final enumEnv = EnviromentEnum.constants;
    final List<WeatherForecastModel> listCity = [];

    for (var city in listCitySearch) {
      final response = await http
          .get(
            Uri.parse(
              '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city',
            ),
          )
          .timeout(_requestTimeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonDecoded = jsonDecode(response.body)['results'];
        final model = WeatherForecastModel.fromJson(jsonDecoded);
        listCity.add(model);
      } else {
        throw Exception('Erro ao carregar dados');
      }
    }
    return listCity;
  }
}
