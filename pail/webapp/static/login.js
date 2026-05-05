document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('login-form');
    const errorDiv = document.getElementById('login-error');

    // Autofill credentials for development
    fetch('/api/dev-aws-creds')
        .then(resp => resp.json())
        .then(creds => {
            if (creds.access_key) document.getElementById('access-key').value = creds.access_key;
            if (creds.secret_key) document.getElementById('secret-key').value = creds.secret_key;
            if (creds.session_token) document.getElementById('session-token').value = creds.session_token;
            if (creds.region) document.getElementById('region').value = creds.region;
        });

    form.onsubmit = function(e) {
        e.preventDefault();
        errorDiv.textContent = '';
        const data = {
            access_key: document.getElementById('access-key').value,
            secret_key: document.getElementById('secret-key').value,
            session_token: document.getElementById('session-token').value,
            region: document.getElementById('region').value
        };
        fetch('/api/login', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        })
        .then(resp => resp.json())
        .then(result => {
            if (result.success) {
                window.location = '/';
            } else {
                errorDiv.textContent = result.error || 'Login failed.';
            }
        })
        .catch(() => {
            errorDiv.textContent = 'Network error.';
        });
    };
});
