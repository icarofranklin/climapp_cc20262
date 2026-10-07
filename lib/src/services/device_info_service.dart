import 'package:climapp_cc20262/src/utils/locale_helper.dart';

class DeviceInfoService {
  /// País do usuário pela localização, com fallback para o idioma do aparelho.
  Future<String> getDeviceCountry() => LocaleHelper.getCountryFromLocation();
}
