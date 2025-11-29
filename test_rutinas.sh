#!/bin/bash

# Script de prueba rápida para la API de Rutinas
# Uso: ./test_rutinas.sh YOUR_JWT_TOKEN

if [ -z "$1" ]; then
    echo "Error: Debes proporcionar un token JWT"
    echo "Uso: ./test_rutinas.sh YOUR_JWT_TOKEN"
    exit 1
fi

TOKEN=$1
BASE_URL="http://localhost:5000/api/rutinas"

echo "🏋️  Testing API de Rutinas"
echo "=========================="
echo ""

# 1. Crear una rutina
echo "1️⃣  Creando rutina 'Leg Day'..."
RESPONSE=$(curl -s -X POST "$BASE_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Leg Day",
    "exercises": [
      {
        "exercise_name": "Squat",
        "type": "strength",
        "sets": [
          { "set_number": 1, "reps": 10, "weight_kg": 80 },
          { "set_number": 2, "reps": 8, "weight_kg": 85 }
        ]
      }
    ]
  }')

RUTINA_ID=$(echo $RESPONSE | grep -o '"_id":"[^"]*' | cut -d'"' -f4)
echo "✅ Rutina creada con ID: $RUTINA_ID"
echo ""

# 2. Obtener todas las rutinas
echo "2️⃣  Obteniendo todas las rutinas..."
curl -s -X GET "$BASE_URL" \
  -H "Authorization: Bearer $TOKEN" | head -c 200
echo "..."
echo "✅ Rutinas obtenidas"
echo ""

# 3. Agregar un ejercicio
echo "3️⃣  Agregando ejercicio 'Lunges' a la rutina..."
curl -s -X POST "$BASE_URL/$RUTINA_ID/ejercicios" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "exercise_name": "Lunges",
    "type": "strength",
    "sets": [
      { "set_number": 1, "reps": 12, "weight_kg": 20 }
    ]
  }' > /dev/null
echo "✅ Ejercicio agregado"
echo ""

# 4. Ver la rutina específica
echo "4️⃣  Obteniendo rutina específica..."
curl -s -X GET "$BASE_URL/$RUTINA_ID" \
  -H "Authorization: Bearer $TOKEN" | head -c 300
echo "..."
echo "✅ Rutina obtenida"
echo ""

# 5. Ver historial de Squat
echo "5️⃣  Obteniendo historial de 'Squat'..."
curl -s -X GET "$BASE_URL/historial/Squat" \
  -H "Authorization: Bearer $TOKEN" | head -c 200
echo "..."
echo "✅ Historial obtenido"
echo ""

# 6. Obtener nombres de ejercicios
echo "6️⃣  Obteniendo nombres de todos los ejercicios..."
curl -s -X GET "$BASE_URL/ejercicios/nombres" \
  -H "Authorization: Bearer $TOKEN"
echo ""
echo "✅ Nombres obtenidos"
echo ""

echo "=========================="
echo "✅ Todas las pruebas completadas!"
echo ""
echo "Rutina de prueba ID: $RUTINA_ID"
echo "Puedes eliminarla con:"
echo "curl -X DELETE $BASE_URL/$RUTINA_ID -H \"Authorization: Bearer $TOKEN\""

