// Multi-file operation modal logic
// Assumes selectedFiles is an array of {bucket, key, prefix, ...}

let multiFileOperationInProgress = false;
let multiFileOperationCancel = false;

function showMultiFileOperationModal(action, files, destination) {
    const modal = document.getElementById('multiFileOperationModal');
    const list = document.getElementById('multiFileOperationList');
    const title = document.getElementById('multiFileOperationTitle');
    const overallProgress = document.getElementById('multiFileOverallProgress');
    multiFileOperationCancel = false;
    title.textContent = `${action.charAt(0).toUpperCase() + action.slice(1)} Progress`;
    list.innerHTML = '';
    overallProgress.value = 0;
    overallProgress.max = files.length;
    files.forEach((file, idx) => {
        const row = document.createElement('div');
        row.className = 'multi-file-row';
        row.id = `multi-file-row-${idx}`;
        row.innerHTML = `
            <span class="file-name">${file.key}</span>
            <span class="file-status" id="file-status-${idx}">Pending</span>
            <progress id="file-progress-${idx}" value="0" max="100" style="width: 40%;"></progress>
        `;
        list.appendChild(row);
    });
    // Slide panel open
    modal.classList.remove('multi-file-panel-closed');
    modal.classList.add('multi-file-panel-open');
    modal.style.display = 'flex';
    document.getElementById('cancelMultiFileOperation').onclick = function() {
        multiFileOperationCancel = true;
    };
    document.getElementById('closeMultiFileModal').onclick = function() {
        modal.classList.remove('multi-file-panel-open');
        modal.classList.add('multi-file-panel-closed');
        setTimeout(() => { modal.style.display = 'none'; }, 300);
    };
}

// Panel tab toggle logic
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('multiFileOperationModal');
    const tab = document.getElementById('multiFileOperationPanelTab');
    let open = false;
    function openPanel() {
        modal.classList.remove('multi-file-panel-closed');
        modal.classList.add('multi-file-panel-open');
        modal.style.display = 'flex';
        tab.innerHTML = '&#x25B6;'; // right arrow
        open = true;
    }
    function closePanel() {
        modal.classList.remove('multi-file-panel-open');
        modal.classList.add('multi-file-panel-closed');
        tab.innerHTML = '&#x25C0;'; // left arrow
        setTimeout(() => { modal.style.display = 'none'; }, 300);
        open = false;
    }
    tab.onclick = function() {
        if (open) {
            closePanel();
        } else {
            openPanel();
        }
    };
    // Always show tab
    tab.style.display = 'flex';
    // Start closed
    closePanel();
});

async function performMultiFileOperation(action, files, destination) {
    console.log('[multi_file_operation] performMultiFileOperation called', action, files, destination);
    showMultiFileOperationModal(action, files, destination);
    multiFileOperationInProgress = true;
    let completed = 0;
    for (let i = 0; i < files.length; i++) {
        if (multiFileOperationCancel) {
            document.getElementById(`file-status-${i}`).textContent = 'Cancelled';
            document.getElementById(`file-progress-${i}`).value = 0;
            continue;
        }
        document.getElementById(`file-status-${i}`).textContent = 'In Progress';
        let result = await performSingleFileOperation(action, files[i], destination, i);
        completed++;
        document.getElementById('multiFileOverallProgress').value = completed;
    }
    multiFileOperationInProgress = false;
}

window.performMultiFileOperation = performMultiFileOperation;

async function performSingleFileOperation(action, file, destination, idx) {
    let url, body;
    let method = 'POST';
    if (action === 'delete') {
        url = `/api/buckets/${file.bucket}/objects`;
        body = JSON.stringify({ key: file.key });
        method = 'DELETE';
    } else if (action === 'move') {
        url = `/api/buckets/${file.bucket}/move`;
        body = JSON.stringify({ source_key: file.key, dest_bucket: destination.bucket, dest_key: destination.prefix + file.key.split('/').pop() });
    } else if (action === 'copy') {
        url = `/api/buckets/${file.bucket}/copy`;
        body = JSON.stringify({ source_key: file.key, dest_bucket: destination.bucket, dest_key: destination.prefix + file.key.split('/').pop() });
    } else if (action === 'unzip') {
        url = `/api/buckets/${file.bucket}/unzip`;
        body = JSON.stringify({ zip_key: file.key, prefix: destination.prefix });
    }
    try {
        const resp = await fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: method === 'GET' ? undefined : body
        });
        const data = await resp.json();
        if (resp.ok && (data.success || action === 'delete')) {
            document.getElementById(`file-status-${idx}`).textContent = 'Done';
            document.getElementById(`file-progress-${idx}`).value = 100;
        } else {
            document.getElementById(`file-status-${idx}`).textContent = 'Error';
            document.getElementById(`file-progress-${idx}`).value = 0;
        }
    } catch (e) {
        document.getElementById(`file-status-${idx}`).textContent = 'Error';
        document.getElementById(`file-progress-${idx}`).value = 0;
    }
}

// To use:
// performMultiFileOperation('move', selectedFiles, {bucket: 'dest-bucket', prefix: 'dest/prefix/'});
// performMultiFileOperation('copy', selectedFiles, {bucket: 'dest-bucket', prefix: 'dest/prefix/'});
// performMultiFileOperation('delete', selectedFiles);
// performMultiFileOperation('unzip', selectedFiles, {prefix: 'dest/prefix/'});
