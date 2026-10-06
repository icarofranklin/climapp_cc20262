import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocaleHelper {
  static const Map<String, String> _countryMap = {
    'BR': 'Brasil 🇧🇷',
    'US': 'Estados Unidos 🇺🇸',
    'PT': 'Portugal 🇵🇹',
    'AR': 'Argentina 🇦🇷',
    'MX': 'México 🇲🇽',
    'CL': 'Chile 🇨🇱',
    'CO': 'Colômbia 🇨🇴',
    'PE': 'Peru 🇵🇪',
    'UY': 'Uruguai 🇺🇾',
    'PY': 'Paraguai 🇵🇾',
    'BO': 'Bolívia 🇧🇴',
    'VE': 'Venezuela 🇻🇪',
    'EC': 'Equador 🇪🇨',
    'GB': 'Reino Unido 🇬🇧',
    'FR': 'França 🇫🇷',
    'DE': 'Alemanha 🇩🇪',
    'IT': 'Itália 🇮🇹',
    'ES': 'Espanha 🇪🇸',
    'JP': 'Japão 🇯🇵',
    'CN': 'China 🇨🇳',
    'CA': 'Canadá 🇨🇦',
    'AU': 'Austrália 🇦🇺',
  };

  /// Retorna o país a partir da localização do usuário. Se a permissão for
  /// negada, o GPS estiver desligado ou não houver internet, usa o país do
  /// idioma do aparelho.
  static Future<String> getCountryFromLocation() async {
    if (kIsWeb) return getCountryNameAndFlag();

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return getCountryNameAndFlag();
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return getCountryNameAndFlag();
      }

      final position =
          await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 10),
            ),
          );

      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final placemark = placemarks.first;
      final countryCode = placemark.isoCountryCode?.toUpperCase() ?? '';

      if (_countryMap.containsKey(countryCode)) {
        return '📍 ${_countryMap[countryCode]}';
      }
      final countryName = placemark.country;
      if (countryName != null && countryName.isNotEmpty) {
        return '📍 $countryName';
      }
      return getCountryNameAndFlag();
    } catch (e) {
      debugPrint('Erro ao obter país pela localização: $e');
      return getCountryNameAndFlag();
    }
  }

  static String getCountryNameAndFlag() {
    if (kIsWeb) {
      return '📍 Acessando via Web';
    }

    try {
      final localeName = Platform.localeName; // ex: 'pt_BR' ou 'en-US'

      String countryCode = '';
      if (localeName.contains('_')) {
        countryCode = localeName.split('_').last;
      } else if (localeName.contains('-')) {
        countryCode = localeName.split('-').last;
      } else {
        return '📍 Idioma: $localeName';
      }

      countryCode = countryCode.toUpperCase();

      if (_countryMap.containsKey(countryCode)) {
        return '📍 ${_countryMap[countryCode]}';
      } else {
        return '📍 Região: $countryCode';
      }
    } catch (e) {
      return '📍 Região: Desconhecida';
    }
  }
}
