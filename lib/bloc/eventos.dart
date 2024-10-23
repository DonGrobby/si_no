import 'package:api_si_no/bloc/bloc.dart';
import 'package:api_si_no/modelo.dart';

sealed class Eventos {}

class Contestado extends Eventos {
  final TipoRespuesta respuesta;
  Contestado(this.respuesta);
}

class Regreso extends Eventos {}

class Respondio extends Eventos {
  final Modelo modelo;

  Respondio(this.modelo);
}

class PuntuacionMaximaCargado extends Eventos {}

class RecordSuperado extends Eventos {
  final Modelo modelo;

  RecordSuperado(this.modelo);
}

class PuntuacionMaximaBorrado extends Eventos {}
