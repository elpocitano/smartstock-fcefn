# Guía de Git y Flujo de Trabajo - SmartStock

Para asegurar la integridad del código y facilitar la colaboración, utilizaremos una versión simplificada de **GitFlow** y el estándar de **Conventional Commits**.

---

## 1. Estrategia de Ramas (Branching)

Dividiremos el desarrollo en ramas según su estabilidad y propósito:

| Rama | Propósito | Regla de Oro |
| :--- | :--- | :--- |
| `main` | **Producción / Entrega Final**. Contiene la versión que el profesor evaluará. | Solo código 100% funcional y testeado. |
| `develop` | **Integración**. Es el tronco común de desarrollo diario. | Aquí se fusionan las funcionalidades terminadas. |
| `feat/` | **Funcionalidades**. Ejemplo: `feat/filtro-busqueda`. | Se crean desde `develop` y vuelven a `develop`. |
| `fix/` | **Correcciones**. Ejemplo: `fix/error-modal`. | Para arreglar errores críticos encontrados en `develop` o `main`. |
| `docs/` | **Documentación**. Ejemplo: `docs/modelo-datos`. | Exclusiva para cambios en archivos Markdown o guías. |

---

## 2. Formato de Commits (Conventional Commits)

Utilizaremos una estructura estandarizada para que el historial sea legible y profesional.

**Patrón:** `tipo(scope): descripción en minúsculas`

### A. Tipos (`type`)
- **`feat`**: Una nueva funcionalidad (ej. el sistema de login).
- **`fix`**: Corrección de un fallo (bug).
- **`docs`**: Cambios solo en la documentación (archivos `.md`).
- **`style`**: Cambios de apariencia (CSS, Bootstrap) que no afectan la lógica.
- **`refactor`**: Cambios en el código para mejorarlo, pero que no añaden funciones ni arreglan fallos.
- **`chore`**: Tareas de mantenimiento, configuración de herramientas o carpetas.

### B. Ámbitos sugeridos (`scope`)
- **`ui`**: Elementos de interfaz (Navbar, Footer, Modales).
- **`auth`**: Lógica de autenticación y Supabase.
- **`inv`**: Todo lo relacionado al módulo de inventario.
- **`data`**: Modelos de datos, SQL o archivos de configuración de base de datos.
- **`docs`**: Documentación interna en la carpeta `/docs`.

---

## 3. Flujo de Trabajo Paso a Paso

Ejemplo: Supongamos que vas a redactar la documentación del **Modelo de Datos**.

1.  **Crear la rama de trabajo** (desde `develop`):
    ```bash
    git checkout develop
    git checkout -b docs/modelo-datos
    ```
2.  **Realizar los cambios**: Creas el archivo `docs/modelo_datos.md` y escribes el contenido.
3.  **Confirmar los cambios (Commit)**:
    ```bash
    git add .
    git commit -m "docs(data): definir entidades y relaciones para postgresql"
    ```
4.  **Fusionar en integración**:
    ```bash
    git checkout develop
    git merge docs/modelo-datos
    ```
5.  **Eliminar la rama temporal** (opcional para limpieza):
    ```bash
    git branch -d docs/modelo-datos
    ```

---

## 4. Versionado y Hitos (Tags)

Utilizaremos **Tags** para marcar los momentos clave y entregas:

- `v0.1.0-alpha`: **Diseño Inicial**. Documentación, sketches y wireframes completados.
- `v0.5.0-beta`: **Prototipo Funcional**. Login básico y listado de equipos operativo.
- `v1.0.0`: **MVP Final**. Versión definitiva para la defensa del examen de Diseño Web 1.

---

## 5. Recomendaciones Pro

- **Haz commits pequeños y frecuentes**: Es mejor tener 10 commits que expliquen el progreso que uno solo gigante que diga "Proyecto terminado".
- **Escribe los mensajes en presente**: Usa "añadir función" en lugar de "se añadió función".
- **Sincroniza antes de empezar**: Si trabajas en varios dispositivos, siempre haz un `git pull` antes de empezar tu jornada para evitar conflictos.

---