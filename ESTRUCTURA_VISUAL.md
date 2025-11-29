# 🏋️ Sistema de Rutinas - Estructura Visual

## 📂 Arquitectura de Archivos

```
OrdinarioBackend/
├── models/
│   └── rutinaModel.js          ✅ Modelo con estructura completa
├── controllers/
│   └── rutinaController.js     ✅ 10 funciones de control
├── routes/
│   └── rutinaRoutes.js         ✅ 10 endpoints REST
├── server.js                   ✅ Actualizado con /api/rutinas
├── API_RUTINAS.md              📖 Documentación de API
├── TESTING_EXAMPLES.md         📖 Ejemplos de uso
├── README_RUTINAS.md           📖 Resumen completo
└── test_rutinas.sh             🧪 Script de prueba
```

## 🗄️ Estructura de Datos

```
┌─────────────────────────────────────────────────────────┐
│                     RUTINA                              │
├─────────────────────────────────────────────────────────┤
│ _id:        ObjectId (auto)                             │
│ user_id:    ObjectId (ref: User)                        │
│ date:       Date (default: ahora)                       │
│ name:       String (ej: "Leg Day")                      │
│ exercises:  Array de Ejercicios ──────┐                 │
│ createdAt:  Date (auto)               │                 │
│ updatedAt:  Date (auto)               │                 │
└───────────────────────────────────────┼─────────────────┘
                                        │
                                        ▼
              ┌─────────────────────────────────────────┐
              │           EJERCICIO                     │
              ├─────────────────────────────────────────┤
              │ exercise_name: String (ej: "Squat")     │
              │ type:          "strength" | "cardio"    │
              │ sets:          Array de Sets ──────┐    │
              └────────────────────────────────────┼────┘
                                                   │
                                                   ▼
                          ┌──────────────────────────────┐
                          │          SET                 │
                          ├──────────────────────────────┤
                          │ set_number:  Number (1, 2..) │
                          │ reps:        Number (10, 8..)│
                          │ weight_kg:   Number (80, 85.)│
                          └──────────────────────────────┘
```

## 🔄 Flujo de Operaciones

### 1. CREAR RUTINA
```
Usuario → POST /api/rutinas → Controller → MongoDB
                ↓
    { name, exercises[] }
                ↓
    ✅ Rutina guardada con ID
```

### 2. AGREGAR EJERCICIO
```
Usuario → POST /api/rutinas/:id/ejercicios → Controller
                ↓
    { exercise_name, type, sets[] }
                ↓
    Buscar rutina → Agregar a array exercises → Guardar
                ↓
    ✅ Rutina actualizada
```

### 3. VER HISTORIAL
```
Usuario → GET /api/rutinas/historial/Squat → Controller
                ↓
    Buscar todas las rutinas con "Squat"
                ↓
    Filtrar solo el ejercicio Squat
                ↓
    Ordenar por fecha (más reciente primero)
                ↓
    ✅ Array con historial completo
```

## 📊 Endpoints y Funciones

| Endpoint | Método | Función | Descripción |
|----------|--------|---------|-------------|
| `/api/rutinas` | GET | getRutinas | Lista todas las rutinas |
| `/api/rutinas` | POST | createRutina | Crea nueva rutina |
| `/api/rutinas/:id` | GET | getRutinaById | Obtiene una rutina |
| `/api/rutinas/:id` | PUT | updateRutina | Actualiza rutina completa |
| `/api/rutinas/:id` | DELETE | deleteRutina | Elimina rutina |
| `/api/rutinas/:id/ejercicios` | POST | addEjercicio | Agrega ejercicio |
| `/api/rutinas/:id/ejercicios/:idx` | PUT | updateEjercicio | Actualiza ejercicio |
| `/api/rutinas/:id/ejercicios/:idx` | DELETE | deleteEjercicio | Elimina ejercicio |
| `/api/rutinas/historial/:name` | GET | getHistorialEjercicio | Ver historial |
| `/api/rutinas/ejercicios/nombres` | GET | getNombresEjercicios | Lista ejercicios únicos |

## 🎯 Ejemplo Completo

```javascript
// 1. CREAR RUTINA
POST /api/rutinas
{
  "name": "Leg Day",
  "exercises": []
}
→ Rutina ID: "67499abc..."

// 2. AGREGAR SQUAT
POST /api/rutinas/67499abc.../ejercicios
{
  "exercise_name": "Squat",
  "type": "strength",
  "sets": [
    { "set_number": 1, "reps": 10, "weight_kg": 80 }
  ]
}

// 3. AGREGAR MÁS SETS AL SQUAT (durante el workout)
PUT /api/rutinas/67499abc.../ejercicios/0
{
  "exercise_name": "Squat",
  "type": "strength",
  "sets": [
    { "set_number": 1, "reps": 10, "weight_kg": 80 },
    { "set_number": 2, "reps": 8, "weight_kg": 85 },
    { "set_number": 3, "reps": 6, "weight_kg": 90 }
  ]
}

// 4. AGREGAR LUNGES
POST /api/rutinas/67499abc.../ejercicios
{
  "exercise_name": "Lunges",
  "type": "strength",
  "sets": [
    { "set_number": 1, "reps": 12, "weight_kg": 20 }
  ]
}

// 5. VER HISTORIAL DE SQUAT (semanas después)
GET /api/rutinas/historial/Squat
→ [
    { date: "2023-10-27", sets: [...] },  // 80-85-90 kg
    { date: "2023-11-03", sets: [...] },  // 85-90-95 kg
    { date: "2023-11-10", sets: [...] }   // 90-95-100 kg
  ]
  📈 ¡Progreso visible!
```

## 🔒 Seguridad

```
Request → Middleware (authMiddleware.js) → Verificar JWT
                ↓
         Token válido?
          /          \
        NO           SÍ
         ↓            ↓
    401 Error    Extraer user.id
                      ↓
              Controller verifica:
              rutina.user_id === req.user.id
                  /          \
                NO           SÍ
                 ↓            ↓
            401 Error    Operación permitida ✅
```

## 💡 Tips de Uso

1. **Para registrar un workout en tiempo real:**
   - Crea la rutina con ejercicios vacíos
   - Ve agregando sets conforme los completas
   - Actualiza el ejercicio cada vez que terminas un set

2. **Para ver tu progreso:**
   - Usa el historial de ejercicio
   - Compara pesos y reps entre fechas
   - Identifica tendencias de mejora

3. **Para organizar tus rutinas:**
   - Usa nombres descriptivos ("Push Day", "Leg Day")
   - El campo date te permite registrar workouts pasados
   - Puedes tener múltiples rutinas con el mismo nombre (diferentes fechas)

## ✅ Todo Implementado

- ✅ Estructura MongoDB exacta según especificación
- ✅ CRUD completo de rutinas
- ✅ Gestión de ejercicios (agregar, editar, eliminar)
- ✅ Registro detallado de sets, reps y peso
- ✅ Historial completo por ejercicio
- ✅ Autenticación y autorización
- ✅ 10 endpoints REST funcionales
- ✅ Documentación completa
- ✅ Scripts de prueba

**🎉 ¡Sistema listo para producción!**

