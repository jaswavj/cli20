<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.text.SimpleDateFormat,java.util.Date" %>
<jsp:useBean id="user" class="user.userBean" />
<jsp:useBean id="bill" class="billing.billingBean" />
<%
String contextPath = request.getContextPath();
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { response.sendRedirect(contextPath + "/index.jsp"); return; }

Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0;i<vecPer.size();i++){Vector cat=(Vector)vecPer.get(i);permissions.add(Integer.parseInt(cat.elementAt(0).toString()));}
if (!permissions.contains(13)) { 
    out.print("<script>alert('Access Denied');window.location='"+contextPath+"/';</script>"); 
    return; 
}

// Date parameters
String fromDate = request.getParameter("fromDate");
String toDate   = request.getParameter("toDate");
String filterUserId = request.getParameter("userId");

if (fromDate==null) fromDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
if (toDate==null)   toDate   = fromDate;

// Fetch incentive data using billingBean
Vector incentiveList = bill.getIncentiveReport(fromDate, toDate, filterUserId);
double totalAmount = bill.getIncentiveTotal(fromDate, toDate, filterUserId);
int totalRecords = bill.getIncentiveCount(fromDate, toDate, filterUserId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Incentive Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        body { background:#f0f2f5; }
        .rpt-wrap { max-width:1200px; margin:32px auto; padding:0 16px 40px; }

        .rpt-header {
            background:#1c1c2e; color:#fff; border-radius:16px 16px 0 0;
            padding:18px 24px; display:flex; align-items:center; justify-content:space-between; gap:12px;
        }
        .rpt-header h4 { 
            margin:0; font-size:18px; font-weight:800;
            display:flex; align-items:center; gap:10px;
        }

        .rpt-body { 
            background:#fff; border-radius:0 0 16px 16px; 
            padding:24px; box-shadow:0 4px 20px rgba(0,0,0,.08); 
        }

        .filter-row { 
            display:flex; flex-wrap:wrap; gap:12px; align-items:flex-end; 
            margin-bottom:24px; padding-bottom:20px; border-bottom:2px solid #f1f5f9;
        }
        .filter-group { display:flex; flex-direction:column; gap:4px; }
        .filter-group label { 
            font-size:11px; font-weight:700; text-transform:uppercase; 
            color:#64748b; letter-spacing:.4px; 
        }
        .filter-group input, .filter-group select {
            border:1.5px solid #e2e8f0; border-radius:9px; padding:8px 12px;
            font-size:13px; outline:none; background:#f8fafc;
        }
        .filter-group input:focus, .filter-group select:focus { border-color:#f5a623; }
        
        .btn-search {
            background:#1c1c2e; color:#fff; border:none; border-radius:9px;
            padding:9px 20px; font-size:13px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; gap:6px; transition:all .2s;
        }
        .btn-search:hover { background:#f5a623; color:#1c1c2e; }
        
        .btn-export {
            background:#dcfce7; color:#166534; border:none; border-radius:9px;
            padding:9px 18px; font-size:13px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; gap:6px; transition:all .2s;
        }
        .btn-export:hover { background:#bbf7d0; }

        /* Summary pills */
        .summary-row { display:flex; gap:14px; flex-wrap:wrap; margin-bottom:20px; }
        .sum-pill {
            background:#f8fafc; border-radius:12px; padding:14px 20px;
            display:flex; flex-direction:column; align-items:center; min-width:120px;
            border:2px solid #e2e8f0;
        }
        .sum-pill .s-val { font-size:24px; font-weight:800; color:#1c1c2e; }
        .sum-pill .s-lbl { 
            font-size:10px; color:#94a3b8; font-weight:700; 
            text-transform:uppercase; margin-top:4px; 
        }
        .sum-pill.total { border-color:#f5a623; background:#fff8f0; }
        .sum-pill.total .s-val { color:#f5a623; }

        /* Table */
        .rpt-table-wrap { overflow-x:auto; }
        table { width:100%; border-collapse:collapse; font-size:13px; }
        thead th {
            background:#1c1c2e; color:#fff; padding:12px 14px;
            font-size:11px; font-weight:700; text-transform:uppercase; 
            letter-spacing:.4px; white-space:nowrap;
        }
        thead th:first-child { border-radius:8px 0 0 0; }
        thead th:last-child  { border-radius:0 8px 0 0; }
        tbody tr { border-bottom:1px solid #f1f5f9; }
        tbody tr:hover { background:#fafafa; }
        tbody td { padding:11px 14px; color:#1e293b; }
        
        .amount-badge {
            background:#dcfce7; color:#166534; padding:5px 12px;
            border-radius:20px; font-weight:700; font-size:13px;
            display:inline-block;
        }
        
        .user-badge {
            background:#dbeafe; color:#1d4ed8; padding:4px 10px;
            border-radius:16px; font-weight:600; font-size:12px;
            display:inline-block;
        }
        
        .date-cell {
            font-weight:600; color:#1c1c2e;
        }
        
        .notes-cell {
            max-width:200px; color:#64748b; font-size:12px;
        }
        
        .no-data { 
            text-align:center; padding:60px 20px; color:#94a3b8; 
            font-size:14px;
        }
        .no-data i { font-size:48px; margin-bottom:16px; opacity:.4; }

        @media(max-width:768px) {
            .rpt-wrap { margin:20px auto; }
            .filter-row { flex-direction:column; align-items:stretch; }
            .filter-group { width:100%; }
            .btn-search, .btn-export { width:100%; justify-content:center; }
        }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="rpt-wrap">
    <div class="rpt-header">
        <h4>
            <i class="fas fa-trophy" style="color:#f5a623"></i>
            Incentive Report
        </h4>
    </div>

    <div class="rpt-body">
        <!-- Filters -->
        <form method="GET" action="">
            <div class="filter-row">
                <div class="filter-group">
                    <label>From Date</label>
                    <input type="date" name="fromDate" value="<%=fromDate%>" required>
                </div>
                
                <div class="filter-group">
                    <label>To Date</label>
                    <input type="date" name="toDate" value="<%=toDate%>" required>
                </div>
                
                <div class="filter-group">
                    <label>User</label>
                    <select name="userId" id="userFilter">
                        <option value="all">All Users</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <button type="submit" class="btn-search">
                        <i class="fas fa-search"></i>
                        Search
                    </button>
                </div>
                
                <div class="filter-group">
                    <button type="button" class="btn-export" onclick="exportToExcel()">
                        <i class="fas fa-file-excel"></i>
                        Export
                    </button>
                </div>
            </div>
        </form>

        <!-- Summary -->
        <div class="summary-row">
            <div class="sum-pill">
                <div class="s-val"><%=totalRecords%></div>
                <div class="s-lbl">Total Records</div>
            </div>
            <div class="sum-pill total">
                <div class="s-val">₹<%=String.format("%.2f", totalAmount)%></div>
                <div class="s-lbl">Total Amount</div>
            </div>
            <% if (totalRecords > 0) { %>
            <div class="sum-pill">
                <div class="s-val">₹<%=String.format("%.2f", totalAmount / totalRecords)%></div>
                <div class="s-lbl">Average Amount</div>
            </div>
            <% } %>
        </div>

        <!-- Table -->
        <div class="rpt-table-wrap">
            <% if (incentiveList.isEmpty()) { %>
            <div class="no-data">
                <div><i class="fas fa-inbox"></i></div>
                <div>No incentive records found for the selected period</div>
            </div>
            <% } else { %>
            <table id="incentiveTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Date</th>
                        <th>User</th>
                        <th>Amount</th>
                        <th>Reason</th>
                        <th>Notes</th>
                        <th>Created By</th>
                        <th>Created At</th>
                    </tr>
                </thead>
                <tbody>
                <%
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
                SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
                
                for (int i = 0; i < incentiveList.size(); i++) {
                    Vector row = (Vector)incentiveList.get(i);
                    // Vector elements: 0=id, 1=user_id, 2=user_name, 3=amount, 4=reason, 5=notes,
                    //                  6=entry_date, 7=created_at, 8=created_by, 9=created_by_name
                %>
                <tr>
                    <td><%=i+1%></td>
                    <td class="date-cell"><%=dateFormat.format((Date)row.get(6))%></td>
                    <td><span class="user-badge"><%=row.get(2)%></span></td>
                    <td><span class="amount-badge">₹<%=String.format("%.2f", (Double)row.get(3))%></span></td>
                    <td><%=row.get(4)%></td>
                    <td class="notes-cell">
                        <%=row.get(5) != null && !row.get(5).toString().isEmpty() ? row.get(5) : "-"%>
                    </td>
                    <td><%=row.get(9)%></td>
                    <td style="font-size:11px;color:#94a3b8;">
                        <%=dateTimeFormat.format((Date)row.get(7))%>
                    </td>
                </tr>
                <%
                }
                %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

<script>
// Load users for filter
document.addEventListener('DOMContentLoaded', function() {
    fetch('<%=contextPath%>/getAllUsers.jsp')
        .then(response => response.json())
        .then(users => {
            const userFilter = document.getElementById('userFilter');
            const currentUserId = '<%=filterUserId != null ? filterUserId : ""%>';
            
            users.forEach(user => {
                const option = document.createElement('option');
                option.value = user.id;
                option.textContent = user.name;
                if (user.id.toString() === currentUserId) {
                    option.selected = true;
                }
                userFilter.appendChild(option);
            });
        })
        .catch(error => console.error('Error loading users:', error));
});

// Export to Excel
function exportToExcel() {
    const table = document.getElementById('incentiveTable');
    if (!table) {
        alert('No data to export');
        return;
    }
    
    let html = '<html><head><meta charset="UTF-8"></head><body>';
    html += '<h2>Incentive Report</h2>';
    html += '<p>Period: <%=fromDate%> to <%=toDate%></p>';
    html += '<p>Total Records: <%=totalRecords%> | Total Amount: ₹<%=String.format("%.2f", totalAmount)%></p>';
    html += table.outerHTML;
    html += '</body></html>';
    
    const blob = new Blob([html], { type: 'application/vnd.ms-excel' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'incentive_report_<%=fromDate%>_to_<%=toDate%>.xls';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
}
</script>

</body>
</html>
