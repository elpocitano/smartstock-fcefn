-- =============================================================================
-- SmartStock - Datos de prueba (seed) - CORREGIDO
-- Versión: 1.1
-- =============================================================================

-- Limpiar datos existentes (opcional, descomentar si se necesita reiniciar)
-- TRUNCATE TABLE loan_items, incidents, loans, equipment, categories, users CASCADE;

-- =============================================================================
-- 1. CATEGORÍAS
-- =============================================================================
INSERT INTO categories (name, description) VALUES
('GPS', 'Equipos de geolocalización y navegación satelital'),
('Drones', 'Aeronaves no tripuladas para fotogrametría y relevamiento'),
('Microscopios', 'Microscopios petrográficos y de laboratorio'),
('Herramientas de campo', 'Martillos, piquetas, brújulas, lupas, etc.'),
('Informática', 'Notebooks, tablets, equipos RTX para procesamiento'),
('Audio/Video', 'Proyectores, cámaras, equipos de sonido'),
('Otros', 'Equipamiento diverso sin clasificación específica');

-- =============================================================================
-- 2. USUARIOS (UUID fijos para consistencia)
-- =============================================================================
INSERT INTO users (id, dni, full_name, email, role, status) VALUES
('11111111-1111-1111-1111-111111111111', '12345678', 'Marcelo Luna', 'marcelo.luna@unsj.edu.ar', 'admin', 'habilitado'),
('22222222-2222-2222-2222-222222222222', '23456789', 'Ana Torres', 'ana.torres@unsj.edu.ar', 'prestamista', 'habilitado'),
('33333333-3333-3333-3333-333333333333', '34567890', 'Laura Martínez', 'laura.martinez@unsj.edu.ar', 'consultor', 'habilitado'),
('44444444-4444-4444-4444-444444444444', '45678901', 'Carlos Gómez', 'carlos.gomez@unsj.edu.ar', 'consultor', 'habilitado'),
('55555555-5555-5555-5555-555555555555', '56789012', 'María González', 'maria.gonzalez@unsj.edu.ar', 'consultor', 'habilitado'),
('66666666-6666-6666-6666-666666666666', '67890123', 'Pedro Sánchez', 'pedro.sanchez@unsj.edu.ar', 'consultor', 'baneado');

-- =============================================================================
-- 3. EQUIPOS (20 activos)
-- =============================================================================
INSERT INTO equipment (internal_code, serial_number, model, category_id, status, kit_components) VALUES
('GEO-001', 'SN-GPS-001', 'GPSMAP 64S', (SELECT id FROM categories WHERE name = 'GPS'), 'disponible', '{"cable_usb": true, "funda": true, "bateria_recargable": true}'),
('GEO-002', 'SN-GPS-002', 'eTrex 32x', (SELECT id FROM categories WHERE name = 'GPS'), 'disponible', '{"cable_usb": true, "funda": false}'),
('GEO-003', 'SN-DRONE-001', 'DJI Phantom 4', (SELECT id FROM categories WHERE name = 'Drones'), 'disponible', '{"baterias_extra": 2, "cargador": true, "helices_repuesto": 4}'),
('GEO-004', 'SN-DRONE-002', 'DJI Mavic 3', (SELECT id FROM categories WHERE name = 'Drones'), 'reparacion', '{"baterias_extra": 1, "cargador": true}'),
('GEO-005', 'SN-MIC-001', 'Microscopio Petrográfico Leica', (SELECT id FROM categories WHERE name = 'Microscopios'), 'disponible', NULL),
('GEO-006', 'SN-MIC-002', 'Microscopio Binocular Olympus', (SELECT id FROM categories WHERE name = 'Microscopios'), 'disponible', NULL),
('GEO-007', 'SN-MIC-003', 'Lupa Estereoscópica', (SELECT id FROM categories WHERE name = 'Microscopios'), 'disponible', NULL),
('GEO-008', 'SN-HERR-001', 'Martillo geológico Estwing', (SELECT id FROM categories WHERE name = 'Herramientas de campo'), 'disponible', NULL),
('GEO-009', 'SN-HERR-002', 'Piqueta de punta', (SELECT id FROM categories WHERE name = 'Herramientas de campo'), 'disponible', NULL),
('GEO-010', 'SN-HERR-003', 'Brújula Brunton', (SELECT id FROM categories WHERE name = 'Herramientas de campo'), 'disponible', NULL),
('GEO-011', 'SN-HERR-004', 'Lupa de 10x', (SELECT id FROM categories WHERE name = 'Herramientas de campo'), 'disponible', NULL),
('GEO-012', 'SN-HERR-005', 'Cinta métrica 50m', (SELECT id FROM categories WHERE name = 'Herramientas de campo'), 'disponible', NULL),
('GEO-013', 'SN-PC-001', 'Notebook RTX 3060', (SELECT id FROM categories WHERE name = 'Informática'), 'disponible', NULL),
('GEO-014', 'SN-PC-002', 'Tablet Samsung Galaxy Tab', (SELECT id FROM categories WHERE name = 'Informática'), 'disponible', NULL),
('GEO-015', 'SN-PC-003', 'Workstation HP Z4', (SELECT id FROM categories WHERE name = 'Informática'), 'disponible', NULL),
('GEO-016', 'SN-AV-001', 'Proyector Epson EB-695Wi', (SELECT id FROM categories WHERE name = 'Audio/Video'), 'disponible', NULL),
('GEO-017', 'SN-AV-002', 'Cámara Sony Alpha 7III', (SELECT id FROM categories WHERE name = 'Audio/Video'), 'disponible', NULL),
('GEO-018', 'SN-OTR-001', 'Estación Total Leica', (SELECT id FROM categories WHERE name = 'Otros'), 'disponible', NULL),
('GEO-019', 'SN-OTR-002', 'Medidor de pH', (SELECT id FROM categories WHERE name = 'Otros'), 'disponible', NULL),
('GEO-020', 'SN-OTR-003', 'Balanza de precisión', (SELECT id FROM categories WHERE name = 'Otros'), 'disponible', NULL);

-- =============================================================================
-- 4. PRÉSTAMOS ACTIVOS
-- =============================================================================
DO $$
DECLARE
    loan_id INTEGER;
BEGIN
    INSERT INTO loans (user_id, type, status, start_date, due_date)
    VALUES ('33333333-3333-3333-3333-333333333333', 'prestamo', 'activo', NOW() - INTERVAL '5 days', NOW() + INTERVAL '2 days')
    RETURNING id INTO loan_id;
    INSERT INTO loan_items (loan_id, equipment_id, effective_return)
    VALUES (loan_id, (SELECT id FROM equipment WHERE internal_code = 'GEO-001'), NULL),
           (loan_id, (SELECT id FROM equipment WHERE internal_code = 'GEO-008'), NULL);
END $$;

DO $$
DECLARE
    loan_id INTEGER;
BEGIN
    INSERT INTO loans (user_id, type, status, start_date, due_date)
    VALUES ('44444444-4444-4444-4444-444444444444', 'prestamo', 'activo', NOW() - INTERVAL '3 days', NOW() + INTERVAL '5 days')
    RETURNING id INTO loan_id;
    INSERT INTO loan_items (loan_id, equipment_id, effective_return)
    VALUES (loan_id, (SELECT id FROM equipment WHERE internal_code = 'GEO-003'), NULL),
           (loan_id, (SELECT id FROM equipment WHERE internal_code = 'GEO-010'), NULL);
END $$;

-- =============================================================================
-- 5. RESERVA PENDIENTE
-- =============================================================================
DO $$
DECLARE
    loan_id INTEGER;
BEGIN
    INSERT INTO loans (user_id, type, status, start_date, due_date, hold_until)
    VALUES ('55555555-5555-5555-5555-555555555555', 'reserva', 'pendiente', NOW() + INTERVAL '3 days', NOW() + INTERVAL '10 days', NOW() + INTERVAL '2 days')
    RETURNING id INTO loan_id;
    INSERT INTO loan_items (loan_id, equipment_id, effective_return)
    VALUES (loan_id, (SELECT id FROM equipment WHERE internal_code = 'GEO-005'), NULL);
END $$;

-- =============================================================================
-- 6. INCIDENCIA DE EJEMPLO (corregido el error de columna ambigua)
-- =============================================================================
DO $$
DECLARE
    loan_item_id INTEGER;
BEGIN
    SELECT li.id INTO loan_item_id
    FROM loan_items li
    JOIN equipment e ON li.equipment_id = e.id
    WHERE e.internal_code = 'GEO-001'
    LIMIT 1;

    IF loan_item_id IS NOT NULL THEN
        INSERT INTO incidents (equipment_id, loan_item_id, description, severity)
        VALUES (
            (SELECT id FROM equipment WHERE internal_code = 'GEO-001'),
            loan_item_id,
            'La pantalla presenta una rajadura y el botón de encendido no responde bien.',
            'medium'
        );
    END IF;
END $$;

-- Mensaje de confirmación
DO $$
DECLARE
    total_equipos INTEGER;
    total_usuarios INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_equipos FROM equipment;
    SELECT COUNT(*) INTO total_usuarios FROM users WHERE status = 'habilitado';
    RAISE NOTICE 'Seed completado: % equipos, % usuarios activos.', total_equipos, total_usuarios;
END $$;