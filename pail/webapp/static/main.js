// main.js for index.html

// State for each pane
const panes = [
  {
    bucket: null,
    prefix: '',
    prefixStack: [],
    tableId: 'explorer-table-1',
    selectId: 'bucket-select-1',
    errorId: 'error-message-1',
  },
  {
    bucket: null,
    prefix: '',
    prefixStack: [],
    tableId: 'explorer-table-2',
    selectId: 'bucket-select-2',
    errorId: 'error-message-2',
  }
];

document.addEventListener('DOMContentLoaded', function() {
  panes.forEach((pane, idx) => {
    // Add sort state to each pane
    pane.sortState = { column: 'name', direction: 'asc' };
    fetchBuckets(pane);
    const select = document.getElementById(pane.selectId);
    if (select) {
      select.addEventListener('change', function() {
        const bucket = select.value;
        if (bucket) {
          pane.bucket = bucket;
          pane.prefix = '';
          pane.prefixStack = [];
          fetchObjectsForBucket(pane, bucket, '');
        }
      });
    }

    // Add sorting event listeners
    const paneNum = idx + 1;
    const nameHeader = document.getElementById(`sort-name-${paneNum}`);
    const sizeHeader = document.getElementById(`sort-size-${paneNum}`);
    const modHeader = document.getElementById(`sort-modified-${paneNum}`);
    if (nameHeader) {
      nameHeader.addEventListener('click', function() {
        handleSortClick(pane, 'name');
      });
    }
    if (sizeHeader) {
      sizeHeader.addEventListener('click', function() {
        handleSortClick(pane, 'size');
      });
    }
    if (modHeader) {
      modHeader.addEventListener('click', function() {
        handleSortClick(pane, 'lastModified');
      });
    }

    // Add search input event listener
    const searchInput = document.getElementById(`search-input-${paneNum}`);
    if (searchInput) {
      searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
          const searchValue = searchInput.value.trim().toLowerCase();
          pane.searchValue = searchValue;
          if (pane.lastObjects) {
            let filtered = pane.lastObjects;
            if (searchValue) {
              filtered = pane.lastObjects.filter(obj => {
                let leafName = obj.Name || obj.Key || '';
                // Remove prefix if present
                if (pane.prefix && leafName.startsWith(pane.prefix)) {
                  leafName = leafName.slice(pane.prefix.length);
                }
                if (leafName.endsWith('/')) leafName = leafName.slice(0, -1);
                return leafName.toLowerCase().startsWith(searchValue);
              });
            }
            // Always sort filtered results by current sort state
            const sorted = sortObjects(filtered, pane.sortState);
            populateExplorerTable(pane, sorted);
          }
        }
      });
    }
  });
});

// Handle sort header click
function handleSortClick(pane, column) {
  if (pane.sortState.column === column) {
    pane.sortState.direction = pane.sortState.direction === 'asc' ? 'desc' : 'asc';
  } else {
    pane.sortState.column = column;
    pane.sortState.direction = 'asc';
  }
  // Sort and re-render
  if (pane.lastObjects) {
    const sorted = sortObjects(pane.lastObjects, pane.sortState);
    populateExplorerTable(pane, sorted);
  }
}

// Sort objects array by column and direction
function sortObjects(objects, sortState) {
  const sorted = [...objects];
  sorted.sort((a, b) => {
    let valA, valB;
    if (sortState.column === 'name') {
      valA = a.Key || a.Name || '';
      valB = b.Key || b.Name || '';
      valA = valA.toLowerCase();
      valB = valB.toLowerCase();
    } else if (sortState.column === 'size') {
      valA = a.Size || 0;
      valB = b.Size || 0;
    } else if (sortState.column === 'lastModified') {
      valA = a.LastModified ? new Date(a.LastModified) : new Date(0);
      valB = b.LastModified ? new Date(b.LastModified) : new Date(0);
    }
    if (valA < valB) return sortState.direction === 'asc' ? -1 : 1;
    if (valA > valB) return sortState.direction === 'asc' ? 1 : -1;
    return 0;
  });
  return sorted;
}
function fetchObjectsForBucket(pane, bucket, prefix = '') {
  pane.bucket = bucket;
  pane.prefix = prefix;
  fetch(`/api/buckets/${encodeURIComponent(bucket)}/objects?prefix=${encodeURIComponent(prefix)}`)
    .then(response => response.json())
    .then(data => {
      if (data.objects) {
        pane.lastObjects = data.objects;
        populateExplorerTable(pane, data.objects);
      } else {
        showError(pane, data.error || 'Could not fetch objects.');
        pane.lastObjects = [];
        populateExplorerTable(pane, []);
      }
    })
    .catch(err => {
      showError(pane, 'Error fetching objects: ' + err);
      pane.lastObjects = [];
      populateExplorerTable(pane, []);
    });
}
// Helper to get selected files for a pane
function getSelectedFilesForPane(pane, objects) {
  if (!pane.selectedIndices || !Array.isArray(pane.selectedIndices)) return [];
  return pane.selectedIndices.map(idx => {
    const obj = objects[idx];
    return {
      bucket: pane.bucket,
      key: obj.Key || obj.Name,
      prefix: pane.prefix || '',
      ...obj
    };
  });
}

function populateExplorerTable(pane, objects) {
  const table = document.getElementById(pane.tableId);
  if (!table) return;
  const tbody = table.querySelector('tbody');
  tbody.innerHTML = '';

  // Show current prefix path to the right of the dropdown
  const prefixDiv = document.getElementById('prefix-path-' + (pane.tableId.endsWith('1') ? '1' : '2'));
  if (prefixDiv) {
    let prefixDisplay = pane.prefix || '';
    if (prefixDisplay.endsWith('/')) prefixDisplay = prefixDisplay.slice(0, -1);
    prefixDiv.textContent = prefixDisplay ? 'Path: ' + prefixDisplay : '';
  }

  // Add ".." row for going up a folder if not at root
  if (pane.prefix && pane.prefixStack.length > 0) {
    const upRow = document.createElement('tr');
    upRow.className = 'folder-row';
    upRow.style.cursor = 'pointer';
    const upCell = document.createElement('td');
    upCell.colSpan = 4;
    upCell.textContent = '.. (Up)';
    upRow.appendChild(upCell);
    upRow.addEventListener('click', function() {
      pane.prefixStack.pop();
      const parentPrefix = pane.prefixStack.length > 0 ? pane.prefixStack[pane.prefixStack.length - 1] : '';
      fetchObjectsForBucket(pane, pane.bucket, parentPrefix);
    });
    tbody.appendChild(upRow);
  }

  if (!objects || objects.length === 0) {
    const row = document.createElement('tr');
    const cell = document.createElement('td');
    cell.colSpan = 4;
    cell.textContent = 'No objects found.';
    row.appendChild(cell);
    tbody.appendChild(row);
    return;
  }

  // Multi-select state for this pane
  pane.selectedIndices = [];
  pane.lastSelectedIndex = null;

  objects.forEach((obj, idx) => {
    const row = document.createElement('tr');
    row.className = obj.Type === 'folder' ? 'folder-row' : 'file-row';
    if (obj.Type === 'folder') row.style.cursor = 'pointer';
    if (idx % 2 === 1) row.style.background = '#f9fbfd'; // alternate row color

    // Name: show only the leaf name, not the full prefix
    let leafName = obj.Name || obj.Key || '';
    if (pane.prefix && leafName.startsWith(pane.prefix)) {
      leafName = leafName.slice(pane.prefix.length);
    }
    if (leafName.endsWith('/')) leafName = leafName.slice(0, -1);

    const nameCell = document.createElement('td');
    nameCell.textContent = leafName;
    nameCell.style.fontWeight = obj.Type === 'folder' ? 'bold' : 'normal';
    row.appendChild(nameCell);
    // Type
    const typeCell = document.createElement('td');
    typeCell.textContent = obj.Type || (obj.Key && obj.Key.endsWith('/') ? 'folder' : 'file');
    row.appendChild(typeCell);
    // Size
    const sizeCell = document.createElement('td');
    sizeCell.textContent = (obj.Size !== undefined && obj.Size !== null && obj.Type !== 'folder') ? formatFileSize(obj.Size) : '';
    row.appendChild(sizeCell);
    // Last Modified
    const modCell = document.createElement('td');
    modCell.textContent = obj.LastModified ? formatDate(obj.LastModified) : '';
    row.appendChild(modCell);

    // Multi-file selection logic
    row.addEventListener('click', function(e) {
      const allRows = Array.from(row.parentElement.querySelectorAll('tr'));
      // Ignore up-row
      const rowIndex = allRows.indexOf(row) - (pane.prefix && pane.prefixStack.length > 0 ? 1 : 0);
      if (rowIndex < 0) return;
      if (e.shiftKey && pane.lastSelectedIndex !== null) {
        // Select range
        const [start, end] = [pane.lastSelectedIndex, rowIndex].sort((a, b) => a - b);
        pane.selectedIndices = [];
        for (let i = start; i <= end; i++) pane.selectedIndices.push(i);
      } else if (e.ctrlKey || e.metaKey) {
        // Toggle selection
        if (pane.selectedIndices.includes(rowIndex)) {
          pane.selectedIndices = pane.selectedIndices.filter(i => i !== rowIndex);
        } else {
          pane.selectedIndices.push(rowIndex);
        }
        pane.lastSelectedIndex = rowIndex;
      } else {
        // Single select
        pane.selectedIndices = [rowIndex];
        pane.lastSelectedIndex = rowIndex;
      }
      // Update row classes
      allRows.forEach((r, i) => {
        if (i === 0 && pane.prefix && pane.prefixStack.length > 0) return; // skip up-row
        const dataIdx = i - (pane.prefix && pane.prefixStack.length > 0 ? 1 : 0);
        if (pane.selectedIndices.includes(dataIdx)) {
          r.classList.add('selected-row');
        } else {
          r.classList.remove('selected-row');
        }
      });
      e.stopPropagation();
    });

    // Context menu for file actions
    if (obj.Type !== 'folder') {
      row.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        showFileContextMenu(e, pane, obj);
      });
    }

    // Folder click handler (navigate on double click for better UX)
    if (obj.Type === 'folder' || (obj.Key && obj.Key.endsWith('/'))) {
      row.addEventListener('dblclick', function(e) {
        // Compute new prefix
        let folderPrefix = obj.Prefix || obj.Key || obj.Name;
        if (!folderPrefix.endsWith('/')) folderPrefix += '/';
        pane.prefixStack.push(folderPrefix);
        fetchObjectsForBucket(pane, pane.bucket, folderPrefix);
      });
    }
    tbody.appendChild(row);
  });
}

// Context menu logic
let contextMenuDiv = null;
function showFileContextMenu(e, pane, obj) {
  // Remove any existing menu
  if (contextMenuDiv) {
    contextMenuDiv.remove();
    contextMenuDiv = null;
  }
  contextMenuDiv = document.createElement('div');
  contextMenuDiv.className = 'file-context-menu';
  contextMenuDiv.style.position = 'absolute';
  contextMenuDiv.style.left = e.pageX + 'px';
  contextMenuDiv.style.top = e.pageY + 'px';
  contextMenuDiv.style.background = '#fff';
  contextMenuDiv.style.border = '1px solid #ccc';
  contextMenuDiv.style.zIndex = 1000;
  contextMenuDiv.style.boxShadow = '0 2px 8px rgba(0,0,0,0.15)';
  contextMenuDiv.style.padding = '0';
  contextMenuDiv.style.minWidth = '120px';

  const actions = [
    { label: 'Move', handler: () => handleMoveFile(pane, obj) },
    { label: 'Copy', handler: () => handleCopyFile(pane, obj) },
    { label: 'Delete', handler: () => handleDeleteFile(pane, obj) }
  ];
  // Only show Unzip for .zip files
  if ((obj.Key || obj.Name || '').toLowerCase().endsWith('.zip')) {
    actions.push({ label: 'Unzip', handler: () => handleUnzipFile(pane, obj) });
  }
  actions.forEach(action => {
    const item = document.createElement('div');
    item.textContent = action.label;
    item.style.padding = '8px 16px';
    item.style.cursor = 'pointer';
    item.addEventListener('click', function(ev) {
      action.handler();
      contextMenuDiv.remove();
      contextMenuDiv = null;
      ev.stopPropagation();
    });
    item.addEventListener('mouseover', function() {
      item.style.background = '#f0f0f0';
    });
    item.addEventListener('mouseout', function() {
      item.style.background = '#fff';
    });
    contextMenuDiv.appendChild(item);
  });
  document.body.appendChild(contextMenuDiv);

  // Remove menu on click elsewhere
  document.addEventListener('click', removeContextMenu, { once: true });
}

function removeContextMenu() {
  if (contextMenuDiv) {
    contextMenuDiv.remove();
    contextMenuDiv = null;
  }
}

// Action handlers (stubs)
function handleMoveFile(pane, obj) {
  const otherPane = panes.find(p => p !== pane);
  if (!otherPane || !otherPane.bucket) {
    showError(pane, 'Other explorer location not available.');
    return;
  }
  const filename = (obj.Key || obj.Name || '').split('/').pop();
  let destPrefix = otherPane.prefix || '';
  if (destPrefix && !destPrefix.endsWith('/')) destPrefix += '/';
  const destKey = destPrefix + filename;
  fetch(`/api/buckets/${encodeURIComponent(pane.bucket)}/move`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      source_key: obj.Key || obj.Name,
      dest_bucket: otherPane.bucket,
      dest_key: destKey
    })
  })
    .then(async response => {
      const text = await response.text();
      let data;
      try {
        data = JSON.parse(text);
      } catch (e) {
        showError(pane, `Move failed: HTTP ${response.status} ${response.statusText}. Response: ${text}`);
        return;
      }
      if (data.success) {
        fetchObjectsForBucket(pane, pane.bucket, pane.prefix);
        fetchObjectsForBucket(otherPane, otherPane.bucket, otherPane.prefix);
      } else {
        showError(pane, data.error || 'Move failed.');
      }
    })
    .catch(err => showError(pane, 'Move error: ' + err));
}
function handleMoveFile(pane, obj) {
  const otherPane = panes.find(p => p !== pane);
  if (!otherPane || !otherPane.bucket) {
    showError(pane, 'Other explorer location not available.');
    return;
  }
  let selectedFiles = getSelectedFilesForPane(pane, pane.lastObjects || []);
  if (!selectedFiles.length) {
    selectedFiles = [{ bucket: pane.bucket, key: obj.Key || obj.Name, prefix: pane.prefix || '', ...obj }];
  }
  performMultiFileOperation('move', selectedFiles, { bucket: otherPane.bucket, prefix: otherPane.prefix || '' })
    .then(() => {
      fetchObjectsForBucket(pane, pane.bucket, pane.prefix);
      fetchObjectsForBucket(otherPane, otherPane.bucket, otherPane.prefix);
    });
}

function handleCopyFile(pane, obj) {
  const otherPane = panes.find(p => p !== pane);
  if (!otherPane || !otherPane.bucket) {
    showError(pane, 'Other explorer location not available.');
    return;
  }
  const filename = (obj.Key || obj.Name || '').split('/').pop();
  let destPrefix = otherPane.prefix || '';
  if (destPrefix && !destPrefix.endsWith('/')) destPrefix += '/';
  const destKey = destPrefix + filename;
  fetch(`/api/buckets/${encodeURIComponent(pane.bucket)}/copy`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      source_key: obj.Key || obj.Name,
      dest_bucket: otherPane.bucket,
      dest_key: destKey
    })
  })
    .then(async response => {
      const text = await response.text();
      let data;
      try {
        data = JSON.parse(text);
      } catch (e) {
        showError(pane, `Copy failed: HTTP ${response.status} ${response.statusText}. Response: ${text}`);
        return;
      }
      if (data.success) {
        fetchObjectsForBucket(otherPane, otherPane.bucket, otherPane.prefix);
      } else {
        showError(pane, data.error || 'Copy failed.');
      }
    })
    .catch(err => showError(pane, 'Copy error: ' + err));
}
function handleCopyFile(pane, obj) {
  const otherPane = panes.find(p => p !== pane);
  if (!otherPane || !otherPane.bucket) {
    showError(pane, 'Other explorer location not available.');
    return;
  }
  let selectedFiles = getSelectedFilesForPane(pane, pane.lastObjects || []);
  if (!selectedFiles.length) {
    selectedFiles = [{ bucket: pane.bucket, key: obj.Key || obj.Name, prefix: pane.prefix || '', ...obj }];
  }
  performMultiFileOperation('copy', selectedFiles, { bucket: otherPane.bucket, prefix: otherPane.prefix || '' })
    .then(() => {
      fetchObjectsForBucket(otherPane, otherPane.bucket, otherPane.prefix);
    });
}

function handleDeleteFile(pane, obj) {
  if (!confirm('Are you sure you want to delete ' + (obj.Key || obj.Name) + '?')) return;
  fetch(`/api/buckets/${encodeURIComponent(pane.bucket)}/objects`, {
    method: 'DELETE',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ key: obj.Key || obj.Name })
  })
    .then(async response => {
      const text = await response.text();
      let data;
      try {
        data = JSON.parse(text);
      } catch (e) {
        showError(pane, `Delete failed: HTTP ${response.status} ${response.statusText}. Response: ${text}`);
        return;
      }
      if (data.success) {
        fetchObjectsForBucket(pane, pane.bucket, pane.prefix);
      } else {
        showError(pane, data.error || 'Delete failed.');
      }
    })
    .catch(err => showError(pane, 'Delete error: ' + err));
}
function handleDeleteFile(pane, obj) {
  let selectedFiles = getSelectedFilesForPane(pane, pane.lastObjects || []);
  if (!selectedFiles.length) {
    selectedFiles = [{ bucket: pane.bucket, key: obj.Key || obj.Name, prefix: pane.prefix || '', ...obj }];
  }
  if (!confirm('Are you sure you want to delete the selected file(s)?')) return;
  performMultiFileOperation('delete', selectedFiles)
    .then(() => {
      fetchObjectsForBucket(pane, pane.bucket, pane.prefix);
    });
}

function handleUnzipFile(pane, obj) {
  // Call backend API to unzip file
  const zipKey = obj.Key || obj.Name;
  const prefix = pane.prefix || '';
  fetch(`/api/buckets/${encodeURIComponent(pane.bucket)}/unzip`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ zip_key: zipKey, prefix: prefix })
  })
    .then(async response => {
      const text = await response.text();
      let data;
      try {
        data = JSON.parse(text);
      } catch (e) {
        showError(pane, `Unzip failed: HTTP ${response.status} ${response.statusText}. Response: ${text}`);
        return;
      }
      if (data.success) {
        fetchObjectsForBucket(pane, pane.bucket, pane.prefix);
        alert('Unzip complete!');
      } else {
        showError(pane, data.error || 'Unzip failed.');
      }
    })
    .catch(err => showError(pane, 'Unzip error: ' + err));
}
function handleUnzipFile(pane, obj) {
  let selectedFiles = getSelectedFilesForPane(pane, pane.lastObjects || []);
  if (!selectedFiles.length) {
    selectedFiles = [{ bucket: pane.bucket, key: obj.Key || obj.Name, prefix: pane.prefix || '', ...obj }];
  }
  performMultiFileOperation('unzip', selectedFiles, { prefix: pane.prefix || '' })
    .then(() => {
      fetchObjectsForBucket(pane, pane.bucket, pane.prefix);
      alert('Unzip complete!');
    });
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 B';
    if (!bytes) return '';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function formatDate(dateStr) {
    // Try to parse ISO or Date object
    const d = new Date(dateStr);
    if (isNaN(d)) return dateStr;
    return d.toLocaleString();
}

function fetchBuckets(pane) {
  fetch('/api/buckets')
    .then(response => response.json())
    .then(data => {
      if (data.buckets) {
        populateBucketDropdown(pane, data.buckets);
      } else {
        showError(pane, data.error || 'Could not fetch buckets.');
      }
    })
    .catch(err => showError(pane, 'Error fetching buckets: ' + err));
}

function populateBucketDropdown(pane, buckets) {
  const select = document.getElementById(pane.selectId);
  if (!select) return;
  select.innerHTML = '';
  buckets.forEach(bucket => {
    const option = document.createElement('option');
    option.value = bucket.Name;
    option.textContent = bucket.Name;
    select.appendChild(option);
  });
  // Always select and load the first bucket
  if (select.options.length > 0) {
    select.selectedIndex = 0;
    pane.bucket = select.value;
    pane.prefix = '';
    pane.prefixStack = [];
    fetchObjectsForBucket(pane, pane.bucket, '');
  }
}

function showError(pane, msg) {
  let errDiv = document.getElementById(pane.errorId);
  if (!errDiv) {
    errDiv = document.createElement('div');
    errDiv.id = pane.errorId;
    errDiv.style.color = 'red';
    document.body.prepend(errDiv);
  }
  errDiv.textContent = msg;
}
