import 'package:bloc/bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  double rating = 5.0;

  ReviewBloc() : super(CalificandoState()) {
    on<CambioCalificacionEvent>((event, emit) {
      rating = event.calificacionUsuario;
      emit(CalificandoState());
    });

    on<CalificoAppEvent>((event, emit) {
      emit(AgradeciendoState());
    });
  }
}

/* ESTADOS */

sealed class ReviewState {}

class CalificandoState extends ReviewState {}

class AgradeciendoState extends ReviewState {}

/* EVENTOS */

sealed class ReviewEvent {}

class CalificoAppEvent extends ReviewEvent {
  final double calificacionApp;

  CalificoAppEvent(this.calificacionApp);
}

class CambioCalificacionEvent extends ReviewEvent {
  final double calificacionUsuario;

  CambioCalificacionEvent(this.calificacionUsuario);
}
