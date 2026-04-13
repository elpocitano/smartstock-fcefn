# Plan de Trabajo - SmartStock (Integración Full Stack)

**Versión:** 1.0  
**Fecha inicio:** [DD/MM/AAAA]  
**Duración estimada:** 6 semanas (parcial, compatible con cursado)

---

## Hitos y entregas clave

| Hito | Semana | Descripción | Criterio de aceptación |
|------|--------|-------------|------------------------|
| **H0** | 0 | Setup de infraestructura | Repositorio con ramas, .gitignore, Supabase proyecto creado. |
| **H1** | 1 | Base de datos y modelo | Script SQL ejecutado, RLS configurado, datos semilla cargados (20 equipos, 5 usuarios). |
| **H2** | 2 | Autenticación y sesión | Login modal funcional (con Supabase Auth), logout, persistencia de sesión. |
| **H3** | 3 | Módulo de Inventario (lectura) | Listado de equipos desde Supabase, filtros, búsqueda, modal de detalle. |
| **H4** | 4 | Módulo de Préstamos/Reservas | Home con devoluciones y reservas interactivas (escritura en DB). |
| **H5** | 5 | Módulo de Usuarios y Guía | Listado de usuarios desde DB, página de guía con artículos estáticos. |
| **H6** | 6 | Pruebas, pulido y entrega | Validación UAT, correcciones, documentación final, tagging v1.0.0. |

---

## Fase 0: Setup y seguridad (Día 1-2)

### Tareas
- [ ] Crear proyecto en Supabase (plan gratuito).
- [ ] Guardar las URL y claves anónimas en `.env.local` (no subir).
- [ ] Estructurar carpetas según README:

> 
> .env  
> .env.local  
> supabase/.temp  
> node\_modules/  
> \*.log  
> .DS\_Store
> 
> text
> 
> Copy
> 
> Download
> 
> \- \[ \] Crear proyecto en Supabase (plan gratuito).
> \- \[ \] Guardar las URL y claves anónimas en \`.env.local\` (no subir).
> \- \[ \] Estructurar carpetas según README:
> 
> smartstock/  
> ├── docs/  
> ├── sql/  
> ├── src/  
> │ ├── features/  
> │ ├── shared/  
> │ └── assets/  
> ├── index.html  
> ├── inventario.html  
> ├── usuarios.html  
> ├── reservas.html  
> ├── guia.html  
> └── ...

- [ ] Crear archivo `src/shared/supabaseClient.js` con inicialización.

**Entregable:** Repositorio funcional con conexión a Supabase (prueba de consulta simple).

---

## Fase 1: Modelo de datos (Semana 1)

### Tareas
- [ ] Escribir script `sql/schema.sql` con todas las tablas (incluyendo índices y triggers de auditoría).
- [ ] Escribir script `sql/seed.sql` con 20 equipos reales y 5 usuarios (roles variados).
- [ ] Ejecutar scripts en Supabase SQL Editor.
- [ ] Configurar políticas RLS para cada tabla:
- `users`: solo lectura para todos, escritura solo para admin.
- `equipment`: lectura para todos, escritura solo para prestamista y admin.
- `loan` y `loan_items`: lectura para el usuario propietario y prestamista; escritura solo para prestamista.
- `incident`: creación cualquiera, lectura para prestamista y admin.
- [ ] Probar RLS con diferentes roles (usando el cliente anónimo y el de servicio).

**Entregable:** Base de datos operativa con datos de prueba y políticas activas.

---

## Fase 2: Autenticación y sesión (Semana 1-2)

### Tareas
- [ ] Crear modal de login (ya existe en index.html, pero ahora real con Supabase Auth).
- [ ] Implementar `src/features/auth/login.js`:
- Capturar email/contraseña, llamar a `supabase.auth.signIn()`.
- Guardar sesión en `sessionStorage`.
- Redirigir a la página de origen.
- [ ] Implementar logout (botón en menú hamburguesa).
- [ ] Crear un interceptor en `src/shared/fetchWithAuth.js` para añadir el token a las peticiones a la API de Supabase.
- [ ] Mostrar nombre del usuario logueado en el menú (ej. "Ana Torres (Secretaria)").
- [ ] Manejar errores de autenticación (credenciales inválidas, red caída).

**Entregable:** Login real con persistencia de sesión y protección de rutas (sin login no se ven datos sensibles).

---

## Fase 3: Módulo de Inventario (Semana 2-3)

### Tareas
- [ ] Crear `src/features/inventario/inventario.js` (módulo ES6).
- [ ] Cargar equipos desde Supabase (filtros, búsqueda) usando `supabase.from('equipment').select('*, users(name)')`.
- [ ] Implementar renderizado híbrido (cards en móvil, tabla en desktop) según código ya diseñado.
- [ ] Implementar filtros dinámicos (categorías desde la DB, estados fijos).
- [ ] Implementar modal de detalle con ficha técnica (leer desde DB).
- [ ] En el modal, agregar botón "Iniciar préstamo" (si equipo está disponible) que abra otro modal para seleccionar usuario y fechas (lógica a implementar en Fase 4).

**Entregable:** Página de inventario totalmente funcional con datos reales de Supabase.

---

## Fase 4: Préstamos y reservas (Semana 3-4)

### Tareas
- [ ] Modificar Home (`index.html`) para que las cards de equipos en préstamo y disponibles se carguen desde la DB.
- [ ] Implementar lógica de devolución:
- Al hacer clic en "Devolver", abrir modal.
- Si se confirma, actualizar `loan_items.effective_return = now()`, y si todos los ítems del préstamo están devueltos, cambiar `loan.status = 'finalizado'`.
- Si hay incidencia, insertar en `incident`.
- [ ] Implementar lógica de retiro/reserva:
- Desde card de categoría (Home) o desde ficha de equipo (Inventario), abrir modal.
- Seleccionar usuario (solo si es prestamista), fechas, tipo (retiro inmediato o reserva).
- Crear registro en `loan` y `loan_items` con estado `activo` (si retiro) o `pendiente` (si reserva).
- Actualizar estado del equipo en `equipment` a `ocupado` o `reservado`.
- [ ] Añadir validación para evitar doble reserva (comprobar disponibilidad en las fechas).

**Entregable:** Ciclo completo de préstamo/devolución/reserva funcionando.

---

## Fase 5: Usuarios y Guía (Semana 4-5)

### Tareas
- [ ] Página `usuarios.html`: listado desde Supabase (tabla `users`), con filtros por rol y estado.
- [ ] Modal de perfil de usuario: mostrar equipos que tiene actualmente (consulta a `loan_items` + `loan`).
- [ ] Página `guia.html`: contenido estático (no requiere DB). Se pueden usar cards con artículos en Markdown o HTML.
- [ ] Añadir en la guía sección de "Preguntas frecuentes" y "Contacto".

**Entregable:** Módulos de usuarios y guía completos.

---

## Fase 6: Pruebas, ajustes y entrega final (Semana 5-6)

### Tareas
- [ ] Realizar pruebas de usuario (UAT) con al menos dos docentes de geología (simuladas).
- [ ] Corregir bugs detectados (especialmente en el flujo de préstamos concurrentes).
- [ ] Optimizar consultas SQL (añadir índices faltantes, usar `explain`).
- [ ] Refinar la UI/UX: spinners de carga, mensajes de error amigables, validación de formularios.
- [ ] Documentar el código (comentarios JSDoc en funciones principales).
- [ ] Actualizar `README.md` con instrucciones de despliegue (variables de entorno, etc.).
- [ ] Hacer merge final de `develop` a `main` y crear tag `v1.0.0`.
- [ ] Preparar presentación (diapositivas) para la defensa.

**Entregable:** MVP completo, desplegado en GitHub Pages (frontend) + Supabase (backend), listo para evaluación.

---

## Recomendaciones adicionales

- **Control de versiones**: Cada tarea debe tener su propia rama `feat/` y merge a `develop` mediante Pull Request (aunque sea uno solo, simula flujo profesional).
- **Monitoreo**: Usar el panel de Supabase para ver logs de autenticación y consultas lentas.
- **Backup**: Configurar un backup semanal automático desde Supabase (Dashboard → Database Backups).
- **Entrega**: Incluir en la carpeta `docs/` el archivo `evidencia.md` con capturas de pantalla del sistema funcionando y enlace al repositorio.

---

## Cronograma tentativo (en horas)

| Fase | Horas estimadas |
|------|----------------|
| Setup | 4 |
| Modelo datos | 8 |
| Autenticación | 6 |
| Inventario | 10 |
| Préstamos/Reservas | 12 |
| Usuarios y Guía | 6 |
| Pruebas y pulido | 8 |
| **Total** | **54 horas** |

*Distribución sugerida: 9 horas/semana durante 6 semanas.*


# Plan de Trabajo - SmartStock (Integración Full Stack + Refactorización)

**Versión:** 1.1  
**Fecha inicio:** [DD/MM/AAAA]  
**Duración estimada:** 6 semanas

---

## Hitos y entregas clave

| Hito | Semana | Descripción | Criterio de aceptación |
|------|--------|-------------|------------------------|
| **H0** | 0 | Setup de infraestructura + limpieza de archivos obsoletos | Repositorio sin archivos descartados, `.gitignore` actualizado, Supabase proyecto creado. |
| **H1** | 1 | Base de datos y modelo | Scripts SQL ejecutados, RLS configurado, datos semilla cargados. |
| **H2** | 2 | Autenticación real y centralización de JS | Login modal funcional, logout, JS de modo oscuro y modales extraído a módulos compartidos. |
| **H3** | 3 | Módulo de Inventario (con Supabase) | Vista híbrida (cards/tabla) con datos reales, filtros, búsqueda, modal de detalle. |
| **H4** | 4 | Módulo de Home (préstamos/devoluciones) | Home dinámico con equipos en préstamo y disponibles, operaciones de devolución y reserva escribiendo en DB. |
| **H5** | 5 | Módulos de Usuarios y Reservas | Listado de usuarios desde tabla `users`, listado de préstamos activos y reservas. |
| **H6** | 6 | Pruebas, pulido y entrega | Validación UAT, correcciones, documentación final, tagging v1.0.0. |

---

## Tareas detalladas por fase

### Fase 0: Setup y limpieza (Día 1-2)

- [ ] Eliminar archivos obsoletos: `desktop.html`, `app.js` (viejo), `dataset_ds.js`.
- [ ] Mover `dataset.js` a `src/legacy/` como respaldo (no se usará en producción).
- [ ] Crear estructura de carpetas modular: