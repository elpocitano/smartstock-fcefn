### Análisis: La diferencia clave (Landing Page vs. Dashboard)

*   **Landing Page (Página de Aterrizaje):** Su objetivo es la **conversión** (registro, compra, demo). Está orientada al marketing, explica el producto y su valor. Suele ser pública y estática . Un ejemplo clásico es la página principal de Amazon antes de iniciar sesión.
*   **Dashboard (Tablero):** Su objetivo es la **productividad**. Está orientado a usuarios autenticados. Muestra herramientas, datos relevantes y acciones para realizar tareas .


### El Conflicto de Nomenclatura

Por convención web, `index.html` es el punto de entrada principal . Si un usuario navega a `www.tusitio.com`, el servidor le mostrará `index.html`. Para un usuario que ya inició sesión, es perfecto que vea el dashboard.

Pero un nuevo visitante ve el dashboard sin contexto, puede no entender el propósito del sistema . 
Se perdería la oportunidad de "presentar" la herramienta y guiar al registro (conversión).

### La Mejor Práctica para SmartStock

La solución es un híbrido como la que usan la mayoría de las aplicaciones SaaS (Gmail, Trello, GitHub) .

**Propuesta:**

Un `index.html` **dinámico**.

1.  **Si el usuario NO ha iniciado sesión (visitante):**
    *   El `index.html` se comporta como una **Landing Page**: muestra el hero, los beneficios, un llamado a la acción (CTA) para registrarse, etc.
    *   Su función es explicar qué es SmartStock y convertir visitantes en usuarios.

2.  **Si el usuario SÍ ha iniciado sesión (prestamista, administrador o cualquier otro rol):**
    *   El `index.html` **se transforma en el Dashboard** que muestra las secciones de devoluciones pendientes y equipos disponibles.
    *   Su función es ser el centro de operaciones diario.

### Beneficios de este Enfoque

| Aspecto | Solución Propuesta |
| :--- | :--- |
| **Experiencia de Usuario (UX)** | Ofrece el contenido correcto a la persona correcta en el momento correcto . |
| **Marketing/Adopción** | Permite promocionar SmartStock y atraer nuevos usuarios (profesores, ayudantes). |
| **SEO (Posicionamiento)** | Una landing page con buen contenido es indexable por buscadores y explica el proyecto, lo cual es útil para su contexto académico y profesional. |
| **Simplicidad Técnica** | Usas un único archivo `index.html` (como dicta la convención) cuya lógica de renderizado cambia según el estado de autenticación del usuario. |

### Conclusión

Para SmartStock, la estructura final de páginas sería:

*   **`index.html` (Página Principal Dinámica):**
    *   **Estado: No Autenticado:** Muestra la Landing Page (Hero, CTA, features).
    *   **Estado: Autenticado:** Muestra el Dashboard (Gestión de Préstamos/Devoluciones).
*   **`inventario.html` (Catálogo de Equipos):**
*   **`usuarios.html` (Directorio):**
*   **`guia.html` (Blog/Guía):**

**Decisión:** Procederemos con la implementación del **Dashboard** (para usuarios autenticados) dentro de `index.html` como prioridad, dejando la estructura y el contenido de la **Landing Page** (para usuarios no autenticados) para una fase o sprint  posterior.