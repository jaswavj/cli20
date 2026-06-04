<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.text.SimpleDateFormat,java.util.Date"%>
<jsp:useBean id="user" class="user.userBean" />
<%
String contextPath = request.getContextPath();
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { response.sendRedirect(contextPath + "/index.jsp"); return; }
Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0;i<vecPer.size();i++){Vector cat=(Vector)vecPer.get(i);permissions.add(Integer.parseInt(cat.elementAt(0).toString()));}
if (!permissions.contains(7)) { out.print("<script>alert('Access Denied');window.location='"+contextPath+"/';</script>"); return; }
String today      = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
String monthStart = new SimpleDateFormat("yyyy-MM").format(new Date()) + "-01";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance Edit Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        body { background:#f0f2f5; }
        .rpt-wrap { max-width:1100px; margin:32px auto; padding:0 16px 60px; }
        .rpt-header {
            background:#1c1c2e; color:#fff; border-radius:16px 16px 0 0;
            padding:18px 24px; display:flex; align-items:center; gap:12px;
        }
        .rpt-header h4 { margin:0; font-size:18px; font-weight:800; }
        .rpt-body { background:#fff; border-radius:0 0 16px 16px; padding:24px; box-shadow:0 4px 20px rgba(0,0,0,.08); }
        .filter-row { display:flex; flex-wrap:wrap; gap:12px; align-items:flex-end; margin-bottom:24px; }
        .filter-group { display:flex; flex-direction:column; gap:4px; }
        .filter-group label { font-size:11px; font-weight:700; text-transform:uppercase; color:#64748b; letter-spacing:.4px; }
        .filter-group input, .filter-group select {
            border:1.5px solid #e2e8f0; border-radius:9px; padding:8px 12px;
            font-size:13px; outline:none; background:#f8fafc; min-width:160px;
        }
        .filter-group input:focus, .filter-group select:focus { border-color:#f5a623; }
        .btn-search {
            background:#1c1c2e; color:#fff; border:none; border-radius:9px;
            padding:9px 20px; font-size:13px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; gap:6px;
        }
        .btn-search:hover { background:#f5a623; color:#1c1c2e; }

        .rpt-table-wrap { overflow-x:auto; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        thead th {
            background:#1c1c2e; color:#fff; padding:11px 13px;
            font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; white-space:nowrap;
        }
        thead th:first-child { border-radius:8px 0 0 0; }
        thead th:last-child  { border-radius:0 8px 0 0; }
        tbody tr { border-bottom:1px solid #f1f5f9; cursor:pointer; transition:background .15s; }
        tbody tr:hover { background:#fffbeb; }
        tbody td { padding:10px 13px; color:#1e293b; white-space:nowrap; }
        .view-badge {
            background:#fef9c3; color:#92400e; border:1px solid #fcd34d;
            padding:3px 10px; border-radius:12px; font-size:11px; font-weight:700;
        }
        .no-data { text-align:center; padding:40px; color:#94a3b8; }

        /* Modal */
        .modal-overlay {
            display:none; position:fixed; inset:0;
            background:rgba(0,0,0,.55); z-index:9999;
            align-items:center; justify-content:center;
        }
        .modal-overlay.open { display:flex; }
        .modal-box {
            background:#fff; border-radius:18px; padding:28px;
            max-width:640px; width:95%; box-shadow:0 20px 60px rgba(0,0,0,.3);
            max-height:90vh; overflow-y:auto;
        }
        .modal-box h5 { font-size:16px; font-weight:800; margin:0 0 6px; color:#1c1c2e; }
        .modal-meta { font-size:12px; color:#94a3b8; margin-bottom:16px; }
        .remarks-box {
            background:#fff8f0; border:1.5px solid #fed7aa; border-radius:10px;
            padding:10px 14px; font-size:13px; color:#92400e; margin-bottom:18px;
            display:flex; align-items:flex-start; gap:8px;
        }
        .diff-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:18px; }
        .diff-card { border-radius:12px; padding:14px; }
        .diff-card.old-card { background:#fff1f2; border:1.5px solid #fecdd3; }
        .diff-card.new-card { background:#f0fdf4; border:1.5px solid #bbf7d0; }
        .diff-card .dlabel {
            font-size:10px; font-weight:800; text-transform:uppercase;
            margin-bottom:10px; display:flex; align-items:center; gap:6px;
        }
        .diff-card.old-card .dlabel { color:#dc2626; }
        .diff-card.new-card .dlabel { color:#16a34a; }
        .diff-row {
            display:flex; justify-content:space-between; align-items:center;
            font-size:12px; padding:4px 0; border-bottom:1px solid rgba(0,0,0,.05);
        }
        .diff-row:last-child { border-bottom:none; }
        .diff-row .dkey { color:#64748b; font-weight:600; }
        .diff-row .dval { font-weight:800; color:#1c1c2e; }
        .diff-row .dval.empty { color:#cbd5e1; font-weight:400; }
        .diff-changed { background:#fef9c3 !important; }
        .modal-close-btn {
            background:#f1f5f9; color:#475569; border:none; border-radius:9px;
            padding:9px 22px; font-size:13px; font-weight:700; cursor:pointer; margin-top:4px;
        }
        .modal-close-btn:hover { background:#e2e8f0; }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="rpt-wrap">
    <div class="rpt-header">
        <i class="fas fa-history" style="color:#f5a623;font-size:20px"></i>
        <h4>Attendance Edit Report</h4>
    </div>
    <div class="rpt-body">
        <form id="filterForm" class="filter-row">
            <div class="filter-group">
                <label>From Date</label>
                <input type="date" name="fromDate" value="<%=monthStart%>">
            </div>
            <div class="filter-group">
                <label>To Date</label>
                <input type="date" name="toDate" value="<%=today%>">
            </div>
            <div class="filter-group">
                <label>Employee</label>
                <select name="userId">
                    <option value="">All Employees</option>
                </select>
            </div>
            <button type="submit" class="btn-search">
                <i class="fas fa-search"></i> Search
            </button>
        </form>

        <div class="rpt-table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Att. Date</th>
                        <th>Employee</th>
                        <th>Edited By</th>
                        <th>Edited At</th>
                        <th>Remarks</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody id="logTbody">
                    <tr><td colspan="7" class="no-data"><i class="fas fa-spinner fa-spin fa-2x"></i></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Detail Modal -->
<div class="modal-overlay" id="detailModal">
    <div class="modal-box">
        <h5 id="modalTitle"></h5>
        <div class="modal-meta" id="modalMeta"></div>
        <div class="remarks-box">
            <i class="fas fa-comment-alt" style="color:#f5a623;margin-top:2px;flex-shrink:0"></i>
            <span id="modalRemarks"></span>
        </div>
        <div class="diff-grid">
            <div class="diff-card old-card">
                <div class="dlabel"><i class="fas fa-times-circle"></i> Before Edit</div>
                <div id="oldVals"></div>
            </div>
            <div class="diff-card new-card">
                <div class="dlabel"><i class="fas fa-check-circle"></i> After Edit</div>
                <div id="newVals"></div>
            </div>
        </div>
        <button class="modal-close-btn" onclick="closeModal()">
            <i class="fas fa-times me-1"></i> Close
        </button>
    </div>
</div>

<script>
const contextPath = '<%=contextPath%>';

fetch(contextPath + '/getAllUsers.jsp').then(r => r.json()).then(users => {
    const sel = document.querySelector('select[name="userId"]');
    (users || []).forEach(u => {
        const o = document.createElement('option'); o.value = u.id; o.text = u.name; sel.appendChild(o);
    });
}).catch(() => {});

let allLogs = [];

function loadLog() {
    const params = new URLSearchParams(new FormData(document.getElementById('filterForm')));
    document.getElementById('logTbody').innerHTML =
        '<tr><td colspan="7" class="no-data"><i class="fas fa-spinner fa-spin fa-2x"></i></td></tr>';
    fetch(contextPath + '/admin/attendanceEdit/getEditLog.jsp?' + params)
        .then(r => r.json())
        .then(renderLog)
        .catch(() => {
            document.getElementById('logTbody').innerHTML =
                '<tr><td colspan="7" class="no-data text-danger">Error loading report</td></tr>';
        });
}

function renderLog(data) {
    allLogs = data || [];
    const tbody = document.getElementById('logTbody');
    if (!allLogs.length) {
        tbody.innerHTML = '<tr><td colspan="7" class="no-data">No edit records found for this period</td></tr>';
        return;
    }
    tbody.innerHTML = allLogs.map((r, i) => `
        <tr onclick="showDetail(${i})">
            <td>${i + 1}</td>
            <td>${r.attDate}</td>
            <td>${r.empName}</td>
            <td>${r.editedBy}</td>
            <td>${r.editedAt}</td>
            <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap"
                title="${(r.remarks||'').replace(/"/g,'&quot;')}">${r.remarks || '—'}</td>
            <td><span class="view-badge"><i class="fas fa-eye me-1"></i>View</span></td>
        </tr>`).join('');
}

function fmtTime(v) {
    return v ? `<span class="dval">${v}</span>` : `<span class="dval empty">—</span>`;
}

function buildDiffRows(data, prefix) {
    const fields = [
        ['S1 In', data[prefix+'In1']], ['S1 Out', data[prefix+'Out1']],
        ['S2 In', data[prefix+'In2']], ['S2 Out', data[prefix+'Out2']],
        ['S3 In', data[prefix+'In3']], ['S3 Out', data[prefix+'Out3']]
    ];
    return fields.map(([key, val]) => {
        const isOld = prefix === 'old';
        const counterKey = isOld ? 'new'+key.replace(' ','').replace('S','In').replace(' ','') : '';
        const changed = isOld && data['new'+key.split(' ').map(w=>w.charAt(0).toUpperCase()+w.slice(1)).join('')] !== val;
        return `<div class="diff-row${changed?' diff-changed':''}">
            <span class="dkey">${key}</span>${fmtTime(val)}
        </div>`;
    }).join('');
}

function showDetail(idx) {
    const r = allLogs[idx];
    document.getElementById('modalTitle').innerHTML =
        `<i class="fas fa-user-edit me-2" style="color:#f5a623"></i>${r.empName} — ${r.attDate}`;
    document.getElementById('modalMeta').innerHTML =
        `<i class="fas fa-clock me-1"></i>Edited at: <strong>${r.editedAt}</strong> &nbsp;|&nbsp; By: <strong>${r.editedBy}</strong>`;
    document.getElementById('modalRemarks').textContent = r.remarks || 'No remarks provided';

    const fields = [
        ['S1 In', 'In1'], ['S1 Out', 'Out1'],
        ['S2 In', 'In2'], ['S2 Out', 'Out2'],
        ['S3 In', 'In3'], ['S3 Out', 'Out3']
    ];

    document.getElementById('oldVals').innerHTML = fields.map(([label, key]) => {
        const oldVal = r['old'+key];
        const newVal = r['new'+key];
        const changed = oldVal !== newVal;
        return `<div class="diff-row${changed?' diff-changed':''}">
            <span class="dkey">${label}</span>${fmtTime(oldVal)}
        </div>`;
    }).join('');

    document.getElementById('newVals').innerHTML = fields.map(([label, key]) => {
        const oldVal = r['old'+key];
        const newVal = r['new'+key];
        const changed = oldVal !== newVal;
        return `<div class="diff-row${changed?' diff-changed':''}">
            <span class="dkey">${label}</span>${fmtTime(newVal)}
        </div>`;
    }).join('');

    document.getElementById('detailModal').classList.add('open');
}

function closeModal() {
    document.getElementById('detailModal').classList.remove('open');
}

document.getElementById('detailModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

document.getElementById('filterForm').addEventListener('submit', e => { e.preventDefault(); loadLog(); });
loadLog();
</script>
<br><br><br>
</body>
</html>
