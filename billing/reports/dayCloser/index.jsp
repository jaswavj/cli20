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
if (!permissions.contains(14)) { out.print("<script>alert('Access Denied');window.location='"+contextPath+"/';</script>"); return; }
String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Day Closer</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        body { background:#f0f2f5; }
        .dc-wrap { max-width:900px; margin:32px auto; padding:0 16px 60px; }

        .dc-header {
            background:#1c1c2e; color:#fff; border-radius:16px 16px 0 0;
            padding:18px 24px; display:flex; align-items:center; justify-content:space-between; gap:12px;
        }
        .dc-header h4 { margin:0; font-size:18px; font-weight:800; }

        .dc-body { background:#fff; border-radius:0 0 16px 16px; padding:24px; box-shadow:0 4px 20px rgba(0,0,0,.08); }

        /* Date bar */
        .date-bar { display:flex; align-items:center; gap:12px; margin-bottom:24px; }
        .date-bar input[type=date] {
            border:2px solid #e2e8f0; border-radius:10px; padding:9px 14px;
            font-size:15px; font-weight:700; background:#f8fafc; outline:none;
        }
        .date-bar input[type=date]:focus { border-color:#f5a623; }
        .btn-load {
            background:#1c1c2e; color:#fff; border:none; border-radius:10px;
            padding:10px 22px; font-size:13px; font-weight:700; cursor:pointer;
        }
        .btn-load:hover { background:#f5a623; color:#1c1c2e; }

        /* Status badge */
        .status-pill {
            font-size:12px; font-weight:800; padding:4px 14px; border-radius:20px;
            display:inline-block; margin-left:8px;
        }
        .pill-open   { background:#dcfce7; color:#166534; }
        .pill-closed { background:#e0f2fe; color:#0369a1; }

        /* Cards grid */
        .cards-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin-bottom:22px; }
        @media(max-width:640px) { .cards-grid { grid-template-columns:1fr 1fr; } }
        @media(max-width:380px) { .cards-grid { grid-template-columns:1fr; } }

        .dc-card {
            border-radius:14px; padding:16px 18px;
            display:flex; flex-direction:column; gap:4px;
            border:2px solid transparent;
        }
        .dc-card .c-lbl { font-size:10px; font-weight:800; text-transform:uppercase; letter-spacing:.5px; color:#64748b; }
        .dc-card .c-val { font-size:22px; font-weight:800; color:#1c1c2e; }
        .dc-card .c-sub { font-size:11px; color:#94a3b8; margin-top:2px; }
        .card-green  { background:#f0fdf4; border-color:#bbf7d0; }
        .card-blue   { background:#eff6ff; border-color:#bfdbfe; }
        .card-yellow { background:#fffbeb; border-color:#fde68a; }
        .card-red    { background:#fff1f2; border-color:#fecdd3; }
        .card-purple { background:#faf5ff; border-color:#e9d5ff; }
        .card-dark   { background:#f1f5f9; border-color:#cbd5e1; }

        /* Closing section */
        .closing-section {
            background:#fafafa; border-radius:14px; padding:20px 22px;
            border:2px solid #e2e8f0; margin-top:4px;
        }
        .closing-section h5 { font-size:14px; font-weight:800; color:#1c1c2e; margin-bottom:16px; }
        .close-form-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        @media(max-width:500px) { .close-form-grid { grid-template-columns:1fr; } }
        .form-grp label { font-size:11px; font-weight:700; text-transform:uppercase; color:#64748b; display:block; margin-bottom:5px; letter-spacing:.4px; }
        .form-grp input, .form-grp textarea {
            width:100%; border:2px solid #e2e8f0; border-radius:10px;
            padding:9px 12px; font-size:14px; font-weight:700; outline:none; background:#fff; box-sizing:border-box;
        }
        .form-grp input:focus, .form-grp textarea:focus { border-color:#f5a623; }
        .form-grp textarea { resize:vertical; min-height:70px; font-weight:400; font-size:13px; }
        .notes-grp { grid-column:1/-1; }

        .btn-settle {
            background:linear-gradient(135deg,#16a34a,#15803d); color:#fff;
            border:none; border-radius:12px; padding:13px 32px;
            font-size:15px; font-weight:800; cursor:pointer; margin-top:18px;
            display:flex; align-items:center; gap:8px; transition:all .15s;
        }
        .btn-settle:hover { transform:translateY(-1px); box-shadow:0 4px 16px rgba(22,163,74,.35); }
        .btn-settle:disabled { opacity:.5; cursor:not-allowed; transform:none; }

        /* Closed view */
        .closed-banner {
            background:#e0f2fe; border:2px solid #7dd3fc; border-radius:14px;
            padding:14px 20px; display:flex; align-items:center; gap:12px;
            font-size:13px; color:#0369a1; font-weight:700; margin-top:4px;
        }
        .meta-row { display:flex; gap:16px; flex-wrap:wrap; margin-top:12px; }
        .meta-item { font-size:12px; color:#64748b; }
        .meta-item strong { color:#1c1c2e; }

        /* Loading / placeholder */
        .dc-placeholder { text-align:center; padding:50px 0; color:#94a3b8; font-size:14px; }

        /* Range report */
        .range-wrap { max-width:900px; margin:0 auto 48px; padding:0 16px; }
        .range-header {
            background:#1c1c2e; color:#fff; border-radius:16px 16px 0 0;
            padding:16px 24px; font-size:15px; font-weight:800;
        }
        .range-body { background:#fff; border-radius:0 0 16px 16px; padding:20px 24px; box-shadow:0 4px 20px rgba(0,0,0,.08); }
        .range-bar { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:18px; }
        .range-bar input[type=date] {
            border:2px solid #e2e8f0; border-radius:10px; padding:8px 12px;
            font-size:14px; font-weight:700; background:#f8fafc; outline:none;
        }
        .range-bar input[type=date]:focus { border-color:#f5a623; }
        .range-bar label { font-size:12px; font-weight:700; color:#64748b; }
        .range-table { width:100%; border-collapse:collapse; font-size:13px; }
        .range-table th { background:#f1f5f9; color:#475569; font-size:11px; text-transform:uppercase; letter-spacing:.4px; padding:9px 12px; text-align:left; border-bottom:2px solid #e2e8f0; }
        .range-table td { padding:9px 12px; border-bottom:1px solid #f1f5f9; color:#334155; }
        .range-table td:not(:first-child) { text-align:right; font-weight:700; }
        .range-table td.fw { color:#1c1c2e; font-weight:800; }
        .range-table tr.total-row td { background:#fffbeb; font-weight:800; color:#1c1c2e; border-top:2px solid #fde68a; }
        .range-table tr:hover td { background:#f8fafc; }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="dc-wrap">
    <div class="dc-header">
        <h4><i class="fas fa-calendar-check me-2" style="color:#f5a623"></i>Day Closer</h4>
        <span id="statusBadge"></span>
    </div>
    <div class="dc-body">
        <!-- Date selector -->
        <div class="date-bar">
            <input type="date" id="selDate" value="<%=today%>" max="<%=today%>">
            <button class="btn-load" onclick="loadDay()">
                <i class="fas fa-search me-1"></i> Load
            </button>
        </div>

        <div id="dcContent">
            <div class="dc-placeholder"><i class="fas fa-calendar-day fa-2x mb-3 d-block"></i>Select a date and click Load</div>
        </div>
    </div>
</div>

<!-- Date Range Report -->
<div class="range-wrap">
    <div class="range-header">
        <i class="fas fa-chart-bar me-2" style="color:#f5a623"></i>Date Range Summary
    </div>
    <div class="range-body">
        <div class="range-bar">
            <label>From</label>
            <input type="date" id="rangeFrom" value="<%=today%>">
            <label>To</label>
            <input type="date" id="rangeTo" value="<%=today%>">
            <button class="btn-load" onclick="loadRange()">
                <i class="fas fa-search me-1"></i> Load
            </button>
        </div>
        <div id="rangeContent">
            <div style="text-align:center;padding:24px;color:#94a3b8;font-size:13px">
                <i class="fas fa-chart-bar fa-2x mb-2 d-block"></i>Select date range and click Load
            </div>
        </div>
    </div>
</div>

<!-- Opening Balance Modal -->
<div class="modal fade" id="openingModal" tabindex="-1" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered" style="max-width:400px">
        <div class="modal-content" style="border-radius:20px;border:none;">
            <div class="modal-body p-4">
                <div style="text-align:center;margin-bottom:20px">
                    <div style="width:56px;height:56px;background:#fff8f0;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;margin-bottom:12px">
                        <i class="fas fa-wallet fa-lg" style="color:#f5a623"></i>
                    </div>
                    <h5 style="font-weight:800;color:#1c1c2e;margin-bottom:4px">Enter Opening Balance</h5>
                    <p id="openModalDate" style="font-size:13px;color:#64748b;margin:0"></p>
                </div>
                <div class="form-grp mb-3">
                    <label>Opening Balance (₹)</label>
                    <input type="number" id="openingAmtInput" placeholder="0.00" min="0" step="0.01">
                </div>
                <button class="btn-settle w-100 justify-content-center" id="btnSaveOpening" onclick="saveOpening()">
                    <i class="fas fa-check-circle"></i> Confirm & Open Day
                </button>
            </div>
        </div>
    </div>
</div>

<script>
const contextPath = '<%=contextPath%>';
let currentData = null;

function fmt(n) {
    return '₹' + parseFloat(n||0).toLocaleString('en-IN',{minimumFractionDigits:2,maximumFractionDigits:2});
}

function loadDay() {
    const date = document.getElementById('selDate').value;
    if (!date) return;
    document.getElementById('dcContent').innerHTML =
        '<div class="dc-placeholder"><i class="fas fa-spinner fa-spin fa-2x mb-3 d-block"></i>Loading...</div>';
    document.getElementById('statusBadge').innerHTML = '';

    fetch(contextPath + '/reports/dayCloser/getStatus.jsp?date=' + date)
        .then(r => r.json())
        .then(data => {
            if (data.error) {
                document.getElementById('dcContent').innerHTML =
                    '<div class="dc-placeholder text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2 d-block"></i>' + data.error + '</div>';
                return;
            }
            currentData = data;
            const today = new Date().toISOString().slice(0,10);
            const isToday = (date === today);
            if (data.status === 'no_entry') {
                if (isToday) {
                    // Today — must enter opening balance first
                    document.getElementById('openModalDate').textContent = 'Date: ' + date;
                    document.getElementById('openingAmtInput').value = '';
                    document.getElementById('dcContent').innerHTML =
                        '<div class="dc-placeholder"><i class="fas fa-lock-open fa-2x mb-2 d-block" style="color:#f5a623"></i>' +
                        'No opening balance for this date. Enter it below.</div>';
                    new bootstrap.Modal(document.getElementById('openingModal')).show();
                } else {
                    // Back date — show report with 0 opening, allow settle
                    data.openingBal = 0; data.cashInHand = parseFloat(data.cashSale||0) + parseFloat(data.dueCash||0) - parseFloat(data.expense||0) - parseFloat(data.purchasePayCash||0);
                    data.cashInBank = parseFloat(data.bankSale||0) + parseFloat(data.dueBank||0) - parseFloat(data.purchasePayBank||0);
                    renderDashboard(data, date);
                }
            } else {
                renderDashboard(data, date);
            }
        })
        .catch(() => {
            document.getElementById('dcContent').innerHTML =
                '<div class="dc-placeholder text-danger"><i class="fas fa-exclamation-triangle fa-2x mb-2 d-block"></i>Request failed</div>';
        });
}

function renderDashboard(d, date) {
    const isClosed = d.status === 'closed';
    document.getElementById('statusBadge').innerHTML =
        isClosed ? '<span class="status-pill pill-closed"><i class="fas fa-check-circle me-1"></i>Closed</span>'
                 : '<span class="status-pill pill-open"><i class="fas fa-circle me-1"></i>Open</span>';

    let html = `
    <div class="cards-grid">
        <div class="dc-card card-green">
            <div class="c-lbl">Opening Balance</div>
            <div class="c-val">${fmt(d.openingBal)}</div>
            <div class="c-sub">Cash on hand at start</div>
        </div>
        <div class="dc-card card-blue">
            <div class="c-lbl">Total Sales</div>
            <div class="c-val">${fmt(d.totalSale)}</div>
            <div class="c-sub">Cash: ${fmt(d.cashSale)} &nbsp; Bank: ${fmt(d.bankSale)}</div>
        </div>
        <div class="dc-card card-blue" style="background:#f0fdf4;border-color:#bbf7d0">
            <div class="c-lbl">Due Collection</div>
            <div class="c-val">${fmt(parseFloat(d.dueCash||0)+parseFloat(d.dueBank||0))}</div>
            <div class="c-sub">Cash: ${fmt(d.dueCash)} &nbsp; Bank: ${fmt(d.dueBank)}</div>
        </div>
        <div class="dc-card card-yellow">
            <div class="c-lbl">Purchase Payment</div>
            <div class="c-val">${fmt(parseFloat(d.purchasePayCash||0)+parseFloat(d.purchasePayBank||0))}</div>
            <div class="c-sub">Cash: ${fmt(d.purchasePayCash)} &nbsp; Bank: ${fmt(d.purchasePayBank)}</div>
        </div>
        <div class="dc-card card-red">
            <div class="c-lbl">Total Expense</div>
            <div class="c-val">${fmt(d.expense)}</div>
            <div class="c-sub">All expenses for the day</div>
        </div>
        <div class="dc-card card-dark">
            <div class="c-lbl">Cash In Hand</div>
            <div class="c-val">${fmt(d.cashInHand)}</div>
            <div class="c-sub">Opening + Cash Sale + Due Cash − Expense − Purchase Cash</div>
        </div>
        <div class="dc-card card-purple" style="grid-column:1/-1">
            <div class="c-lbl">Cash In Bank</div>
            <div class="c-val">${fmt(d.cashInBank)}</div>
            <div class="c-sub">Bank Sale + Due Bank − Purchase Bank</div>
        </div>
    </div>`;

    if (isClosed) {
        html += `
        <div class="closing-section">
            <h5><i class="fas fa-check-circle me-2" style="color:#16a34a"></i>Day Closed</h5>
            <div class="dc-card card-green" style="margin-bottom:12px">
                <div class="c-lbl">Closing Balance</div>
                <div class="c-val">${fmt(d.closingBal)}</div>
            </div>
            ${d.notes ? `<div style="background:#f8fafc;border-radius:10px;padding:12px 14px;border:1.5px solid #e2e8f0;font-size:13px;color:#475569;margin-bottom:12px"><strong>Notes:</strong> ${d.notes}</div>` : ''}
            <div class="meta-row">
                <div class="meta-item">Opened by <strong>${d.openUser}</strong> at <strong>${d.openDt}</strong></div>
                <div class="meta-item">Closed by <strong>${d.closeUser}</strong> at <strong>${d.closeDt}</strong></div>
            </div>
        </div>`;
    } else {
        html += `
        <div class="closing-section">
            <h5><i class="fas fa-sign-in-alt me-2" style="color:#f5a623"></i>Settle & Close Day</h5>
            <div class="close-form-grid">
                <div class="form-grp">
                    <label>Closing Balance (₹) <span style="color:#dc2626">*</span></label>
                    <input type="number" id="closingBalInput" placeholder="Enter actual cash in hand"
                        value="${parseFloat(d.cashInHand||0).toFixed(2)}" min="0" step="0.01">
                </div>
                <div class="form-grp">
                    <label>Opened by</label>
                    <input type="text" value="${d.openUser}" readonly style="background:#f1f5f9;color:#64748b">
                </div>
                <div class="notes-grp form-grp">
                    <label>Notes / Remarks</label>
                    <textarea id="closingNotes" placeholder="Any remarks for this day...">${d.notes||''}</textarea>
                </div>
            </div>
            <button class="btn-settle" id="btnSettle" onclick="settleDay('${date}',${d.totalSale},${d.purchase},${d.expense})">
                <i class="fas fa-lock"></i> Settle & Close Day
            </button>
        </div>
        <div class="meta-row" style="margin-top:10px;padding:0 2px">
            <div class="meta-item">Opened by <strong>${d.openUser}</strong> at <strong>${d.openDt}</strong></div>
        </div>`;
    }

    document.getElementById('dcContent').innerHTML = html;
}

function saveOpening() {
    const date   = document.getElementById('selDate').value;
    const amount = document.getElementById('openingAmtInput').value;
    if (amount === '' || isNaN(amount)) {
        Swal.fire({icon:'warning',title:'Enter Amount',text:'Please enter the opening balance.',timer:2000,showConfirmButton:false});
        return;
    }
    document.getElementById('btnSaveOpening').disabled = true;
    const params = new URLSearchParams({date, amount});
    fetch(contextPath + '/reports/dayCloser/saveOpening.jsp', {method:'POST', body:params})
        .then(r => r.json())
        .then(res => {
            if (res.success) {
                bootstrap.Modal.getInstance(document.getElementById('openingModal')).hide();
                Swal.fire({icon:'success',title:'Opening Balance Saved',timer:1200,showConfirmButton:false});
                setTimeout(loadDay, 800);
            } else {
                Swal.fire({icon:'error',title:'Error',text:res.message||'Failed'});
                document.getElementById('btnSaveOpening').disabled = false;
            }
        })
        .catch(() => {
            Swal.fire({icon:'error',title:'Error',text:'Request failed'});
            document.getElementById('btnSaveOpening').disabled = false;
        });
}

function settleDay(date, totalSale, purchase, expense) {
    const closingBalance = document.getElementById('closingBalInput').value;
    const notes          = document.getElementById('closingNotes').value;
    if (closingBalance === '' || isNaN(closingBalance)) {
        Swal.fire({icon:'warning',title:'Enter Closing Balance',text:'Please enter the actual closing balance.',timer:2000,showConfirmButton:false});
        return;
    }
    Swal.fire({
        icon:'question', title:'Confirm Day Close',
        html:'Close day <strong>' + date + '</strong> with closing balance <strong>₹' + parseFloat(closingBalance).toLocaleString('en-IN',{minimumFractionDigits:2}) + '</strong>?<br><small class="text-muted">This action cannot be undone.</small>',
        showCancelButton:true, confirmButtonText:'Yes, Close Day', confirmButtonColor:'#16a34a', cancelButtonText:'Cancel'
    }).then(result => {
        if (!result.isConfirmed) return;
        document.getElementById('btnSettle').disabled = true;
        const params = new URLSearchParams({date, closingBalance, totalSale, purchase, expense, notes});
        fetch(contextPath + '/reports/dayCloser/saveClosing.jsp', {method:'POST', body:params})
            .then(r => r.json())
            .then(res => {
                if (res.success) {
                    Swal.fire({icon:'success',title:'Day Closed!',text:'Day has been successfully closed.',timer:1600,showConfirmButton:false});
                    setTimeout(loadDay, 1000);
                } else {
                    Swal.fire({icon:'error',title:'Error',text:res.message||'Failed'});
                    document.getElementById('btnSettle').disabled = false;
                }
            })
            .catch(() => {
                Swal.fire({icon:'error',title:'Error',text:'Request failed'});
                document.getElementById('btnSettle').disabled = false;
            });
    });
}

// Auto-load today on page load
window.addEventListener('DOMContentLoaded', () => { loadDay(); loadRange(); });

function loadRange() {
    const from = document.getElementById('rangeFrom').value;
    const to   = document.getElementById('rangeTo').value;
    if (!from || !to) return;
    document.getElementById('rangeContent').innerHTML =
        '<div style="text-align:center;padding:24px;color:#94a3b8"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';
    fetch(contextPath + '/reports/dayCloser/getRange.jsp?fromDate=' + from + '&toDate=' + to)
        .then(r => r.json())
        .then(d => {
            if (d.error) { document.getElementById('rangeContent').innerHTML = '<div style="color:#dc2626;padding:12px">' + d.error + '</div>'; return; }
            document.getElementById('rangeContent').innerHTML = `
            <table class="range-table">
                <thead><tr><th>Metric</th><th>Cash</th><th>Bank</th><th>Total</th></tr></thead>
                <tbody>
                    <tr><td>Sales</td><td>${fmt(d.cashSale)}</td><td>${fmt(d.bankSale)}</td><td class="fw">${fmt(d.totalSale)}</td></tr>
                    <tr><td>Due Collection</td><td>${fmt(d.dueCash)}</td><td>${fmt(d.dueBank)}</td><td class="fw">${fmt(d.totalDue)}</td></tr>
                    <tr><td>Purchase Payment</td><td>${fmt(d.purchasePayCash)}</td><td>${fmt(d.purchasePayBank)}</td><td class="fw">${fmt(d.totalPurchPay)}</td></tr>
                    <tr><td>Expense</td><td colspan="2" style="text-align:center">${fmt(d.expense)}</td><td class="fw">${fmt(d.expense)}</td></tr>
                    <tr class="total-row"><td>Net Cash In Hand</td><td colspan="3" style="text-align:right">${fmt(d.netCashInHand)}</td></tr>
                    <tr class="total-row"><td>Net Cash In Bank</td><td colspan="3" style="text-align:right">${fmt(d.netCashInBank)}</td></tr>
                </tbody>
            </table>`;
        })
        .catch(() => { document.getElementById('rangeContent').innerHTML = '<div style="color:#dc2626;padding:12px">Request failed</div>'; });
}</script>
<br><br><br><br><br><br><br>
</body>
</html>
