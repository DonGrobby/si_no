import 'dart:convert';

import 'package:api_si_no/bloc/estados.dart';
import 'package:api_si_no/bloc/eventos.dart';
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

class SipiBloc extends Bloc<Eventos, Estados> {
  TipoRespuesta ultimaRespuesta = TipoRespuesta.no;
  int _puntuacion = 0;
  int _puntuacionMaxima = 0;
  int get puntuacionMaxima => _puntuacionMaxima;
  bool recordSuperado = false;
  late SharedPreferencesAsync shared;
  SipiBloc() : super(Inicial(0)) {
    on<PuntuacionMaximaCargado>((event, emit) async {
      shared = await SharedPreferencesAsync();
      _puntuacionMaxima = await shared.getInt(sharedPuntuacionMaxima) ?? 0;
    });
    on<Contestado>((event, emit) async {
      emit(Cargando());
      ultimaRespuesta = event.respuesta;
      Uri uri = Uri.https('yesno.wtf', 'api');
      late http.Response respuesta;
      try {
        respuesta = await http.get(uri);
      } catch (e) {
        emit(EstadoFallido());
      }

      if (respuesta.statusCode == 200) {
        var modelo = Modelo.fromJson(jsonDecode(respuesta.body));
        add(Respondio(modelo));
        return;
      }
      emit(EstadoFallido());
    });

    on<Regreso>((event, emit) {
      emit(Inicial(_puntuacion));
    });
    on<Respondio>((event, emit) {
      var queRespondio = cadenaARespuesta(event.modelo.answer);
      if (queRespondio == ultimaRespuesta) _puntuacion++;
      recordSuperado = _puntuacion > _puntuacionMaxima;
      _puntuacionMaxima = recordSuperado ? _puntuacion : _puntuacionMaxima;
      emit(EstadoRespuesta(event.modelo));
    });
  }
}
