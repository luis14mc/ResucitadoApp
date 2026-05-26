#!/bin/bash

echo "🚀 Iniciando generación de código para Parroquia Cristo Resucitado App..."

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
flutter clean

# Obtener dependencias
echo "📦 Instalando dependencias..."
flutter pub get

# Generar código
echo "⚙️ Generando código (modelos, DI, clientes API)..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Verificar que no hay errores
echo "🔍 Verificando código generado..."
flutter analyze

echo "✅ ¡Generación de código completada!"
echo ""
echo "📁 Archivos generados:"
echo "   - Modelos JSON: *.g.dart"
echo "   - Inyección de dependencias: injection.config.dart"
echo "   - Clientes API: *_api.g.dart"
echo ""
echo "🏃‍♂️ Para ejecutar la app: flutter run"