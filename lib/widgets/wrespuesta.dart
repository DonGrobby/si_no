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
    
    return Column(
      children: [
        Image.network(
          modelo.image,
          loadingBuilder: (context, child, loadingProgress) {
            return const CircularProgressIndicator();
          },
        ),
        Text(modelo.answer),
        IconButton(
            onPressed: () {
              context.read<SipiBloc>().add(Regreso());
            },
            icon: const Icon(Icons.abc))
      ],
    );
  }
}
