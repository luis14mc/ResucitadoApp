import 'package:flutter_test/flutter_test.dart';
import 'package:pcr_app/features/oraciones/data/models/oracion_model.dart';
import 'package:pcr_app/features/oraciones/data/models/oracion_seccion_model.dart';
import 'package:pcr_app/features/oraciones/domain/entities/oracion.dart';

void main() {
  group('OracionModel', () {
    test('debería parsear una oración simple desde JSON (texto plano)', () {
      final json = {
        'id': 5,
        'titulo': 'Padre Nuestro',
        'slug': 'padre-nuestro',
        'categoria': 'basicas',
        'descripcion': 'Oración del Señor',
        'contenido': 'Padre nuestro, que estás...',
        'orden': 50,
        'destacada': false,
        'duracion_estimada': 1,
        'secciones': [],
      };

      final model = OracionModel.fromJson(json);

      expect(model.id, '5');
      expect(model.titulo, 'Padre Nuestro');
      expect(model.slug, 'padre-nuestro');
      expect(model.categoria, 'basicas');
      expect(model.contenido, 'Padre nuestro, que estás...');
      expect(model.orden, 50);
      expect(model.destacada, false);
      expect(model.duracionEstimada, 1);
      expect(model.secciones, isEmpty);
    });

    test('debería parsear una oración compleja con secciones desde JSON', () {
      final json = {
        'id': '10',
        'titulo': 'Lectio Divina',
        'slug': 'lectio-divina',
        'categoria': 'lectio_divina',
        'descripcion': 'Lectura orante',
        'contenido': '',
        'orden': 10,
        'destacada': true,
        'duracion_estimada': 15,
        'secciones': [
          {
            'id': 1,
            'titulo': 'Invocación',
            'contenido': 'Ven Espíritu Santo...',
            'orden': 0,
          }
        ]
      };

      final model = OracionModel.fromJson(json);

      expect(model.id, '10');
      expect(model.titulo, 'Lectio Divina');
      expect(model.destacada, true);
      expect(model.duracionEstimada, 15);
      expect(model.secciones, isNotEmpty);
      expect(model.secciones.length, 1);
      expect(model.secciones[0].id, '1');
      expect(model.secciones[0].titulo, 'Invocación');
      expect(model.secciones[0].contenido, 'Ven Espíritu Santo...');
      expect(model.secciones[0].orden, 0);
    });

    test('debería convertir correctamente a Entidad de Dominio', () {
      const model = OracionModel(
        id: '1',
        titulo: 'Test',
        slug: 'test',
        categoria: 'basicas',
        descripcion: 'Desc',
        contenido: 'Content',
        orden: 1,
        destacada: false,
        duracionEstimada: 3,
        secciones: [],
      );

      final entity = model.toEntity();

      expect(entity, isA<Oracion>());
      expect(entity.id, model.id);
      expect(entity.titulo, model.titulo);
      expect(entity.slug, model.slug);
      expect(entity.categoria, model.categoria);
      expect(entity.contenido, model.contenido);
      expect(entity.orden, model.orden);
      expect(entity.destacada, model.destacada);
      expect(entity.duracionEstimada, model.duracionEstimada);
      expect(entity.secciones, isEmpty);
    });

    test('debería generar JSON correcto desde toJson', () {
      const model = OracionModel(
        id: '99',
        titulo: 'Gloria',
        slug: 'gloria',
        categoria: 'basicas',
        descripcion: 'Doxología',
        contenido: 'Gloria al Padre...',
        orden: 70,
        destacada: false,
        duracionEstimada: 1,
        secciones: [],
      );

      final json = model.toJson();

      expect(json['id'], '99');
      expect(json['titulo'], 'Gloria');
      expect(json['slug'], 'gloria');
      expect(json['contenido'], 'Gloria al Padre...');
      expect(json['orden'], 70);
      expect(json['destacada'], false);
      expect(json['duracion_estimada'], 1);
      expect(json['secciones'], isEmpty);
    });
  });
}
