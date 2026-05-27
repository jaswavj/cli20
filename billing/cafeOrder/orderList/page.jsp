<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../assets/common/head.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>Order List</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; overflow: hidden; font-family: 'Segoe UI', system-ui, sans-serif; background: #f0f2f5; }
        .app-shell { display: flex; flex-direction: column; height: 100vh; height: 100dvh; overflow: hidden; }
        .app-nav { flex-shrink: 0; }

        /* ── HEADER ── */
        .ol-header {
            background: #1c1c2e; color: #fff; padding: 11px 18px;
            display: flex; align-items: center; gap: 12px; flex-shrink: 0;
        }
        .ol-header h4 { font-size: 16px; font-weight: 700; flex: 1; display: flex; align-items: center; gap: 8px; }
        .refresh-btn {
            background: rgba(255,255,255,.12); border: none; color: #fff;
            border-radius: 8px; padding: 6px 13px; font-size: 12px; cursor: pointer;
            display: flex; align-items: center; gap: 6px; transition: background .15s;
        }
        .refresh-btn:hover { background: rgba(255,255,255,.22); }
        .countdown-ring { font-size: 11px; color: #f5a623; font-weight: 700; min-width: 32px; text-align: center; }

        /* ── TABS ── */
        .tab-bar {
            background: #fff; border-bottom: 2px solid #e5e7eb;
            display: flex; gap: 0; flex-shrink: 0;
        }
        .tab-btn {
            flex: 1; padding: 11px 8px; border: none; background: none;
            font-size: 13px; font-weight: 600; color: #64748b; cursor: pointer;
            border-bottom: 3px solid transparent; transition: all .15s;
            display: flex; align-items: center; justify-content: center; gap: 6px;
        }
        .tab-btn:hover { color: #1c1c2e; }
        .tab-btn.active { color: #1c1c2e; border-bottom-color: #f5a623; }
        .tab-count {
            background: #e2e8f0; color: #64748b; border-radius: 20px;
            padding: 1px 8px; font-size: 11px; font-weight: 700;
        }
        .tab-btn.active .tab-count { background: #f5a623; color: #1c1c2e; }

        /* ── BODY ── */
        .ol-body { flex: 1; display: flex; overflow: hidden; }

        /* ── ORDER LIST PANEL ── */
        .order-list-panel {
            flex: 1; overflow-y: auto; padding: 16px;
            display: flex; flex-direction: column; gap: 12px;
        }

        /* order card */
        .order-card {
            background: #fff; border-radius: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,.07);
            border-left: 4px solid #e2e8f0;
            padding: 14px 16px; cursor: pointer;
            transition: transform .15s, box-shadow .15s;
            display: flex; align-items: center; gap: 14px;
        }
        .order-card:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(0,0,0,.11); }
        .order-card.pending  { border-left-color: #f59e0b; }
        .order-card.delivered { border-left-color: #22c55e; }
        .order-card.billed   { border-left-color: #6366f1; }

        .oc-icon {
            width: 44px; height: 44px; border-radius: 12px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center; font-size: 18px;
        }
        .pending  .oc-icon { background: #fef3c7; color: #d97706; }
        .delivered .oc-icon { background: #dcfce7; color: #16a34a; }
        .billed   .oc-icon { background: #ede9fe; color: #7c3aed; }

        .oc-info { flex: 1; min-width: 0; }
        .oc-table { font-size: 15px; font-weight: 700; color: #1e293b; }
        .oc-meta { font-size: 11px; color: #94a3b8; margin-top: 2px; }
        .oc-no { font-size: 12px; color: #64748b; font-weight: 600; margin-top: 3px; }

        .oc-right { display: flex; flex-direction: column; align-items: flex-end; gap: 6px; flex-shrink: 0; }
        .oc-status {
            font-size: 10px; font-weight: 700; text-transform: uppercase;
            letter-spacing: .4px; padding: 3px 10px; border-radius: 20px;
        }
        .pending  .oc-status { background: #fef3c7; color: #d97706; }
        .delivered .oc-status { background: #dcfce7; color: #16a34a; }
        .billed   .oc-status { background: #ede9fe; color: #7c3aed; }

        .oc-actions { display: flex; gap: 6px; }
        .oc-btn {
            border: none; border-radius: 8px; padding: 5px 11px;
            font-size: 12px; font-weight: 600; cursor: pointer; transition: all .12s;
            display: flex; align-items: center; gap: 4px;
        }
        .oc-btn.view   { background: #e0f2fe; color: #0369a1; }
        .oc-btn.view:hover { background: #bae6fd; }
        .oc-btn.deliver { background: #dcfce7; color: #16a34a; }
        .oc-btn.deliver:hover { background: #86efac; }

        .ol-empty {
            text-align: center; padding: 60px 20px;
            color: #94a3b8; font-size: 14px;
        }
        .ol-empty i { font-size: 48px; margin-bottom: 14px; display: block; opacity: .3; }

        /* ── DETAIL PANEL (desktop) ── */
        .detail-panel {
            width: 380px; flex-shrink: 0; background: #fff;
            border-left: 1.5px solid #e5e7eb;
            display: flex; flex-direction: column; overflow: hidden;
        }
        .detail-panel.hidden { display: none; }
        .dp-header {
            background: #1c1c2e; color: #fff; padding: 12px 16px;
            display: flex; align-items: center; gap: 10px; flex-shrink: 0;
        }
        .dp-header h6 { flex: 1; font-size: 14px; font-weight: 700; margin: 0; }
        .dp-close {
            background: rgba(255,255,255,.12); border: none; color: #fff;
            border-radius: 6px; width: 28px; height: 28px; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: background .15s;
        }
        .dp-close:hover { background: rgba(255,255,255,.25); }
        .dp-meta { padding: 12px 16px; background: #f8fafc; border-bottom: 1px solid #e5e7eb; flex-shrink: 0; }
        .dp-meta p { font-size: 12px; color: #64748b; margin: 0 0 4px; }
        .dp-meta p strong { color: #1e293b; }
        .dp-items { flex: 1; overflow-y: auto; }
        .di-row {
            display: flex; align-items: center; gap: 10px;
            padding: 11px 16px; border-bottom: 1px solid #f1f5f9;
        }
        .di-name { flex: 1; font-size: 13px; font-weight: 600; color: #1e293b; }
        .di-sub { font-size: 11px; color: #94a3b8; }
        .di-qty { font-size: 13px; font-weight: 700; color: #64748b; background: #f1f5f9; border-radius: 6px; padding: 3px 9px; }
        .di-total { font-size: 13px; font-weight: 700; color: #1e293b; min-width: 60px; text-align: right; }
        .di-status { width: 26px; height: 26px; border-radius: 50%; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 12px; flex-shrink: 0; }
        .di-status.done { background: #dcfce7; color: #16a34a; cursor: default; }
        .di-status.pending { background: #fef3c7; color: #d97706; }
        .di-status.pending:hover { background: #fde68a; }
        .dp-footer { padding: 14px 16px; border-top: 2px solid #f1f5f9; flex-shrink: 0; }
        .dp-total-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .dp-total-label { font-size: 13px; color: #64748b; font-weight: 600; }
        .dp-total-amount { font-size: 20px; font-weight: 800; color: #1c1c2e; }
        .btn-deliver-all {
            width: 100%; background: #22c55e; color: #fff; border: none;
            border-radius: 10px; padding: 12px; font-size: 14px; font-weight: 700;
            cursor: pointer; display: flex; align-items: center; justify-content: center;
            gap: 8px; transition: background .15s;
        }
        .btn-deliver-all:hover { background: #16a34a; }
        .btn-deliver-all:disabled { background: #e2e8f0; color: #94a3b8; cursor: not-allowed; }

        /* ── BOTTOM SHEET (mobile detail) ── */
        .bsheet-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 1060; align-items: flex-end; }
        .bsheet-overlay.open { display: flex; }
        .bsheet { background: #fff; width: 100%; border-radius: 20px 20px 0 0; max-height: 88vh; display: flex; flex-direction: column; transform: translateY(100%); transition: transform .28s cubic-bezier(.4,0,.2,1); }
        .bsheet-overlay.open .bsheet { transform: translateY(0); }
        .bsheet-handle { width: 40px; height: 4px; background: #d1d5db; border-radius: 4px; margin: 10px auto 4px; flex-shrink: 0; }
        .bsheet-hdr { display: flex; align-items: center; gap: 10px; padding: 6px 16px 12px; border-bottom: 1.5px solid #f1f5f9; flex-shrink: 0; }
        .bsheet-hdr h6 { flex: 1; font-size: 15px; font-weight: 700; color: #1c1c2e; margin: 0; }
        .bsheet-close { background: #f1f5f9; border: none; border-radius: 50%; width: 30px; height: 30px; font-size: 14px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: #64748b; }
        .bsheet-body { flex: 1; overflow-y: auto; }
        .bsheet-meta { padding: 10px 16px; background: #f8fafc; border-bottom: 1px solid #e5e7eb; font-size: 12px; color: #64748b; }
        .bsheet-meta strong { color: #1e293b; }
        .bsheet-footer { padding: 14px 16px; border-top: 2px solid #f1f5f9; flex-shrink: 0; }

        /* ── RESPONSIVE ── */
        @media(max-width:700px) {
            .detail-panel { display: none !important; }
            .order-list-panel { padding: 10px; }
            .order-card { padding: 12px; gap: 10px; }
        }
        @media(min-width:701px) and (max-width:1024px) {
            .detail-panel { width: 320px; }
        }
    </style>
</head>
<body>
<div class="app-shell">
    <div class="app-nav"><jsp:include page="/assets/navbar/navbar.jsp" /></div>

    <div class="ol-header">
        <h4><i class="fas fa-clipboard-list"></i> Order List</h4>
        <span class="countdown-ring" id="countdownDisplay">30s</span>
        <button class="refresh-btn" onclick="refreshOrders()">
            <i class="fas fa-sync-alt"></i> Refresh
        </button>
        <a href="<%=request.getContextPath()%>/cafeOrder/order/page.jsp" class="refresh-btn" style="text-decoration:none;">
            <i class="fas fa-plus-circle"></i> New Order
        </a>
    </div>

    <div class="tab-bar">
        <button class="tab-btn active" id="tab-pending"   onclick="switchTab('pending')">
            <i class="fas fa-clock"></i> Pending <span class="tab-count" id="cnt-pending">0</span>
        </button>
        <button class="tab-btn" id="tab-delivered" onclick="switchTab('delivered')">
            <i class="fas fa-check-circle"></i> Delivered <span class="tab-count" id="cnt-delivered">0</span>
        </button>
    </div>

    <div class="ol-body">
        <div class="order-list-panel" id="orderListPanel">
            <div class="ol-empty"><i class="fas fa-spinner fa-spin"></i> Loading orders…</div>
        </div>
        <div class="detail-panel hidden" id="detailPanel">
            <div class="dp-header">
                <h6 id="dpTitle"><i class="fas fa-receipt me-2"></i>Order Detail</h6>
                <button class="dp-close" onclick="closeDetail()"><i class="fas fa-times"></i></button>
            </div>
            <div class="dp-meta" id="dpMeta"></div>
            <div class="dp-items" id="dpItems"></div>
            <div class="dp-footer" id="dpFooter"></div>
        </div>
    </div>
</div>

<!-- Mobile bottom sheet detail -->
<div class="bsheet-overlay" id="bsheetOverlay" onclick="closeBSheetOnBg(event)">
    <div class="bsheet">
        <div class="bsheet-handle"></div>
        <div class="bsheet-hdr">
            <h6 id="bsheetTitle">Order Detail</h6>
            <button class="bsheet-close" onclick="closeBottomSheet()"><i class="fas fa-times"></i></button>
        </div>
        <div class="bsheet-meta" id="bsheetMeta"></div>
        <div class="bsheet-body" id="bsheetItems"></div>
        <div class="bsheet-footer" id="bsheetFooter"></div>
    </div>
</div>

<script>
let currentTab = 'pending';
let activeOrderId = null;
let countdownSec = 30;
let countdownTimer = null;

/* ── INIT ── */
$(document).ready(function () {
    loadOrders('pending');
    startCountdown();
});

/* ── COUNTDOWN / AUTO-REFRESH ── */
function startCountdown() {
    clearInterval(countdownTimer);
    countdownSec = 30;
    document.getElementById('countdownDisplay').textContent = countdownSec + 's';
    countdownTimer = setInterval(function () {
        countdownSec--;
        document.getElementById('countdownDisplay').textContent = countdownSec + 's';
        if (countdownSec <= 0) {
            loadOrders(currentTab);
            countdownSec = 30;
        }
    }, 1000);
}

function refreshOrders() {
    loadOrders(currentTab);
    startCountdown();
}

/* ── TABS ── */
function switchTab(type) {
    currentTab = type;
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + type).classList.add('active');
    closeDetail();
    loadOrders(type);
}

/* ── LOAD ORDERS ── */
function loadOrders(type) {
    $('#orderListPanel').html('<div class="ol-empty"><i class="fas fa-spinner fa-spin"></i> Loading…</div>');
    $.ajax({
        url: 'getOrders.jsp', data: { type }, dataType: 'json',
        success: function (orders) {
            document.getElementById('cnt-' + type).textContent = orders ? orders.length : 0;
            renderOrders(orders || [], type);
        },
        error: function () {
            $('#orderListPanel').html('<div class="ol-empty"><i class="fas fa-exclamation-circle"></i> Error loading orders</div>');
        }
    });
}

function renderOrders(orders, type) {
    if (orders.length === 0) {
        const msg = type === 'pending' ? 'No pending orders right now.' : type === 'delivered' ? 'No delivered orders.' : 'No billed orders.';
        const icon = type === 'pending' ? 'fa-clock' : type === 'delivered' ? 'fa-check-circle' : 'fa-file-invoice';
        $('#orderListPanel').html(`<div class="ol-empty"><i class="fas ${icon}"></i>${msg}</div>`);
        return;
    }
    let html = '';
    orders.forEach(o => {
        const cls = type;
        const icon = type === 'pending' ? 'fa-fire' : type === 'delivered' ? 'fa-check' : 'fa-file-invoice-dollar';
        const label = type === 'pending' ? 'Pending' : type === 'delivered' ? 'Delivered' : 'Billed';
        html += `<div class="order-card ${cls}" onclick="viewOrderDetails(${o.id})">
            <div class="oc-icon"><i class="fas ${icon}"></i></div>
            <div class="oc-info">
                <div class="oc-table">${o.table_name}</div>
                <div class="oc-no"># ${o.order_no}</div>
                <div class="oc-meta">${o.date} &nbsp;·&nbsp; ${o.time}</div>
            </div>
            <div class="oc-right">
                <span class="oc-status">${label}</span>
                <div class="oc-actions">
                    <button class="oc-btn view" onclick="event.stopPropagation(); viewOrderDetails(${o.id})">
                        <i class="fas fa-eye"></i> View
                    </button>
                    ${type === 'pending' ? `<button class="oc-btn deliver" onclick="event.stopPropagation(); markOrderDelivered(${o.id})">
                        <i class="fas fa-check"></i> Deliver
                    </button>` : ''}
                </div>
            </div>
        </div>`;
    });
    $('#orderListPanel').html(html);
}

/* ── ORDER DETAIL ── */
function viewOrderDetails(orderId) {
    activeOrderId = orderId;
    const isMobile = window.innerWidth <= 700;

    $.ajax({
        url: 'getOrderDetails.jsp', data: { orderId }, dataType: 'json',
        success: function (data) {
            if (data.error) { Swal.fire('Error', data.error, 'error'); return; }
            const metaHtml = `
                <p><strong>Order:</strong> ${data.order_no} &nbsp;·&nbsp; <strong>Table:</strong> ${data.table_name}</p>
                <p><strong>Date:</strong> ${data.date} &nbsp;·&nbsp; <strong>Time:</strong> ${data.time}</p>`;
            const itemsHtml = buildDetailItems(data.items);
            const footerHtml = buildDetailFooter(data.grand_total, orderId, data.all_delivered);

            if (isMobile) {
                document.getElementById('bsheetTitle').textContent = 'Table: ' + data.table_name;
                document.getElementById('bsheetMeta').innerHTML = metaHtml;
                document.getElementById('bsheetItems').innerHTML = itemsHtml;
                document.getElementById('bsheetFooter').innerHTML = footerHtml;
                openBottomSheet();
            } else {
                document.getElementById('dpTitle').innerHTML = '<i class="fas fa-receipt me-2"></i>Table: ' + data.table_name;
                document.getElementById('dpMeta').innerHTML = metaHtml;
                document.getElementById('dpItems').innerHTML = itemsHtml;
                document.getElementById('dpFooter').innerHTML = footerHtml;
                document.getElementById('detailPanel').classList.remove('hidden');
            }
        },
        error: function () { Swal.fire('Error', 'Could not load order details', 'error'); }
    });
}

function buildDetailItems(items) {
    if (!items || items.length === 0) return '<div class="ol-empty" style="padding:30px"><i class="fas fa-box-open"></i>No items</div>';
    let html = '';
    items.forEach(item => {
        const done = item.is_delivered == 1;
        const statusCls = done ? 'done' : 'pending';
        const statusIcon = done ? 'fa-check' : 'fa-hourglass-half';
        const btnAttr = done ? 'disabled title="Delivered"' : `onclick="deliverItem(${item.id})" title="Mark delivered"`;
        html += `<div class="di-row" id="di-${item.id}">
            <div style="flex:1;min-width:0;">
                <div class="di-name">${item.name}</div>
                <div class="di-sub">${item.code}</div>
            </div>
            <span class="di-qty">×${item.qty}</span>
            <div class="di-total">₹${parseFloat(item.total).toFixed(2)}</div>
            <button class="di-status ${statusCls}" ${btnAttr}><i class="fas ${statusIcon}"></i></button>
        </div>`;
    });
    return html;
}

function buildDetailFooter(grandTotal, orderId, allDelivered) {
    const isPending = currentTab === 'pending';
    return `<div class="dp-total-row">
        <span class="dp-total-label">Grand Total</span>
        <span class="dp-total-amount">₹${parseFloat(grandTotal).toFixed(2)}</span>
    </div>
    ${isPending ? `<button class="btn-deliver-all" ${allDelivered ? 'disabled' : ''} onclick="markOrderDelivered(${orderId})">
        <i class="fas fa-check-double"></i> Mark All Delivered
    </button>` : ''}`;
}

function closeDetail() {
    activeOrderId = null;
    document.getElementById('detailPanel').classList.add('hidden');
}

/* ── DELIVER SINGLE ITEM ── */
function deliverItem(detailId) {
    $.post('updateDelivery.jsp', { detailId }, function (resp) {
        if (resp.trim() === 'success') {
            if (activeOrderId) viewOrderDetails(activeOrderId);
        } else { Swal.fire('Error', resp, 'error'); }
    });
}

/* ── MARK ALL DELIVERED ── */
function markOrderDelivered(orderId) {
    Swal.fire({
        title: 'Mark as Delivered?', text: 'All items in this order will be marked delivered.',
        icon: 'question', showCancelButton: true,
        confirmButtonColor: '#22c55e', cancelButtonColor: '#94a3b8',
        confirmButtonText: 'Yes, Deliver', cancelButtonText: 'Cancel'
    }).then(result => {
        if (!result.isConfirmed) return;
        $.post('markOrderDelivered.jsp', { orderId }, function (resp) {
            if (resp.trim() === 'success') {
                Swal.fire({ icon: 'success', title: 'Delivered!', timer: 1400, showConfirmButton: false });
                closeDetail();
                closeBottomSheet();
                loadOrders(currentTab);
            } else { Swal.fire('Error', resp, 'error'); }
        });
    });
}

/* ── BOTTOM SHEET ── */
function openBottomSheet() {
    const ov = document.getElementById('bsheetOverlay');
    ov.style.display = 'flex';
    requestAnimationFrame(() => ov.classList.add('open'));
}
function closeBottomSheet() {
    const ov = document.getElementById('bsheetOverlay');
    ov.classList.remove('open');
    setTimeout(() => { ov.style.display = 'none'; }, 290);
}
function closeBSheetOnBg(e) { if (e.target === document.getElementById('bsheetOverlay')) closeBottomSheet(); }
</script>
</body>
</html>
