import logging
from datetime import date, timedelta
from django.core.management.base import BaseCommand
from django.utils import timezone

from core_liturgia.models import (
    DiaSemana,
    MisaHorario,
    Evento,
    VideoMisa,
    EstadoEmision,
    ParroquiaInfo,
    OficinaInfo,
    Santo,
    CalendarioLiturgico,
    Oracion,
    OracionSeccion,
)
from core_liturgia.services.lecturas_proxy import LecturasProxyService

logger = logging.getLogger(__name__)

class Command(BaseCommand):
    help = 'Carga datos de prueba iniciales (seed) en la base de datos para desarrollo local.'

    def handle(self, *args, **options):
        self.stdout.write(self.style.WARNING('Iniciando carga de datos seed para desarrollo...'))
        today = timezone.localdate()

        # ----------------------------------------------------
        # A) HORARIOS DE MISA
        # ----------------------------------------------------
        self.stdout.write('Cargando horarios de misas...')
        
        # Domingo 7:00 AM
        MisaHorario.objects.update_or_create(
            dia_semana=DiaSemana.DOMINGO,
            hora='07:00:00',
            lugar='Templo Principal',
            defaults={
                'celebrante': 'P. Párroco',
                'notas': 'Misa matutina - Comunión general',
                'activo': True
            }
        )

        # Domingo 10:00 AM
        MisaHorario.objects.update_or_create(
            dia_semana=DiaSemana.DOMINGO,
            hora='10:00:00',
            lugar='Templo Principal',
            defaults={
                'celebrante': 'P. Vicario',
                'notas': 'Misa de las familias y catequesis',
                'activo': True
            }
        )

        # Domingo 06:00 PM
        MisaHorario.objects.update_or_create(
            dia_semana=DiaSemana.DOMINGO,
            hora='18:00:00',
            lugar='Templo Principal',
            defaults={
                'celebrante': 'P. Párroco',
                'notas': 'Misa vespertina de jóvenes',
                'activo': True
            }
        )

        # Lunes a Viernes 6:00 PM
        for dia in [DiaSemana.LUNES, DiaSemana.MARTES, DiaSemana.MIERCOLES, DiaSemana.JUEVES, DiaSemana.VIERNES]:
            MisaHorario.objects.update_or_create(
                dia_semana=dia,
                hora='18:00:00',
                lugar='Templo Principal',
                defaults={
                    'celebrante': '',
                    'notas': 'Misa diaria regular',
                    'activo': True
                }
            )

        # Sábado 5:00 PM
        MisaHorario.objects.update_or_create(
            dia_semana=DiaSemana.SABADO,
            hora='17:00:00',
            lugar='Capilla Sagrada Familia',
            defaults={
                'celebrante': 'P. Colaborador',
                'notas': 'Misa de precepto en capilla filial',
                'activo': True
            }
        )

        # ----------------------------------------------------
        # B) EVENTOS ACTIVOS (Fechas dinámicas a futuro)
        # ----------------------------------------------------
        self.stdout.write('Cargando eventos activos...')

        def get_next_weekday(target_weekday):
            days_ahead = target_weekday - today.weekday()
            if days_ahead <= 0:
                days_ahead += 7
            return today + timedelta(days=days_ahead)

        # Misa Dominical (Próximo Domingo)
        fecha_domingo = get_next_weekday(6)
        Evento.objects.update_or_create(
            titulo='Solemne Misa Dominical',
            fecha=fecha_domingo,
            defaults={
                'descripcion': 'Únete a nuestra celebración comunitaria en la liturgia del domingo.',
                'hora': '10:00 AM',
                'lugar': 'Templo Principal, Col. Loarque',
                'categoria': 'liturgia',
                'es_recurrente': True,
                'frecuencia_recurrencia': 'Semanal',
                'maximo_participantes': 300,
                'participantes_actuales': 0,
                'requiere_inscripcion': False,
                'contacto_responsable': 'Pastoral de Acogida',
                'telefono': '+504 2226-0000',
                'email': 'acogida@cristoresucitado.hn',
                'etiquetas': ['Dominical', 'Familia', 'Comunidad'],
                'activo': True
            }
        )

        # Hora Santa (Próximo Jueves Sacerdotal)
        fecha_jueves = get_next_weekday(3)
        Evento.objects.update_or_create(
            titulo='Hora Santa de Adoración',
            fecha=fecha_jueves,
            defaults={
                'descripcion': 'Un espacio íntimo de silencio, oración y canto ante el Santísimo Sacramento del Altar.',
                'hora': '07:00 PM',
                'lugar': 'Capilla del Santísimo',
                'categoria': 'liturgia',
                'es_recurrente': True,
                'frecuencia_recurrencia': 'Semanal',
                'maximo_participantes': 80,
                'participantes_actuales': 0,
                'requiere_inscripcion': False,
                'contacto_responsable': 'Adoradores Nocturnos',
                'etiquetas': ['Eucaristía', 'Adoración', 'Silencio'],
                'activo': True
            }
        )

        # Catequesis Juvenil (Próximo Sábado)
        fecha_sabado = get_next_weekday(5)
        Evento.objects.update_or_create(
            titulo='Encuentro de Catequesis Juvenil',
            fecha=fecha_sabado,
            defaults={
                'descripcion': 'Formación y crecimiento espiritual para jóvenes que se preparan para su Confirmación.',
                'hora': '02:00 PM',
                'lugar': 'Salón Parroquial San Juan Pablo II',
                'categoria': 'juventud',
                'es_recurrente': True,
                'frecuencia_recurrencia': 'Semanal',
                'maximo_participantes': 60,
                'participantes_actuales': 25,
                'requiere_inscripcion': True,
                'contacto_responsable': 'Coordinación de Catequesis',
                'telefono': '+504 2226-1111',
                'email': 'confirmacion@cristoresucitado.hn',
                'etiquetas': ['Confirmación', 'Jóvenes', 'Catequesis'],
                'activo': True
            }
        )

        # Reunión de Pastoral (Próximo Martes)
        fecha_martes = get_next_weekday(1)
        Evento.objects.update_or_create(
            titulo='Asamblea de Coordinación Pastoral',
            fecha=fecha_martes,
            defaults={
                'descripcion': 'Reunión de planificación de las distintas pastorales y movimientos de la parroquia.',
                'hora': '07:00 PM',
                'lugar': 'Salón Multiusos',
                'categoria': 'comunidad',
                'es_recurrente': False,
                'maximo_participantes': 40,
                'participantes_actuales': 0,
                'requiere_inscripcion': False,
                'contacto_responsable': 'Consejo de Pastoral',
                'etiquetas': ['Planificación', 'Pastoral', 'Líderes'],
                'activo': True
            }
        )

        # ----------------------------------------------------
        # C) EMISIONES (VideoMisa - Facebook Live)
        # ----------------------------------------------------
        self.stdout.write('Cargando emisiones y transmisiones...')

        # Emisión Programada (Próximo Domingo)
        fecha_emision_dom = timezone.make_aware(timezone.datetime(fecha_domingo.year, fecha_domingo.month, fecha_domingo.day, 10, 0))
        VideoMisa.objects.update_or_create(
            titulo='Solemne Misa Dominical - Transmisión en Vivo',
            fecha_evento=fecha_emision_dom,
            defaults={
                'descripcion': 'Sintoniza la transmisión en vivo de la Eucaristía dominical de la Parroquia Cristo Resucitado.',
                'estado': EstadoEmision.PROGRAMADA,
                'url_facebook': 'https://facebook.com/cristoresucitadotgu/live',
                'facebook_video_id': 'fb_live_domingo_001',
                'destacada': True
            }
        )

        # Emisión Grabada (Miércoles Pasado)
        fecha_emision_mi = timezone.now() - timedelta(days=3)
        VideoMisa.objects.update_or_create(
            titulo='Reflexión Litúrgica: El Camino de Emaús',
            fecha_evento=fecha_emision_mi,
            defaults={
                'descripcion': 'Una meditación guiada por nuestro párroco sobre la aparición de Jesús resucitado a los discípulos de Emaús.',
                'estado': EstadoEmision.GRABADA,
                'url_facebook': 'https://facebook.com/cristoresucitadotgu/videos/reflexion_emaus',
                'facebook_video_id': 'fb_video_emaus_123',
                'duracion_minutos': 42,
                'destacada': False
            }
        )

        # Emisión Grabada Destacada (Ayer)
        fecha_emision_ayer = timezone.now() - timedelta(days=1)
        VideoMisa.objects.update_or_create(
            titulo='Santo Rosario Parroquial por las Vocaciones',
            fecha_evento=fecha_emision_ayer,
            defaults={
                'descripcion': 'Únete en oración del Santo Rosario pidiendo por las vocaciones sacerdotales y religiosas en nuestro país.',
                'estado': EstadoEmision.GRABADA,
                'url_facebook': 'https://facebook.com/cristoresucitadotgu/videos/rosario_vocaciones',
                'facebook_video_id': 'fb_video_rosario_456',
                'duracion_minutos': 28,
                'destacada': True
            }
        )

        # ----------------------------------------------------
        # D) INFORMACIÓN PARROQUIAL (Singleton)
        # ----------------------------------------------------
        self.stdout.write('Cargando información parroquial...')
        ParroquiaInfo.objects.update_or_create(
            id=1,
            defaults={
                'nombre': 'Parroquia Cristo Resucitado',
                'historia': 'La Parroquia Cristo Resucitado fue erigida en la década de los 80 en la zona sur de Tegucigalpa, Honduras. Desde su creación bajo el amparo de la Arquidiócesis de Tegucigalpa, ha crecido junto a sus comunidades y capillas, impulsando la fe activa, la labor social y la formación integral de los fieles.',
                'mision': 'Evangelizar con gozo a nuestras comunidades a través de la liturgia, el servicio caritativo y la vivencia fraterna, reflejando el amor redentor de Cristo Resucitado.',
                'vision': 'Ser una comunidad parroquial unida, misionera, sólidamente formada en la fe y comprometida socialmente, que sea luz y testimonio del Evangelio en Honduras.',
                'valores': ['Fe viva', 'Comunión eclesial', 'Servicio caritativo', 'Fraternidad', 'Transparencia'],
                'imagenes': [
                    'https://picsum.photos/seed/parroquia_front/800/600',
                    'https://picsum.photos/seed/parroquia_altar/800/600'
                ],
                'direccion': 'Colonia Loarque, Carretera al Sur, entrada principal, Tegucigalpa, Honduras.',
                'telefono': '+504 2226-0000',
                'email': 'oficina@cristoresucitado.hn'
            }
        )

        # ----------------------------------------------------
        # E) OFICINA PARROQUIAL (Singleton)
        # ----------------------------------------------------
        self.stdout.write('Cargando información de oficina...')
        OficinaInfo.objects.update_or_create(
            id=1,
            defaults={
                'direccion': 'Costado lateral derecho del Templo Principal, Colonia Loarque, Tegucigalpa, Honduras.',
                'telefono': '+504 2226-1111',
                'email': 'oficina@cristoresucitado.hn',
                'horarios': {
                    'Lunes a Viernes': '08:00 AM - 12:00 PM, 02:00 PM - 05:00 PM',
                    'Sábados': '08:00 AM - 12:00 PM',
                    'Domingos': 'Cerrado'
                },
                'servicios': [
                    'Solicitud y pláticas de Bautizo',
                    'Inscripción de catequesis de Primera Comunión y Confirmación',
                    'Amonestaciones y trámites de Matrimonio',
                    'Anotación de intenciones de misa y sufragios',
                    'Emisión de constancias, certificaciones de Sacramentos y solvencias eclesiales'
                ],
                'latitud': 14.0435,
                'longitud': -87.2186
            }
        )

        # ----------------------------------------------------
        # F) SANTO DEL DÍA & SANTOS
        # ----------------------------------------------------
        self.stdout.write('Cargando santos...')
        
        # Santo del Día (Dinámicamente enlazado a la fecha actual)
        Santo.objects.update_or_create(
            nombre='San Felipe Neri',
            defaults={
                'titulo': 'Presbítero y Fundador del Oratorio',
                'fecha_celebracion': today,
                'biografia': 'San Felipe Neri, conocido como el "Apóstol de Roma" y el "Santo de la Alegría", fue un sacerdote italiano del siglo XVI que reformó la vida eclesial mediante la caridad activa, el humor y la evangelización dedicada a jóvenes y enfermos. Fundó la Congregación del Oratorio para rezar, cantar y cultivar la música sacra.',
                'festividad': f'{today.day} de {["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"][today.month - 1]}',
                'patrono': 'Educadores, humoristas, comediantes y jóvenes.',
                'oracion': 'Oh Dios, que colmaste el corazón de San Felipe Neri con el fuego de tu Espíritu Santo, infunde en nosotros ese mismo amor para que sepamos ser alegres servidores de tu Reino.',
                'atributos': ['Corazón ardiente', 'Lirio', 'Libro de oraciones', 'Rosario'],
                'imagen_url': 'https://picsum.photos/seed/felipeneri/400/400'
            }
        )

        # Otros Santos Famosos para robustecer búsquedas/listados
        Santo.objects.update_or_create(
            nombre='San Francisco de Asís',
            defaults={
                'titulo': 'Fundador de los Franciscanos y Patrono de la Ecología',
                'fecha_celebracion': date(today.year, 10, 4),
                'biografia': 'San Francisco de Asís renunció a su riqueza familiar para vivir en pobreza y predicar el Evangelio con sencillez absoluta. Amante de la creación de Dios, compuso el Canto de las Criaturas y fue marcado con los estigmas de Cristo.',
                'festividad': '4 de Octubre',
                'patrono': 'Ecologistas, animales, sastres y la paz.',
                'oracion': 'Señor, hazme un instrumento de tu paz. Que donde haya odio, yo ponga amor; donde haya ofensa, yo ponga perdón...',
                'atributos': ['Estigmas', 'Lobo', 'Crucifijo de San Damián', 'Túnica marrón'],
                'imagen_url': 'https://picsum.photos/seed/franciscoasis/400/400'
            }
        )

        # ----------------------------------------------------
        # G) CALENDARIO LITÚRGICO / LECTURAS (Garantizar día actual)
        # ----------------------------------------------------
        self.stdout.write('Garantizando caché de Lecturas del día actual...')
        try:
            LecturasProxyService().fetch_and_cache(today)
        except Exception as exc:
            self.stdout.write(self.style.ERROR(f'No se pudo conectar a Ciudad Redonda: {exc}. Se crearon lecturas locales de fallback.'))

        # ----------------------------------------------------
        # H) ORACIONES Y DEVOCIONARIO
        # ----------------------------------------------------
        self.stdout.write('Cargando oraciones y devocionario...')

        # Helper to create sections safely
        def create_secciones(oracion, secciones_data):
            # Delete old sections to ensure idempotency and no duplicates on reload
            OracionSeccion.objects.filter(oracion=oracion).delete()
            for index, (titulo, contenido) in enumerate(secciones_data):
                OracionSeccion.objects.create(
                    oracion=oracion,
                    titulo=titulo,
                    contenido=contenido,
                    orden=index
                )

        # 1. Lectio Divina
        ld, _ = Oracion.objects.update_or_create(
            slug='lectio-divina',
            defaults={
                'titulo': 'Lectio Divina',
                'categoria': 'lectio_divina',
                'descripcion': 'Método tradicional de lectura orante y meditación de las Sagradas Escrituras para profundizar la relación con Dios.',
                'contenido': '',
                'orden': 10,
                'activo': True,
                'destacada': True,
                'duracion_estimada': 15,
            }
        )
        create_secciones(ld, [
            ('Invocación al Espíritu Santo', 'Ven, Espíritu Santo, llena los corazones de tus fieles y enciende en ellos el fuego de tu amor. Envía tu Espíritu y todo será creado, y renovarás la faz de la tierra. Amén.'),
            ('Lectura (¿Qué dice el texto?)', 'Lee despacio el pasaje del Evangelio del día. Presta atención a las palabras, a los personajes, a las acciones y al contexto. Relee el texto si es necesario para captar su mensaje original.'),
            ('Meditación (¿Qué me dice Dios en el texto?)', 'Reflexiona sobre cómo resuena esta Palabra en tu vida actual. ¿Qué te confronta? ¿Qué te consuela? ¿A qué te invita el Señor a través de estos versículos? Deja que penetre en tu corazón.'),
            ('Oración (¿Qué le digo yo a Dios?)', 'Responde al Señor con tus propias palabras. Exprésale tu agradecimiento, pídele perdón por tus faltas, suplica su gracia para cambiar o preséntale las necesidades de tus hermanos.'),
            ('Contemplación (Silencio y reposo en Dios)', 'Entra en un momento de silencio adorante. Déjate amar por el Señor, reposa en su presencia y permite que su gracia transforme tu interior más allá de los pensamientos y las palabras.'),
            ('Acción (Compromiso concreto)', 'Traduce tu encuentro orante en una actitud o acción concreta para tu jornada. ¿Cómo puedes vivir hoy la Palabra meditada en tu familia, trabajo o comunidad?')
        ])

        # 2. Completas
        comp, _ = Oracion.objects.update_or_create(
            slug='completas-oracion',
            defaults={
                'titulo': 'Completas (Liturgia de las Horas)',
                'categoria': 'liturgia_horas',
                'descripcion': 'Oración oficial de la Iglesia al finalizar el día, antes del descanso nocturno.',
                'contenido': '',
                'orden': 20,
                'activo': True,
                'destacada': True,
                'duracion_estimada': 10,
            }
        )
        create_secciones(comp, [
            ('Invocación inicial', 'V. Dios mío, ven en mi auxilio.\nR. Señor, date prisa en socorrerme.\nGloria al Padre, y al Hijo, y al Espíritu Santo. Como era en el principio, ahora y siempre, por los siglos de los siglos. Amén. Aleluya.'),
            ('Examen de conciencia', 'En un breve silencio, revisamos el día que termina. Pedimos perdón a Dios por nuestros pecados y flaquezas con un corazón arrepentido.'),
            ('Himno', 'Al terminar el día, creador del universo, te pedimos que nos guardes en tu amor y nos concedas un descanso tranquilo bajo tu protección paternal.'),
            ('Salmo (Salmo 90)', 'Tú que habitas al amparo del Altísimo, que vives a la sombra del Omnipotente, di al Señor: "Refugio mío, alcázar mío, Dios mío en quien confío". Él te librará de la red del cazador...'),
            ('Lectura breve', 'No se ponga el sol sobre vuestra ira; no deis ocasión al diablo. No salga de vuestra boca palabra mala, sino la que sea buena para la edificación necesaria.'),
            ('Responsorio', 'V. En tus manos, Señor, encomiendo mi espíritu.\nR. En tus manos, Señor, encomiendo mi espíritu.\nV. Tú nos redimiste, Señor, Dios de verdad.\nR. Encomiendo mi espíritu.\nV. Gloria al Padre, y al Hijo, y al Espíritu Santo.\nR. En tus manos, Señor...'),
            ('Cántico de Simeón', 'Sálvanos, Señor, despiertos, protégenos mientras dormimos, para que velemos con Cristo y descansemos en paz.\n\n"Ahora, Señor, según tu promesa, puedes dejar a tu siervo irse en paz..."'),
            ('Oración final', 'Visita, Señor, esta habitación; aleja de ella las insidias del enemigo; que tus santos ángeles habiten en ella para guardarnos en paz, y que tu bendición permanezca siempre con nosotros. Por Jesucristo nuestro Señor. Amén.')
        ])

        # 3. Santo Rosario
        Oracion.objects.update_or_create(
            slug='santo-rosario',
            defaults={
                'titulo': 'Santo Rosario',
                'categoria': 'rosario',
                'descripcion': 'Contemplación de los misterios de la vida de Jesús y la Virgen María, entrelazada con el rezo de las oraciones marianas tradicionales.',
                'contenido': 'El Santo Rosario es una de las devociones más queridas. Se divide en cuatro grupos de Misterios:\n\n'
                             '1. Misterios Gozosos (Lunes y Sábado): La Encarnación, la Visitación, el Nacimiento, la Presentación, el Niño Jesús hallado en el templo.\n'
                             '2. Misterios Luminosos (Jueves): El Bautismo de Jesús, las Bodas de Caná, el Anuncio del Reino, la Transfiguración, la Institución de la Eucaristía.\n'
                             '3. Misterios Dolorosos (Martes y Viernes): La Agonía en el huerto, la Flagelación, la Coronación de espinas, Jesús con la cruz a cuestas, la Crucifixión.\n'
                             '4. Misterios Gloriosos (Miércoles y Domingo): La Resurrección, la Ascensión, la Venida del Espíritu Santo, la Asunción de María, la Coronación de la Virgen.\n\n'
                             'Para rezarlo: Inicia con el Credo, reza un Padre Nuestro, tres Ave Marías y un Gloria. En cada misterio se reza un Padre Nuestro, diez Ave Marías, un Gloria y la jaculatoria de Fátima.',
                'orden': 30,
                'activo': True,
                'destacada': True,
                'duracion_estimada': 20,
            }
        )

        # 4. Coronilla de la Divina Misericordia
        Oracion.objects.update_or_create(
            slug='coronilla-misericordia',
            defaults={
                'titulo': 'Coronilla de la Divina Misericordia',
                'categoria': 'coronilla',
                'descripcion': 'Oración revelada por Jesús a Santa Faustina Kowalska para implorar su divina misericordia sobre el mundo entero.',
                'contenido': 'Se reza utilizando un rosario común, iniciando con un Padre Nuestro, Ave María y Credo.\n\n'
                             'En las cuentas grandes (del Padre Nuestro) se dice:\n'
                             '"Padre Eterno, te ofrezco el Cuerpo y la Sangre, el Alma y la Divinidad de tu amadísimo Hijo, nuestro Señor Jesucristo, como propiciación de nuestros pecados y los del mundo entero."\n\n'
                             'En las cuentas pequeñas (del Ave María) se dice:\n'
                             '"Por su dolorosa Pasión, ten misericordia de nosotros y del mundo entero."\n\n'
                             'Al finalizar las cinco decenas, se repite tres veces:\n'
                             '"Santo Dios, Santo Fuerte, Santo Inmortal, ten piedad de nosotros y del mundo entero."',
                'orden': 40,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 10,
            }
        )

        # 5. Padre Nuestro
        Oracion.objects.update_or_create(
            slug='padre-nuestro',
            defaults={
                'titulo': 'Padre Nuestro',
                'categoria': 'basicas',
                'descripcion': 'La oración del Señor, modelo de toda oración cristiana.',
                'contenido': 'Padre nuestro, que estás en el cielo, santificado sea tu Nombre; venga a nosotros tu reino; hágase tu voluntad en la tierra como en el cielo. Danos hoy nuestro pan de cada día; perdona nuestras ofensas, como también nosotros perdonamos a los que nos ofenden; no nos dejes caer en la tentación, y líbranos del mal. Amén.',
                'orden': 50,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 1,
            }
        )

        # 6. Ave María
        Oracion.objects.update_or_create(
            slug='ave-maria',
            defaults={
                'titulo': 'Ave María',
                'categoria': 'basicas',
                'descripcion': 'El saludo del Arcángel Gabriel y la Iglesia a la Santísima Virgen María.',
                'contenido': 'Dios te salve, María, llena eres de gracia, el Señor es contigo; bendita tú eres entre todas las mujeres, y bendito es el fruto de tu vientre, Jesús. Santa María, Madre de Dios, ruega por nosotros, pecadores, ahora y en la hora de nuestra muerte. Amén.',
                'orden': 60,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 1,
            }
        )

        # 7. Gloria
        Oracion.objects.update_or_create(
            slug='gloria-al-padre',
            defaults={
                'titulo': 'Gloria al Padre',
                'categoria': 'basicas',
                'descripcion': 'Himno de alabanza y doxología a la Santísima Trinidad.',
                'contenido': 'Gloria al Padre, y al Hijo, y al Espíritu Santo. Como era en el principio, ahora y siempre, por los siglos de los siglos. Amén.',
                'orden': 70,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 1,
            }
        )

        # 8. Oración al Espíritu Santo
        Oracion.objects.update_or_create(
            slug='oracion-espiritu-santo',
            defaults={
                'titulo': 'Oración al Espíritu Santo',
                'categoria': 'basicas',
                'descripcion': 'Petición de luz, sabiduría y guía espiritual.',
                'contenido': 'Ven, Espíritu Santo, llena los corazones de tus fieles y enciende en ellos el fuego de tu amor. Envía, Señor, tu Espíritu y todo será creado, y renovarás la faz de la tierra. Oh Dios, que has iluminado los corazones de tus fieles con la luz del Espíritu Santo, concédenos que guiados por el mismo Espíritu, disfrutemos de lo que es recto y gocemos siempre de su consuelo. Por Jesucristo nuestro Señor. Amén.',
                'orden': 80,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 2,
            }
        )

        # 9. Acto de contrición
        Oracion.objects.update_or_create(
            slug='acto-contricion',
            defaults={
                'titulo': 'Acto de contrición',
                'categoria': 'basicas',
                'descripcion': 'Oración tradicional para manifestar el arrepentimiento de los pecados antes de la Reconciliación.',
                'contenido': 'Señor mío Jesucristo, Dios y Hombre verdadero, Creador, Padre y Redentor mío; por ser Vos quien sois, Bondad infinita, y porque os amo sobre todas las cosas, me pesa de todo corazón de haberos ofendido; también me pesa porque podéis castigarme con las penas del infierno. Propongo firmemente enmendarme y evitar las ocasiones de pecar, confesarme y cumplir la penitencia que me fuere impuesta. Amén.',
                'orden': 90,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 2,
            }
        )

        # 10. Oración por los enfermos
        Oracion.objects.update_or_create(
            slug='oracion-enfermos',
            defaults={
                'titulo': 'Oración por los enfermos',
                'categoria': 'intenciones',
                'descripcion': 'Súplica al Señor de la Vida por la salud corporal y espiritual de nuestros hermanos que sufren la enfermedad.',
                'contenido': 'Señor Jesús, Aquel que pasó haciendo el bien y sanando a los enfermos, te pedimos hoy por todos aquellos que sufren dolores físicos y espirituales. Concede a nuestros hermanos enfermos la paciencia en el sufrimiento, la esperanza de la recuperación y la fortaleza de tu presencia divina. Bendice a los médicos y enfermeros que los cuidan y haz que sientan tu amor consolador. Tú que vives y reinas por los siglos de los siglos. Amén.',
                'orden': 100,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 2,
            }
        )

        # 11. Oración por la familia
        Oracion.objects.update_or_create(
            slug='oracion-familia',
            defaults={
                'titulo': 'Oración por la familia',
                'categoria': 'intenciones',
                'descripcion': 'Oración por la paz, unión, respeto y fidelidad en los hogares.',
                'contenido': 'Señor Jesús, te encomendamos hoy a todas las familias de nuestra parroquia y del mundo entero. Que nuestros hogares sean reflejo del amor de la Sagrada Familia de Nazaret. Concede a los esposos fidelidad y mutuo apoyo; a los padres, sabiduría para educar a sus hijos; y a los hijos, docilidad y cariño. Que en medio de las dificultades familiares reine la reconciliación, el perdón y tu bendita paz. Amén.',
                'orden': 110,
                'activo': True,
                'destacada': False,
                'duracion_estimada': 2,
            }
        )

        self.stdout.write(self.style.SUCCESS('¡Carga de datos seed finalizada exitosamente!'))

