import 'package:equatable/equatable.dart';

/// Entidad de dominio para los horarios de misa
class HorarioMisa extends Equatable {
  final String id;
  final TipoMisa tipo;
  final DiaSemana? dia; // null para misas especiales
  final String hora;
  final String lugar;
  final String? sacerdote;
  final String? descripcion;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HorarioMisa({
    required this.id,
    required this.tipo,
    this.dia,
    required this.hora,
    required this.lugar,
    this.sacerdote,
    this.descripcion,
    this.activo = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        tipo,
        dia,
        hora,
        lugar,
        sacerdote,
        descripcion,
        activo,
        createdAt,
        updatedAt,
      ];
}

/// Tipo de misa
enum TipoMisa {
  diaria,
  dominical,
  festivo,
  especial;

  String get displayName {
    switch (this) {
      case TipoMisa.diaria:
        return 'Misa Diaria';
      case TipoMisa.dominical:
        return 'Misa Dominical';
      case TipoMisa.festivo:
        return 'Misa de Festivo';
      case TipoMisa.especial:
        return 'Misa Especial';
    }
  }
}

/// Días de la semana
enum DiaSemana {
  lunes,
  martes,
  miercoles,
  jueves,
  viernes,
  sabado,
  domingo;

  String get displayName {
    switch (this) {
      case DiaSemana.lunes:
        return 'Lunes';
      case DiaSemana.martes:
        return 'Martes';
      case DiaSemana.miercoles:
        return 'Miércoles';
      case DiaSemana.jueves:
        return 'Jueves';
      case DiaSemana.viernes:
        return 'Viernes';
      case DiaSemana.sabado:
        return 'Sábado';
      case DiaSemana.domingo:
        return 'Domingo';
    }
  }

  String get displayNameShort {
    switch (this) {
      case DiaSemana.lunes:
        return 'Lun';
      case DiaSemana.martes:
        return 'Mar';
      case DiaSemana.miercoles:
        return 'Mié';
      case DiaSemana.jueves:
        return 'Jue';
      case DiaSemana.viernes:
        return 'Vie';
      case DiaSemana.sabado:
        return 'Sáb';
      case DiaSemana.domingo:
        return 'Dom';
    }
  }
}
