import 'dart:io';
import 'package:flutter/foundation.dart';

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
