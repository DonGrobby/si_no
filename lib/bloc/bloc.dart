import 'dart:convert';

import 'package:api_si_no/bloc/estados.dart';
import 'package:api_si_no/bloc/eventos.dart';
import 'package:api_si_no/bloc/modelos_sipibloc.dart';
import 'package:api_si_no/constantes.dart';
import 'package:api_si_no/modelo.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum TipoRespuesta { si, no }

TipoRespuesta cadenaARespuesta(String cadena) {
  if (cadena == "yes") return TipoRespuesta.si;
  return TipoRespuesta.no;
}

class SipiBloc extends Bloc<Eventos, SipiState> {
  TipoRespuesta ultimaRespuesta = TipoRespuesta.no;
  int _puntuacion = 0;

  //Calificar aplicación.
  ReviewApp review = ReviewApp();

  // Guardar localmente puntuación máxima.
  int _puntuacionMaxima = 0;
  int get puntuacionMaxima => _puntuacionMaxima;
  bool recordSuperado = false;
  late SharedPreferencesAsync shared;

  //Codigos
  Codigos codigos = Codigos();

  SipiBloc() : super(Inicial(0)) {
    on<PuntuacionMaximaCargado>((event, emit) async {
      shared = SharedPreferencesAsync();
      _puntuacionMaxima = await shared.getInt(sharedPuntuacionMaxima) ?? 0;
      emit(Inicial(0));
    });
    on<Contestado>((event, emit) async {
      emit(Cargando());
      ultimaRespuesta = event.respuesta;
      Uri uri = Uri.https('yesno.wtf', 'api');
      late http.Response respuesta;
      try {
        respuesta = await http.get(uri);
        if (respuesta.statusCode == 200) {
          var modelo = Modelo.fromJson(jsonDecode(respuesta.body));
          add(Respondio(modelo));
          return;
        }
      } catch (e) {
        emit(EstadoFallido());
      }
      emit(EstadoFallido());
    });

    on<Regreso>((event, emit) {
      emit(Inicial(_puntuacion));
    });
    on<RecordSuperado>((event, emit) async {
      recordSuperado = true;
      _puntuacionMaxima = recordSuperado ? _puntuacion : _puntuacionMaxima;
      await shared.setInt(sharedPuntuacionMaxima, _puntuacionMaxima);
      emit(EstadoRespuesta(event.modelo));
    });
    on<Respondio>((event, emit) async {
      var queRespondio = cadenaARespuesta(event.modelo.answer);
      if (queRespondio == ultimaRespuesta) _puntuacion++;
      if (codigos.konamiCode[codigos.codeIndex] == ultimaRespuesta) {
        codigos.codeIndex++;
      } else {
        codigos.codeIndex = 0;
      }
      if (codigos.codeIndex == codigos.konamiCode.length) {
        add(PuntuacionMaximaBorrado(event.modelo));
      }
      if (_puntuacion > _puntuacionMaxima) {
        add(RecordSuperado(event.modelo));
        return;
      }
      recordSuperado = false;
      emit(EstadoRespuesta(event.modelo));
    });

    on<PuntuacionMaximaBorrado>((event, emit) async {
      shared.setInt(sharedPuntuacionMaxima, _puntuacion);
      _puntuacionMaxima = _puntuacion;
      codigos.codeIndex = 0;
      emit(EstadoRespuesta(event.modelo));
    });

    on<BorradoFloating>((event, emit) async {
      shared.setInt(sharedPuntuacionMaxima, _puntuacion);
      _puntuacionMaxima = 0;
      codigos.codeIndex = 0;
      emit(Inicial(0));
    });
  }
}
