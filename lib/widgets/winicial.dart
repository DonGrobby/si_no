import 'package:api_si_no/bloc/bloc.dart';
import 'package:api_si_no/bloc/estados.dart';
import 'package:api_si_no/bloc/eventos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WInicial extends StatelessWidget {
  final int puntuacion;

  const WInicial(this.puntuacion, {super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<SipiBloc>();
    // SnackBar snackBar = SnackBar(
    //   content: Text("Nueva puntuación máxima ${bloc.puntuacionMaxima}"),
    // );
    // print(bloc.recordSuperado);
    // if (bloc.recordSuperado) {
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
    return Center(
      child: Column(
        children: [
          Text('$puntuacion', style: Theme.of(context).textTheme.headlineLarge),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<SipiBloc>().add(Contestado(TipoRespuesta.si));
                  },
                  child: const Text("Si"),
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                ),
                ElevatedButton(
                    onPressed: () {
                      context
                          .read<SipiBloc>()
                          .add(Contestado(TipoRespuesta.no));
                    },
                    child: const Text("No"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
