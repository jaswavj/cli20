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
boolean isAdmin = permissions.contains(8);
String fromDate = request.getParameter("fromDate");
String toDate   = request.getParameter("toDate");
if (fromDate==null) fromDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
if (toDate==null)   toDate   = fromDate;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        body { background:#f0f2f5; }
        .rpt-wrap { max-width:1100px; margin:32px auto; padding:0 16px 40px; }

        .rpt-header {
            background:#1c1c2e; color:#fff; border-radius:16px 16px 0 0;
            padding:18px 24px; display:flex; align-items:center; justify-content:space-between; gap:12px;
        }
        .rpt-header h4 { margin:0; font-size:18px; font-weight:800; }

        .rpt-body { background:#fff; border-radius:0 0 16px 16px; padding:24px; box-shadow:0 4px 20px rgba(0,0,0,.08); }

        .filter-row { display:flex; flex-wrap:wrap; gap:12px; align-items:flex-end; margin-bottom:24px; }
        .filter-group { display:flex; flex-direction:column; gap:4px; }
        .filter-group label { font-size:11px; font-weight:700; text-transform:uppercase; color:#64748b; letter-spacing:.4px; }
        .filter-group input, .filter-group select {
            border:1.5px solid #e2e8f0; border-radius:9px; padding:8px 12px;
            font-size:13px; outline:none; background:#f8fafc;
        }
        .filter-group input:focus, .filter-group select:focus { border-color:#f5a623; }
        .btn-search {
            background:#1c1c2e; color:#fff; border:none; border-radius:9px;
            padding:9px 20px; font-size:13px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; gap:6px;
        }
        .btn-search:hover { background:#f5a623; color:#1c1c2e; }
        .btn-export {
            background:#dcfce7; color:#166534; border:none; border-radius:9px;
            padding:9px 18px; font-size:13px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; gap:6px;
        }
        .btn-export:hover { background:#bbf7d0; }

        /* Summary pills */
        .summary-row { display:flex; gap:12px; flex-wrap:wrap; margin-bottom:20px; }
        .sum-pill {
            background:#f8fafc; border-radius:10px; padding:10px 18px;
            display:flex; flex-direction:column; align-items:center; min-width:90px;
            border:1.5px solid #e2e8f0;
        }
        .sum-pill .s-val { font-size:20px; font-weight:800; color:#1c1c2e; }
        .sum-pill .s-lbl { font-size:10px; color:#94a3b8; font-weight:700; text-transform:uppercase; margin-top:2px; }

        /* Table */
        .rpt-table-wrap { overflow-x:auto; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        thead th {
            background:#1c1c2e; color:#fff; padding:11px 13px;
            font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.4px;
            white-space:nowrap;
        }
        thead th:first-child { border-radius:8px 0 0 0; }
        thead th:last-child  { border-radius:0 8px 0 0; }
        tbody tr { border-bottom:1px solid #f1f5f9; }
        tbody tr:hover { background:#fafafa; }
        tbody td { padding:10px 13px; color:#1e293b; white-space:nowrap; }
        .shift-group { display:flex; gap:6px; align-items:center; }
        .shift-badge { font-size:10px; font-weight:700; padding:2px 8px; border-radius:20px; }
        .shift1-color { background:#dbeafe; color:#1d4ed8; }
        .shift2-color { background:#fef9c3; color:#854d0e; }
        .shift3-color { background:#f3e8ff; color:#7e22ce; }
        .dur-chip { font-size:11px; font-weight:700; background:#fff8f0; color:#f5a623; padding:2px 7px; border-radius:6px; }
        .status-done    { background:#dcfce7; color:#166534; }
        .status-partial { background:#fef9c3; color:#854d0e; }
        .status-absent  { background:#fee2e2; color:#991b1b; }
        .status-badge { font-size:11px; font-weight:700; padding:3px 10px; border-radius:20px; }
        .total-dur { font-weight:800; color:#1c1c2e; }
        .no-data { text-align:center; padding:40px; color:#94a3b8; }

        /* Edited row indicator */
        tr.row-edited { background:#fffbeb !important; cursor:pointer; }
        tr.row-edited:hover { background:#fef3c7 !important; }
        .edited-icon { color:#f5a623; font-size:11px; margin-left:4px; }

        /* Edit history modal */
        .eh-modal-overlay {
            display:none; position:fixed; inset:0;
            background:rgba(0,0,0,.55); z-index:9999;
            align-items:center; justify-content:center;
        }
        .eh-modal-overlay.open { display:flex; }
        .eh-modal-box {
            background:#fff; border-radius:18px; padding:28px;
            max-width:680px; width:95%; box-shadow:0 20px 60px rgba(0,0,0,.3);
            max-height:88vh; overflow-y:auto;
        }
        .eh-modal-box h5 { font-size:16px; font-weight:800; margin:0 0 5px; color:#1c1c2e; }
        .eh-modal-meta { font-size:12px; color:#94a3b8; margin-bottom:18px; }
        .eh-entry {
            border:1.5px solid #e2e8f0; border-radius:12px; padding:16px;
            margin-bottom:14px;
        }
        .eh-entry-header {
            display:flex; justify-content:space-between; align-items:flex-start;
            margin-bottom:12px; flex-wrap:wrap; gap:6px;
        }
        .eh-entry-meta { font-size:11px; color:#64748b; }
        .eh-entry-by { font-size:12px; font-weight:700; color:#1c1c2e; }
        .eh-remarks {
            background:#fff8f0; border-left:3px solid #f5a623;
            border-radius:0 8px 8px 0; padding:7px 12px;
            font-size:12px; color:#92400e; margin-bottom:12px;
        }
        .eh-diff-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
        .eh-diff-card { border-radius:9px; padding:10px 12px; }
        .eh-diff-card.old { background:#fff1f2; border:1px solid #fecdd3; }
        .eh-diff-card.new { background:#f0fdf4; border:1px solid #bbf7d0; }
        .eh-diff-label { font-size:10px; font-weight:800; text-transform:uppercase; margin-bottom:7px; }
        .eh-diff-card.old .eh-diff-label { color:#dc2626; }
        .eh-diff-card.new .eh-diff-label { color:#16a34a; }
        .eh-diff-row { display:flex; justify-content:space-between; font-size:11px; padding:3px 0; border-bottom:1px solid rgba(0,0,0,.05); }
        .eh-diff-row:last-child { border-bottom:none; }
        .eh-diff-row .dk { color:#64748b; }
        .eh-diff-row .dv { font-weight:700; color:#1c1c2e; }
        .eh-diff-row .dv-empty { color:#cbd5e1; font-weight:400; }
        .eh-diff-row.changed { background:#fef9c3; border-radius:4px; padding-left:4px; }
        .eh-modal-close { background:#f1f5f9; color:#475569; border:none; border-radius:9px; padding:9px 22px; font-size:13px; font-weight:700; cursor:pointer; }
        .eh-modal-close:hover { background:#e2e8f0; }
        .eh-no-history { text-align:center; padding:28px; color:#94a3b8; }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="rpt-wrap">
    <div class="rpt-header">
        <h4><i class="fas fa-chart-bar me-2" style="color:#f5a623"></i>Attendance Report</h4>
        <button class="btn-export" onclick="exportToExcel()">
            <i class="fas fa-file-excel"></i> Export
        </button>
    </div>
    <div class="rpt-body">
        <!-- Filters -->
        <form id="filterForm" class="filter-row">
            <div class="filter-group">
                <label>From Date</label>
                <input type="date" name="fromDate" value="<%=fromDate%>" required>
            </div>
            <div class="filter-group">
                <label>To Date</label>
                <input type="date" name="toDate" value="<%=toDate%>" required>
            </div>
            <%if(isAdmin){%>
            <div class="filter-group">
                <label>User</label>
                <select name="userId" id="userSelect" style="min-width:160px">
                    <option value="">All Users </option>
                </select>
            </div>
            <%}%>
            <button type="submit" class="btn-search">
                <i class="fas fa-search"></i> Search
            </button>
        </form>

        <!-- Summary -->
        <div class="summary-row" id="summaryRow" style="display:none!important"></div>

        <!-- Table -->
        <div class="rpt-table-wrap">
            <table id="rptTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <%if(isAdmin){%><th>User</th><%}%>
                        <th>Date</th>
                        <th><span class="shift-badge shift1-color">S1</span> In</th>
                        <th><span class="shift-badge shift1-color">S1</span> Out</th>
                        <th><span class="shift-badge shift1-color">S1</span> Duration</th>
                        <th><span class="shift-badge shift2-color">S2</span> In</th>
                        <th><span class="shift-badge shift2-color">S2</span> Out</th>
                        <th><span class="shift-badge shift2-color">S2</span> Duration</th>
                        <th><span class="shift-badge shift3-color">S3</span> In</th>
                        <th><span class="shift-badge shift3-color">S3</span> Out</th>
                        <th><span class="shift-badge shift3-color">S3</span> Duration</th>
                        <th>Total</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody id="rptTbody">
                    <tr><td colspan="14" class="no-data"><i class="fas fa-spinner fa-spin fa-2x"></i></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
const contextPath = '<%=contextPath%>';
const isAdmin = <%=isAdmin%>;

function minsToStr(m) { return m>0 ? Math.floor(m/60)+'h '+(m%60)+'m' : 'â€”'; }
function durMins(inT,outT) {
    if(!inT||!outT) return 0;
    const [ih,im]=inT.split(':').map(Number),[oh,om]=outT.split(':').map(Number);
    return Math.max(0,(oh*60+om)-(ih*60+im));
}

function loadReport() {
    const params = new URLSearchParams(new FormData(document.getElementById('filterForm')));
    document.getElementById('rptTbody').innerHTML = '<tr><td colspan="14" class="no-data"><i class="fas fa-spinner fa-spin fa-2x"></i></td></tr>';
    fetch(contextPath+'/attendance/getAttendanceReport.jsp?'+params)
        .then(r=>r.json()).then(renderReport)
        .catch(()=>{ document.getElementById('rptTbody').innerHTML='<tr><td colspan="14" class="no-data text-danger">Error loading report</td></tr>'; });
}

function renderReport(data) {
    const tbody = document.getElementById('rptTbody');
    if(!data||data.length===0){ tbody.innerHTML='<tr><td colspan="14" class="no-data">No records found</td></tr>'; return; }

    let totalDays=0, completeDays=0, totalMins=0;
    tbody.innerHTML = data.map((row,i)=>{
        totalDays++;
        const m1=durMins(row.in1,row.out1), m2=durMins(row.in2,row.out2), m3=durMins(row.in3,row.out3), tot=m1+m2+m3;
        totalMins+=tot;
        const hasAll = row.in1&&row.out1&&row.in2&&row.out2&&row.in3&&row.out3;
        if(hasAll) completeDays++;

        let statusHtml;
        if(row.in1&&row.out1&&row.in2&&row.out2&&row.in3&&row.out3) statusHtml='<span class="status-badge status-done">Complete</span>';
        else if(row.in1&&row.out1&&row.in2&&row.out2)               statusHtml='<span class="status-badge status-partial">S1+S2 Only</span>';
        else if(row.in1&&row.out1)                                   statusHtml='<span class="status-badge status-partial">S1 Only</span>';
        else if(row.in1&&!row.out1)                                  statusHtml='<span class="status-badge status-partial">In Progress</span>';
        else                                                         statusHtml='<span class="status-badge status-absent">Absent</span>';

        return `<tr${row.isEdited ? ` class="row-edited" title="This record was edited — click to view edit history" onclick="showEditHistory('${row.date}',${row.userId},'${row.userName.replace(/'/g,"\\'")}')"`  : ''}>
            <td>${i+1}${row.isEdited ? '<i class="fas fa-edit edited-icon" title="Edited"></i>' : ''}</td>
            ${isAdmin?`<td>${row.userName}</td>`:''}
            <td>${row.date}</td>
            <td>${row.in1||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${row.out1||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${m1>0?'<span class="dur-chip">'+minsToStr(m1)+'</span>':'—'}</td>
            <td>${row.in2||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${row.out2||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${m2>0?'<span class="dur-chip">'+minsToStr(m2)+'</span>':'—'}</td>
            <td>${row.in3||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${row.out3||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${m3>0?'<span class="dur-chip">'+minsToStr(m3)+'</span>':'—'}</td>
            <td class="total-dur">${tot>0?minsToStr(tot):'—'}</td>
            <td>${statusHtml}</td>
        </tr>`;
    }).join('');

    // Summary
    const sr = document.getElementById('summaryRow');
    sr.style.display='flex';
    sr.innerHTML=`
        <div class="sum-pill"><div class="s-val">${totalDays}</div><div class="s-lbl">Days</div></div>
        <div class="sum-pill"><div class="s-val">${completeDays}</div><div class="s-lbl">Complete</div></div>
        <div class="sum-pill"><div class="s-val">${totalDays-completeDays}</div><div class="s-lbl">Partial</div></div>
        <div class="sum-pill"><div class="s-val" style="color:#f5a623">${minsToStr(totalMins)}</div><div class="s-lbl">Total Hours</div></div>`;
}

function exportToExcel() {
    const table = document.getElementById('rptTable');
    const html = '<html><head><meta charset="UTF-8"></head><body>'+table.outerHTML+'</body></html>';
    const blob = new Blob([html],{type:'application/vnd.ms-excel'});
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a'); a.href=url; a.download='attendance_report.xls'; a.click();
}

if(isAdmin) {
    fetch(contextPath+'/getAllUsers.jsp').then(r=>r.json()).then(users=>{
        const sel=document.getElementById('userSelect');
        (users||[]).forEach(u=>{ const o=document.createElement('option'); o.value=u.id; o.text=u.name; sel.appendChild(o); });
    }).catch(()=>{});
}

document.getElementById('filterForm').addEventListener('submit',e=>{ e.preventDefault(); loadReport(); });
loadReport();

// ---- Edit History Modal ----
function showEditHistory(date, userId, userName) {
    const modal = document.getElementById('ehModal');
    document.getElementById('ehModalTitle').innerHTML =
        `<i class="fas fa-history me-2" style="color:#f5a623"></i>${userName} — ${date}`;
    document.getElementById('ehModalMeta').textContent = 'Loading edit history…';
    document.getElementById('ehModalBody').innerHTML =
        '<div class="eh-no-history"><i class="fas fa-spinner fa-spin fa-2x"></i></div>';
    modal.classList.add('open');

    fetch(contextPath + '/admin/attendanceEdit/getEditLog.jsp?attDate=' + encodeURIComponent(date) + '&empId=' + encodeURIComponent(userId))
        .then(r => r.json())
        .then(logs => {
            document.getElementById('ehModalMeta').textContent =
                logs.length + ' edit' + (logs.length !== 1 ? 's' : '') + ' found';
            if (!logs.length) {
                document.getElementById('ehModalBody').innerHTML =
                    '<div class="eh-no-history">No edit history found for this record.</div>';
                return;
            }
            const fields = [
                ['S1 In','In1'],['S1 Out','Out1'],
                ['S2 In','In2'],['S2 Out','Out2'],
                ['S3 In','In3'],['S3 Out','Out3']
            ];
            document.getElementById('ehModalBody').innerHTML = logs.map((r, i) => {
                const oldRows = fields.map(([label, key]) => {
                    const ov = r['old'+key], nv = r['new'+key];
                    const changed = ov !== nv;
                    return `<div class="eh-diff-row${changed?' changed':''}">
                        <span class="dk">${label}</span>
                        ${ov ? `<span class="dv">${ov}</span>` : `<span class="dv-empty">—</span>`}
                    </div>`;
                }).join('');
                const newRows = fields.map(([label, key]) => {
                    const ov = r['old'+key], nv = r['new'+key];
                    const changed = ov !== nv;
                    return `<div class="eh-diff-row${changed?' changed':''}">
                        <span class="dk">${label}</span>
                        ${nv ? `<span class="dv">${nv}</span>` : `<span class="dv-empty">—</span>`}
                    </div>`;
                }).join('');
                return `<div class="eh-entry">
                    <div class="eh-entry-header">
                        <div>
                            <div class="eh-entry-by"><i class="fas fa-user-edit me-1"></i>Edited by: ${r.editedBy}</div>
                            <div class="eh-entry-meta">${r.editedAt}</div>
                        </div>
                        <span style="font-size:11px;background:#e0f2fe;color:#0369a1;padding:2px 8px;border-radius:10px;font-weight:700">#${i+1}</span>
                    </div>
                    <div class="eh-remarks"><i class="fas fa-comment-alt me-1"></i>${r.remarks||'No remarks'}</div>
                    <div class="eh-diff-grid">
                        <div class="eh-diff-card old">
                            <div class="eh-diff-label"><i class="fas fa-times-circle me-1"></i>Before</div>
                            ${oldRows}
                        </div>
                        <div class="eh-diff-card new">
                            <div class="eh-diff-label"><i class="fas fa-check-circle me-1"></i>After</div>
                            ${newRows}
                        </div>
                    </div>
                </div>`;
            }).join('');
        })
        .catch(() => {
            document.getElementById('ehModalBody').innerHTML =
                '<div class="eh-no-history text-danger">Error loading edit history.</div>';
        });
}

function closeEhModal() {
    document.getElementById('ehModal').classList.remove('open');
}
document.getElementById('ehModal').addEventListener('click', function(e) {
    if (e.target === this) closeEhModal();
});
</script>

<!-- Edit History Modal -->
<div class="eh-modal-overlay" id="ehModal">
    <div class="eh-modal-box">
        <h5 id="ehModalTitle"></h5>
        <div class="eh-modal-meta" id="ehModalMeta"></div>
        <div id="ehModalBody"></div>
        <button class="eh-modal-close" onclick="closeEhModal()">
            <i class="fas fa-times me-1"></i> Close
        </button>
    </div>
</div>

<br><br><br><br><br><br><br>
</body>
</html>
