from datetime import date, timedelta
from unittest.mock import patch
from django.urls import reverse
from django.utils import timezone
from django.test import override_settings
from rest_framework import status
from rest_framework.test import APITestCase

from .models import (
    Oracion,
    OracionSeccion,
    Santo,
    Evento,
    MisaHorario,
    VideoMisa,
    ParroquiaInfo,
    OficinaInfo,
    DiaSemana,
    ColorLiturgico,
    TipoCelebracion,
    EstadoEmision,
    CalendarioLiturgico,
    IntencionOracion,
)


class CoreLiturgiaAPITests(APITestCase):

    def setUp(self):
        # 1. Oraciones
        self.oracion_simple = Oracion.objects.create(
            titulo='Oración Simple Test',
            slug='oracion-simple-test',
            categoria='basicas',
            contenido='Contenido de la oración simple.',
            orden=1,
            activo=True,
            destacada=False,
            duracion_estimada=2,
        )
        self.oracion_destacada = Oracion.objects.create(
            titulo='Oración Destacada Test',
            slug='oracion-destacada-test',
            categoria='lectio_divina',
            contenido='',
            orden=2,
            activo=True,
            destacada=True,
            duracion_estimada=15,
        )
        self.seccion_1 = OracionSeccion.objects.create(
            oracion=self.oracion_destacada,
            titulo='Sección 1',
            contenido='Contenido de la sección 1.',
            orden=0,
        )

        # 2. Santo
        self.today = timezone.localdate()
        self.santo = Santo.objects.create(
            nombre='San Test',
            titulo='Patrono de los Tests',
            fecha_celebracion=self.today,
            biografia='Nació para ser testeado.',
            festividad='Hoy',
            patrono='QAs',
            oracion='Oh Dios del código...',
            imagen_url='http://example.com/santo.png',
            atributos=['Teclado', 'Pantalla'],
        )

        # 3. Evento
        self.evento = Evento.objects.create(
            titulo='Evento de Prueba',
            descripcion='Descripción del evento de prueba.',
            fecha=self.today + timedelta(days=2),
            hora='10:00 AM',
            lugar='Templo Principal',
            categoria='comunidad',
            maximo_participantes=50,
            participantes_actuales=5,
            requiere_inscripcion=True,
            activo=True,
        )

        # 4. Misa Horario
        self.horario = MisaHorario.objects.create(
            dia_semana=DiaSemana.DOMINGO,
            hora='08:00:00',
            lugar='Capilla',
            celebrante='P. Test',
            activo=True,
        )

        # 5. Video Misa
        self.video = VideoMisa.objects.create(
            titulo='Misa en Vivo de Prueba',
            descripcion='Transmisión de prueba.',
            fecha_evento=timezone.now() + timedelta(hours=1),
            estado=EstadoEmision.PROGRAMADA,
            url_facebook='http://facebook.com/live',
            facebook_video_id='12345',
            destacada=True,
        )

        # 6. Parroquia Info (Singleton)
        self.parroquia_info = ParroquiaInfo.objects.create(
            nombre='Parroquia Cristo Resucitado Test',
            historia='Historia de prueba.',
            mision='Misión de prueba.',
            vision='Visión de prueba.',
            valores=['Valor1', 'Valor2'],
            imagenes=['http://example.com/img1.png'],
            direccion='Calle de Prueba',
            telefono='2226-0000',
            email='test@cristoresucitado.hn',
        )

        # 7. Oficina Info (Singleton)
        self.oficina_info = OficinaInfo.objects.create(
            direccion='Lateral del Templo',
            telefono='2226-1111',
            email='oficina@cristoresucitado.hn',
            horarios={'Lunes': '8am - 5pm'},
            servicios=['Servicio1'],
            latitud=14.0,
            longitud=-87.0,
        )

    # ============================================================
    # Pruebas de Oraciones
    # ============================================================
    def test_list_oraciones(self):
        url = reverse('oraciones-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.data
        if isinstance(data, dict) and 'results' in data:
            results = data['results']
        else:
            results = data
        self.assertEqual(len(results), 2)

    def test_retrieve_oracion_detail_with_sections(self):
        url = reverse('oraciones-detail', kwargs={'slug': 'oracion-destacada-test'})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('secciones', response.data)
        self.assertEqual(len(response.data['secciones']), 1)
        self.assertEqual(response.data['secciones'][0]['titulo'], 'Sección 1')

    def test_list_oraciones_destacadas(self):
        url = reverse('oraciones-destacadas')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['slug'], 'oracion-destacada-test')

    def test_list_oraciones_por_categoria(self):
        url = reverse('oraciones-por-categoria', kwargs={'categoria': 'basicas'})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['slug'], 'oracion-simple-test')

    # ============================================================
    # Pruebas de Santos
    # ============================================================
    def test_santo_del_dia(self):
        url = reverse('santos-hoy')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['nombre'], 'San Test')

    def test_santos_del_mes(self):
        url = reverse('santos-mes')
        response = self.client.get(url, {'mes': self.today.month})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

    # ============================================================
    # Pruebas de Eventos
    # ============================================================
    def test_eventos_activos(self):
        url = reverse('eventos-activos')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['titulo'], 'Evento de Prueba')

    def test_inscripcion_evento(self):
        url = reverse('eventos-inscribirse', kwargs={'pk': self.evento.pk})
        response = self.client.post(url, {'nombre': 'Fiel Test'}, format='json', HTTP_IDEMPOTENCY_KEY='test-1')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['status'], 'inscrito')
        self.assertFalse(response.data['idempotente'])
        registration_id = response.data['inscripcion_id']
        self.evento.refresh_from_db()
        self.assertEqual(self.evento.participantes_actuales, 6)

        retry = self.client.post(url, {'nombre': 'Fiel Test'}, format='json', HTTP_IDEMPOTENCY_KEY='test-1')
        self.assertEqual(retry.status_code, status.HTTP_200_OK)
        self.assertTrue(retry.data['idempotente'])
        self.evento.refresh_from_db()
        self.assertEqual(self.evento.participantes_actuales, 6)

        cancel_url = reverse(
            'eventos-cancelar-inscripcion',
            kwargs={'pk': self.evento.pk, 'part_id': registration_id},
        )
        cancelled = self.client.delete(cancel_url)
        self.assertEqual(cancelled.status_code, status.HTTP_200_OK)
        self.evento.refresh_from_db()
        self.assertEqual(self.evento.participantes_actuales, 5)

    def test_contract_includes_flutter_lecture_shape(self):
        CalendarioLiturgico.objects.create(
            fecha=self.today,
            titulo='Domingo de prueba',
            tipo_celebracion='domingo',
            color_liturgico=ColorLiturgico.VERDE,
            primera_lectura_cita='Gn 1, 1-5',
            primera_lectura_texto='Texto',
            salmo_cita='Sal 1',
            salmo_respuesta='Respuesta',
            salmo_texto='Salmo',
            evangelio_cita='Jn 1, 1-5',
            evangelio_texto='Evangelio',
        )
        response = self.client.get(reverse('calendario-hoy'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('primeraLectura', response.data)
        self.assertIn('evangelio', response.data)
        self.assertEqual(response.data['salmo']['respuesta'], 'Respuesta')

    def test_public_intention_cannot_self_publish(self):
        response = self.client.post(
            reverse('intenciones-create'),
            {
                'nombre': 'Fiel',
                'intencion': 'Por mi familia',
                'es_publica': True,
            },
            format='json',
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertFalse(IntencionOracion.objects.get().es_publica)

    @override_settings(LECTURAS_REFRESH_TOKEN='test-refresh-token')
    def test_refresh_requires_service_token(self):
        url = reverse('lecturas-refresh')
        self.assertEqual(self.client.post(url).status_code, status.HTTP_403_FORBIDDEN)
        with patch(
            'core_liturgia.views.LecturasProxyService.refresh_range',
            return_value={'refrescadas': [], 'fallidas': [], 'total': 0},
        ):
            response = self.client.post(url, HTTP_X_INTERNAL_TOKEN='test-refresh-token')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    # ============================================================
    # Pruebas de Horarios y Emisiones
    # ============================================================
    def test_list_horarios(self):
        url = reverse('horarios-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        results = response.data['results'] if 'results' in response.data else response.data
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0]['lugar'], 'Capilla')

    def test_list_emisiones_destacadas(self):
        url = reverse('emisiones-destacadas')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['titulo'], 'Misa en Vivo de Prueba')

    # ============================================================
    # Pruebas de Información Singleton
    # ============================================================
    def test_parroquia_info(self):
        url = reverse('parroquia-info')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['nombre'], 'Parroquia Cristo Resucitado Test')

    def test_oficina_info(self):
        url = reverse('oficina-info')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['direccion'], 'Lateral del Templo')
