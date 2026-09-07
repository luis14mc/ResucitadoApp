import 'package:flutter_test/flutter_test.dart';
import 'package:pcr_app/features/eventos/data/models/evento_model.dart';
import 'package:pcr_app/features/eventos/domain/entities/evento.dart';

void main() {
  test('EventoModel acepta el contrato DRF camelCase y snake_case', () {
    final evento = EventoModel.fromJson({
      'id': 10,
      'titulo': 'Retiro parroquial',
      'descripcion': 'Un encuentro para la comunidad.',
      'fecha': '2026-09-20',
      'hora': '09:00',
      'lugar': 'Salón parroquial',
      'categoria': 'comunidad',
      'es_recurrente': true,
      'maximo_participantes': '30',
      'participantes_actuales': '12',
      'requiere_inscripcion': 'true',
      'created_at': '2026-09-01T10:00:00Z',
      'updated_at': '2026-09-02T10:00:00Z',
      'etiquetas': ['familias'],
    });

    expect(evento.id, '10');
    expect(evento.categoria, EventoCategoria.comunidad);
    expect(evento.maximoParticipantes, 30);
    expect(evento.participantesActuales, 12);
    expect(evento.requiereInscripcion, isTrue);
    expect(evento.etiquetas, ['familias']);
  });
}
