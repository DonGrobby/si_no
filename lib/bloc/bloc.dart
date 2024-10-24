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

class SipiBloc extends Bloc<Eventos, SipiState> {
  TipoRespuesta ultimaRespuesta = TipoRespuesta.no;
  int _puntuacion = 0;
  int _puntuacionMaxima = 0;
  int get puntuacionMaxima => _puntuacionMaxima;
  bool recordSuperado = false;
  late SharedPreferencesAsync shared;
  int codeIndex = 0;
  Map<int, TipoRespuesta> konamiCode = {
    0: TipoRespuesta.no,
    1: TipoRespuesta.no,
    2: TipoRespuesta.si,
    3: TipoRespuesta.si,
    4: TipoRespuesta.no,
  };
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
      print(codeIndex);
      print("${konamiCode[codeIndex]} $ultimaRespuesta");
      var queRespondio = cadenaARespuesta(event.modelo.answer);
      if (queRespondio == ultimaRespuesta) _puntuacion++;
      if (konamiCode[codeIndex] == ultimaRespuesta) codeIndex++;
      if (codeIndex == konamiCode.length) add(PuntuacionMaximaBorrado());
      if (_puntuacion > _puntuacionMaxima) {
        add(RecordSuperado(event.modelo));
        return;
      }
      recordSuperado = false;
      emit(EstadoRespuesta(event.modelo));
    });

    on<PuntuacionMaximaBorrado>((event, emit) async {
      shared.setInt(sharedPuntuacionMaxima, 0);
      _puntuacionMaxima = 0;
      codeIndex = 0;
      emit(Inicial(0));
    });
  }
}
