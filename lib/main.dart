import 'package:api_si_no/bloc/bloc.dart';
import 'package:api_si_no/bloc/estados.dart';
import 'package:api_si_no/bloc/eventos.dart';
import 'package:api_si_no/bloc_review/bloc_review.dart';
import 'package:api_si_no/widgets/wcargando.dart';
import 'package:api_si_no/widgets/westadofallido.dart';
import 'package:api_si_no/widgets/winicial.dart';
import 'package:api_si_no/widgets/wrespuesta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

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
        (Inicial i) => BlocBuilder<SipiBloc, SipiState>(
            buildWhen: (previous, current) {
              SnackBar konamiCode = const SnackBar(
                content: Text("Código super secreto super desecretado."),
              );
              if (bloc.codigos.codeIndex ==
                  bloc.codigos.konamiCode.length - 1) {
                ScaffoldMessenger.of(context).showSnackBar(konamiCode);
              }
              return true;
            },
            builder: (context, state) {
              return WInicial(i.puntuacion);
            },
          ),
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
              if (!bloc.review.aplicacionCalificada &&
                  bloc.review.vecesRespondido == bloc.review.limiteMaximo) {
                showDialog(
                  context: context,
                  builder: (context) => BlocProvider(
                    create: (context) => ReviewBloc(),
                    child: const CalificarAppWidget(),
                  ),
                );
              }
              bloc.review.vecesRespondido =
                  bloc.review.vecesRespondido < bloc.review.limiteMaximo
                      ? bloc.review.vecesRespondido + 1
                      : 0;
              return true;
            },
            builder: (context, state) {
              return WRespuesta(r.modelo);
            },
          ),
      },
    );
  }
}

class CalificarAppWidget extends StatelessWidget {
  const CalificarAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ReviewBloc reviewBloc = context.watch<ReviewBloc>();
    return switch (reviewBloc.state) {
      (CalificandoState _) => CalificarWidget(reviewBloc: reviewBloc),
      (AgradeciendoState _) => const AgradecerCalificacionAppWidget(),
    };
  }
}

class AgradecerCalificacionAppWidget extends StatelessWidget {
  const AgradecerCalificacionAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Muchas gracias por calificarnos."),
      content: const Text("Siga disfrutando de la aplicacion."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Listo")),
      ],
    );
  }
}

class CalificarWidget extends StatelessWidget {
  const CalificarWidget({
    super.key,
    required this.reviewBloc,
  });

  final ReviewBloc reviewBloc;

  @override
  Widget build(BuildContext context) {
    SipiBloc sipiBloc = context.watch<SipiBloc>();
    return AlertDialog(
      title: const Text("¿Te ha gustado la aplicación?, califícanos!!!"),
      content: const ReviewWidget(),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Más tarde")),
        TextButton(
            onPressed: () {
              sipiBloc.review.aplicacionCalificada = true;
              reviewBloc.add(CalificoAppEvent(reviewBloc.rating));
            },
            child: const Text("Calificar")),
      ],
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({super.key});
  @override
  Widget build(BuildContext context) {
    ReviewBloc reviewBloc = context.watch<ReviewBloc>();
    double rating = reviewBloc.rating;
    return PannableRatingBar(
      rate: rating,
      items: List.generate(
          5,
          (index) => const RatingWidget(
                selectedColor: Colors.red,
                unSelectedColor: Colors.yellow,
                child: Icon(
                  Icons.star,
                  size: 48,
                ),
              )),
      onChanged: (value) {
        reviewBloc.add(CambioCalificacionEvent(value));
      },
    );
  }
}
