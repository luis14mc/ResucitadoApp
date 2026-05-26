import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Representa una sección en el dashboard de Home
class HomeSection extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color? color;
  final int? itemCount; // Contador opcional (ej: 5 eventos próximos)
  final String? lastUpdate; // Última actualización
  final bool isLoading;

  const HomeSection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.color,
    this.itemCount,
    this.lastUpdate,
    this.isLoading = false,
  });

  HomeSection copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    String? route,
    Color? color,
    int? itemCount,
    String? lastUpdate,
    bool? isLoading,
  }) {
    return HomeSection(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      color: color ?? this.color,
      itemCount: itemCount ?? this.itemCount,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        icon,
        route,
        color,
        itemCount,
        lastUpdate,
        isLoading,
      ];
}

/// Información resumida del santo del día para el home
class SantoSummary extends Equatable {
  final String nombre;
  final String festividad;
  final DateTime fecha;

  const SantoSummary({
    required this.nombre,
    required this.festividad,
    required this.fecha,
  });

  @override
  List<Object?> get props => [nombre, festividad, fecha];
}

/// Información resumida de eventos para el home
class EventosSummary extends Equatable {
  final int totalActivos;
  final int proximosSemanales;
  final String? proximoEvento;

  const EventosSummary({
    required this.totalActivos,
    required this.proximosSemanales,
    this.proximoEvento,
  });

  @override
  List<Object?> get props => [totalActivos, proximosSemanales, proximoEvento];
}

/// Información resumida de lecturas para el home
class LecturasSummary extends Equatable {
  final String evangelio;
  final String colorLiturgico;
  final int totalLecturas;

  const LecturasSummary({
    required this.evangelio,
    required this.colorLiturgico,
    required this.totalLecturas,
  });

  @override
  List<Object?> get props => [evangelio, colorLiturgico, totalLecturas];
}

/// Información resumida de horarios para el home
class HorariosSummary extends Equatable {
  final int totalHorarios;
  final String? proximaMisa;
  final String? diaSemana;

  const HorariosSummary({
    required this.totalHorarios,
    this.proximaMisa,
    this.diaSemana,
  });

  @override
  List<Object?> get props => [totalHorarios, proximaMisa, diaSemana];
}
