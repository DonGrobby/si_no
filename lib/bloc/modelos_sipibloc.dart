import 'package:api_si_no/bloc/bloc.dart';

class ReviewApp {
  bool aplicacionCalificada = false;
  int vecesRespondido = 0;
  int limiteMaximo = 5;
}

class Codigos{
  int codeIndex = 0;
  Map<int, TipoRespuesta> konamiCode = {
    0: TipoRespuesta.no,
    1: TipoRespuesta.no,
    2: TipoRespuesta.si,
    3: TipoRespuesta.si,
    4: TipoRespuesta.no,
  };
}