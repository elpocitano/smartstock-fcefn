# SmartStock – Cumplimiento de Requisitos de Diseño Web 1

**Versión:** 1.0  
**Fecha:** Abril 2026  
**Asignatura:** Diseño Web 1 – FCEFN (UNSJ)  
**Proyecto:** SmartStock – Gestión de activos para Geología

---

## 🎯 Propósito de este documento

Este archivo sirve como **lista de verificación** y **evidencia documentada** de que el proyecto SmartStock cumple con todos los contenidos exigidos en la materia **Diseño Web 1**. Se incluyen referencias directas a los archivos del código fuente y a las buenas prácticas implementadas.

---

## ✅ Tabla de cumplimiento (checklist)

| Tema / Contenido | Requisito específico | Implementación en SmartStock | Dónde se evidencia |
|------------------|----------------------|------------------------------|--------------------|
| **1. UX/UI – Evolución de la Web** | Comprender Web 2.0 y diseño responsivo | Uso de HTML5, CSS3, JS moderno (ES6), diseño mobile‑first, media queries. | `styles.css` (media queries), `index.html` (viewport) |
| **1. UX/UI – HCI (Interacción Persona‑Ordenador)** | Aplicar Ley de Fitts, reducir fricción | Botones grandes (padding 12px), footer fijo con área táctil, flujo de devolución en 2 taps, feedback visual inmediato. | `styles.css` (`.btn-action`, `.c-footer-mobile`), `index.html` (modal devolución) |
| **1. UX/UI – Arquitectura de información** | Mapas de navegación, jerarquía | Menú hamburguesa + footer navegación. Estructura clara: Home → Inventario → Usuarios → Guía. | `index.html` (navbar), `sketchs_4_versiones.md` |
| **1. UX/UI – Fases del desarrollo web** | Sketch, wireframe, mockup, prototipo | Documentación completa de cada fase en la carpeta `docs/`. | `sketchs_4_versiones.md`, `SmartStock_Propuesta_de_diseño.md` |
| **2. HTML – Elementos estructurales** | `<html>`, `<head>`, `<body>` correctos | Presente en todas las páginas. | `index.html`, `inventario.html`, etc. |
| **2. HTML – Configuración del documento** | Metadatos, título, enlaces a CSS/JS | Uso de `<meta charset>`, `<meta viewport>`, `<title>`, `<link>` a Bootstrap y CSS propio, `<script>` al final del body. | `index.html` (head) |
| **2. HTML – Maquetación semántica (HTML5)** | `<main>`, `<nav>`, `<section>`, `<article>`, `<footer>`, etc. | Navbar (`<nav>`), contenido principal (`<main>`), secciones (`<section>`), artículos en Guía (`<article>`), footer semántico. | `index.html`, `guia.html` |
| **2. HTML – Organización de datos** | Tablas con `<table>`, `<td>`, `<td>`, `<th>` | En vista de inventario para desktop se utiliza tabla responsiva. | `inventario.html` (tabla oculta en móvil) |
| **2. HTML – Formularios e interacción** | `<form>`, `<input>`, `<select>`, `<button>`, `<label>`, `<fieldset>` | Modales con formularios de devolución (checkbox, textarea, select) y reserva (fechas, selects). | `index.html` (`#modalFicha`, `#reservaModal`) |
| **3. CSS – Fundamentos** | Separación de contenido y presentación | Todo el CSS está en archivos externos (`styles.css`, `navbar.css`, etc.). | `css/` |
| **3. CSS – Sintaxis, selectores, clases, IDs** | Uso de selectores de clase, ID y pseudoclases | Metodología BEM (`.c-card`, `.c-card__title`). Pseudoclases `:hover`, `:active`. | `styles.css` |
| **3. CSS – Modelo de cajas** | `padding`, `margin`, `border`, `box-sizing` | Controlado en `.c-card`, `.c-card__content`, `.c-card__footer`. | `styles.css` |
| **3. CSS – Tipografía y texto** | `font-family`, `font-size`, `text-align`, etc. | Google Fonts (Montserrat + Open Sans). Variables de tamaño y peso. | `styles.css` (sección tipografía) |
| **3. CSS – Gestión de colores y fondos** | Paleta hexadecimal, `background-image`, etc. | Paleta geológica en `:root` (`--geo-pizarra`, `--geo-bosque`, etc.). Modo oscuro con `data-bs-theme`. | `styles.css` (variables) |
| **3. CSS – Posicionamiento y maquetación** | `display: flex`, `position`, `float`, `z-index` | Uso de Flexbox en navbar y cards. Footer móvil con `position: fixed`. `sticky-top` en navbar. | `styles.css` (`.c-footer-mobile`, `.c-navbar`) |
| **3. CSS – Diseño responsivo** | `@media` queries, diseño mobile‑first | Breakpoints para móvil (por defecto), tablet y desktop. Vistas híbridas (cards/tabla). | `styles.css` (`@media`), `inventario.html` (`d-md-none`, `d-none d-md-block`) |
| **4. JavaScript – Capa de comportamiento** | JS para lógica e interactividad | Renderizado dinámico, filtros, búsqueda, modales, cambio de tema. | `inventario.js`, `index.html` (script interno) |
| **4. JavaScript – Funcionalidades** | Animaciones, efectos visuales, manejo de eventos | Animaciones `fadeIn`, `slideDown`, feedback de éxito, cambio de texto en botones dinámicamente. | `styles.css` (keyframes), `index.html` (event listeners) |
| **4. JavaScript – Integración en formularios** | Validaciones, resultados dinámicos, `<output>` | Validación de campos requeridos, cambio de texto según tipo de operación (retiro/reserva). | `index.html` (`.addEventListener('submit')`) |
| **5. Herramientas y Frameworks – Bootstrap** | Uso del grid de 12 columnas y componentes | Grid (`row`, `col-*`), navbar, modales, badges, tabs, switch de modo oscuro. | `index.html`, `inventario.html` |
| **5. Herramientas y Frameworks – Software de diseño** | Figma, Adobe XD, Canva (al menos uno) | Wireframes documentados en Markdown (simulan baja fidelidad) y referencias a diseño en Figma. | `docs/sketchs_4_versiones.md` |
| **5. Herramientas y Frameworks – Guía de estilos** | Paleta de colores, tipografía, iconografía, branding | Documento `02_identidad_visual.md` con paleta geológica, tipografías y justificación WCAG. | `docs/02_identidad_visual.md` |

---

## 🌟 Implementaciones adicionales (valor agregado)

El proyecto supera los requisitos mínimos al incluir:

| Tecnología / Práctica | Descripción |
|-----------------------|-------------|
| **Metodología BEM** | Nomenclatura estricta en todas las clases CSS personalizadas. |
| **Modo oscuro / claro** | Persistente con `localStorage` y detección `prefers-color-scheme`. |
| **Accesibilidad WCAG 2.1** | Contraste 4.5:1, etiquetas `aria-label`, `visually-hidden`, área táctil mínima de 44px. |
| **Backend real (Supabase)** | Integración con PostgreSQL, políticas RLS y autenticación JWT (opcional para la materia, pero demuestra dominio). |
| **Control de versiones profesional** | Uso de Git con Conventional Commits y GitFlow (ramas `main`, `develop`, `feat/`). |
| **Documentación técnica** | DER, modelo de datos, plan de trabajo, guía de estilos, todo en Markdown. |

---

## 📁 Ubicación de los archivos relevantes

| Archivo / Carpeta | Descripción |
|-------------------|-------------|
| `index.html` | Home con sección de devoluciones y reservas. |
| `inventario.html` | Vista híbrida (cards en móvil, tabla en desktop). |
| `usuarios.html` | Listado de usuarios desde base de datos. |
| `guia.html` | Blog con artículos estáticos. |
| `css/styles.css` | Variables, BEM, modo oscuro, animaciones. |
| `js/inventario.js` | Lógica de renderizado, filtros y conexión a Supabase. |
| `docs/02_identidad_visual.md` | Paleta de colores, tipografía, accesibilidad. |
| `docs/sketchs_4_versiones.md` | Wireframes textuales de las 4 pantallas. |
| `sql/schema.sql` | Esquema de base de datos (PostgreSQL). |
| `sql/seed.sql` | Datos de prueba (20 equipos, 5 usuarios, préstamos activos). |

---

## 🧪 Cómo verificar el cumplimiento

1. **Abrir la aplicación** en un navegador móvil (o usar herramientas de desarrollador en modo dispositivo).
2. **Probar el flujo de devolución**: tocar una card de la sección superior, marcar incidencia opcional, confirmar.
3. **Probar el flujo de reserva**: tocar una card de equipos disponibles, elegir retiro o reserva, completar fechas.
4. **Cambiar el tema** (modo oscuro/claro) y verificar persistencia.
5. **Revisar el inventario** en móvil (cards) y en desktop (tabla).
6. **Inspeccionar el código** para verificar HTML semántico, clases BEM y variables CSS.

---

## ✍️ Nota para la defensa

Este documento puede ser incluido en la entrega final como **evidencia de que se han cubierto todos los puntos del temario**. Se recomienda mostrarlo al profesor junto con una demostración en vivo de las funcionalidades.

---

**SmartStock – Gestión inteligente de activos**  
*Facultad de Ciencias Exactas, Físicas y Naturales – UNSJ*  
*Proyecto Integrador: Diseño Web 1, Base de Datos, Backend y Ciberseguridad*