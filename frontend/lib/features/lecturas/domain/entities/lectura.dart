import 'package:equatable/equatable.dart';

/// Entity que representa las lecturas del día
class Lectura extends Equatable {
  final String id;
  final DateTime fecha;
  final String tiempoLiturgico;
  final String colorLiturgico;
  final PrimeraLectura primeraLectura;
  final Salmo salmo;
  final SegundaLectura? segundaLectura; // Opcional, solo algunos días
  final Evangelio evangelio;
  final Reflexion? reflexion; // Opcional

  const Lectura({
    required this.id,
    required this.fecha,
    required this.tiempoLiturgico,
    required this.colorLiturgico,
    required this.primeraLectura,
    required this.salmo,
    this.segundaLectura,
    required this.evangelio,
    this.reflexion,
  });

  @override
  List<Object?> get props => [
        id,
        fecha,
        tiempoLiturgico,
        colorLiturgico,
        primeraLectura,
        salmo,
        segundaLectura,
        evangelio,
        reflexion,
      ];
}

/// Primera lectura
class PrimeraLectura extends Equatable {
  final String titulo;
  final String referencia;
  final String texto;

  const PrimeraLectura({
    required this.titulo,
    required this.referencia,
    required this.texto,
  });

  @override
  List<Object?> get props => [titulo, referencia, texto];
}

/// Salmo responsorial
class Salmo extends Equatable {
  final String titulo;
  final String referencia;
  final String texto;
  final String respuesta;

  const Salmo({
    required this.titulo,
    required this.referencia,
    required this.texto,
    required this.respuesta,
  });

  @override
  List<Object?> get props => [titulo, referencia, texto, respuesta];
}

/// Segunda lectura (opcional)
class SegundaLectura extends Equatable {
  final String titulo;
  final String referencia;
  final String texto;

  const SegundaLectura({
    required this.titulo,
    required this.referencia,
    required this.texto,
  });

  @override
  List<Object?> get props => [titulo, referencia, texto];
}

/// Evangelio del día
class Evangelio extends Equatable {
  final String titulo;
  final String referencia;
  final String texto;

  const Evangelio({
    required this.titulo,
    required this.referencia,
    required this.texto,
  });

  @override
  List<Object?> get props => [titulo, referencia, texto];
}

/// Reflexión o palabras del Santo Padre
class Reflexion extends Equatable {
  final String titulo;
  final String fuente;
  final String texto;

  const Reflexion({
    required this.titulo,
    required this.fuente,
    required this.texto,
  });

  @override
  List<Object?> get props => [titulo, fuente, texto];
}
