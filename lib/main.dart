import 'package:api_si_no/bloc/bloc.dart';
import 'package:api_si_no/bloc/estados.dart';
import 'package:api_si_no/bloc/eventos.dart';
import 'package:api_si_no/widgets/wcargando.dart';
import 'package:api_si_no/widgets/westadofallido.dart';
import 'package:api_si_no/widgets/winicial.dart';
import 'package:api_si_no/widgets/wrespuesta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
      create: (context) => SipiBloc()..add(PuntuacionMaximaCargado()),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Si/no juego',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Si/no juego'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<SipiBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: switch (bloc.state) {
        (Inicial i) => WInicial(i.puntuacion),
        (Cargando _) => const WCargando(),
        (EstadoFallido _) => const WEstadoFallido(),
        (EstadoRespuesta r) => BlocBuilder<SipiBloc, SipiState>(
            buildWhen: (previous, current) {
              SnackBar snackBar = SnackBar(
                content:
                    Text("Nueva puntuación máxima: ${bloc.puntuacionMaxima}"),
              );
              if (bloc.recordSuperado) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              return true;
            },
            builder: (context, state) {
              return WRespuesta(r.modelo);
            },
          ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<SipiBloc>().add(PuntuacionMaximaBorrado());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
