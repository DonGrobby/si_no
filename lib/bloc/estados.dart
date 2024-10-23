import 'package:api_si_no/modelo.dart';

sealed class Estados {}

class Inicial extends Estados {
  final int puntuacion;

  Inicial(this.puntuacion);
}

class Cargando extends Estados {}

class EstadoFallido extends Estados {}

class EstadoRespuesta extends Estados {
  final Modelo modelo;

  EstadoRespuesta(this.modelo);
}
