import 'package:api_si_no/bloc/bloc.dart';
import 'package:api_si_no/bloc/eventos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WInicial extends StatelessWidget {
  final int puntuacion;

  const WInicial(this.puntuacion, {super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<SipiBloc>();
    return Center(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: Color.fromARGB(255, 223, 185, 255)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: JuegoWidget(puntuacion: puntuacion, bloc: bloc),
        ),
      ),
    );
  }
}

class JuegoWidget extends StatelessWidget {
  const JuegoWidget({
    super.key,
    required this.puntuacion,
    required this.bloc,
  });

  final int puntuacion;
  final SipiBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$puntuacion', style: Theme.of(context).textTheme.displayLarge),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BotonesRespuesta(
                mensaje: "Si",
                colorBoton: Colors.blue,
                respuesta: TipoRespuesta.si,
              ),
              BotonesRespuesta(
                mensaje: "No",
                colorBoton: Color.fromARGB(255, 255, 75, 75),
                respuesta: TipoRespuesta.no,
              ),
            ],
          ),
        ),
        Text(
          "Puntuacion maxima: ${bloc.puntuacionMaxima}",
          style: const TextStyle(fontSize: 20),
        )
      ],
    );
  }
}

class BotonesRespuesta extends StatelessWidget {
  final String mensaje;
  final TipoRespuesta respuesta;
  final Color colorBoton;
  const BotonesRespuesta(
      {super.key,
      required this.mensaje,
      required this.colorBoton,
      required this.respuesta});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style:
              ButtonStyle(backgroundColor: WidgetStatePropertyAll(colorBoton)),
          onPressed: () {
            context.read<SipiBloc>().add(Contestado(respuesta));
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
