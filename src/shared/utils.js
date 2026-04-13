// src/shared/utils.js
// Funciones de utilidad general

export function formatDate(dateString) {
    if (!dateString) return '—';
    const date = new Date(dateString);
    return date.toLocaleDateString('es-AR');
}

export function formatDateTime(dateString) {
    if (!dateString) return '—';
    const date = new Date(dateString);
    return date.toLocaleString('es-AR');
}

export function showToast(message, type = 'success') {
    // Temporal: usar alert hasta implementar toast
    console.log(`[${type}] ${message}`);
}