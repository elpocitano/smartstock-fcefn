Guía de Git Actualizada (Versión SmartStock)
🌿 Ramas (Branching)

    main: Solo código que funciona perfectamente. Es lo que verá el profesor.

    develop: Tu zona de trabajo diario. Aquí integras todo.

    feat/nombre-función: Para crear algo nuevo (ej: feat/login-supabase).

    fix/nombre-error: Para arreglar algo roto (ej: fix/error-estilo-boton).

📝 Formato de Commits

Patrón: tipo(scope): descripción

Tipos:

    feat: Nueva función (ej: el filtro de búsqueda).

    fix: Arreglaste un bug.

    docs: Solo tocaste archivos .md o comentarios.

    style: Tocaste CSS o clases de Bootstrap (sin cambiar lógica).

    refactor: Cambiaste la estructura de carpetas o limpiaste código.

Scopes sugeridos (Adaptados a tu proyecto):

    ui: Para cosas generales de la interfaz.

    auth: Todo lo relacionado a Supabase Login.

    inv: Relacionado al inventario (features/inventory).

    data: Cambios en SQL o modelos de datos.

    docs: Cambios en la carpeta /docs.

3. Ejemplo de flujo de trabajo (Paso a paso)

Imagina que vas a crear el archivo del Modelo de Datos:

    Creas la rama:
    git checkout -b feat/modelo-datos

    Creas el archivo docs/MODELO_DATOS.md y escribes el contenido.

    Haces el commit:
    git add .
    git commit -m "docs(data): definir entidades y relaciones para postgresql"

    Vuelves a develop y fusionas:
    git checkout develop
    git merge feat/modelo-datos

4. ¿Cómo organizar el versionado (Tags)?

Como es para aprobar materias, te sugiero usar Tags de Git para marcar los hitos de entrega:

    v0.1.0-alpha: Cuando tengas los documentos de diseño listos.

    v0.5.0-beta: Cuando el login y la lista de equipos funcionen.

    v1.0.0: Tu MVP final para entregar en la universidad.