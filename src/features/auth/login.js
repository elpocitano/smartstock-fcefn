// src/features/auth/login.js
import { supabase } from '../../shared/supabaseClient.js';

export function initLoginModal() {
    const loginForm = document.getElementById('loginForm');
    if (!loginForm) return;

    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const email = document.getElementById('loginEmail').value;
        const password = document.getElementById('loginPassword').value;
        const errorDiv = document.getElementById('loginError');
        
        // Limpiar error anterior
        errorDiv.classList.add('d-none');
        
        // Mostrar loading en el botón
        const submitBtn = loginForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerText;
        submitBtn.innerText = 'Ingresando...';
        submitBtn.disabled = true;
        
        // Intentar login
        const { data, error } = await supabase.auth.signInWithPassword({
            email: email,
            password: password
        });
        
        // Restaurar botón
        submitBtn.innerText = originalText;
        submitBtn.disabled = false;
        
        if (error) {
            errorDiv.innerText = error.message;
            errorDiv.classList.remove('d-none');
            return;
        }
        
        // Login exitoso
        console.log('✅ Login exitoso:', data.user.email);
        
        // Cerrar modal
        const modal = bootstrap.Modal.getInstance(document.getElementById('loginModal'));
        if (modal) modal.hide();
        
        // Recargar la página para mostrar el dashboard
        window.location.reload();
    });
}