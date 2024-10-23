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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    var estado = context.watch<SipiBloc>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: switch (estado) {
        (Inicial _) => WInicial(estado.puntuacion),
        (Cargando _) => WCargando(),
        (EstadoFallido _) => WEstadoFallido(),
        (EstadoRespuesta r) => WRespuesta(r.modelo),
      },
    );
  }
}
