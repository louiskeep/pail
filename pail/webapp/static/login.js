document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('login-form');
    const errorDiv = document.getElementById('login-error');
    const tabs = document.querySelectorAll('.auth-tab');
    const panes = {
        default: document.getElementById('pane-default'),
        profile: document.getElementById('pane-profile'),
        keys: document.getElementById('pane-keys'),
    };
    let mode = 'keys';

    function setMode(m) {
        mode = m;
        tabs.forEach(t => t.classList.toggle('active', t.dataset.mode === m));
        Object.entries(panes).forEach(([k, el]) => el.classList.toggle('active', k === m));
        errorDiv.textContent = '';
    }
    tabs.forEach(t => t.addEventListener('click', () => setMode(t.dataset.mode)));

    // Populate profile list + default-chain status
    fetch('/api/auth-options')
        .then(r => r.json())
        .then(opts => {
            const sel = document.getElementById('profile-select');
            sel.innerHTML = '';
            if (opts.profiles && opts.profiles.length) {
                opts.profiles.forEach(p => {
                    const o = document.createElement('option');
                    o.value = p; o.textContent = p;
                    sel.appendChild(o);
                });
            } else {
                sel.innerHTML = '<option value="">(no profiles found)</option>';
            }
            const status = document.getElementById('default-status');
            if (opts.has_default) {
                status.textContent = 'Default credentials detected — click Login to use them.';
                status.style.color = '#059669';
                setMode('default');
            } else {
                status.textContent = 'No default credentials found in environment / ~/.aws.';
                status.style.color = '#9ca3af';
                if (opts.profiles && opts.profiles.length) setMode('profile');
            }
        })
        .catch(() => {});

    // Dev autofill for keys mode
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
        const region = document.getElementById('region').value;
        let data = { mode, region };
        if (mode === 'keys') {
            data.access_key = document.getElementById('access-key').value;
            data.secret_key = document.getElementById('secret-key').value;
            data.session_token = document.getElementById('session-token').value;
        } else if (mode === 'profile') {
            data.profile = document.getElementById('profile-select').value;
        }
        fetch('/api/login', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        })
        .then(resp => resp.json().then(j => ({ ok: resp.ok, body: j })))
        .then(({ ok, body }) => {
            if (body.success) {
                window.location = '/';
            } else {
                errorDiv.textContent = body.error || 'Login failed.';
            }
        })
        .catch(() => {
            errorDiv.textContent = 'Network error.';
        });
    };
});
