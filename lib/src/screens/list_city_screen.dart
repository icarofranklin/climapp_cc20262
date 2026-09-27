import 'package:climapp_cc20262/src/controller/list_city_controller.dart';
import 'package:climapp_cc20262/src/screens/weather_city_screen.dart';
import 'package:climapp_cc20262/src/widgets/city_tile_widget.dart';
import 'package:climapp_cc20262/src/widgets/no_connection_widget.dart';
import 'package:flutter/material.dart';

class ListCityScreen extends StatefulWidget {
  const ListCityScreen({super.key});

  @override
  _ListCityScreenState createState() => _ListCityScreenState();
}

class _ListCityScreenState extends State<ListCityScreen> {
  final TextEditingController textController = TextEditingController();

  final ListCityController controller = ListCityController();

  @override
  void initState() {
    super.initState();
    controller.loadCities();
  }

  @override
  void dispose() {
    textController.dispose();
    controller.dispose();
    super.dispose();
  }

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
            mainAxisSize: .max,
            children: [
              const SizedBox(height: 25),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: textController,
                onChanged: controller.filterCities,
                decoration: const InputDecoration(
                  fillColor: Color(0xff15ffffff),
                  filled: true,
                  hintText: 'Digite uma cidade',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: .none,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    if (controller.hasConnectionError) {
                      return NoConnectionWidget(onRetry: controller.loadCities);
                    }
                    if (controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: controller.filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = controller.filteredCities[index];
                        return CityTileWidget(
                          cityName: city.cityName,
                          icon: city.conditionSlug,
                          temperature: city.temp,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherCityScreen(
                                  weatherForecastModel: city,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
