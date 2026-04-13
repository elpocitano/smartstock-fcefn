## 📋 Análisis del MVP actual y plan de refactorización

### 1. Archivos a descartar o reemplazar

| Archivo | Estado | Motivo |
|---------|--------|--------|
| `desktop.html` | ❌ Descartar | Página estática con datos falsos, sin integración con Supabase. No forma parte de la estructura actual. |
| `app.js` | ❌ Reemplazar | Usa `equipos` y `usuarios` globales de `dataset.js`. No sirve para la nueva arquitectura. |
| `dataset.js` | ⚠️ Mantener temporal (solo referencia) | Datos estáticos. Se reemplazarán por consultas a Supabase. |
| `inventario.js` (ejemplo) | ✅ Base para refactor | Contiene lógica de vista híbrida, pero debe modificarse para usar Supabase en lugar de `dataset.js`. |
| `footer.html` | ✅ Conservar (como fragmento) | Estructura HTML correcta. **Se debe extraer el JS embebido** (modo oscuro, modales) a archivos compartidos. |
| `navbar.html` | ✅ Conservar (como fragmento) | Igual que footer: extraer JS a módulos compartidos. |
| `index.html` | ✅ Refactorizar | Mantener estructura, pero reemplazar datos estáticos por consultas a Supabase y conectar modales con la API. |
| `inventario.html` | ✅ Refactorizar | Reemplazar cards estáticas por vista híbrida dinámica (cards móvil + tabla desktop) con datos de Supabase. |
| `styles.css` | ✅ Mantener | Ya está bien estructurado con variables CSS, BEM y modo oscuro. |

---

### 2. Archivos faltantes (por crear)

| Archivo | Propósito |
|---------|-----------|
| `src/shared/supabaseClient.js` | Cliente de Supabase (credenciales desde variables de entorno). |
| `src/features/auth/login.js` | Lógica de autenticación (login, logout, sesión). |
| `src/features/inventario/inventario.js` | Módulo ES6 para la página de inventario (conexión a Supabase). |
| `src/features/home/home.js` | Módulo para la página principal (cargar equipos en préstamo y disponibles, procesar devoluciones/reservas). |
| `src/features/usuarios/usuarios.js` | Módulo para listar usuarios desde Supabase. |
| `src/features/reservas/reservas.js` | Módulo para listar préstamos activos y reservas. |
| `reservas.html` | Página nueva para el listado de préstamos/reservas. |
| `usuarios.html` | Página nueva (o refactorizar la existente) para mostrar usuarios desde Supabase. |
| `guia.html` | Página estática con artículos (si no existe, crearla). |
| `config.js` (o `.env` en frontend) | Almacenar URL y clave anónima de Supabase (no subir al repo). |

---

### 3. Plan de trabajo actualizado (incorporando refactorización)

Actualizaré el `plan_trabajo.md` agregando las tareas específicas de refactorización y los nuevos módulos. A continuación, el contenido revisado:

```markdown
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
  ```
  src/
  ├── shared/
  │   ├── supabaseClient.js
  │   ├── theme.js          (modo oscuro)
  │   ├── modals.js         (lógica común de modales)
  │   └── utils.js
  ├── features/
  │   ├── auth/
  │   │   └── login.js
  │   ├── home/
  │   │   └── home.js
  │   ├── inventario/
  │   │   └── inventario.js
  │   ├── usuarios/
  │   │   └── usuarios.js
  │   └── reservas/
  │       └── reservas.js
  └── assets/
      └── img/
  ```
- [ ] Configurar `.gitignore` para ignorar `config.js` y `.env`.
- [ ] Crear `config.js` (no subir) con:
  ```javascript
  window.SUPABASE_URL = 'https://tu-proyecto.supabase.co';
  window.SUPABASE_ANON_KEY = 'tu-clave-anon';
  ```
- [ ] Crear `src/shared/supabaseClient.js` (importa `config.js` y exporta cliente).

**Entregable:** Proyecto limpio, estructura modular, cliente Supabase listo.

---

### Fase 1: Base de datos (Semana 1)

- [ ] Ejecutar `sql/schema.sql` y `sql/seed.sql` en Supabase (ya hecho).
- [ ] Verificar políticas RLS (ajustar si es necesario para pruebas iniciales).
- [ ] Probar consulta simple desde la consola del navegador usando `supabaseClient`.

**Entregable:** Base de datos operativa y accesible desde frontend.

---

### Fase 2: Autenticación y centralización de JS (Semana 1-2)

- [ ] Extraer lógica de modo oscuro de `index.html`, `navbar.html`, `footer.html` a `src/shared/theme.js`.
- [ ] Extraer lógica de modales (devolución, reserva) a `src/shared/modals.js` (funciones reutilizables).
- [ ] Implementar `src/features/auth/login.js`:
  - Capturar email/contraseña del modal `#loginModal`.
  - Usar `supabase.auth.signInWithPassword()`.
  - Guardar sesión en `sessionStorage`.
  - Redirigir o mostrar error.
- [ ] Agregar botón de logout en el menú hamburguesa (solo visible cuando hay sesión).
- [ ] Mostrar nombre del usuario logueado en el menú (desde `supabase.auth.user()`).

**Entregable:** Login real, sesión persistente, JS modularizado.

---

### Fase 3: Inventario (Semana 2-3)

- [ ] Refactorizar `inventario.html`:
  - Eliminar cards estáticas.
  - Agregar contenedores para vista híbrida: `<div id="inventarioCardsContainer" class="row g-4">` y `<tbody id="inventarioTableBody">`.
  - Mantener buscador y filtros (con `id` correspondientes).
- [ ] Crear `src/features/inventario/inventario.js`:
  - Cargar equipos desde `supabase.from('equipment').select('*, categories(name), users(full_name)')`.
  - Renderizar cards (móvil) y tabla (desktop) con los mismos datos.
  - Implementar búsqueda y filtros (local o vía consulta a Supabase).
  - Modal de detalle (con datos reales).
- [ ] Agregar en el modal de detalle un botón "Iniciar préstamo" (si estado = disponible) que abra el modal de reserva (reutilizar lógica de Home).

**Entregable:** Inventario dinámico con datos de Supabase.

---

### Fase 4: Home (préstamos y devoluciones) (Semana 3-4)

- [ ] Refactorizar `index.html`:
  - Eliminar cards estáticas de equipos en préstamo y disponibles.
  - Agregar contenedores dinámicos: `<div id="prestamosContainer" class="row g-4">` y `<div id="disponiblesContainer" class="row g-4">`.
  - Mantener modales (`#modalFicha`, `#reservaModal`) con su estructura actual.
- [ ] Crear `src/features/home/home.js`:
  - Cargar préstamos activos: `supabase.from('loan_items').select('*, loans(*), equipment(*), users(*))'` y filtrar donde `effective_return IS NULL`.
  - Renderizar cards de devolución (con botón "Devolver").
  - Cargar equipos disponibles: `equipment` con estado `disponible` (agrupados por categoría o individuales según diseño).
  - Implementar lógica de devolución:
    - Al hacer clic en "Devolver", abrir modal (reutilizar `#modalFicha`).
    - Al confirmar, actualizar `loan_items.effective_return = now()`, y si todos los ítems del préstamo están devueltos, cambiar `loan.status = 'finalizado'`.
    - Si hay incidencia, insertar en `incidents`.
  - Implementar lógica de reserva/retiro:
    - Desde card de categoría, abrir `#reservaModal`.
    - Al enviar, crear `loan` (type según selección) y `loan_items`.
    - Actualizar estado del equipo en `equipment` a `ocupado` o `reservado` (el trigger SQL lo hará automáticamente si está bien configurado).
- [ ] Reutilizar el componente de incidencia ya existente en el modal.

**Entregable:** Home completamente funcional con operaciones de escritura en Supabase.

---

### Fase 5: Usuarios y Reservas (Semana 4-5)

- [ ] Crear `usuarios.html`:
  - Listado de usuarios desde `supabase.from('users').select('*')`.
  - Filtros por rol y estado.
  - Modal de detalle con equipos asignados actualmente (consulta a `loan_items` + `loans`).
- [ ] Crear `reservas.html`:
  - Dos secciones: Préstamos activos y Reservas pendientes.
  - Consultar `loans` con `type` y `status` correspondiente, incluyendo `loan_items` y `equipment`.
  - Permitir cancelar reservas (actualizar `status = 'cancelado'`) y liberar equipos.
- [ ] Implementar `src/features/usuarios/usuarios.js` y `src/features/reservas/reservas.js`.
- [ ] Página `guia.html` (estática): crear con cards de artículos (puede ser contenido simulado).

**Entregable:** Módulos de usuarios y reservas operativos.

---

### Fase 6: Pruebas, ajustes y documentación (Semana 5-6)

- [ ] Probar todos los flujos en móvil y desktop.
- [ ] Verificar que las políticas RLS no bloqueen operaciones legítimas.
- [ ] Agregar spinners de carga en todas las peticiones asíncronas.
- [ ] Manejar errores de red y mostrar mensajes amigables.
- [ ] Documentar el código con JSDoc.
- [ ] Actualizar `README.md` con instrucciones de despliegue (variables de entorno, etc.).
- [ ] Hacer merge final a `main` y crear tag `v1.0.0`.

**Entregable:** MVP completo listo para evaluación.

---

## Recomendaciones adicionales

- **No mezclar lógica de `app.js` antigua** con los nuevos módulos. Eliminar o renombrar.
- **Usar `type="module"`** en los scripts para poder importar/exportar.
- **Centralizar el cliente Supabase** en `src/shared/supabaseClient.js` y reutilizarlo.
- **Mantener el diseño BEM** y las variables CSS ya definidas en `styles.css`.

```

---

### 4. Documento de refactorización detallada (`docs/REFACTORIZACION.md`)

Crearé un archivo aparte para dejar constancia de los cambios específicos en cada archivo HTML/JS, sirviendo como guía para el equipo.

```markdown
# Refactorización de SmartStock para integración con Supabase

**Fecha:** Abril 2026  
**Objetivo:** Transformar el prototipo estático en una aplicación full stack conectada a PostgreSQL (Supabase), manteniendo la identidad visual y la experiencia de usuario ya validada.

---

## Cambios generales

- Se eliminan `desktop.html`, `app.js` (antiguo), `dataset_ds.js`.
- Se crea la carpeta `src/` con subcarpetas `shared/`, `features/`, `assets/`.
- Todo el JavaScript se migra a módulos ES6 (import/export).
- Las credenciales de Supabase se cargan desde `config.js` (ignorado por Git).

---

## Archivos modificados

### `index.html`
- Se eliminan las cards estáticas de las secciones "Equipos en préstamo" y "Equipos disponibles".
- Se agregan contenedores vacíos con `id="prestamosContainer"` y `id="disponiblesContainer"`.
- Se mantienen los modales `#modalFicha` y `#reservaModal` (ya están bien estructurados).
- Se añade `<script type="module" src="src/features/home/home.js"></script>`.
- Se elimina el bloque `<script>` interno (modo oscuro, devoluciones, reservas) y se reemplaza por la importación de `theme.js` y `modals.js`.

### `inventario.html`
- Se reemplaza el grid de cards estáticas por un contenedor `#inventarioCardsContainer` y un `tbody#inventarioTableBody`.
- Se mantienen los filtros (buscador, categoría, estado) pero se les asignan `id` únicos.
- Se añade `<script type="module" src="src/features/inventario/inventario.js"></script>`.
- Se elimina el script embebido.

### `navbar.html` y `footer.html`
- Se extrae el código JS de modo oscuro y de manejo de modales a `src/shared/theme.js` y `src/shared/modals.js`.
- En cada página que incluya estos fragmentos, se deberá importar dichos módulos.
- Los botones de login/logout se gestionarán desde `auth/login.js`.

### `styles.css`
- Se mantiene intacto. Solo se agregarán clases nuevas si son necesarias (por ejemplo, `.spinner-border` para estados de carga).

### Archivos nuevos (resumen)

| Ruta | Contenido |
|------|-----------|
| `src/shared/supabaseClient.js` | Inicializa `supabase` con `SUPABASE_URL` y `SUPABASE_ANON_KEY` desde `window`. |
| `src/shared/theme.js` | Controla el modo oscuro (lectura/escritura en `localStorage`, cambio de icono). |
| `src/shared/modals.js` | Funciones para abrir/cerrar modales comunes (devolución, reserva) sin lógica de negocio. |
| `src/features/auth/login.js` | `signIn`, `signOut`, manejo de sesión. |
| `src/features/home/home.js` | Carga y renderizado de préstamos activos y equipos disponibles. Procesa devoluciones y reservas. |
| `src/features/inventario/inventario.js` | Carga y renderizado de todos los equipos (vista híbrida). Filtros y modal de detalle. |
| `src/features/usuarios/usuarios.js` | Carga y filtrado de usuarios desde `users`. Modal con equipos asignados. |
| `src/features/reservas/reservas.js` | Listado de préstamos activos y reservas pendientes. Cancelación de reservas. |

---

## Archivos obsoletos (eliminar)

- `desktop.html`
- `app.js`
- `dataset_ds.js`
- Cualquier otro archivo que contenga `equipos` estáticos y no sea el `dataset.js` de respaldo (mover a `src/legacy/`).

---

## Pasos para probar la refactorización

1. Clonar el repositorio.
2. Crear `config.js` en la raíz con las credenciales de Supabase.
3. Abrir `index.html` con un servidor local (Live Server, `npx serve`, etc.).
4. Verificar que el cliente Supabase se inicializa sin errores (abrir consola).
5. Probar login con un usuario existente en la tabla `users` (la contraseña debe ser la misma que en `auth.users` de Supabase – por ahora se puede usar el seed con contraseñas predefinidas o crear usuarios manualmente).
6. Navegar por las páginas y comprobar que los datos se cargan desde la base de datos.

---

## Notas sobre compatibilidad con el diseño actual

- Las clases CSS y la estructura BEM no se modifican.
- Los modales ya existentes (`#modalFicha`, `#reservaModal`) conservan su HTML y solo se les inyecta contenido dinámico.
- Los botones "Devolver" y "Retirar/Reservar" seguirán teniendo los mismos atributos `data-bs-toggle` y `data-bs-target`, pero los eventos se manejarán desde los módulos JS.

```

---

### 5. Conclusión y siguientes pasos

Con este plan y la documentación de refactorización, el equipo puede proceder ordenadamente:

1. **Eliminar archivos obsoletos** y crear la estructura de carpetas.
2. **Implementar el cliente Supabase** y probar la conexión.
3. **Centralizar la lógica común** (modo oscuro, modales).
4. **Desarrollar los módulos por orden de prioridad:** Inventario → Home → Usuarios → Reservas.
5. **Probar y pulir.**

¿Necesitas que redacte alguno de los módulos JS específicos (por ejemplo, `home.js` o `inventario.js`) para acelerar el desarrollo?