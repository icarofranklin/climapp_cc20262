import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:climapp_cc20262/src/enums/enviroments_enum.dart';
import 'package:climapp_cc20262/src/models/weather_forecast_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<List<WeatherForecastModel>> getWeatherForecast(
    List<String> listCitySearch,
  ) async {
    final enumEnv = EnviromentEnum.constants;
    final List<WeatherForecastModel> listCity = [];

    for (var city in listCitySearch) {
      final uri =
          '${enumEnv.API_BASE_URL}?key=${enumEnv.API_KEY}&city_name=$city';
      final response = await http
          .get(Uri.parse(uri))
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException(
                "Tempo de resposta esgotado. Verifique sua conexão.",
              );
            },
          );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonDecoded = jsonDecode(response.body)['results'];
        final model = WeatherForecastModel.fromJson(jsonDecoded);
        listCity.add(model);
      } else {
        throw HttpException(
          'Erro no servidor de previsão do tempo. Código: ${response.statusCode}',
        );
      }
    }
    return listCity;
  }
}
