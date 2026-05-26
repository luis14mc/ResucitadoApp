@echo off
echo 🚀 Iniciando generación de código para Parroquia Cristo Resucitado App...

REM Limpiar builds anteriores
echo 🧹 Limpiando builds anteriores...
call flutter clean

REM Obtener dependencias
echo 📦 Instalando dependencias...
call flutter pub get

REM Generar código
echo ⚙️ Generando código (modelos, DI, clientes API)...
call flutter packages pub run build_runner build --delete-conflicting-outputs

REM Verificar que no hay errores
echo 🔍 Verificando código generado...
call flutter analyze

echo ✅ ¡Generación de código completada!
echo.
echo 📁 Archivos generados:
echo    - Modelos JSON: *.g.dart
echo    - Inyección de dependencias: injection.config.dart
echo    - Clientes API: *_api.g.dart
echo.
echo 🏃‍♂️ Para ejecutar la app: flutter run

pause