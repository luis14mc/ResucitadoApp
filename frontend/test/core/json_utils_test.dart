import 'package:flutter_test/flutter_test.dart';
import 'package:pcr_app/core/utils/json_utils.dart';

void main() {
  group('JsonUtils', () {
    const payload = <String, dynamic>{
      'count': '4',
      'enabled': 'si',
      'createdAt': '2026-09-07T12:00:00Z',
      'tags': ['fe', 7],
    };

    test('convierte números y booleanos tolerantes', () {
      expect(JsonUtils.integer(payload, ['count']), 4);
      expect(JsonUtils.boolean(payload, ['enabled']), isTrue);
    });

    test('selecciona el primer alias disponible', () {
      expect(JsonUtils.string(payload, ['missing', 'count']), '4');
    });

    test('parsea fechas y listas sin casts inseguros', () {
      expect(JsonUtils.date(payload, ['createdAt'])?.year, 2026);
      expect(JsonUtils.stringList(payload['tags']), ['fe', '7']);
      expect(JsonUtils.stringList(null), isEmpty);
    });
  });
}
