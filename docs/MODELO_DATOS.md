# Modelo de Datos - SmartStock

Este documento detalla la estructura de la base de datos relacional (PostgreSQL) para el control de activos del laboratorio de Geología (FCEFN-UNSJ).

## 1. Diagrama Entidad-Relación (MER)
Utilizamos la sintaxis Mermaid para representar las relaciones.

```mermaid
erDiagram
    %% --- Entidades Principales (Fuertes) ---
    USER ||--o{ LOAN : "solicita / genera"
    EQUIPMENT }o--|| CATEGORY : "pertenece a"

    %% --- Entidades Asociativas y Transaccionales ---
    EQUIPMENT ||--o{ LOAN_ITEMS : "es incluido en"
    LOAN ||--o{ LOAN_ITEMS : "se compone de"
    EQUIPMENT ||--o{ INCIDENT : "registra"
    LOAN ||--o{ INCIDENT : "puede reportar"

    %% --- Definición de Campos (Atributos) ---
    USER {
        uuid id PK
        string dni UK "Documento Único"
        string full_name "Nombre Completo"
        string role "profesor/alumno/tecnico"
        string status "habilitado/baneado"
        timestamp created_at
    }

    EQUIPMENT {
        int id PK
        string internal_code UK "Código Inventario UNSJ (ej: GEO-001)"
        string serial_number UK "Número de Serie Fabricante"
        string model
        int category_id FK
        string status "disponible/reservado/ocupado/reparacion"
        jsonb kit_components "Detalle de piezas internas (opcional)"
    }

    LOAN {
        int id PK
        uuid user_id FK "Responsable del ticket"
        string type "reserva/prestamo"
        string status "pendiente/activo/finalizado/cancelado/mora"
        timestamp start_date "Fecha pactada retiro"
        timestamp due_date "Fecha límite devolución"
        timestamp created_at
    }

    %% --- Tabla Asociativa (Muchos a Muchos) ---
    LOAN_ITEMS {
        int id PK
        int loan_id FK
        int equipment_id FK
        timestamp effective_return "Fecha real de devolución de este ítem"
    }

    CATEGORY {
        int id PK
        string name UK "ej: Geolocalización"
    }

    INCIDENT {
        int id PK
        int equipment_id FK "Obligatorio"
        int loan_id FK "Opcional (NULL si es en depósito)"
        string description
        string severity "leve/critica"
        timestamp registered_at
    }
```

## 2. Diccionario de Datos
Tabla	Campo	Tipo	Descripción
EQUIPMENTS	internal_code	VARCHAR	Código físico pegado al equipo (ej: GEO-001).
EQUIPMENTS	status	ENUM	Controla si el equipo puede ser prestado o no.
LOANS	due_date	TIMESTAMP	Fecha límite de devolución (Materia: Backend/Lógica).
INCIDENTS	severity	VARCHAR	Gravedad del daño reportado en la devolución.

## 3. Consideraciones de Ciberseguridad en Datos

Integridad Referencial: No se pueden borrar categorías que tengan equipos asociados (RESTRICT).

Privacidad: Los IDs de los usuarios son UUID (no incrementales) para evitar que alguien adivine cuántos usuarios hay.