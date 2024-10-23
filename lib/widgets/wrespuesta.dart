import 'package:api_si_no/bloc/bloc.dart';
import 'package:api_si_no/bloc/eventos.dart';
import 'package:api_si_no/modelo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WRespuesta extends StatelessWidget {
  final Modelo modelo;

  const WRespuesta(this.modelo, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: Color.fromARGB(255, 223, 185, 255)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ResultadoWidget(modelo: modelo),
        ),
      ),
    );
  }
}

class ResultadoWidget extends StatelessWidget {
  const ResultadoWidget({
    super.key,
    required this.modelo,
  });

  final Modelo modelo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          modelo.image,
          loadingBuilder: (context, child, loadingProgress) {
            return const CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
        Text(
          modelo.answer,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const BotonRegresar(mensaje: "Regresar", colorBoton: Colors.blue)
      ],
    );
  }
}

class BotonRegresar extends StatelessWidget {
  final String mensaje;
  final Color colorBoton;
  const BotonRegresar({
    super.key,
    required this.mensaje,
    required this.colorBoton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style:
              ButtonStyle(backgroundColor: WidgetStatePropertyAll(colorBoton)),
          onPressed: () {
            context.read<SipiBloc>().add(Regreso());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              mensaje,
              style: const TextStyle(color: Colors.white, fontSize: 30),
            ),
          )),
    );
  }
}
