import 'package:api_si_no/modelo.dart';

sealed class SipiState {}

class Inicial extends SipiState {
  final int puntuacion;

  Inicial(this.puntuacion);
}

class Cargando extends SipiState {}

class EstadoFallido extends SipiState {}

class EstadoRespuesta extends SipiState {
  final Modelo modelo;

  EstadoRespuesta(this.modelo);
}
