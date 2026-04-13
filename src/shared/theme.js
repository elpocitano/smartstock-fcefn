// src/shared/theme.js
export function initTheme() {
    const darkModeSwitch = document.getElementById('darkModeSwitch');
    const htmlElement = document.documentElement;
    const themeIcon = document.getElementById('themeIcon');

    if (!darkModeSwitch) return;

    const applyTheme = (theme) => {
        htmlElement.setAttribute('data-bs-theme', theme);
        darkModeSwitch.checked = theme === 'dark';
        if (themeIcon) themeIcon.innerText = theme === 'dark' ? '☀️' : '🌙';
    };

    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        applyTheme(savedTheme);
    } else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        applyTheme('dark');
    } else {
        applyTheme('light');
    }

    darkModeSwitch.addEventListener('change', () => {
        const theme = darkModeSwitch.checked ? 'dark' : 'light';
        applyTheme(theme);
        localStorage.setItem('theme', theme);
    });
}