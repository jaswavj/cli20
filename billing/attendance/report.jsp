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
        .dur-chip { font-size:11px; font-weight:700; background:#fff8f0; color:#f5a623; padding:2px 7px; border-radius:6px; }
        .status-done    { background:#dcfce7; color:#166534; }
        .status-partial { background:#fef9c3; color:#854d0e; }
        .status-absent  { background:#fee2e2; color:#991b1b; }
        .status-badge { font-size:11px; font-weight:700; padding:3px 10px; border-radius:20px; }
        .total-dur { font-weight:800; color:#1c1c2e; }
        .no-data { text-align:center; padding:40px; color:#94a3b8; }
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
                    <option value="">— All Users —</option>
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
                        <th>Total</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody id="rptTbody">
                    <tr><td colspan="11" class="no-data"><i class="fas fa-spinner fa-spin fa-2x"></i></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
const contextPath = '<%=contextPath%>';
const isAdmin = <%=isAdmin%>;

function minsToStr(m) { return m>0 ? Math.floor(m/60)+'h '+(m%60)+'m' : '—'; }
function durMins(inT,outT) {
    if(!inT||!outT) return 0;
    const [ih,im]=inT.split(':').map(Number),[oh,om]=outT.split(':').map(Number);
    return Math.max(0,(oh*60+om)-(ih*60+im));
}

function loadReport() {
    const params = new URLSearchParams(new FormData(document.getElementById('filterForm')));
    document.getElementById('rptTbody').innerHTML = '<tr><td colspan="11" class="no-data"><i class="fas fa-spinner fa-spin fa-2x"></i></td></tr>';
    fetch(contextPath+'/attendance/getAttendanceReport.jsp?'+params)
        .then(r=>r.json()).then(renderReport)
        .catch(()=>{ document.getElementById('rptTbody').innerHTML='<tr><td colspan="11" class="no-data text-danger">Error loading report</td></tr>'; });
}

function renderReport(data) {
    const tbody = document.getElementById('rptTbody');
    if(!data||data.length===0){ tbody.innerHTML='<tr><td colspan="11" class="no-data">No records found</td></tr>'; return; }

    let totalDays=0, completeDays=0, totalMins=0;
    tbody.innerHTML = data.map((row,i)=>{
        totalDays++;
        const m1=durMins(row.in1,row.out1), m2=durMins(row.in2,row.out2), tot=m1+m2;
        totalMins+=tot;
        const hasAll = row.in1&&row.out1&&row.in2&&row.out2;
        const hasSome= row.in1||row.in2;
        if(hasAll) completeDays++;

        let statusHtml;
        if(row.in1&&row.out1&&row.in2&&row.out2) statusHtml='<span class="status-badge status-done">Complete</span>';
        else if(row.in1&&row.out1)               statusHtml='<span class="status-badge status-partial">S1 Only</span>';
        else if(row.in1&&!row.out1)              statusHtml='<span class="status-badge status-partial">In Progress</span>';
        else                                     statusHtml='<span class="status-badge status-absent">Absent</span>';

        return `<tr>
            <td>${i+1}</td>
            ${isAdmin?`<td>${row.userName}</td>`:''}
            <td>${row.date}</td>
            <td>${row.in1||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${row.out1||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${m1>0?'<span class="dur-chip">'+minsToStr(m1)+'</span>':'—'}</td>
            <td>${row.in2||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${row.out2||'<span style="color:#cbd5e1">—</span>'}</td>
            <td>${m2>0?'<span class="dur-chip">'+minsToStr(m2)+'</span>':'—'}</td>
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
</script>
</body>
</html>
<%
String contextPath = request.getContextPath();
Integer uid = (Integer) session.getAttribute("userId");

if (uid == null) {
    response.sendRedirect(contextPath + "/index.jsp");
    return;
}

// Load permissions from database and check for admin
Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i = 0; i < vecPer.size(); i++) {
    Vector cat = (Vector) vecPer.get(i);
    int modId = Integer.parseInt(cat.elementAt(0).toString());
    permissions.add(modId);
}
boolean isAdmin = permissions.contains(8); // Admin permission

// Get filter params
String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
String userFilter = request.getParameter("userId");

if (fromDate == null) fromDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
if (toDate == null) toDate = fromDate;

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
String today = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        .attendance-report-wrap .card-header h5 {
            font-size: 1.35rem;
            font-weight: 700;
        }
        .attendance-report-wrap .form-label {
            font-size: 1.12rem;
            font-weight: 500;
        }
        .attendance-report-wrap .form-control,
        .attendance-report-wrap .form-select,
        .attendance-report-wrap .btn,
        .attendance-report-wrap table th,
        .attendance-report-wrap table td,
        .attendance-report-wrap .badge {
            font-size: 1.05rem;
        }
        @media (max-width: 768px) {
            .attendance-report-wrap .card-header h5 {
                font-size: 1.18rem;
            }
            .attendance-report-wrap .form-label,
            .attendance-report-wrap .form-control,
            .attendance-report-wrap .form-select,
            .attendance-report-wrap .btn,
            .attendance-report-wrap table th,
            .attendance-report-wrap table td,
            .attendance-report-wrap .badge {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="container-fluid mt-4 attendance-report-wrap">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Attendance Report</h5>
                </div>
                <div class="card-body">
                    <!-- Filters -->
                    <form id="filterForm" class="row g-3 mb-4">
                        <div class="col-md-2">
                            <label class="form-label">From Date:</label>
                            <input type="date" name="fromDate" class="form-control" value="<%=fromDate%>" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">To Date:</label>
                            <input type="date" name="toDate" class="form-control" value="<%=toDate%>" required>
                        </div>
                        <%if(isAdmin) {%>
                        <div class="col-md-3">
                            <label class="form-label">Filter by User:</label>
                            <select name="userId" class="form-select" id="userSelect">
                                <option value="">-- All Users --</option>
                            </select>
                        </div>
                        <%}%>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-1"></i>Search
                            </button>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="button" class="btn btn-success w-100" onclick="exportToExcel()">
                                <i class="fas fa-download me-1"></i>Export
                            </button>
                        </div>
                    </form>

                    <!-- Report Table -->
                    <div class="table-responsive">
                        <table id="attendanceTable" class="table table-hover table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>S.No</th>
                                    <%if(isAdmin) {%><th>User</th><%}%>
                                    <th>Date</th>
                                    <th>Check In</th>
                                    <th>Check Out</th>
                                    <th>Duration</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody id="reportTbody">
                                <tr><td colspan="7" class="text-center text-muted py-4">Loading...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
const contextPath = '<%=contextPath%>';
const isAdmin = <%=isAdmin%>;
const currentUid = <%=uid%>;

function loadReport() {
    const form = document.getElementById('filterForm');
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);
    
    fetch(contextPath + '/attendance/getAttendanceReport.jsp?' + params.toString())
        .then(r => r.json())
        .then(data => renderReport(data))
        .catch(err => {
            document.getElementById('reportTbody').innerHTML = 
                '<tr><td colspan="7" class="text-center text-danger py-4">Error loading report</td></tr>';
        });
}

function renderReport(data) {
    const tbody = document.getElementById('reportTbody');
    
    if (!data || data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted py-4">No records found</td></tr>';
        return;
    }

    tbody.innerHTML = data.map((row, i) => {
        let duration = '-';
        if (row.inTime && row.outTime) {
            const inParts = row.inTime.split(':');
            const outParts = row.outTime.split(':');
            const inMins = parseInt(inParts[0]) * 60 + parseInt(inParts[1]);
            const outMins = parseInt(outParts[0]) * 60 + parseInt(outParts[1]);
            const diffMins = outMins - inMins;
            const hours = Math.floor(diffMins / 60);
            const mins = diffMins % 60;
            duration = hours + 'h ' + mins + 'm';
        }

        let status = '<span class="badge bg-warning">Pending Out</span>';
        if (row.inTime && row.outTime) {
            status = '<span class="badge bg-success">Completed</span>';
        } else if (!row.inTime) {
            status = '<span class="badge bg-secondary">Not Marked</span>';
        }

        return `<tr>
            <td>${i + 1}</td>
            ${isAdmin ? `<td>${row.userName}</td>` : ''}
            <td>${row.date}</td>
            <td>${row.inTime || '-'}</td>
            <td>${row.outTime || '-'}</td>
            <td>${duration}</td>
            <td>${status}</td>
        </tr>`;
    }).join('');
}

function exportToExcel() {
    const table = document.getElementById('attendanceTable');
    const html = '<html><body>' + table.outerHTML + '</body></html>';
    const blob = new Blob([html], { type: 'application/vnd.ms-excel' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'attendance_report.xls';
    link.click();
}

if (isAdmin) {
    // Load users dropdown
    fetch(contextPath + '/getAllUsers.jsp')
        .then(r => {
            if (!r.ok) throw new Error('Failed to load users: ' + r.status);
            return r.json();
        })
        .then(users => {
            const select = document.getElementById('userSelect');
            if (users && users.length > 0) {
                users.forEach(u => {
                    const opt = document.createElement('option');
                    opt.value = u.id;
                    opt.text = u.name;
                    select.appendChild(opt);
                });
            }
        })
        .catch(err => {
            console.error('Error loading users:', err);
        });
}

document.getElementById('filterForm').addEventListener('submit', function(e) {
    e.preventDefault();
    loadReport();
});

// Initial load
loadReport();
</script>
</body>
</html>
