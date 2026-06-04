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
String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance Edit</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        body { background:#f0f2f5; }
        .ae-wrap { max-width:900px; margin:32px auto; padding:0 16px 60px; }

        .ae-header {
            background:#1c1c2e; color:#fff; border-radius:16px 16px 0 0;
            padding:18px 24px; display:flex; align-items:center; gap:12px;
        }
        .ae-header h4 { margin:0; font-size:18px; font-weight:800; }

        .ae-body {
            background:#fff; border-radius:0 0 16px 16px;
            padding:24px; box-shadow:0 4px 20px rgba(0,0,0,.08);
        }

        .filter-row { display:flex; flex-wrap:wrap; gap:12px; align-items:flex-end; margin-bottom:24px; }
        .filter-group { display:flex; flex-direction:column; gap:4px; }
        .filter-group label { font-size:11px; font-weight:700; text-transform:uppercase; color:#64748b; letter-spacing:.4px; }
        .filter-group input, .filter-group select {
            border:1.5px solid #e2e8f0; border-radius:9px; padding:8px 12px;
            font-size:13px; outline:none; background:#f8fafc; min-width:180px;
        }
        .filter-group input:focus, .filter-group select:focus { border-color:#f5a623; }

        .btn-load {
            background:#1c1c2e; color:#fff; border:none; border-radius:9px;
            padding:9px 20px; font-size:13px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; gap:6px;
        }
        .btn-load:hover { background:#f5a623; color:#1c1c2e; }

        #editSection { display:none; }

        .emp-banner {
            background:#f0fdf4; border:1.5px solid #86efac; border-radius:12px;
            padding:12px 18px; margin-bottom:20px;
            display:flex; align-items:center; gap:10px;
            font-weight:700; color:#166534; font-size:14px;
        }

        .shifts-edit-grid { display:grid; grid-template-columns:1fr 1fr 1fr; gap:16px; margin-bottom:22px; }
        @media(max-width:700px){ .shifts-edit-grid { grid-template-columns:1fr; } }
        @media(max-width:900px) and (min-width:701px) { .shifts-edit-grid { grid-template-columns:1fr 1fr; } }

        .shift-edit-card {
            background:#f8fafc; border:2px solid #e2e8f0; border-radius:14px; padding:18px;
        }
        .shift-edit-title {
            font-size:12px; font-weight:800; text-transform:uppercase; letter-spacing:.5px;
            color:#64748b; margin-bottom:14px; display:flex; align-items:center; gap:7px;
        }
        .shift-dot { width:8px; height:8px; border-radius:50%; flex-shrink:0; }
        .s1-dot { background:#1d4ed8; }
        .s2-dot { background:#854d0e; }
        .s3-dot { background:#7e22ce; }

        .time-field-row { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
        .time-field { display:flex; flex-direction:column; gap:4px; }
        .time-field label { font-size:10px; font-weight:700; color:#94a3b8; text-transform:uppercase; }
        .time-field input {
            border:1.5px solid #e2e8f0; border-radius:8px; padding:8px 10px;
            font-size:14px; font-weight:700; color:#1c1c2e; background:#fff;
            outline:none; width:100%; box-sizing:border-box;
        }
        .time-field input:focus { border-color:#f5a623; }

        .current-badge {
            text-align:center; font-size:11px; color:#f5a623; font-weight:700;
            margin-top:8px; background:#fff8f0; border-radius:6px; padding:4px;
        }

        .remarks-row { margin-bottom:22px; }
        .remarks-row label { font-size:11px; font-weight:700; text-transform:uppercase; color:#64748b; display:block; margin-bottom:5px; }
        .remarks-row textarea {
            width:100%; border:1.5px solid #e2e8f0; border-radius:9px; padding:10px 14px;
            font-size:13px; outline:none; resize:vertical; min-height:70px; box-sizing:border-box;
        }
        .remarks-row textarea:focus { border-color:#f5a623; }

        .action-row { display:flex; gap:12px; align-items:center; }
        .btn-save {
            background:#22c55e; color:#fff; border:none; border-radius:10px;
            padding:11px 28px; font-size:14px; font-weight:800; cursor:pointer;
            display:inline-flex; align-items:center; gap:8px;
        }
        .btn-save:hover { background:#16a34a; }
        .btn-cancel {
            background:#f1f5f9; color:#64748b; border:none; border-radius:10px;
            padding:11px 20px; font-size:14px; font-weight:700; cursor:pointer;
        }
        .btn-cancel:hover { background:#e2e8f0; }

        .info-note {
            background:#eff6ff; border:1.5px solid #bfdbfe; border-radius:10px;
            padding:11px 16px; font-size:12px; color:#1d4ed8; margin-bottom:20px;
            display:flex; align-items:center; gap:8px;
        }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="ae-wrap">
    <div class="ae-header">
        <i class="fas fa-user-edit" style="color:#f5a623;font-size:20px"></i>
        <h4>Attendance Edit</h4>
    </div>
    <div class="ae-body">

        <div class="info-note">
            <i class="fas fa-info-circle"></i>
            Select an employee and date to load their attendance. All edits are logged with timestamp and reason.
        </div>

        <!-- Filter -->
        <div class="filter-row">
            <div class="filter-group">
                <label>Date</label>
                <input type="date" id="editDate" value="<%=today%>">
            </div>
            <div class="filter-group">
                <label>Employee</label>
                <select id="empSelect">
                    <option value="">-- Select Employee --</option>
                </select>
            </div>
            <button class="btn-load" onclick="loadAttendance()">
                <i class="fas fa-search"></i> Load
            </button>
        </div>

        <!-- Edit Section -->
        <div id="editSection">
            <div class="emp-banner">
                <i class="fas fa-user-circle" style="font-size:18px"></i>
                <span id="empBannerText"></span>
            </div>

            <div class="shifts-edit-grid">
                <!-- Shift 1 -->
                <div class="shift-edit-card">
                    <div class="shift-edit-title"><span class="shift-dot s1-dot"></span> Shift 1 — Morning</div>
                    <div class="time-field-row">
                        <div class="time-field">
                            <label>In Time</label>
                            <input type="time" id="in1">
                        </div>
                        <div class="time-field">
                            <label>Out Time</label>
                            <input type="time" id="out1">
                        </div>
                    </div>
                    <div class="current-badge" id="orig1"></div>
                </div>
                <!-- Shift 2 -->
                <div class="shift-edit-card">
                    <div class="shift-edit-title"><span class="shift-dot s2-dot"></span> Shift 2 — Evening</div>
                    <div class="time-field-row">
                        <div class="time-field">
                            <label>In Time</label>
                            <input type="time" id="in2">
                        </div>
                        <div class="time-field">
                            <label>Out Time</label>
                            <input type="time" id="out2">
                        </div>
                    </div>
                    <div class="current-badge" id="orig2"></div>
                </div>
                <!-- Shift 3 -->
                <div class="shift-edit-card">
                    <div class="shift-edit-title"><span class="shift-dot s3-dot"></span> Shift 3 — Night</div>
                    <div class="time-field-row">
                        <div class="time-field">
                            <label>In Time</label>
                            <input type="time" id="in3">
                        </div>
                        <div class="time-field">
                            <label>Out Time</label>
                            <input type="time" id="out3">
                        </div>
                    </div>
                    <div class="current-badge" id="orig3"></div>
                </div>
            </div>

            <div class="remarks-row">
                <label><i class="fas fa-comment-alt me-1"></i> Reason for Edit <span style="color:#dc2626">*</span></label>
                <textarea id="editRemarks" placeholder="Enter reason for editing attendance (required)…"></textarea>
            </div>

            <div class="action-row">
                <button class="btn-save" onclick="saveEdit()">
                    <i class="fas fa-save"></i> Save Changes
                </button>
                <button class="btn-cancel" onclick="cancelEdit()">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
        </div>
    </div>
</div>

<script>
const contextPath = '<%=contextPath%>';

// Load employees
fetch(contextPath + '/getAllUsers.jsp').then(r => r.json()).then(users => {
    const sel = document.getElementById('empSelect');
    (users || []).forEach(u => {
        const o = document.createElement('option');
        o.value = u.id; o.text = u.name;
        sel.appendChild(o);
    });
}).catch(() => {});

function loadAttendance() {
    const date  = document.getElementById('editDate').value;
    const empId = document.getElementById('empSelect').value;
    if (!date)  { Swal.fire('Missing', 'Please select a date', 'warning'); return; }
    if (!empId) { Swal.fire('Missing', 'Please select an employee', 'warning'); return; }

    fetch(contextPath + '/admin/attendanceEdit/getForEdit.jsp?date=' + encodeURIComponent(date) + '&userId=' + encodeURIComponent(empId))
        .then(r => r.json())
        .then(data => {
            const empName = document.getElementById('empSelect').options[document.getElementById('empSelect').selectedIndex].text;
            document.getElementById('empBannerText').textContent = empName + ' — ' + date;

            document.getElementById('in1').value  = data.in1  || '';
            document.getElementById('out1').value = data.out1 || '';
            document.getElementById('in2').value  = data.in2  || '';
            document.getElementById('out2').value = data.out2 || '';
            document.getElementById('in3').value  = data.in3  || '';
            document.getElementById('out3').value = data.out3 || '';

            document.getElementById('orig1').textContent = data.found ? ('Current: ' + (data.in1||'—') + ' → ' + (data.out1||'—')) : 'No record found — will create new';
            document.getElementById('orig2').textContent = data.found ? ('Current: ' + (data.in2||'—') + ' → ' + (data.out2||'—')) : '';
            document.getElementById('orig3').textContent = data.found ? ('Current: ' + (data.in3||'—') + ' → ' + (data.out3||'—')) : '';

            document.getElementById('editRemarks').value = '';
            document.getElementById('editSection').style.display = 'block';
        })
        .catch(() => { Swal.fire('Error', 'Failed to load attendance data', 'error'); });
}

function saveEdit() {
    const date    = document.getElementById('editDate').value;
    const empId   = document.getElementById('empSelect').value;
    const remarks = document.getElementById('editRemarks').value.trim();

    if (!remarks) {
        Swal.fire('Required', 'Please enter a reason for the edit', 'warning');
        return;
    }

    const body = new URLSearchParams({
        date,
        userId: empId,
        in1:   document.getElementById('in1').value,
        out1:  document.getElementById('out1').value,
        in2:   document.getElementById('in2').value,
        out2:  document.getElementById('out2').value,
        in3:   document.getElementById('in3').value,
        out3:  document.getElementById('out3').value,
        remarks
    });

    fetch(contextPath + '/admin/attendanceEdit/saveEdit.jsp', { method: 'POST', body })
        .then(r => r.json())
        .then(res => {
            if (res.success) {
                Swal.fire({ icon: 'success', title: 'Saved', text: 'Attendance updated and logged successfully' })
                    .then(() => cancelEdit());
            } else {
                Swal.fire('Error', res.message || 'Save failed', 'error');
            }
        })
        .catch(() => { Swal.fire('Error', 'Network error', 'error'); });
}

function cancelEdit() {
    document.getElementById('editSection').style.display = 'none';
    document.getElementById('empSelect').value = '';
}
</script>
</body>
</html>
