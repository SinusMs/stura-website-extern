// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"

document.addEventListener('turbo:load', function() {
    const toast = document.getElementById('liveToast');
    if (toast) {
        const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toast);
        toastBootstrap.show();
    }
});

document.addEventListener('turbo:frame-load', function() {
    const toast = document.getElementById('contactToast');
    if (toast) {
        const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toast);
        toastBootstrap.show();
    }
});