<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="user" class="user.userBean" />
<%
String contextPath = request.getContextPath();
Integer uid = (Integer) session.getAttribute("userId");
String userName = (String) session.getAttribute("username");
if (uid == null) { response.sendRedirect(contextPath + "/index.jsp"); return; }
Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0;i<vecPer.size();i++) { Vector cat=(Vector)vecPer.get(i); permissions.add(Integer.parseInt(cat.elementAt(0).toString())); }
if (!permissions.contains(13)) { out.print("<script>alert('Access Denied');window.location='"+contextPath+"/';</script>"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance Entry</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/assets/common/head.jsp" />
    <style>
        body { background:#f0f2f5; }
        .att-page { max-width:700px; margin:40px auto; padding:0 16px 40px; }

        .att-hero {
            background:#1c1c2e; color:#fff; border-radius:20px;
            padding:28px 28px 24px; margin-bottom:22px;
            display:flex; align-items:center; justify-content:space-between; gap:16px;
            box-shadow:0 8px 32px rgba(0,0,0,.18);
        }
        .att-hero-left h2 { font-size:22px; font-weight:800; margin:0 0 4px; }
        .att-hero-left .sub { font-size:13px; color:rgba(255,255,255,.55); }
        .att-clock .time { font-size:30px; font-weight:800; color:#f5a623; letter-spacing:1px; }
        .att-clock .date { font-size:11px; color:rgba(255,255,255,.5); margin-top:2px; text-align:right; }

        .att-status {
            border-radius:12px; padding:13px 18px; margin-bottom:20px;
            font-size:14px; font-weight:600; display:flex; align-items:center; gap:10px;
        }
        .att-status.info    { background:#e0f2fe; color:#0369a1; }
        .att-status.warning { background:#fef9c3; color:#854d0e; }
        .att-status.success { background:#dcfce7; color:#166534; }
        .att-status.danger  { background:#fee2e2; color:#991b1b; }

        .shifts-grid { display:grid; grid-template-columns:1fr 1fr 1fr; gap:16px; }
        @media(max-width:760px) { .shifts-grid { grid-template-columns:1fr 1fr; } }
        @media(max-width:520px) { .shifts-grid { grid-template-columns:1fr; } }

        .shift-card {
            background:#fff; border-radius:16px; padding:20px;
            box-shadow:0 2px 10px rgba(0,0,0,.07);
            border:2px solid transparent; transition:border-color .2s;
        }
        .shift-card.active { border-color:#f5a623; }
        .shift-card.done   { border-color:#22c55e; }
        .shift-card.locked { opacity:.55; }

        .shift-title {
            font-size:13px; font-weight:800; text-transform:uppercase;
            letter-spacing:.6px; color:#64748b; margin-bottom:14px;
            display:flex; align-items:center; gap:7px;
        }
        .shift-dot { width:8px; height:8px; border-radius:50%; flex-shrink:0; background:#e2e8f0; }
        .shift-card.active .shift-dot { background:#f5a623; }
        .shift-card.done   .shift-dot { background:#22c55e; }

        .shift-times { display:flex; gap:10px; margin-bottom:16px; }
        .shift-time-box { flex:1; background:#f8fafc; border-radius:10px; padding:10px 12px; text-align:center; }
        .shift-time-box .lbl { font-size:10px; color:#94a3b8; font-weight:700; text-transform:uppercase; }
        .shift-time-box .val { font-size:18px; font-weight:800; color:#1c1c2e; margin-top:2px; }
        .shift-time-box .val.empty { color:#cbd5e1; font-size:14px; font-weight:400; }

        .shift-btns { display:grid; grid-template-columns:1fr 1fr; gap:8px; }
        .shift-btn {
            border:none; border-radius:10px; padding:10px 8px;
            font-size:13px; font-weight:800; cursor:pointer;
            display:flex; align-items:center; justify-content:center; gap:6px; transition:all .15s;
        }
        .shift-btn.in-btn  { background:#dcfce7; color:#16a34a; }
        .shift-btn.in-btn:hover:not(:disabled)  { background:#bbf7d0; }
        .shift-btn.out-btn { background:#fee2e2; color:#dc2626; }
        .shift-btn.out-btn:hover:not(:disabled) { background:#fecaca; }
        .shift-btn:disabled { opacity:.4; cursor:not-allowed; }

        .duration-badge {
            text-align:center; font-size:12px; font-weight:700; color:#f5a623;
            margin-top:10px; background:#fff8f0; border-radius:8px; padding:5px; display:none;
        }
        .shift-card.done .duration-badge { display:block; }
    </style>
</head>
<body>
<jsp:include page="/assets/navbar/navbar.jsp" />

<div class="att-page">
    <div class="att-hero">
        <div class="att-hero-left">
            <h2><i class="fas fa-fingerprint me-2" style="color:#f5a623"></i>Attendance</h2>
            <div class="sub">Welcome, <strong style="color:#fff"><%=userName%></strong></div>
        </div>
        <div class="att-clock">
            <div class="time" id="liveClock">--:--</div>
            <div class="date" id="liveDate"></div>
        </div>
    </div>

    <div class="att-status info" id="attStatus">
        <i class="fas fa-spinner fa-spin"></i> Loading attendance…
    </div>

    <div class="shifts-grid">
        <!-- Shift 1 -->
        <div class="shift-card" id="shift1Card">
            <div class="shift-title"><span class="shift-dot"></span> Shift 1 — Morning</div>
            <div class="shift-times">
                <div class="shift-time-box"><div class="lbl">In</div><div class="val empty" id="s1in">—</div></div>
                <div class="shift-time-box"><div class="lbl">Out</div><div class="val empty" id="s1out">—</div></div>
            </div>
            <div class="shift-btns">
                <button class="shift-btn in-btn"  id="btn_in1"  onclick="mark('in1')"  disabled><i class="fas fa-sign-in-alt"></i> In</button>
                <button class="shift-btn out-btn" id="btn_out1" onclick="mark('out1')" disabled><i class="fas fa-sign-out-alt"></i> Out</button>
            </div>
            <div class="duration-badge" id="dur1"></div>
        </div>
        <!-- Shift 2 -->
        <div class="shift-card locked" id="shift2Card">
            <div class="shift-title"><span class="shift-dot"></span> Shift 2 — Evening</div>
            <div class="shift-times">
                <div class="shift-time-box"><div class="lbl">In</div><div class="val empty" id="s2in">—</div></div>
                <div class="shift-time-box"><div class="lbl">Out</div><div class="val empty" id="s2out">—</div></div>
            </div>
            <div class="shift-btns">
                <button class="shift-btn in-btn"  id="btn_in2"  onclick="mark('in2')"  disabled><i class="fas fa-sign-in-alt"></i> In</button>
                <button class="shift-btn out-btn" id="btn_out2" onclick="mark('out2')" disabled><i class="fas fa-sign-out-alt"></i> Out</button>
            </div>
            <div class="duration-badge" id="dur2"></div>
        </div>
        <!-- Shift 3 -->
        <div class="shift-card locked" id="shift3Card">
            <div class="shift-title"><span class="shift-dot"></span> Shift 3 — Night</div>
            <div class="shift-times">
                <div class="shift-time-box"><div class="lbl">In</div><div class="val empty" id="s3in">—</div></div>
                <div class="shift-time-box"><div class="lbl">Out</div><div class="val empty" id="s3out">—</div></div>
            </div>
            <div class="shift-btns">
                <button class="shift-btn in-btn"  id="btn_in3"  onclick="mark('in3')"  disabled><i class="fas fa-sign-in-alt"></i> In</button>
                <button class="shift-btn out-btn" id="btn_out3" onclick="mark('out3')" disabled><i class="fas fa-sign-out-alt"></i> Out</button>
            </div>
            <div class="duration-badge" id="dur3"></div>
        </div>
</div>

<script>
const contextPath = '<%=contextPath%>';

function tickClock() {
    const now = new Date();
    document.getElementById('liveClock').textContent = now.toLocaleTimeString('en-IN',{hour:'2-digit',minute:'2-digit',hour12:true});
    document.getElementById('liveDate').textContent  = now.toLocaleDateString('en-IN',{weekday:'long',day:'numeric',month:'long',year:'numeric'});
}
tickClock(); setInterval(tickClock,1000);

function calcDur(inT, outT) {
    if (!inT||!outT) return null;
    const [ih,im]=inT.split(':').map(Number), [oh,om]=outT.split(':').map(Number);
    const d=(oh*60+om)-(ih*60+im); if(d<0) return null;
    return Math.floor(d/60)+'h '+(d%60)+'m';
}

function applyState(d) {
    const i1=d.in1||null,o1=d.out1||null,i2=d.in2||null,o2=d.out2||null,i3=d.in3||null,o3=d.out3||null;
    [['s1in',i1],['s1out',o1],['s2in',i2],['s2out',o2],['s3in',i3],['s3out',o3]].forEach(([id,v])=>{
        const el=document.getElementById(id);
        el.textContent=v||'—'; el.classList.toggle('empty',!v);
    });
    const c1=document.getElementById('shift1Card'); c1.classList.remove('active','done','locked');
    if(o1) c1.classList.add('done'); else if(i1) c1.classList.add('active');
    const c2=document.getElementById('shift2Card'); c2.classList.remove('active','done','locked');
    if(o2) c2.classList.add('done'); else if(i2) c2.classList.add('active'); else if(!o1) c2.classList.add('locked');
    const c3=document.getElementById('shift3Card'); c3.classList.remove('active','done','locked');
    if(o3) c3.classList.add('done'); else if(i3) c3.classList.add('active'); else if(!o2) c3.classList.add('locked');

    document.getElementById('btn_in1').disabled  = !!i1;
    document.getElementById('btn_out1').disabled = !i1||!!o1;
    document.getElementById('btn_in2').disabled  = !o1||!!i2;
    document.getElementById('btn_out2').disabled = !i2||!!o2;
    document.getElementById('btn_in3').disabled  = !o2||!!i3;
    document.getElementById('btn_out3').disabled = !i3||!!o3;

    const d1=calcDur(i1,o1), d2=calcDur(i2,o2), d3=calcDur(i3,o3);
    document.getElementById('dur1').textContent = d1?'⏱ '+d1:'';
    document.getElementById('dur2').textContent = d2?'⏱ '+d2:'';
    document.getElementById('dur3').textContent = d3?'⏱ '+d3:'';

    const st=document.getElementById('attStatus');
    if(!d.hasEntry||!i1)            { st.className='att-status info';    st.innerHTML='<i class="fas fa-play-circle"></i> Ready — click <strong>Shift 1 In</strong> to begin.'; }
    else if(i1&&!o1)                { st.className='att-status warning'; st.innerHTML='<i class="fas fa-sun"></i> Shift 1 in progress since <strong>'+i1+'</strong>'; }
    else if(o1&&!i2)                { st.className='att-status info';    st.innerHTML='<i class="fas fa-coffee"></i> Shift 1 done ('+(d1||'—')+') — start Shift 2 when ready.'; }
    else if(i2&&!o2)                { st.className='att-status warning'; st.innerHTML='<i class="fas fa-moon"></i> Shift 2 in progress since <strong>'+i2+'</strong>'; }
    else if(o2&&!i3)                { st.className='att-status info';    st.innerHTML='<i class="fas fa-coffee"></i> Shift 2 done ('+(d2||'—')+') — start Shift 3 when ready.'; }
    else if(i3&&!o3)                { st.className='att-status warning'; st.innerHTML='<i class="fas fa-star-half-alt"></i> Shift 3 in progress since <strong>'+i3+'</strong>'; }
    else {
        const toMins=s=>s?s.split('h ').reduce((a,v,i)=>a+(i===0?parseInt(v)*60:parseInt(v)),0):0;
        const tot=Math.floor((toMins(d1)+toMins(d2)+toMins(d3))/60)+'h '+((toMins(d1)+toMins(d2)+toMins(d3))%60)+'m';
        st.className='att-status success'; st.innerHTML='<i class="fas fa-check-circle"></i> All shifts complete! Total: <strong>'+tot+'</strong>';
    }
}

function loadStatus() {
    fetch(contextPath+'/attendance/checkAttendance.jsp').then(r=>r.json()).then(applyState)
    .catch(()=>{ const st=document.getElementById('attStatus'); st.className='att-status danger'; st.innerHTML='<i class="fas fa-exclamation-circle"></i> Error loading status.'; });
}

function mark(action) {
    const labels={in1:'Shift 1 In',out1:'Shift 1 Out',in2:'Shift 2 In',out2:'Shift 2 Out',in3:'Shift 3 In',out3:'Shift 3 Out'};
    ['btn_in1','btn_out1','btn_in2','btn_out2','btn_in3','btn_out3'].forEach(id=>document.getElementById(id).disabled=true);
    fetch(contextPath+'/attendance/markAttendance.jsp?action='+action,{method:'POST'})
    .then(r=>r.json()).then(data=>{
        if(data.success){ Swal.fire({icon:'success',title:labels[action],text:'Marked at '+data.time,timer:1400,showConfirmButton:false}); setTimeout(loadStatus,400); }
        else { Swal.fire({icon:'error',title:'Error',text:data.message||'Failed'}); loadStatus(); }
    }).catch(()=>{ Swal.fire({icon:'error',title:'Error',text:'Request failed'}); loadStatus(); });
}

loadStatus();
</script>
<br><br><br><br>
</body>
</html>
