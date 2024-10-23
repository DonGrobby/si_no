import 'package:api_si_no/bloc/bloc.dart';
import 'package:api_si_no/bloc/eventos.dart';
import 'package:api_si_no/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WEstadoFallido extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "algo salió mal y tu no tuviste la culpa",
          ),
          IconButton(
            onPressed: () {
              context.read<SipiBloc>().add(Regreso());
            },
            icon: const Icon(Icons.abc),
          )
        ],
      ),
    );
  }
}
