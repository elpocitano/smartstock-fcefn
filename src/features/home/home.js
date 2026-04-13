// src/features/home/home.js
import { supabase } from '../../shared/supabaseClient.js';

// Cargar préstamos activos (equipos no devueltos)
export async function cargarPrestamosActivos() {
    const { data, error } = await supabase
        .from('loan_items')
        .select(`
            id,
            effective_return,
            equipment:equipment_id (
                id,
                internal_code,
                model,
                status,
                kit_components
            ),
            loan:loan_id (
                id,
                user_id,
                due_date,
                status
            )
        `)
        .is('effective_return', null)
        .eq('loan.status', 'activo');

    if (error) {
        console.error('Error cargando préstamos:', error);
        return [];
    }
    
    console.log('📋 Préstamos activos:', data);
    return data;
}

// Cargar equipos disponibles
export async function cargarEquiposDisponibles() {
    const { data, error } = await supabase
        .from('equipment')
        .select('*')
        .eq('status', 'disponible')
        .limit(6);

    if (error) {
        console.error('Error cargando equipos disponibles:', error);
        return [];
    }
    
    console.log('✅ Equipos disponibles:', data);
    return data;
}

// Renderizar cards de préstamos activos
export function renderizarPrestamos(containerId, prestamos) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    if (!prestamos || prestamos.length === 0) {
        container.innerHTML = '<div class="col-12"><p class="text-muted">No hay equipos en préstamo</p></div>';
        return;
    }
    
    container.innerHTML = '';
    
    prestamos.forEach(item => {
        const equipo = item.equipment;
        const fechaVence = new Date(item.loan.due_date).toLocaleDateString('es-AR');
        const esVenceHoy = new Date(item.loan.due_date).toDateString() === new Date().toDateString();
        
        const col = document.createElement('div');
        col.className = 'col-12 col-md-6 col-lg-4';
        col.innerHTML = `
            <div class="c-card">
                <div class="c-card__img-container">
                    <img src="./assets/img/placeholder.jpg" alt="${equipo.model || equipo.internal_code}" class="c-card__img" onerror="this.src='./assets/img/placeholder.jpg'">
                    <span class="c-tag ${esVenceHoy ? 'c-tag--urgent' : 'c-tag--warning'}">${esVenceHoy ? '⚠️ Vence hoy' : '📅 En préstamo'}</span>
                </div>
                <div class="c-card__content">
                    <h3 class="c-card__title">${equipo.model || equipo.internal_code}</h3>
                    <div class="c-card__info">
                        <p><strong>Código:</strong> ${equipo.internal_code}</p>
                        <p><strong>Vence:</strong> ${fechaVence}</p>
                        <p><strong>Usuario ID:</strong> ${item.loan.user_id.substring(0, 8)}...</p>
                    </div>
                </div>
                <div class="c-card__footer">
                    <button class="btn btn-action w-100"
                        data-bs-toggle="modal" 
                        data-bs-target="#modalFicha"
                        data-id="${equipo.id}"
                        data-nombre="${equipo.model || equipo.internal_code}"
                        data-usuario="ID: ${item.loan.user_id.substring(0, 8)}..."
                        data-vence="${fechaVence}"
                        data-id-equipo="${equipo.internal_code}"
                        data-img="./assets/img/placeholder.jpg">
                        Devolver Equipo
                    </button>
                </div>
            </div>
        `;
        container.appendChild(col);
    });
}

// Renderizar cards de equipos disponibles
export function renderizarDisponibles(containerId, equipos) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    if (!equipos || equipos.length === 0) {
        container.innerHTML = '<div class="col-12"><p class="text-muted">No hay equipos disponibles</p></div>';
        return;
    }
    
    container.innerHTML = '';
    
    equipos.forEach(equipo => {
        const col = document.createElement('div');
        col.className = 'col-12 col-md-6 col-lg-4';
        col.innerHTML = `
            <div class="c-card">
                <div class="c-card__img-container">
                    <img src="./assets/img/placeholder.jpg" alt="${equipo.model || equipo.internal_code}" class="c-card__img" onerror="this.src='./assets/img/placeholder.jpg'">
                    <span class="c-tag c-tag--normal">✅ Disponible</span>
                </div>
                <div class="c-card__content">
                    <h3 class="c-card__title">${equipo.model || equipo.internal_code}</h3>
                    <div class="c-card__info">
                        <p><strong>Código:</strong> ${equipo.internal_code}</p>
                        <p><strong>Estado:</strong> ${equipo.status}</p>
                    </div>
                </div>
                <div class="c-card__footer">
                    <button class="btn btn-action w-100"
                        data-bs-toggle="modal" 
                        data-bs-target="#reservaModal"
                        data-categoria="${equipo.model || equipo.internal_code}"
                        data-id="${equipo.id}"
                        data-codigo="${equipo.internal_code}">
                        Retirar / Reservar
                    </button>
                </div>
            </div>
        `;
        container.appendChild(col);
    });
}

// Función principal para cargar todo el dashboard
export async function cargarDashboard() {
    const prestamosContainer = 'prestamosContainer';
    const disponiblesContainer = 'disponiblesContainer';
    
    // Verificar que los contenedores existen
    if (!document.getElementById(prestamosContainer) || !document.getElementById(disponiblesContainer)) {
        console.error('❌ Contenedores del dashboard no encontrados');
        return;
    }
    
    // Mostrar spinners de carga
    document.getElementById(prestamosContainer).innerHTML = '<div class="col-12"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div></div>';
    document.getElementById(disponiblesContainer).innerHTML = '<div class="col-12"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div></div>';
    
    // Cargar datos
    const prestamos = await cargarPrestamosActivos();
    const disponibles = await cargarEquiposDisponibles();
    
    // Renderizar
    renderizarPrestamos(prestamosContainer, prestamos);
    renderizarDisponibles(disponiblesContainer, disponibles);
}