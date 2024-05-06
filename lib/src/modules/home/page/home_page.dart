import 'package:fast_location/src/modules/home/components/search_empty.dart';
import 'package:fast_location/src/modules/home/controller/home_controller.dart';
import 'package:fast_location/src/routes/app_router.dart';
import 'package:fast_location/src/shared/colors/app_colors.dart';
import 'package:fast_location/src/shared/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  final TextEditingController _cepController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appPageBackground,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.multiple_stop,
                    size: 35,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Fast_Location',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: SearchEmpty(),
                    ),
                  ),
                ),
              ),
              AppButton(
                label: 'Localizar endereço',
                action: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              TextFormField(
                                enabled: true,
                                controller: _cepController,
                                textAlign: TextAlign.start,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    label: Text('Digite o CEP')),
                              ),
                              AppButton(
                                label: 'Buscar',
                                action: () async {
                                  String cep = _cepController.text;
                                  await _controller.getAddress(cep);
                                  Navigator.pop(
                                      context); // Fechar o diálogo após a busca
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.place,
                      color: Colors.green,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Últimos endereços localizados',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Text('Lista de endereços..'),
              ),
              SizedBox(height: 10),
              Observer(
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _controller.addressRecentList.map((address) {
                    return Text(
                      '${address.publicPlace}, ${address.neighborhood}',
                      style: TextStyle(fontSize: 16),
                    );
                  }).toList(),
                ),
              ),
              AppButton(
                label: 'Histórico de dendereços',
                action: () {
                  Navigator.of(context).pushNamed(AppRouter.history);
                },
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        )),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 40,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(
          Icons.fork_right,
          color: Colors.white,
          size: 45,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
