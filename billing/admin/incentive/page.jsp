<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.text.SimpleDateFormat,java.util.Date" %>
<jsp:useBean id="user" class="user.userBean" />
<%
String contextPath = request.getContextPath();
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { response.sendRedirect(contextPath + "/index.jsp"); return; }

Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0; i<vecPer.size(); i++) {
    Vector cat = (Vector) vecPer.get(i);
    permissions.add(Integer.parseInt(cat.elementAt(0).toString()));
}
if (!permissions.contains(7)) {
    out.print("<script>alert('Access Denied');window.location='" + contextPath + "/';</script>");
    return;
}

String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Incentive Entry</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        body { background:#f3f5f8; }
        .inc-page { max-width:760px; margin:36px auto; padding:0 16px 40px; }
        .inc-card {
            background:#fff;
            border-radius:14px;
            padding:26px;
            box-shadow:0 8px 24px rgba(15, 23, 42, 0.08);
        }
        .inc-title { margin:0 0 20px; font-size:22px; font-weight:800; color:#0f172a; }
        .form-group { margin-bottom:16px; }
        .form-label {
            display:block;
            margin-bottom:6px;
            font-size:12px;
            font-weight:700;
            color:#334155;
            text-transform:uppercase;
            letter-spacing:0.4px;
        }
        .required { color:#dc2626; }
        .form-control, .form-select {
            width:100%;
            border:1px solid #cbd5e1;
            border-radius:10px;
            padding:10px 12px;
            font-size:14px;
            background:#fff;
        }
        .form-control:focus, .form-select:focus {
            border-color:#0f766e;
            outline:none;
            box-shadow:0 0 0 3px rgba(15, 118, 110, 0.12);
        }
        textarea.form-control { min-height:90px; resize:vertical; }
        .alert {
            display:none;
            border-radius:10px;
            padding:12px 14px;
            margin-bottom:16px;
            font-weight:600;
            font-size:14px;
        }
        .alert.show { display:block; }
        .alert.success { background:#dcfce7; color:#166534; }
        .alert.error { background:#fee2e2; color:#991b1b; }
        .actions { margin-top:20px; }
        .btn-submit {
            border:none;
            border-radius:10px;
            background:#0f766e;
            color:#fff;
            font-weight:700;
            padding:11px 22px;
            cursor:pointer;
        }
        .btn-submit:disabled { opacity:0.6; cursor:not-allowed; }
        .btn-reset {
            border:none;
            border-radius:10px;
            margin-left:8px;
            background:#e2e8f0;
            color:#1e293b;
            font-weight:700;
            padding:11px 22px;
            cursor:pointer;
        }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="inc-page">
    <div class="inc-card">
        <h2 class="inc-title"><i class="fas fa-trophy"></i> Incentive Entry</h2>

        <div id="alertBox" class="alert"></div>

        <form id="incentiveForm">
            <div class="form-group">
                <label class="form-label">User <span class="required">*</span></label>
                <select id="userId" name="userId" class="form-select" required>
                    <option value="">Select user</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Amount <span class="required">*</span></label>
                <input type="number" id="amount" name="amount" class="form-control" step="0.01" min="0.01" required>
            </div>

            <div class="form-group">
                <label class="form-label">Reason <span class="required">*</span></label>
                <input type="text" id="reason" name="reason" class="form-control" maxlength="255" required>
            </div>

            <div class="form-group">
                <label class="form-label">Notes</label>
                <textarea id="notes" name="notes" class="form-control"></textarea>
            </div>

            <div class="form-group">
                <label class="form-label">Date <span class="required">*</span></label>
                <input type="date" id="entryDate" name="entryDate" class="form-control" value="<%=todayDate%>" required>
            </div>

            <div class="actions">
                <button type="submit" id="submitBtn" class="btn-submit"><i class="fas fa-save"></i> Save Incentive</button>
                <button type="reset" class="btn-reset">Reset</button>
            </div>
        </form>
    </div>
</div>

<script>
const contextPath = '<%=contextPath%>';
const todayDate = '<%=todayDate%>';

document.addEventListener('DOMContentLoaded', function() {
    loadUsers();

    document.getElementById('incentiveForm').addEventListener('submit', submitForm);
});

function loadUsers() {
    fetch(contextPath + '/getAllUsers.jsp')
        .then(function(response) { return response.json(); })
        .then(function(users) {
            const select = document.getElementById('userId');
            select.innerHTML = '<option value="">Select user</option>';

            users.forEach(function(u) {
                const opt = document.createElement('option');
                opt.value = String(u.id);
                opt.textContent = u.name;
                select.appendChild(opt);
            });
        })
        .catch(function() {
            showAlert('Failed to load users', 'error');
        });
}

function submitForm(e) {
    e.preventDefault();

    const submitBtn = document.getElementById('submitBtn');
    const userId = document.getElementById('userId').value;
    const amount = document.getElementById('amount').value;
    const reason = document.getElementById('reason').value;
    const notes = document.getElementById('notes').value;
    const entryDate = document.getElementById('entryDate').value;

    if (!userId) { showAlert('Please select a user', 'error'); return; }
    if (!amount || Number(amount) <= 0) { showAlert('Please enter valid amount', 'error'); return; }
    if (!reason || reason.trim() === '') { showAlert('Please enter reason', 'error'); return; }
    if (!entryDate) { showAlert('Please select date', 'error'); return; }

    const body = new URLSearchParams();
    body.append('userId', userId);
    body.append('amount', amount);
    body.append('reason', reason.trim());
    body.append('notes', notes);
    body.append('entryDate', entryDate);

    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';

    fetch(contextPath + '/admin/incentive/saveIncentive.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: body.toString()
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
        if (data.success) {
            showAlert(data.message || 'Incentive saved successfully', 'success');
            document.getElementById('incentiveForm').reset();
            document.getElementById('entryDate').value = todayDate;
            document.getElementById('userId').value = '';
        } else {
            showAlert(data.message || 'Failed to save incentive', 'error');
        }
    })
    .catch(function() {
        showAlert('Request failed while saving incentive', 'error');
    })
    .finally(function() {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="fas fa-save"></i> Save Incentive';
    });
}

function showAlert(message, type) {
    const alertBox = document.getElementById('alertBox');
    alertBox.className = 'alert ' + type + ' show';
    alertBox.textContent = message;
}
</script>
</body>
</html>
