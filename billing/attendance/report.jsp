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
                    <option value="">â€” All Users â€”</option>
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

function minsToStr(m) { return m>0 ? Math.floor(m/60)+'h '+(m%60)+'m' : 'â€”'; }
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
            <td>${row.in1||'<span style="color:#cbd5e1">â€”</span>'}</td>
            <td>${row.out1||'<span style="color:#cbd5e1">â€”</span>'}</td>
            <td>${m1>0?'<span class="dur-chip">'+minsToStr(m1)+'</span>':'â€”'}</td>
            <td>${row.in2||'<span style="color:#cbd5e1">â€”</span>'}</td>
            <td>${row.out2||'<span style="color:#cbd5e1">â€”</span>'}</td>
            <td>${m2>0?'<span class="dur-chip">'+minsToStr(m2)+'</span>':'â€”'}</td>
            <td class="total-dur">${tot>0?minsToStr(tot):'â€”'}</td>
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
