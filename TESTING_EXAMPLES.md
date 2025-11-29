# Ejemplos de Testing para la API de Rutinas

## Usando cURL

### 1. Crear una nueva rutina
```bash
curl -X POST http://localhost:5000/api/rutinas \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
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
      },
      {
        "exercise_name": "Lunges",
        "type": "strength",
        "sets": [
          { "set_number": 1, "reps": 12, "weight_kg": 20 }
        ]
      }
    ]
  }'
```

### 2. Obtener todas las rutinas
```bash
curl -X GET http://localhost:5000/api/rutinas \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 3. Obtener una rutina específica
```bash
curl -X GET http://localhost:5000/api/rutinas/RUTINA_ID \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 4. Actualizar una rutina
```bash
curl -X PUT http://localhost:5000/api/rutinas/RUTINA_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "name": "Updated Leg Day"
  }'
```

### 5. Agregar un ejercicio a una rutina
```bash
curl -X POST http://localhost:5000/api/rutinas/RUTINA_ID/ejercicios \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "exercise_name": "Leg Press",
    "type": "strength",
    "sets": [
      { "set_number": 1, "reps": 15, "weight_kg": 100 },
      { "set_number": 2, "reps": 12, "weight_kg": 110 }
    ]
  }'
```

### 6. Actualizar un ejercicio (índice 0)
```bash
curl -X PUT http://localhost:5000/api/rutinas/RUTINA_ID/ejercicios/0 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "exercise_name": "Squat",
    "type": "strength",
    "sets": [
      { "set_number": 1, "reps": 10, "weight_kg": 85 },
      { "set_number": 2, "reps": 8, "weight_kg": 90 },
      { "set_number": 3, "reps": 6, "weight_kg": 95 }
    ]
  }'
```

### 7. Obtener historial de un ejercicio
```bash
curl -X GET http://localhost:5000/api/rutinas/historial/Squat \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 8. Obtener nombres de todos los ejercicios
```bash
curl -X GET http://localhost:5000/api/rutinas/ejercicios/nombres \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 9. Eliminar un ejercicio (índice 1)
```bash
curl -X DELETE http://localhost:5000/api/rutinas/RUTINA_ID/ejercicios/1 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 10. Eliminar una rutina completa
```bash
curl -X DELETE http://localhost:5000/api/rutinas/RUTINA_ID \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## Usando Thunder Client / Postman / Insomnia

### Headers necesarios para todas las peticiones:
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

### Colección de ejemplos:

#### 1. POST - Crear rutina
**URL:** `http://localhost:5000/api/rutinas`
**Body:**
```json
{
  "name": "Push Day",
  "exercises": [
    {
      "exercise_name": "Bench Press",
      "type": "strength",
      "sets": [
        { "set_number": 1, "reps": 10, "weight_kg": 60 },
        { "set_number": 2, "reps": 8, "weight_kg": 65 },
        { "set_number": 3, "reps": 6, "weight_kg": 70 }
      ]
    },
    {
      "exercise_name": "Shoulder Press",
      "type": "strength",
      "sets": [
        { "set_number": 1, "reps": 10, "weight_kg": 30 },
        { "set_number": 2, "reps": 8, "weight_kg": 35 }
      ]
    }
  ]
}
```

#### 2. GET - Ver todas las rutinas
**URL:** `http://localhost:5000/api/rutinas`

#### 3. GET - Ver historial de Bench Press
**URL:** `http://localhost:5000/api/rutinas/historial/Bench Press`

#### 4. POST - Agregar ejercicio a rutina
**URL:** `http://localhost:5000/api/rutinas/{RUTINA_ID}/ejercicios`
**Body:**
```json
{
  "exercise_name": "Tricep Dips",
  "type": "strength",
  "sets": [
    { "set_number": 1, "reps": 15, "weight_kg": 0 },
    { "set_number": 2, "reps": 12, "weight_kg": 0 },
    { "set_number": 3, "reps": 10, "weight_kg": 0 }
  ]
}
```

---

## Flujo de trabajo típico

### Día 1: Crear y realizar una rutina
1. **Crear rutina nueva:**
   - POST `/api/rutinas` con nombre "Chest & Triceps"
   
2. **Agregar ejercicios uno por uno:**
   - POST `/api/rutinas/{id}/ejercicios` - Agregar Bench Press
   - POST `/api/rutinas/{id}/ejercicios` - Agregar Incline Press
   - POST `/api/rutinas/{id}/ejercicios` - Agregar Tricep Extension

3. **Durante el workout, actualizar sets:**
   - PUT `/api/rutinas/{id}/ejercicios/0` - Actualizar Bench Press con los pesos usados

### Día 2: Revisar progreso
1. **Ver historial de Bench Press:**
   - GET `/api/rutinas/historial/Bench Press`
   
2. **Crear nueva rutina basada en la anterior:**
   - GET `/api/rutinas/{id}` - Ver la rutina anterior
   - POST `/api/rutinas` - Crear nueva con pesos incrementados

### Análisis
1. **Ver todos los ejercicios que has hecho:**
   - GET `/api/rutinas/ejercicios/nombres`

2. **Ver todas las rutinas:**
   - GET `/api/rutinas`

---

## Notas de Testing

- Primero debes autenticarte en `/api/users/login` para obtener el token JWT
- Reemplaza `YOUR_TOKEN_HERE` con tu token JWT real
- Reemplaza `RUTINA_ID` con el ID real de la rutina (lo obtienes al crear o listar rutinas)
- Los nombres de ejercicios con espacios deben estar URL-encoded en las URLs (ej: "Bench Press" → "Bench%20Press")

