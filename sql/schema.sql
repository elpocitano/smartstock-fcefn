-- =============================================================================
-- SmartStock - Esquema de Base de Datos
-- Versión: 1.0 (PostgreSQL + Supabase)
-- Descripción: Tablas, relaciones, índices, triggers y RLS
-- =============================================================================

-- Habilitar extensión para UUID (si no está)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- 1. TABLAS PRINCIPALES
-- =============================================================================

-- Tabla de usuarios (autenticación gestionada por Supabase Auth)
-- Se sincroniza con auth.users mediante trigger
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    dni VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'prestamista', 'consultor')),
    status VARCHAR(20) NOT NULL DEFAULT 'habilitado' CHECK (status IN ('habilitado', 'baneado')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de categorías de equipos
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- Tabla de equipos
CREATE TABLE equipment (
    id SERIAL PRIMARY KEY,
    internal_code VARCHAR(20) UNIQUE NOT NULL,
    serial_number VARCHAR(50) UNIQUE,
    model VARCHAR(100),
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'disponible' CHECK (status IN ('disponible', 'reservado', 'ocupado', 'reparacion')),
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    kit_components JSONB, -- Para kits de piezas (formato libre)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de préstamos/reservas (cabecera)
CREATE TABLE loans (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    type VARCHAR(20) NOT NULL CHECK (type IN ('reserva', 'prestamo')),
    status VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (status IN ('pendiente', 'activo', 'finalizado', 'cancelado')),
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    due_date TIMESTAMP WITH TIME ZONE NOT NULL,
    hold_until TIMESTAMP WITH TIME ZONE, -- Solo para reservas: fecha hasta la que se bloquea el equipo
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de ítems de préstamo (relación muchos a muchos)
CREATE TABLE loan_items (
    id SERIAL PRIMARY KEY,
    loan_id INTEGER NOT NULL REFERENCES loans(id) ON DELETE CASCADE,
    equipment_id INTEGER NOT NULL REFERENCES equipment(id) ON DELETE RESTRICT,
    effective_return TIMESTAMP WITH TIME ZONE, -- NULL = aún no devuelto
    return_condition VARCHAR(20) CHECK (return_condition IN ('good', 'damaged', 'missing')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(loan_id, equipment_id)
);

-- Tabla de incidencias (daños, observaciones)
CREATE TABLE incidents (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER NOT NULL REFERENCES equipment(id) ON DELETE CASCADE,
    loan_item_id INTEGER REFERENCES loan_items(id) ON DELETE SET NULL,
    description TEXT NOT NULL,
    severity VARCHAR(10) NOT NULL CHECK (severity IN ('low', 'medium', 'high')),
    registered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de auditoría (para cumplir ISO 55000)
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(10) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_data JSONB,
    new_data JSONB,
    changed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================================================
-- 2. ÍNDICES (optimización de consultas frecuentes)
-- =============================================================================

-- Equipment
CREATE INDEX idx_equipment_status ON equipment(status);
CREATE INDEX idx_equipment_category ON equipment(category_id);
CREATE INDEX idx_equipment_assigned_to ON equipment(assigned_to);

-- Loans
CREATE INDEX idx_loans_user_id ON loans(user_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_loans_due_date ON loans(due_date) WHERE status = 'activo';
CREATE INDEX idx_loans_type_status ON loans(type, status);
CREATE INDEX idx_loans_hold_until ON loans(hold_until) WHERE hold_until IS NOT NULL;

-- Loan items
CREATE INDEX idx_loan_items_loan ON loan_items(loan_id);
CREATE INDEX idx_loan_items_equipment ON loan_items(equipment_id);
CREATE INDEX idx_loan_items_return ON loan_items(effective_return) WHERE effective_return IS NULL;

-- Incidents
CREATE INDEX idx_incidents_equipment ON incidents(equipment_id);
CREATE INDEX idx_incidents_registered_at ON incidents(registered_at);

-- Audit log
CREATE INDEX idx_audit_table_record ON audit_log(table_name, record_id);
CREATE INDEX idx_audit_changed_at ON audit_log(changed_at);

-- =============================================================================
-- 3. FUNCIONES Y TRIGGERS
-- =============================================================================

-- Función para actualizar el campo updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a todas las tablas que tienen updated_at
CREATE TRIGGER trigger_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trigger_equipment_updated_at BEFORE UPDATE ON equipment FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trigger_loans_updated_at BEFORE UPDATE ON loans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER trigger_loan_items_updated_at BEFORE UPDATE ON loan_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función de auditoría (registra cambios en equipment y loans)
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
DECLARE
    old_json JSONB;
    new_json JSONB;
    action TEXT;
BEGIN
    IF (TG_OP = 'INSERT') THEN
        old_json := NULL;
        new_json := to_jsonb(NEW);
        action := 'INSERT';
    ELSIF (TG_OP = 'UPDATE') THEN
        old_json := to_jsonb(OLD);
        new_json := to_jsonb(NEW);
        action := 'UPDATE';
    ELSIF (TG_OP = 'DELETE') THEN
        old_json := to_jsonb(OLD);
        new_json := NULL;
        action := 'DELETE';
    ELSE
        RETURN NULL;
    END IF;

    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)
    VALUES (TG_TABLE_NAME, COALESCE(NEW.id, OLD.id), action, old_json, new_json, current_setting('app.current_user_id', true)::UUID, NOW());
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Crear triggers de auditoría para las tablas críticas
CREATE TRIGGER audit_equipment AFTER INSERT OR UPDATE OR DELETE ON equipment FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
CREATE TRIGGER audit_loans AFTER INSERT OR UPDATE OR DELETE ON loans FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
CREATE TRIGGER audit_loan_items AFTER INSERT OR UPDATE OR DELETE ON loan_items FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- Función para actualizar el estado del equipo según préstamos activos (desnormalización)
-- Se ejecuta al insertar/actualizar/eliminar loan_items o loans
CREATE OR REPLACE FUNCTION update_equipment_status_from_loans()
RETURNS TRIGGER AS $$
DECLARE
    active_loan_exists BOOLEAN;
    reserved_loan_exists BOOLEAN;
BEGIN
    -- Verificar si el equipo está en algún préstamo activo (status 'activo' y effective_return NULL)
    SELECT EXISTS (
        SELECT 1 FROM loan_items li
        JOIN loans l ON li.loan_id = l.id
        WHERE li.equipment_id = COALESCE(NEW.equipment_id, OLD.equipment_id)
          AND l.status = 'activo'
          AND li.effective_return IS NULL
    ) INTO active_loan_exists;

    -- Verificar si el equipo está en alguna reserva pendiente (status 'pendiente' y type='reserva')
    SELECT EXISTS (
        SELECT 1 FROM loan_items li
        JOIN loans l ON li.loan_id = l.id
        WHERE li.equipment_id = COALESCE(NEW.equipment_id, OLD.equipment_id)
          AND l.type = 'reserva'
          AND l.status = 'pendiente'
    ) INTO reserved_loan_exists;

    -- Actualizar el estado del equipo
    IF active_loan_exists THEN
        UPDATE equipment SET status = 'ocupado' WHERE id = COALESCE(NEW.equipment_id, OLD.equipment_id);
    ELSIF reserved_loan_exists THEN
        UPDATE equipment SET status = 'reservado' WHERE id = COALESCE(NEW.equipment_id, OLD.equipment_id);
    ELSE
        -- Si no hay préstamo activo ni reserva, poner disponible (a menos que esté en reparación)
        UPDATE equipment SET status = 'disponible' 
        WHERE id = COALESCE(NEW.equipment_id, OLD.equipment_id) AND status != 'reparacion';
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Triggers para mantener la coherencia de estado
CREATE TRIGGER sync_equipment_status AFTER INSERT OR UPDATE OR DELETE ON loan_items FOR EACH ROW EXECUTE FUNCTION update_equipment_status_from_loans();
CREATE TRIGGER sync_equipment_status_loan AFTER UPDATE OF status ON loans FOR EACH ROW EXECUTE FUNCTION update_equipment_status_from_loans();

-- =============================================================================
-- 4. POLÍTICAS DE SEGURIDAD (RLS)
-- =============================================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE loans ENABLE ROW LEVEL SECURITY;
ALTER TABLE loan_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Políticas básicas (se pueden refinar según necesidad)
-- Nota: Supabase añade automáticamente políticas para auth.users, pero aquí definimos para las tablas personalizadas.

-- USERS: cada usuario puede leer su propio perfil; los prestamistas y admin pueden leer todos
CREATE POLICY users_select_own ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY users_select_all ON users FOR SELECT USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);
-- Solo admin puede insertar/actualizar/borrar usuarios (por ahora no se implementa en MVP)

-- EQUIPMENT: todos los autenticados pueden leer; solo prestamista/admin pueden modificar
CREATE POLICY equipment_select ON equipment FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY equipment_insert_update_delete ON equipment FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);

-- CATEGORIES: solo lectura para todos
CREATE POLICY categories_select ON categories FOR SELECT USING (auth.role() = 'authenticated');

-- LOANS: los usuarios pueden ver sus propios préstamos; prestamista/admin ven todos
CREATE POLICY loans_select_own ON loans FOR SELECT USING (user_id = auth.uid());
CREATE POLICY loans_select_all ON loans FOR SELECT USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);
-- Solo prestamista/admin pueden insertar/actualizar/borrar
CREATE POLICY loans_modify ON loans FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);

-- LOAN_ITEMS: mismas reglas que loans (por asociación)
CREATE POLICY loan_items_select_own ON loan_items FOR SELECT USING (
    EXISTS (SELECT 1 FROM loans WHERE loans.id = loan_items.loan_id AND loans.user_id = auth.uid())
);
CREATE POLICY loan_items_select_all ON loan_items FOR SELECT USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);
CREATE POLICY loan_items_modify ON loan_items FOR ALL USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);

-- INCIDENTS: cualquier usuario autenticado puede leer y crear incidencias (para reportar daños)
CREATE POLICY incidents_select ON incidents FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY incidents_insert ON incidents FOR INSERT WITH CHECK (auth.role() = 'authenticated');
-- Solo prestamista/admin pueden modificar
CREATE POLICY incidents_modify ON incidents FOR UPDATE USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);

-- AUDIT_LOG: solo lectura para admin y prestamista
CREATE POLICY audit_log_select ON audit_log FOR SELECT USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role IN ('admin', 'prestamista'))
);

-- =============================================================================
-- 5. COMENTARIOS DE DOCUMENTACIÓN
-- =============================================================================

COMMENT ON TABLE users IS 'Usuarios del sistema sincronizados con auth.users';
COMMENT ON TABLE equipment IS 'Activos físicos del inventario';
COMMENT ON TABLE categories IS 'Categorías de equipos (ej: GPS, Drones, Microscopios)';
COMMENT ON TABLE loans IS 'Cabecera de préstamos y reservas';
COMMENT ON TABLE loan_items IS 'Equipos individuales dentro de un préstamo/reserva';
COMMENT ON TABLE incidents IS 'Reportes de daños o novedades';
COMMENT ON TABLE audit_log IS 'Auditoría de cambios críticos (ISO 55000)';