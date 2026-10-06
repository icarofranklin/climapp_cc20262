import 'package:climapp_cc20262/src/screens/list_city_screen.dart';
import 'package:climapp_cc20262/src/utils/locale_helper.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final Future<String> _country = LocaleHelper.getCountryFromLocation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF00457D), Color(0xFF05051F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 40,
            children: [
              SizedBox(height: 30),
              Image.asset("assets/logo_climapp.png", width: 200),
              Image.asset("assets/ilustracao_home.png", width: 250),
              Text(
                'Boas-vindas!',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListCityScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7693FF),
                  ),
                  child: const Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Entrar',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.black, size: 25),
                    ],
                  ),
                ),
              ),
              FutureBuilder<String>(
                future: _country,
                initialData: LocaleHelper.getCountryNameAndFlag(),
                builder: (context, snapshot) => Text(
                  snapshot.data ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
