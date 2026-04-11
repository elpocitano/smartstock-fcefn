> # Ciclo de Vida de Desarrollo - SmartStock
> 
> Este documento define la metodología, las fases y los blindajes técnicos para la construcción de SmartStock. Seguimos una estrategia de **Vertical Slicing** e **Integración Continua**.
> 
> ## 1\. Metodología de Trabajo
> 
> -   **Vertical Slicing:** Desarrollamos por "rebanadas" funcionales (UI + Lógica + DB) para entregar valor incremental.
>     
> -   **Git Workflow:** Rama `main` (Producción), `develop` (Integración) y `feat/` o `fix/` para el trabajo diario.
>     
> -   **Blindaje de Seguridad:** Uso de `.gitignore` para proteger credenciales y secretos.
>     
> 
> ## 2\. Fases del Ciclo de Vida (SDLC)
> 
> ### Fase 1: Setup y Seguridad (Día 1)
> 
> -   **Infraestructura Git:** Inicializar repo, ramas y establecer protección de `main`.
>     
> -   **Manejo de Secretos:** Creación obligatoria de `.gitignore`. Asegurar que las **API Keys** de Supabase y archivos de configuración local jamás se suban al repositorio público.
>     
> -   **Scaffolding:** Creación de la estructura física de carpetas definida en el `README.md`.
>     
> 
> ### Fase 2: UX/UI y Layout Base
> 
> -   **Design Tokens:** Definir `src/shared/vars.css` con la paleta geológica (Pizarra, Bosque, Tierra).
>     
> -   **Layout Base:** Diseñar e implementar la **Navbar** y el **Footer** como componentes compartidos antes de iniciar los slices. Esto garantiza coherencia visual inmediata.
>     
> -   **Wireframes Mobile-First:** Bocetos enfocados en la "Ley de Fitts" (botones grandes y accesibles para uso con pulgar en campo).
>     
> 
> ### Fase 3: Infraestructura de Datos (PostgreSQL)
> 
> -   **Esquema Relacional:** Ejecución de `sql/schema.sql` (Tablas y Relaciones).
>     
> -   **Políticas RLS:** Configuración de **Row Level Security** en Supabase para blindar el acceso a los datos.
>     
> -   **Seed Data:** Carga de datos reales de prueba (ej: GPSMAP 64S, Martillos Estwing) para validación visual.
>     
> 
> ### Fase 4: Desarrollo por Slices (Iteraciones)
> 
> Cada funcionalidad se desarrolla en su propia rama `feat/`:
> 
> 1.  **Slice 1: Inventario:** Listado dinámico desde la DB.
>     
> 2.  **Slice 2: Auth:** Gestión de sesiones de usuario.
>     
> 3.  **Slice 3: Préstamos:** Lógica transaccional y cambio de estados.
>     
> 4.  **Slice 4: Incidencias:** Reporte de daños ligado al equipo.
>     
> 
> ### Fase 5: Integración y Pruebas (UAT)
> 
> -   **Manejo de Estados:** Implementar estados de carga (_spinners_) para mitigar la latencia de la red.
>     
> -   **Validación con Usuario Final (UAT):** Simulación de uso real con "perfil de docente" para validar ergonomía y legibilidad bajo luz solar (accesibilidad WCAG).
>     
> -   **Modo Oscuro:** Implementación final mediante clases de Bootstrap 5.3.
>     
> 
> ### Fase 6: Cierre y Tagging
> 
> -   **Auditoría de Código:** Limpieza de `console.log` y comentarios temporales.
>     
> -   **Release:** Merge final de `develop` a `main`.
>     
> -   **Tagging:** `git tag -a v1.0.0 -m "MVP Final para entrega universitaria"`.
>     
> 
> * * *
> 
> ## 3\. Matriz de Responsabilidades Tácticas
> 
## 3. Matriz de Responsabilidades Tácticas

| Fase | Foco Técnico | Blindaje |
| :--- | :--- | :--- |
| **Setup** | Git / Estructura de Carpetas | `.gitignore` (Protección de Secretos) |
| **Diseño** | Bootstrap / CSS Custom | Layout Base (Coherencia Visual) |
| **Datos** | PostgreSQL / Supabase | RLS (Políticas de Ciberseguridad) |
| **Pruebas** | UX / Feedback de Usuario | UAT (Validación en Entorno Real) |