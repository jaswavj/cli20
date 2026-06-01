<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../assets/common/head.jsp" %>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>Cafe Order</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; overflow: hidden; font-family: 'Segoe UI', system-ui, sans-serif; background: #f0f2f5; }

        .app-shell { display: flex; flex-direction: column; height: 100vh; height: 100dvh; height: 100svh; overflow: hidden; }
        .app-nav { flex-shrink: 0; }
        .view { display: none; flex: 1; min-height: 0; flex-direction: column; overflow: hidden; }
        .view.active { display: flex; }

        /* ── TABLES VIEW ── */
        .tables-header { background:#1c1c2e; color:#fff; padding:12px 20px; display:flex; align-items:center; justify-content:space-between; flex-shrink:0; gap:12px; }
        .tables-header h4 { font-size:17px; font-weight:700; letter-spacing:.4px; display:flex; align-items:center; gap:8px; }
        .legend { display:flex; gap:14px; font-size:12px; align-items:center; }
        .legend-dot { width:10px; height:10px; border-radius:50%; display:inline-block; }
        .tables-body { flex:1; min-height:0; overflow-y:auto; -webkit-overflow-scrolling:touch; padding:20px; padding-bottom:100px; }
        .tables-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(130px,1fr)); gap:14px; }

        .table-card { background:#fff; border-radius:14px; padding:18px 12px 14px; text-align:center; cursor:pointer; transition:transform .18s,box-shadow .18s; box-shadow:0 2px 8px rgba(0,0,0,.08); border:2.5px solid transparent; position:relative; user-select:none; }
        .table-card:hover { transform:translateY(-4px); box-shadow:0 8px 22px rgba(0,0,0,.14); }
        .table-card:active { transform:scale(.97); }
        .table-card.available { border-color:#22c55e; }
        .table-card.occupied  { border-color:#ef4444; background:#fff5f5; }
        .table-card .tc-icon { font-size:28px; margin-bottom:8px; }
        .table-card.available .tc-icon { color:#22c55e; }
        .table-card.occupied  .tc-icon { color:#ef4444; }
        .table-card .tc-name { font-weight:700; font-size:14px; color:#1c1c2e; margin-bottom:6px; }
        .table-card .tc-badge { display:inline-block; padding:2px 10px; border-radius:20px; font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:.4px; }
        .table-card.available .tc-badge { background:#dcfce7; color:#16a34a; }
        .table-card.occupied  .tc-badge { background:#fee2e2; color:#dc2626; }
        .table-card .tc-occ-dot { position:absolute; top:8px; right:8px; width:20px; height:20px; background:#ef4444; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:9px; color:#fff; }
        .tc-bill-btn {
            margin-top:8px; width:100%; background:#1c1c2e; color:#f5a623;
            border:none; border-radius:8px; padding:6px 0; font-size:11px;
            font-weight:800; cursor:pointer; letter-spacing:.3px;
            display:flex; align-items:center; justify-content:center; gap:5px;
            transition:background .15s,color .15s;
        }
        .tc-bill-btn:hover { background:#f5a623; color:#1c1c2e; }

        /* ── ORDER VIEW ── */
        .order-header { background:#1c1c2e; color:#fff; padding:10px 16px; display:flex; align-items:center; gap:12px; flex-shrink:0; }
        .back-btn { background:rgba(255,255,255,.12); border:none; color:#fff; border-radius:8px; padding:6px 14px; font-size:13px; cursor:pointer; display:flex; align-items:center; gap:6px; transition:background .15s; }
        .back-btn:hover { background:rgba(255,255,255,.22); }
        .order-header .table-title { font-size:16px; font-weight:700; flex:1; }
        .status-pill { font-size:11px; padding:3px 10px; border-radius:20px; font-weight:700; }
        .status-pill.available { background:#22c55e; color:#fff; }
        .status-pill.occupied  { background:#ef4444; color:#fff; }

        .order-body { display:flex; flex:1; min-height:0; overflow:hidden; }

        /* left panel */
        .left-panel { display:flex; flex-direction:column; flex:1; min-height:0; overflow:hidden; border-right:1.5px solid #e5e7eb; background:#f8fafc; }
        .cat-strip { background:#fff; border-bottom:1.5px solid #e5e7eb; padding:10px 14px; display:flex; gap:8px; overflow-x:auto; flex-shrink:0; scrollbar-width:none; }
        .cat-strip::-webkit-scrollbar { display:none; }
        .cat-btn { flex-shrink:0; padding:6px 16px; border-radius:20px; border:2px solid #e2e8f0; background:#fff; color:#64748b; font-size:12px; font-weight:600; cursor:pointer; transition:all .15s; white-space:nowrap; }
        .cat-btn:hover { border-color:#f5a623; color:#f5a623; }
        .cat-btn.active { background:#f5a623; border-color:#f5a623; color:#fff; }
        .prod-search-wrap { padding:10px 14px; background:#fff; border-bottom:1px solid #e5e7eb; flex-shrink:0; }
        .prod-search { width:100%; border:1.5px solid #e2e8f0; border-radius:10px; padding:8px 14px 8px 36px; font-size:13px; outline:none; background:#f8fafc url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='15' height='15' viewBox='0 0 24 24' fill='none' stroke='%239ca3af' stroke-width='2.5'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cpath d='m21 21-4.35-4.35'/%3E%3C/svg%3E") no-repeat 11px center; transition:border-color .15s; }
        .prod-search:focus { border-color:#f5a623; }
        .prod-grid-wrap { flex:1; min-height:0; overflow-y:auto; -webkit-overflow-scrolling:touch; padding:14px; padding-bottom:80px; }
        .prod-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(120px,1fr)); gap:10px; }

        .prod-card { background:#fff; border-radius:12px; padding:14px 10px 10px; text-align:center; cursor:pointer; box-shadow:0 1px 4px rgba(0,0,0,.07); border:2px solid transparent; transition:all .15s; position:relative; user-select:none; }
        .prod-card:hover { border-color:#f5a623; box-shadow:0 4px 14px rgba(245,166,35,.2); transform:translateY(-2px); }
        .prod-card:active { transform:scale(.97); }
        .prod-card.in-order { border-color:#22c55e; background:#f0fdf4; }
        .prod-card .pc-icon { font-size:26px; margin-bottom:6px; color:#94a3b8; }
        .prod-card.in-order .pc-icon { color:#22c55e; }
        .prod-card .pc-name { font-size:12px; font-weight:600; color:#1e293b; margin-bottom:4px; line-height:1.3; }
        .prod-card .pc-code { font-size:10px; color:#94a3b8; margin-bottom:6px; }
        .prod-card .pc-price { font-size:13px; font-weight:700; color:#f5a623; }
        .prod-card .pc-qty-badge { position:absolute; top:-6px; right:-6px; background:#22c55e; color:#fff; border-radius:50%; width:22px; height:22px; display:none; align-items:center; justify-content:center; font-size:11px; font-weight:700; }
        .prod-card.in-order .pc-qty-badge { display:flex; }
        .prod-empty { grid-column:1/-1; text-align:center; padding:40px 20px; color:#94a3b8; }
        .prod-empty i { font-size:36px; margin-bottom:10px; display:block; opacity:.4; }

        /* right panel */
        .right-panel { width:320px; flex-shrink:0; display:flex; flex-direction:column; min-height:0; background:#fff; }
        .order-summary-header { padding:12px 16px; background:#1c1c2e; color:#fff; font-size:14px; font-weight:700; display:flex; align-items:center; justify-content:space-between; flex-shrink:0; }
        .order-count-pill { background:#f5a623; color:#1c1c2e; border-radius:20px; padding:2px 10px; font-size:12px; font-weight:700; }
        .order-items-list { flex:1; min-height:0; overflow-y:auto; -webkit-overflow-scrolling:touch; padding:8px; }
        .oi-empty { display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%; color:#cbd5e1; font-size:13px; text-align:center; padding:20px; }
        .oi-empty i { font-size:40px; margin-bottom:10px; display:block; }
        .oi-row { display:flex; align-items:center; gap:8px; padding:8px 6px; border-bottom:1px solid #f1f5f9; animation:fadeSlide .18s ease; }
        @keyframes fadeSlide { from{opacity:0;transform:translateX(10px)} to{opacity:1;transform:none} }
        .oi-name { font-size:12px; font-weight:600; color:#1e293b; line-height:1.3; }
        .oi-price { font-size:11px; color:#94a3b8; }
        .oi-qty-ctrl { display:flex; align-items:center; gap:4px; }
        .qty-btn { width:26px; height:26px; border-radius:6px; border:none; font-size:14px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; transition:background .12s; }
        .qty-btn.minus { background:#fee2e2; color:#dc2626; }
        .qty-btn.minus:hover { background:#fca5a5; }
        .qty-btn.plus  { background:#dcfce7; color:#16a34a; }
        .qty-btn.plus:hover  { background:#86efac; }
        .qty-num { min-width:22px; text-align:center; font-size:13px; font-weight:700; color:#1e293b; }
        .oi-total { font-size:13px; font-weight:700; color:#1e293b; min-width:52px; text-align:right; }
        .oi-del { background:none; border:none; color:#cbd5e1; cursor:pointer; font-size:14px; padding:2px 4px; transition:color .12s; }
        .oi-del:hover { color:#ef4444; }
        .order-footer { flex-shrink:0; border-top:2px solid #f1f5f9; padding:12px 14px; background:#fff; }
        .total-row { display:flex; justify-content:space-between; align-items:center; margin-bottom:12px; }
        .total-label { font-size:13px; color:#64748b; font-weight:600; }
        .total-amount { font-size:22px; font-weight:800; color:#1c1c2e; }
        .btn-place-order { width:100%; background:#f5a623; color:#1c1c2e; border:none; border-radius:10px; padding:13px; font-size:15px; font-weight:800; cursor:pointer; letter-spacing:.3px; transition:background .15s,transform .12s; display:flex; align-items:center; justify-content:center; gap:8px; }
        .btn-place-order:hover { background:#e09510; }
        .btn-place-order:active { transform:scale(.98); }
        .btn-place-order:disabled { background:#e2e8f0; color:#94a3b8; cursor:not-allowed; }
        .btn-cancel-order { width:100%; background:#fff; color:#ef4444; border:2px solid #ef4444; border-radius:10px; padding:9px; font-size:13px; font-weight:700; cursor:pointer; margin-top:8px; display:flex; align-items:center; justify-content:center; gap:6px; transition:background .15s; }
        .btn-cancel-order:hover { background:#fee2e2; }

        @media(max-width:700px) {
            .order-body { flex-direction:column; position:relative; }
            .right-panel { display:none !important; }
            /* Absolute fill so left-panel height is always 100% of order-body */
            .left-panel { position:absolute; top:0; left:0; right:0; bottom:0; overflow:hidden; }
            .tables-grid { grid-template-columns:repeat(auto-fill,minmax(100px,1fr)); }
            .prod-grid { grid-template-columns:repeat(auto-fill,minmax(100px,1fr)); }
            .prod-grid-wrap {
                overflow-y: scroll;
                -webkit-overflow-scrolling: touch;
                touch-action: pan-y;
                overscroll-behavior: contain;
                padding-bottom: 420px;
            }
        }

        /* ── MOBILE FLOATING ORDER BAR ── */
        .mob-order-bar {
            display: none;
            position: fixed;
            bottom: 0; left: 0; right: 0;
            background: #1c1c2e;
            color: #fff;
            padding: 12px 16px;
            z-index: 1050;
            align-items: center;
            gap: 12px;
            box-shadow: 0 -4px 18px rgba(0,0,0,.22);
        }
        @media(max-width:700px) {
            /* mob-order-bar shown via JS only when table is selected */
        }
        .mob-order-bar .mob-count {
            background: #f5a623;
            color: #1c1c2e;
            border-radius: 20px;
            padding: 3px 12px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
        }
        .mob-order-bar .mob-total {
            flex: 1;
            font-size: 15px;
            font-weight: 800;
        }
        .mob-order-bar .mob-place-btn {
            background: #f5a623;
            color: #1c1c2e;
            border: none;
            border-radius: 10px;
            padding: 10px 18px;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
        }
        .mob-order-bar .mob-place-btn:disabled { background:#e2e8f0; color:#94a3b8; cursor:not-allowed; }
        @media(max-width:700px){
            .mob-order-bar {
                padding-top: 10px;
                padding-bottom: calc(150px + env(safe-area-inset-bottom, 0px));
            }
        }

        /* ── BOTTOM SHEET ── */
        .bsheet-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.5);
            z-index: 1060;
            align-items: flex-end;
        }
        .bsheet-overlay.open { display: flex; }
        .bsheet {
            background: #fff;
            width: 100%;
            border-radius: 20px 20px 0 0;
            max-height: 85vh;
            max-height: 85dvh;
            max-height: 85svh;
            display: flex;
            flex-direction: column;
            transform: translateY(100%);
            transition: transform .28s cubic-bezier(.4,0,.2,1);
        }
        .bsheet-overlay.open .bsheet { transform: translateY(0); }
        .bsheet-handle {
            width: 40px; height: 4px;
            background: #d1d5db;
            border-radius: 4px;
            margin: 10px auto 4px;
            flex-shrink: 0;
        }
        .bsheet-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 16px 10px;
            border-bottom: 1.5px solid #f1f5f9;
            flex-shrink: 0;
        }
        .bsheet-header h6 { font-size:15px; font-weight:700; color:#1c1c2e; margin:0; }
        .bsheet-close {
            background: #f1f5f9;
            border: none;
            border-radius: 50%;
            width: 30px; height: 30px;
            font-size: 14px;
            cursor: pointer;
            display: flex; align-items:center; justify-content:center;
            color: #64748b;
        }
        .bsheet-body {
            flex: 1;
            overflow-y: auto;
            padding: 4px 8px;
        }
        .bsheet-footer {
            padding: 12px 16px;
            padding-bottom: calc(160px + env(safe-area-inset-bottom, 0px));
            border-top: 2px solid #f1f5f9;
            flex-shrink: 0;
        }
        .bsheet-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .bsheet-total-label { font-size:13px; color:#64748b; font-weight:600; }
        .bsheet-total-amount { font-size:22px; font-weight:800; color:#1c1c2e; }
        @media(min-width:701px) and (max-width:1024px) {
            .right-panel { width:280px; }
        }

        /* ── NEED BILL BUTTON ── */
        .btn-need-bill {
            width:100%; background:#1c1c2e; color:#f5a623; border:2px solid #f5a623;
            border-radius:10px; padding:10px; font-size:14px; font-weight:800;
            cursor:pointer; margin-top:8px; display:none; align-items:center;
            justify-content:center; gap:7px; transition:background .15s,color .15s;
            letter-spacing:.3px;
        }
        .btn-need-bill:hover { background:#f5a623; color:#1c1c2e; }
        .btn-need-bill.show { display:flex; }

        /* ── BILL MODAL ── */
        .bm-overlay {
            display:none; position:fixed; inset:0; background:rgba(0,0,0,.6);
            z-index:2000; align-items:center; justify-content:center; padding:12px;
        }
        .bm-overlay.open { display:flex; }
        .bm-modal {
            background:#fff; border-radius:18px; width:100%; max-width:680px;
            max-height:90vh; display:flex; flex-direction:column;
            box-shadow:0 20px 60px rgba(0,0,0,.35);
            animation:bmIn .25s cubic-bezier(.4,0,.2,1);
        }
        @keyframes bmIn { from{opacity:0;transform:translateY(-28px)} to{opacity:1;transform:none} }
        @media(max-width:700px){
            .bm-overlay { padding:0; align-items:flex-start; }
            .bm-modal {
                border-radius:0 0 20px 20px;
                position:fixed;
                top:env(safe-area-inset-top, 0px); left:0; right:0;
                max-height:calc(92svh - env(safe-area-inset-top, 0px));
                width:100%;
            }
        }
        .bm-head {
            background:#1c1c2e; color:#fff; padding:14px 18px;
            border-radius:18px 18px 0 0; display:flex; align-items:center;
            justify-content:space-between; flex-shrink:0;
        }
        @media(max-width:700px){ .bm-head { border-radius:0; } }
        .bm-head-title { font-size:16px; font-weight:800; }
        .bm-head-sub { font-size:11px; color:rgba(255,255,255,.55); margin-top:2px; }
        .bm-close-btn {
            background:rgba(255,255,255,.12); border:none; color:#fff;
            border-radius:50%; width:34px; height:34px; font-size:14px;
            cursor:pointer; display:flex; align-items:center; justify-content:center;
            transition:background .15s; flex-shrink:0;
        }
        .bm-close-btn:hover { background:rgba(255,255,255,.25); }
        .bm-body {
            flex:1;
            overflow-y:auto;
            min-height:0;                       /* CRITICAL: lets flex child honour max-height */
            -webkit-overflow-scrolling:touch;   /* smooth scroll on iOS */
            overscroll-behavior:contain;
        }
        .bm-sec {
            padding:13px 16px; border-bottom:1.5px solid #f1f5f9;
        }
        .bm-sec:last-child { border-bottom:none; }
        .bm-sec-title {
            font-size:10px; font-weight:800; text-transform:uppercase;
            letter-spacing:.6px; color:#64748b; margin-bottom:10px;
            display:flex; align-items:center; gap:6px;
        }
        /* item rows */
        .bm-irow { display:flex; align-items:center; gap:8px; padding:6px 0; border-bottom:1px solid #f8fafc; }
        .bm-irow:last-child { border-bottom:none; }
        .bm-irow-info { flex:1; min-width:0; }
        .bm-irow-name { font-size:13px; font-weight:600; color:#1e293b; }
        .bm-irow-price { font-size:11px; color:#94a3b8; margin-top:1px; }
        .bm-iqc { display:flex; align-items:center; gap:4px; }
        .bm-qbtn { width:28px;height:28px;border-radius:7px;border:none;font-size:14px;font-weight:700;
                   cursor:pointer;display:flex;align-items:center;justify-content:center;transition:background .12s; }
        .bm-qbtn.m { background:#fee2e2; color:#dc2626; }
        .bm-qbtn.m:hover { background:#fca5a5; }
        .bm-qbtn.p { background:#dcfce7; color:#16a34a; }
        .bm-qbtn.p:hover { background:#86efac; }
        .bm-qnum { min-width:24px;text-align:center;font-size:13px;font-weight:700;color:#1e293b; }
        .bm-itotal { font-size:13px;font-weight:700;color:#1e293b;min-width:60px;text-align:right; }
        .bm-price-bar { display:flex;justify-content:flex-end;align-items:center;gap:8px;
                        padding:8px 0 0;font-size:13px;font-weight:700;color:#1e293b; }
        /* fields */
        .bm-frow { display:flex; flex-wrap:wrap; gap:10px; }
        .bm-fg { display:flex; flex-direction:column; gap:4px; flex:1; min-width:110px; position:relative; }
        .bm-lbl { font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.5px;color:#64748b; }
        .bm-lbl.red { color:#ef4444; }
        .bm-inp {
            height:36px; border:1.5px solid #e2e8f0; border-radius:8px; padding:0 10px;
            font-size:13px; outline:none; transition:border-color .15s; width:100%; background:#fff;
        }
        .bm-inp:focus { border-color:#f5a623; }
        .bm-inp:disabled, .bm-inp.ro { background:#f8fafc; color:#64748b; cursor:default; }
        .bm-sel { height:36px;border:1.5px solid #e2e8f0;border-radius:8px;padding:0 8px;
                  font-size:13px;outline:none;width:100%;cursor:pointer;transition:border-color .15s; }
        .bm-sel:focus { border-color:#f5a623; }
        .bm-payable-inp {
            font-size:20px !important; font-weight:800 !important; text-align:center;
            background:#fff8f0 !important; border-color:#f5a623 !important; color:#1c1c2e !important;
        }
        /* footer */
        .bm-foot {
            flex-shrink:0; padding:12px 16px;
            background:#1c1c2e; border-radius:0 0 18px 18px;
            display:flex; align-items:center; gap:14px;
        }
        @media(max-width:700px){
            .bm-foot {
                border-radius:0 0 20px 20px;
                padding-bottom: calc(80px + env(safe-area-inset-bottom, 0px));
            }
        }
        .bm-foot-summary { flex:1; }
        .bm-foot-label { font-size:11px; color:rgba(255,255,255,.55); font-weight:600; text-transform:uppercase; }
        .bm-foot-amount { font-size:22px; font-weight:800; color:#fff; }
        .bm-save-btn {
            background:#f5a623; color:#1c1c2e; border:none; border-radius:10px;
            padding:12px 22px; font-size:15px; font-weight:800; cursor:pointer;
            transition:background .15s,transform .12s; display:flex; align-items:center; gap:7px;
            white-space:nowrap;
        }
        .bm-save-btn:hover { background:#e09210; }
        .bm-save-btn:active { transform:scale(.98); }
        .bm-save-btn:disabled { background:#e2e8f0; color:#94a3b8; cursor:not-allowed; }
        /* autocomplete dropdown in modal */
        .bm-ac-list {
            position:absolute; top:100%; left:0; z-index:3000; background:#fff;
            border:1.5px solid #e2e8f0; border-radius:8px; list-style:none;
            padding:4px 0; margin:2px 0 0; max-height:180px; overflow-y:auto;
            width:100%; box-shadow:0 6px 20px rgba(0,0,0,.12);
        }
        .bm-ac-list li { padding:9px 12px; cursor:pointer; font-size:13px; border-bottom:1px solid #f1f5f9; }
        .bm-ac-list li:last-child { border-bottom:none; }
        .bm-ac-list li:hover { background:#f8fafc; }
    </style>
</head>
<body>
<div class="app-shell">
    <div class="app-nav"><jsp:include page="/assets/navbar/navbar.jsp" /></div>

    <!-- ══ TABLES VIEW ══ -->
    <div class="view active" id="tablesView">
        <div class="tables-header">
            <h4><i class="fas fa-store-alt"></i> Cafe Tables</h4>
            <div class="legend">
                <span><span class="legend-dot" style="background:#22c55e"></span> Available</span>
                <span><span class="legend-dot" style="background:#ef4444"></span> Occupied</span>
            </div>
            <button style="background:#f5a623;color:#1c1c2e;font-weight:700;border:none;border-radius:8px;padding:6px 14px;cursor:pointer;" onclick="refreshTables()">
                <i class="fas fa-sync-alt me-1"></i>Refresh
            </button>
        </div>
        <div class="tables-body">
            <div class="tables-grid" id="tablesGrid">
                <div style="grid-column:1/-1;text-align:center;padding:40px;color:#94a3b8;">
                    <i class="fas fa-spinner fa-spin fa-2x"></i><br><br>Loading tables…
                </div>
            </div><br><br><br><br><br><br><br><br><br><br>
        </div>
    </div>

    <!-- ══ ORDER VIEW ══ -->
    <div class="view" id="orderView">
        <div class="order-header">
            <button class="back-btn" onclick="goBackToTables()"><i class="fas fa-arrow-left"></i> Tables</button>
            <div class="table-title"><i class="fas fa-chair me-2"></i><span id="orderTableName">-</span></div>
            <span class="status-pill available" id="orderStatusPill">Available</span>
        </div>
        <div class="order-body">
            <div class="left-panel">
                <div class="cat-strip" id="catStrip">
                    <button class="cat-btn active" onclick="selectCategory(null,this)"><i class="fas fa-th me-1"></i>All</button>
                </div>
                <div class="prod-search-wrap">
                    <input type="text" class="prod-search" id="prodSearch" placeholder="Search menu items…">
                </div>
                <div class="prod-grid-wrap">
                    <div class="prod-grid" id="prodGrid">
                        <div class="prod-empty"><i class="fas fa-spinner fa-spin"></i> Loading…</div>
                    </div>
                </div>
            </div>
            <div class="right-panel">
                <div class="order-summary-header">
                    <span><i class="fas fa-receipt me-2"></i>Order</span>
                    <span class="order-count-pill" id="orderCountPill">0 items</span>
                </div>
                <div class="order-items-list" id="orderItemsList">
                    <div class="oi-empty"><i class="fas fa-utensils"></i>Add items from the menu</div>
                </div>
                <div class="order-footer">
                    <div class="total-row">
                        <span class="total-label">Total</span>
                        <span class="total-amount">₹<span id="orderTotal">0.00</span></span>
                    </div>
                    <button class="btn-place-order" id="btnPlaceOrder" onclick="saveOrder()" disabled>
                        <i class="fas fa-check-circle"></i> Place Order
                    </button>
                    <button class="btn-cancel-order" id="btnCancelOrder" style="display:none;" onclick="cancelOrder()">
                        <i class="fas fa-times-circle"></i> Cancel Order
                    </button>
                </div>
            </div>
        </div>
        <input type="hidden" id="selectedTableId">
        <input type="hidden" id="currentOrderId">
        <input type="hidden" id="isTableOccupied">
    </div>

</div><!-- end app-shell -->

<!-- Mobile floating order bar (outside app-shell to avoid transform clipping) -->
<div class="mob-order-bar" id="mobOrderBar">
    <span class="mob-count" id="mobCountPill" onclick="openBottomSheet()">0 items</span>
    <span class="mob-total">₹<span id="mobTotal">0.00</span></span>
    <button class="mob-place-btn" id="mobPlaceBtn" onclick="saveOrder()" disabled>
        <i class="fas fa-check-circle me-1"></i>Place Order
    </button>
</div>

<!-- ══ BILL MODAL ══ -->
<div class="bm-overlay" id="bmOverlay">
    <div class="bm-modal">
        <!-- Header -->
        <div class="bm-head">
            <div>
                <div class="bm-head-title"><i class="fas fa-file-invoice-dollar me-2"></i>Cafe Bill</div>
                <div class="bm-head-sub" id="bmTableSub">Loading…</div>
            </div>
            <button class="bm-close-btn" onclick="closeBillModal()"><i class="fas fa-times"></i></button>
        </div>
        <!-- Body -->
        <div class="bm-body">

            <!-- Inline validation error -->
            <div id="bmValidationError" style="display:none;margin:0 0 10px;padding:10px 14px;background:#fee2e2;border:1.5px solid #fca5a5;border-radius:8px;color:#b91c1c;font-size:13px;font-weight:600;display:flex;align-items:center;gap:8px;">
                <i class="fas fa-exclamation-circle"></i>
                <span id="bmValidationMsg"></span>
            </div>

            <!-- Items -->
            <div class="bm-sec">
                <div class="bm-sec-title"><i class="fas fa-utensils"></i> Order Items</div>
                <div id="bmItemsList"></div>
                <div class="bm-price-bar">
                    <span style="color:#64748b;font-weight:600;">Price Total</span>
                    <span id="bmPriceTotalDisplay">₹0.00</span>
                </div>
            </div>

            <!-- Customer -->
            <div class="bm-sec">
                <div class="bm-sec-title"><i class="fas fa-user"></i> Customer Details</div>
                <div class="bm-frow">
                    <div class="bm-fg" style="flex:1.5;">
                        <label class="bm-lbl">Customer Name</label>
                        <input type="text" id="bmCustName" class="bm-inp" placeholder="Name (optional)" autocomplete="off">
                        <input type="hidden" id="bmCustId" value="0">
                    </div>
                    <div class="bm-fg" style="flex:1;">
                        <label class="bm-lbl">Phone No</label>
                        <input type="text" id="bmCustPhn" class="bm-inp" placeholder="Phone (optional)" autocomplete="off">
                    </div>
                </div>
            </div>

            <!-- Totals -->
            <div class="bm-sec">
                <div class="bm-sec-title"><i class="fas fa-calculator"></i> Bill Summary</div>
                <div class="bm-frow">
                    <div class="bm-fg">
                        <label class="bm-lbl">Price Total</label>
                        <input type="text" id="bmPriceTotal" class="bm-inp ro" readonly>
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl">Discount</label>
                        <input type="text" id="bmDiscTotal" class="bm-inp ro" readonly value="0.00">
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl">Grand Total</label>
                        <input type="text" id="bmGrandTotal" class="bm-inp ro" readonly>
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl">Extra Disc</label>
                        <input type="number" id="bmExtraDisc" class="bm-inp" value="0" min="0" oninput="calcBillPayable()">
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl red">PAYABLE</label>
                        <input type="text" id="bmPayable" class="bm-inp bm-payable-inp" readonly>
                    </div>
                </div>
            </div>

            <!-- Payment -->
            <div class="bm-sec">
                <div class="bm-sec-title"><i class="fas fa-wallet"></i> Payment</div>
                <div class="bm-frow">
                    <div class="bm-fg">
                        <label class="bm-lbl">Pay Mode</label>
                        <select id="bmMode" class="bm-sel" onchange="updateBmPayFields()">
                            <option value="1">Cash</option>
                            <option value="2">Bank</option>
                            <option value="3">Mixed</option>
                        </select>
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl">Pay Type</label>
                        <select id="bmType" class="bm-sel">
                            <option value="1">UPI</option>
                            <option value="2">Debit Card</option>
                            <option value="3">Credit Card</option>
                            <option value="4">Net Banking</option>
                            <option value="5">Wallet</option>
                        </select>
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl">Cash Paid</label>
                        <input type="number" id="bmCashPaid" class="bm-inp" value="0" min="0">
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl">Bank Paid</label>
                        <input type="number" id="bmBankPaid" class="bm-inp" value="0" min="0">
                    </div>
                    <div class="bm-fg">
                        <label class="bm-lbl">Balance</label>
                        <input type="number" id="bmBalance" class="bm-inp" value="0">
                    </div>
                </div>
            </div>

        </div><!-- /bm-body -->

        <!-- Footer -->
        <div class="bm-foot">
            <div class="bm-foot-summary">
                <div class="bm-foot-label">Payable</div>
                <div class="bm-foot-amount" id="bmFootPayable">₹0.00</div>
            </div>
            <button id="bmSaveBtn" class="bm-save-btn" onclick="saveCafeBill()">
                <i class="fas fa-save"></i> SAVE BILL
            </button>
        </div>
    </div>
</div>

<!-- Bottom Sheet -->
<div class="bsheet-overlay" id="bsheetOverlay" onclick="closeBSheetOnBg(event)">
    <div class="bsheet" id="bsheet">
        <div class="bsheet-handle"></div>
        <div class="bsheet-header">
            <h6><i class="fas fa-receipt me-2"></i>Order Items</h6>
            <button class="bsheet-close" onclick="closeBottomSheet()"><i class="fas fa-times"></i></button>
        </div>
        <div class="bsheet-body" id="bsheetBody">
            <div class="oi-empty"><i class="fas fa-utensils"></i>No items yet</div>
        </div>
        <div class="bsheet-footer">
            <div class="bsheet-total-row">
                <span class="bsheet-total-label">Total</span>
                <span class="bsheet-total-amount">₹<span id="bsheetTotal">0.00</span></span>
            </div>
            <button class="btn-place-order" id="bsheetPlaceBtn" onclick="saveOrder()" disabled>
                <i class="fas fa-check-circle"></i> Place Order
            </button>
            <button class="btn-cancel-order" id="bsheetCancelBtn" style="display:none;" onclick="cancelOrder()">
                <i class="fas fa-times-circle"></i> Cancel Order
            </button>
        </div>
    </div>
</div>

<script>
/* ── STATE ── */
let orderItems = [];
let allProducts = [];
let selectedCategoryId = null;

/* ── VIEWS ── */
function showView(id) {
    document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
    document.getElementById(id).classList.add('active');
}

function escJs(s) { return (s+'').replace(/\\/g,'\\\\').replace(/'/g,"\\'"); }

/* ── TABLES ── */
$(document).ready(function(){ loadTables(); });

function loadTables() {
    $.ajax({ url:'getAvailableTables.jsp', dataType:'json',
        success: function(tables){ renderTables(tables); },
        error: function(){ $('#tablesGrid').html('<div style="grid-column:1/-1;text-align:center;color:#ef4444;padding:40px;"><i class="fas fa-exclamation-circle fa-2x"></i><br><br>Error loading tables</div>'); }
    });
}

function refreshTables() {
    $('#tablesGrid').html('<div style="grid-column:1/-1;text-align:center;padding:40px;color:#94a3b8;"><i class="fas fa-spinner fa-spin fa-2x"></i><br><br>Loading…</div>');
    loadTables();
}

function renderTables(tables) {
    if (!tables || tables.length === 0) {
        $('#tablesGrid').html('<div style="grid-column:1/-1;text-align:center;padding:40px;color:#94a3b8;"><i class="fas fa-chair fa-2x" style="opacity:.3"></i><br><br>No tables found.</div>');
        return;
    }
    let html = '';
    tables.forEach(t => {
        const occ = t.is_occupied == 1;
        const cls = occ ? 'occupied' : 'available';
        const icon = occ ? 'fa-utensils' : 'fa-chair';
        const badge = occ ? 'Occupied' : 'Available';
        const fn = occ ? `viewOccupiedTableOrder(${t.id},'${escJs(t.name)}')` : `selectTable(${t.id},'${escJs(t.name)}')`;
        html += `<div class="table-card ${cls}" onclick="${fn}">
            ${occ ? '<div class="tc-occ-dot"><i class="fas fa-user"></i></div>' : ''}
            <div class="tc-icon"><i class="fas ${icon}"></i></div>
            <div class="tc-name">${t.name}</div>
            <span class="tc-badge">${badge}</span>
            ${occ ? `<button class="tc-bill-btn" onclick="event.stopPropagation();openBillForTable(${t.id},'${escJs(t.name)}')">
                <i class="fas fa-file-invoice-dollar"></i> Bill
            </button>` : ''}
        </div>`;
    });
    $('#tablesGrid').html(html);
}

function goBackToTables() {
    document.getElementById('mobOrderBar').style.display = 'none';
    showView('tablesView'); orderItems = []; loadTables();
}

function showMobBar() {
    if (window.innerWidth <= 700)
        document.getElementById('mobOrderBar').style.display = 'flex';
}

/* ── OPEN BILL DIRECTLY FROM TABLE CARD ── */
function openBillForTable(tableId, tableName) {
    Swal.fire({ title: 'Loading order…', allowOutsideClick: false, didOpen: () => Swal.showLoading() });
    $.ajax({ url: 'getTableOrder.jsp', data: { tableId }, dataType: 'json',
        success: function(data) {
            Swal.close();
            if (data.error) { Swal.fire('Error', data.error, 'error'); return; }
            if (!data.items || data.items.length === 0) {
                Swal.fire('No Items', 'No items found for this table.', 'info'); return;
            }
            // Set state so openBillModal can use it
            document.getElementById('selectedTableId').value = tableId;
            document.getElementById('currentOrderId').value  = data.orderId || '';
            document.getElementById('isTableOccupied').value = '1';
            document.getElementById('orderTableName').textContent = tableName;
            orderItems = data.items || [];
            openBillModal();
        },
        error: function() { Swal.fire('Error', 'Could not load table order.', 'error'); }
    });
}

/* ── SELECT TABLE ── */
function selectTable(id, name) {
    orderItems = [];
    $('#selectedTableId').val(id); $('#currentOrderId').val(''); $('#isTableOccupied').val('0');
    $('#orderTableName').text(name);
    $('#orderStatusPill').removeClass('occupied').addClass('available').text('Available');
    $('#btnCancelOrder').hide();
    $('#bsheetCancelBtn').hide();
    renderOrderItems(); loadCategories(); loadProducts(null);
    showView('orderView');
    showMobBar();
}

function viewOccupiedTableOrder(tableId, tableName) {
    $.ajax({ url:'getTableOrder.jsp', data:{tableId}, dataType:'json',
        success: function(data) {
            if (data.error) { Swal.fire('Error', data.error, 'error'); return; }
            $('#selectedTableId').val(tableId);
            $('#orderTableName').text(tableName);
            $('#orderStatusPill').removeClass('available').addClass('occupied').text('Occupied');
            $('#currentOrderId').val(data.orderId||'');
            $('#isTableOccupied').val('1');
            orderItems = data.items||[];
            if (data.orderId) { $('#btnCancelOrder').show(); $('#bsheetCancelBtn').show(); }
            else              { $('#btnCancelOrder').hide(); $('#bsheetCancelBtn').hide(); }
            selectedCategoryId = null;
            renderOrderItems(); loadCategories(); loadProducts(null);
            showView('orderView');
            showMobBar();
        },
        error: function(){ Swal.fire('Error','Could not load table order','error'); }
    });
}

/* ── CATEGORIES ── */
function loadCategories() {
    $.ajax({ url:'getCategories.jsp', dataType:'json',
        success: function(cats) {
            let html = '<button class="cat-btn active" onclick="selectCategory(null,this)"><i class="fas fa-th me-1"></i>All</button>';
            (cats||[]).forEach(c => { html += `<button class="cat-btn" onclick="selectCategory(${c.id},this)">${c.name}</button>`; });
            $('#catStrip').html(html);
        }
    });
}

function selectCategory(catId, btn) {
    selectedCategoryId = catId;
    document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
    if (btn) btn.classList.add('active');
    loadProducts(catId);
    $('#prodSearch').val('');
}

/* ── PRODUCTS ── */
function loadProducts(catId) {
    let url = 'getProducts.jsp';
    if (catId != null) url += '?category_id=' + catId;
    $('#prodGrid').html('<div class="prod-empty"><i class="fas fa-spinner fa-spin"></i> Loading…</div>');
    $.ajax({ url, dataType:'json',
        success: function(products) { allProducts = products||[]; renderProducts(allProducts); },
        error: function(){ $('#prodGrid').html('<div class="prod-empty"><i class="fas fa-exclamation-circle"></i> Error loading products</div>'); }
    });
}

function renderProducts(products) {
    if (!products || products.length === 0) {
        $('#prodGrid').html('<div class="prod-empty"><i class="fas fa-box-open"></i><br>No items found</div>');
        return;
    }
    let html = '';
    products.forEach(p => {
        const inOrder = orderItems.find(o => o.prodId == p.id);
        const inCls = inOrder ? 'in-order' : '';
        const qty = inOrder ? inOrder.qty : 0;
        html += `<div class="prod-card ${inCls}" id="pc-${p.id}" onclick="addToOrder(${p.id},'${escJs(p.name)}',${p.price},'${escJs(p.code)}')">
            <div class="pc-qty-badge">${qty > 0 ? qty : ''}</div>
            <div class="pc-icon"><i class="fas fa-utensils"></i></div>
            <div class="pc-name">${p.name}</div>
            <div class="pc-price">₹${parseFloat(p.price).toFixed(2)}</div>
        </div>`;
    });
    $('#prodGrid').html(html);
}

$('#prodSearch').on('input', function() {
    const q = this.value.toLowerCase().trim();
    if (!q) { renderProducts(allProducts); return; }
    renderProducts(allProducts.filter(p => p.name.toLowerCase().includes(q) || (p.code&&p.code.toLowerCase().includes(q))));
});

/* ── ORDER ── */
function addToOrder(prodId, prodName, price, code) {
    let item = orderItems.find(i => i.prodId == prodId);
    if (item) { item.qty++; item.total = item.qty * item.price; }
    else { orderItems.push({prodId, prodName, code:code||'', price:parseFloat(price), qty:1, total:parseFloat(price)}); }
    renderOrderItems(); updateProductCard(prodId);
}

function updateQty(prodId, change) {
    let item = orderItems.find(i => i.prodId == prodId);
    if (!item) return;
    item.qty += change;
    if (item.qty <= 0) orderItems = orderItems.filter(i => i.prodId != prodId);
    else item.total = item.qty * item.price;
    renderOrderItems(); updateProductCard(prodId);
}

function removeItem(prodId) {
    orderItems = orderItems.filter(i => i.prodId != prodId);
    renderOrderItems(); updateProductCard(prodId);
}

function updateProductCard(prodId) {
    const card = document.getElementById('pc-'+prodId);
    if (!card) return;
    const item = orderItems.find(i => i.prodId == prodId);
    const badge = card.querySelector('.pc-qty-badge');
    if (item) { card.classList.add('in-order'); if(badge){badge.textContent=item.qty;} }
    else      { card.classList.remove('in-order'); if(badge){badge.textContent='';} }
}

function buildOrderHTML() {
    if (orderItems.length === 0) return '<div class="oi-empty"><i class="fas fa-utensils"></i>Add items from the menu</div>';
    let html = '';
    orderItems.forEach(item => {
        html += `<div class="oi-row">
            <div style="flex:1;min-width:0;">
                <div class="oi-name">${item.prodName}</div>
                <div class="oi-price">₹${item.price.toFixed(2)} each</div>
            </div>
            <div class="oi-qty-ctrl">
                <button class="qty-btn minus" onclick="updateQty(${item.prodId},-1)">−</button>
                <span class="qty-num">${item.qty}</span>
                <button class="qty-btn plus"  onclick="updateQty(${item.prodId}, 1)">+</button>
            </div>
            <div class="oi-total">₹${item.total.toFixed(2)}</div>
            <button class="oi-del" onclick="removeItem(${item.prodId})" title="Remove"><i class="fas fa-times"></i></button>
        </div>`;
    });
    return html;
}

function renderOrderItems() {
    const total = orderItems.reduce((s,i) => s+i.total, 0);
    const count = orderItems.reduce((s,i) => s+i.qty, 0);
    const label = count+(count===1?' item':' items');

    // Desktop panel
    document.getElementById('orderTotal').textContent = total.toFixed(2);
    document.getElementById('orderCountPill').textContent = label;
    document.getElementById('btnPlaceOrder').disabled = orderItems.length === 0;
    document.getElementById('orderItemsList').innerHTML = orderItems.length === 0
        ? '<div class="oi-empty"><i class="fas fa-utensils"></i>Add items from the menu</div>'
        : buildOrderHTML();

    // Mobile bar
    document.getElementById('mobCountPill').textContent = label;
    document.getElementById('mobTotal').textContent = total.toFixed(2);
    document.getElementById('mobPlaceBtn').disabled = orderItems.length === 0;

    // Mobile cancel btn
    const bsheetCancel = document.getElementById('bsheetCancelBtn');
    const desktopCancel = document.getElementById('btnCancelOrder');
    const showCancel = document.getElementById('currentOrderId').value !== '';
    if (bsheetCancel) bsheetCancel.style.display = showCancel ? 'flex' : 'none';
    if (desktopCancel) desktopCancel.style.display = showCancel ? 'flex' : 'none';

    // Refresh bottom sheet if open
    if (document.getElementById('bsheetOverlay').classList.contains('open')) {
        refreshBottomSheet();
    }
}

function refreshBottomSheet() {
    const total = orderItems.reduce((s,i) => s+i.total, 0);
    document.getElementById('bsheetBody').innerHTML = orderItems.length === 0
        ? '<div class="oi-empty"><i class="fas fa-utensils"></i>No items yet</div>'
        : buildOrderHTML();
    document.getElementById('bsheetTotal').textContent = total.toFixed(2);
    document.getElementById('bsheetPlaceBtn').disabled = orderItems.length === 0;
}

function openBottomSheet() {
    refreshBottomSheet();
    const overlay = document.getElementById('bsheetOverlay');
    overlay.style.display = 'flex';
    requestAnimationFrame(() => overlay.classList.add('open'));
}

function closeBottomSheet() {
    const overlay = document.getElementById('bsheetOverlay');
    overlay.classList.remove('open');
    setTimeout(() => { overlay.style.display = 'none'; }, 290);
}

function closeBSheetOnBg(e) {
    if (e.target === document.getElementById('bsheetOverlay')) closeBottomSheet();
}

/* ── SAVE / CANCEL ── */
function saveOrder() {
    if (orderItems.length === 0) return;
    $.post('saveOrder.jsp', {tableId:$('#selectedTableId').val(), items:JSON.stringify(orderItems)}, function(resp) {
        if (resp.trim()==='success') {
            Swal.fire({icon:'success',title:'Order Placed!',text:'Order has been placed successfully.',confirmButtonColor:'#f5a623'})
                .then(() => { orderItems=[]; goBackToTables(); });
        } else { Swal.fire('Error', resp, 'error'); }
    });
}

function cancelOrder() {
    const orderId = $('#currentOrderId').val();
    if (!orderId) { Swal.fire('Info','No active order to cancel.','info'); return; }
    Swal.fire({title:'Cancel Order?',text:'This will cancel the current order for this table.',icon:'warning',
        showCancelButton:true,confirmButtonColor:'#ef4444',cancelButtonColor:'#94a3b8',
        confirmButtonText:'Yes, Cancel',cancelButtonText:'No'
    }).then(result => {
        if (!result.isConfirmed) return;
        $.post('cancelOrder.jsp', {orderId, tableId:$('#selectedTableId').val()}, function(resp) {
            if (resp.trim()==='success') {
                Swal.fire({icon:'success',title:'Cancelled!',text:'Order cancelled.',confirmButtonColor:'#f5a623'})
                    .then(() => { orderItems=[]; goBackToTables(); });
            } else { Swal.fire('Error', resp, 'error'); }
        });
    });
}

/* ════════════════════════════════════════
   BILL MODAL LOGIC
   ════════════════════════════════════════ */
var bmItems = [];
var bmCustTimeout;
var _ctxPath = '<%=ctxPath%>';

function openBillModal() {
    if (orderItems.length === 0) {
        Swal.fire('No Items','There are no items in this order to bill.','info');
        return;
    }
    // Deep-copy order items
    bmItems = orderItems.map(i => Object.assign({}, i));

    const tableName = $('#orderTableName').text();
    document.getElementById('bmTableSub').textContent = tableName;

    // Reset fields
    document.getElementById('bmCustName').value = '';
    document.getElementById('bmCustId').value   = '0';
    document.getElementById('bmCustPhn').value  = '';
    document.getElementById('bmExtraDisc').value = '0';
    // Clear any previous validation error
    var errDiv = document.getElementById('bmValidationError');
    if (errDiv) { errDiv.style.display = 'none'; document.getElementById('bmCustName').style.borderColor = ''; }
    document.getElementById('bmMode').value = '1';
    document.getElementById('bmType').value = '1';
    // Reset save button in case it was left in loading state
    var saveBtn = document.getElementById('bmSaveBtn');
    saveBtn.disabled = false;
    saveBtn.innerHTML = '<i class="fas fa-save"></i> SAVE BILL';

    renderBmItems();
    calcBillTotals();
    setupBmAutocomplete();

    const ol = document.getElementById('bmOverlay');
    ol.style.display = 'flex';
    requestAnimationFrame(() => ol.classList.add('open'));
    // Hide Place Order bar while bill modal is open
    document.getElementById('mobOrderBar').style.display = 'none';
}

function closeBillModal() {
    const ol = document.getElementById('bmOverlay');
    ol.classList.remove('open');
    setTimeout(() => { ol.style.display = 'none'; }, 250);
    // Restore Place Order bar (we're still in order view)
    showMobBar();
}

// Close on overlay click
document.getElementById('bmOverlay').addEventListener('click', function(e) {
    if (e.target === this) closeBillModal();
});

function renderBmItems() {
    if (!bmItems || bmItems.length === 0) {
        document.getElementById('bmItemsList').innerHTML = '<div style="text-align:center;padding:20px;color:#94a3b8;">No items</div>';
        return;
    }
    let html = '';
    bmItems.forEach(function(item, idx) {
        const lineTotal = (item.qty * item.price).toFixed(2);
        html += '<div class="bm-irow">' +
            '<div class="bm-irow-info">' +
                '<div class="bm-irow-name">' + item.prodName + '</div>' +
                '<div class="bm-irow-price">\u20b9' + item.price.toFixed(2) + ' each</div>' +
            '</div>' +
            '<div class="bm-iqc">' +
                '<button class="bm-qbtn m" onclick="updateBmQty(' + idx + ',-1)">&minus;</button>' +
                '<span class="bm-qnum">' + item.qty + '</span>' +
                '<button class="bm-qbtn p" onclick="updateBmQty(' + idx + ',1)">+</button>' +
            '</div>' +
            '<div class="bm-itotal">\u20b9' + lineTotal + '</div>' +
        '</div>';
    });
    document.getElementById('bmItemsList').innerHTML = html;
}

function updateBmQty(idx, chg) {
    bmItems[idx].qty += chg;
    if (bmItems[idx].qty <= 0) {
        bmItems.splice(idx, 1);
    } else {
        bmItems[idx].total = bmItems[idx].qty * bmItems[idx].price;
    }
    renderBmItems();
    calcBillTotals();
}

function calcBillTotals() {
    const priceTotal = bmItems.reduce(function(s,i){ return s + i.qty * i.price; }, 0);
    const extraDisc  = parseFloat(document.getElementById('bmExtraDisc').value) || 0;
    const capped     = Math.min(extraDisc, priceTotal);
    if (capped !== extraDisc) document.getElementById('bmExtraDisc').value = capped;
    const payable    = Math.max(0, priceTotal - capped);

    document.getElementById('bmPriceTotalDisplay').textContent = '\u20b9' + priceTotal.toFixed(2);
    document.getElementById('bmPriceTotal').value   = priceTotal.toFixed(2);
    document.getElementById('bmDiscTotal').value    = '0.00';
    document.getElementById('bmGrandTotal').value   = priceTotal.toFixed(2);
    document.getElementById('bmPayable').value      = payable.toFixed(2);
    document.getElementById('bmFootPayable').textContent = '\u20b9' + payable.toFixed(2);

    updateBmPayFields();
}

function calcBillPayable() { calcBillTotals(); }

function updateBmPayFields() {
    var payable  = parseFloat(document.getElementById('bmPayable').value) || 0;
    var mode     = document.getElementById('bmMode').value;
    var cash     = document.getElementById('bmCashPaid');
    var bank     = document.getElementById('bmBankPaid');
    var bal      = document.getElementById('bmBalance');

    cash.oninput = null; bank.oninput = null; bal.oninput = null;

    if (mode === '1') {          // Cash
        cash.disabled = false; bank.disabled = true; bal.disabled = true;
        cash.value = payable.toFixed(2); bank.value = '0'; bal.value = '0';
        cash.oninput = function() { bal.value = (payable - (parseFloat(cash.value)||0)).toFixed(2); };
    } else if (mode === '2') {   // Bank
        cash.disabled = true; bank.disabled = false; bal.disabled = true;
        cash.value = '0'; bank.value = payable.toFixed(2); bal.value = '0';
        bank.oninput = function() { bal.value = (payable - (parseFloat(bank.value)||0)).toFixed(2); };
    } else {                     // Mixed
        cash.disabled = false; bank.disabled = false; bal.disabled = false;
        cash.value = payable.toFixed(2); bank.value = '0'; bal.value = '0';
        cash.oninput = function() {
            var bkv = parseFloat(bank.value)||0, bv = parseFloat(bal.value)||0;
            bank.value = Math.max(0, payable - (parseFloat(cash.value)||0) - bv).toFixed(2);
        };
        bank.oninput = function() {
            var cv = parseFloat(cash.value)||0, bv = parseFloat(bal.value)||0;
            cash.value = Math.max(0, payable - (parseFloat(bank.value)||0) - bv).toFixed(2);
        };
        bal.oninput = function() {
            var bkv = parseFloat(bank.value)||0, bv = parseFloat(bal.value)||0;
            cash.value = Math.max(0, payable - bkv - bv).toFixed(2);
        };
    }
}

/* -- BILL CUSTOMER AUTOCOMPLETE -- */
var _bmAcSetup = false;
function setupBmAutocomplete() {
    if (_bmAcSetup) return;
    _bmAcSetup = true;
    var nameInp = document.getElementById('bmCustName');
    var phnInp  = document.getElementById('bmCustPhn');
    var acTimer;

    nameInp.addEventListener('input', function() {
        var q = this.value.trim();
        clearTimeout(acTimer); removeBmAc('name');
        if (q.length < 2) { document.getElementById('bmCustId').value = '0'; return; }
        acTimer = setTimeout(function() {
            fetch(_ctxPath + '/billing/customerAutocomplete.jsp?query=' + encodeURIComponent(q))
                .then(function(r){ return r.json(); })
                .then(function(d){ if (d.length) showBmAcList(d, nameInp, 'name'); })
                .catch(function(e){ console.error(e); });
        }, 300);
    });

    phnInp.addEventListener('input', function() {
        var q = this.value.trim();
        clearTimeout(acTimer); removeBmAc('phone');
        if (q.length < 3) return;
        acTimer = setTimeout(function() {
            fetch(_ctxPath + '/billing/customerAutocomplete.jsp?phone=' + encodeURIComponent(q))
                .then(function(r){ return r.json(); })
                .then(function(d){ if (d.length) showBmAcList(d, phnInp, 'phone'); })
                .catch(function(e){ console.error(e); });
        }, 300);
    });

    document.addEventListener('click', function(e) {
        if (e.target !== nameInp) removeBmAc('name');
        if (e.target !== phnInp)  removeBmAc('phone');
    });
}

function showBmAcList(customers, inputEl, type) {
    removeBmAc(type);
    var list = document.createElement('ul');
    list.id = 'bmAc_' + type;
    list.className = 'bm-ac-list';
    customers.forEach(function(c) {
        var li = document.createElement('li');
        li.textContent = type === 'name'
            ? (c.name + (c.phone && c.phone !== '-' ? ' — ' + c.phone : ''))
            : (c.phone + (c.name ? ' — ' + c.name : ''));
        li.addEventListener('click', function() { selectBmCustomer(c); });
        list.appendChild(li);
    });
    inputEl.parentElement.appendChild(list);
    inputEl.addEventListener('keydown', function hdl(e) {
        if (e.key === 'Tab' || e.key === 'Enter') {
            e.preventDefault();
            var first = list.querySelector('li');
            if (first) first.click();
            inputEl.removeEventListener('keydown', hdl);
        }
    });
}

function removeBmAc(type) {
    var el = document.getElementById('bmAc_' + type);
    if (el) el.remove();
}

function selectBmCustomer(c) {
    document.getElementById('bmCustName').value = c.name || '';
    document.getElementById('bmCustPhn').value  = (c.phone && c.phone !== '-') ? c.phone : '';
    document.getElementById('bmCustId').value   = c.id || '0';
    removeBmAc('name'); removeBmAc('phone');
}

/* -- SAVE CAFE BILL -- */
function saveCafeBill() {
    if (!bmItems || bmItems.length === 0) {
        Swal.fire('Empty Bill','Please add items to the order before saving.','warning');
        return;
    }

    var customerName = (document.getElementById('bmCustName').value.trim() || '-');
    var customerPhn  = (document.getElementById('bmCustPhn').value.trim()  || '-');
    var customerId   = document.getElementById('bmCustId').value || '0';

    var priceTotal   = parseFloat(document.getElementById('bmPriceTotal').value) || 0;
    var discountTotal= parseFloat(document.getElementById('bmDiscTotal').value)  || 0;
    var grandTotalV  = parseFloat(document.getElementById('bmGrandTotal').value) || 0;
    var finalDiscount= parseFloat(document.getElementById('bmExtraDisc').value)  || 0;
    var payableAmt   = parseFloat(document.getElementById('bmPayable').value)    || 0;
    var mode         = document.getElementById('bmMode').value;
    var type         = document.getElementById('bmType').value;
    var cashPaid     = parseFloat(document.getElementById('bmCashPaid').value)   || 0;
    var bankPaid     = parseFloat(document.getElementById('bmBankPaid').value)   || 0;
    var totalPaid    = cashPaid + bankPaid;
    var balance      = parseFloat(document.getElementById('bmBalance').value)    || 0;

    if (priceTotal === 0) {
        Swal.fire('Empty Bill','No items to bill.','warning');
        return;
    }
    if (totalPaid > payableAmt + 0.01) {
        Swal.fire('Error','Paid amount exceeds payable amount.','error');
        return;
    }
    if (Math.abs(totalPaid + balance - payableAmt) > 0.05) {
        Swal.fire('Error','Cash Paid + Bank Paid + Balance must equal Payable amount.','error');
        return;
    }
    if (customerName === '-' && balance > 0) {
        var errDiv = document.getElementById('bmValidationError');
        document.getElementById('bmValidationMsg').textContent = 'Customer name is required for due/balance payment.';
        errDiv.style.display = 'flex';
        // Scroll error into view and highlight the field
        errDiv.scrollIntoView({ behavior: 'smooth', block: 'start' });
        var nameInp = document.getElementById('bmCustName');
        nameInp.style.borderColor = '#ef4444';
        nameInp.focus();
        nameInp.addEventListener('input', function clearErr() {
            errDiv.style.display = 'none';
            nameInp.style.borderColor = '';
            nameInp.removeEventListener('input', clearErr);
        });
        return;
    }

    var products = bmItems.map(function(item) {
        return { id: item.prodId, qty: item.qty, price: item.price,
                 discount: 0, total: item.qty * item.price, batchId: 0, commission: 0 };
    });

    var btn = document.getElementById('bmSaveBtn');
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving…';

    $.ajax({
        url:  _ctxPath + '/billing/saveBill.jsp',
        type: 'POST',
        data: {
            customerName:  customerName,
            customerId:    customerId,
            attenderId:    0,
            priceCategory: 3,
            isTaxBill:     1,
            finalDiscount: finalDiscount,
            payableAmount: payableAmt,
            grandTotal:    grandTotalV,
            priceTotal:    priceTotal,
            discountTotal: discountTotal,
            customerPhn:   customerPhn,
            mode:          mode,
            type:          type,
            cashPaid:      cashPaid,
            bankPaid:      bankPaid,
            totalPaid:     totalPaid,
            balance:       balance,
            quotationId:   0,
            isEligibleForCommission: 0,
            products:      JSON.stringify(products),
            exchangePointUsed: 0
        },
        success: function(resp) {
            var r = resp.trim();
            if (r.indexOf('ERROR:') === 0) {
                Swal.fire('Error Saving Bill', r, 'error');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-save"></i> SAVE BILL';
                return;
            }
            // Mark order as billed and free the table
            var orderId = document.getElementById('currentOrderId').value;
            var tableId = document.getElementById('selectedTableId').value;
            if (orderId && tableId) {
                $.post(_ctxPath + '/billing/updateOrderStatus.jsp', { orderId: orderId, tableId: tableId });
            }
            closeBillModal();
            Swal.fire({
                icon: 'success', title: 'Bill Saved!',
                html: 'Bill No: <b>' + r + '</b>',
                confirmButtonColor: '#f5a623'
            }).then(function() { location.reload(); });
        },
        error: function(xhr) {
            var msg = xhr.status === 401
                ? 'Session expired. Please login again.'
                : 'Failed to save bill. Status: ' + xhr.status;
            Swal.fire('Error!', msg, 'error');
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-save"></i> SAVE BILL';
        }
    });
}
</script>

</body>
</html>
