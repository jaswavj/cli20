<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="prod" class="product.productBean" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Components - Billing App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover">
    <%@ include file="/assets/common/head.jsp" %>
    <style>
        body { background: #f5f7fa; }
        /* iPhone Safari safe area */
        .page-wrap {
            padding-left: env(safe-area-inset-left);
            padding-right: env(safe-area-inset-right);
            padding-bottom: calc(env(safe-area-inset-bottom) + 1rem);
        }
        /* Card list rows */
        .comp-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
            padding: .75rem 1rem;
            margin-bottom: .6rem;
            display: flex; align-items: center; justify-content: space-between;
        }
        .comp-card .prod-name { font-weight: 600; font-size: .95rem; color: #2d3748; }
        .comp-card .prod-meta { font-size: .78rem; color: #718096; margin-top: 2px; }
        /* Normal centered modal on all screen sizes */
        .modal-dialog { max-width: 480px; margin: 1.75rem auto; }
        @media (max-width: 576px) {
            .modal-dialog { margin: 1rem; max-width: calc(100% - 2rem); }
        }
        /* jQuery UI autocomplete inside modal */
        #addComponentModal .ui-autocomplete {
            z-index: 9999 !important;
            max-height: 200px;
            overflow-y: auto;
            overflow-x: hidden;
        }
        .mst-card-header {
            padding: .75rem 1rem;
            background: linear-gradient(135deg,#4e54c8,#8f94fb);
            color: #fff; border-radius: 8px 8px 0 0;
            display: flex; align-items: center; justify-content: space-between;
        }
    </style>
</head>
<body>
    <%@ include file="/assets/navbar/navbar.jsp" %>

    <%
    String msg = request.getParameter("msg");
    String type = request.getParameter("type");
    if (msg != null) {
    %>
    <div class="alert alert-<%= (type != null ? type : "info") %> alert-dismissible fade show mx-3 mt-3" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="container-fluid mt-3 page-wrap" style="max-width: 700px;">
        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-3 px-1">
            <div>
                <h6 class="mb-0 fw-bold" style="font-size:1rem;">Product Components</h6>
                <small class="text-muted">Tap a product to view / tap + to add</small>
            </div>
            <button class="btn btn-sm btn-primary d-inline-flex align-items-center gap-1"
                    data-bs-toggle="modal" data-bs-target="#addComponentModal">
                <i class="fas fa-plus"></i> Add Component
            </button>
        </div>

        <!-- Card List -->
        <%
        try {
            Vector productList = prod.getProductsWithComponents();
            if (productList != null && productList.size() > 0) {
                for (int i = 0; i < productList.size(); i++) {
                    Vector row = (Vector) productList.get(i);
                    if (row != null && row.size() >= 4) {
                        int productId = (Integer) row.elementAt(0);
                        String productName = row.elementAt(1).toString();
                        String productCode = row.elementAt(2).toString();
                        int componentCount = (Integer) row.elementAt(3);
        %>
        <div class="comp-card" onclick="openComponents(<%=productId%>, '<%=productName.replace("'","\\'" )%>', '<%=productCode%>')"
             style="cursor:pointer;">
            <div>
                <div class="prod-name"><%=productName%></div>
                <div class="prod-meta">Code: <%=productCode%> &nbsp;·&nbsp; <span class="badge bg-info text-dark"><%=componentCount%> component<%=componentCount != 1 ? "s" : ""%></span></div>
            </div>
            <i class="fas fa-chevron-right text-muted" style="font-size:.85rem;"></i>
        </div>
        <%
                    }
                }
            } else {
        %>
        <div class="text-center text-muted py-5">
            <i class="fas fa-inbox fa-3x mb-3 d-block" style="opacity:.25;"></i>
            <p class="mb-0">No components configured yet.<br>Tap <strong>+</strong> to add one.</p>
        </div>
        <%
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
        %>
    </div>

    <!-- View Components Modal -->
    <div class="modal fade" id="viewComponentsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="mst-card-header">
                    <span><i class="fas fa-cubes me-2"></i><span id="viewModalTitle">Components</span></span>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding:1rem; min-height:120px;">
                    <div id="viewModalBody"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Component Modal -->
    <div class="modal fade" id="addComponentModal" tabindex="-1" aria-labelledby="addComponentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="mst-card-header">
                    <span><i class="fas fa-plus-circle me-2"></i>Add Component</span>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="padding:1.25rem;">
                    <form id="addComponentForm" action="<%=contextPath%>/product/master/components/saveComponent.jsp" method="post">
                        <div class="mb-3">
                            <label class="form-label" style="font-size:.875rem;">Main Product</label>
                            <input type="text" id="mainProductName" class="form-control" placeholder="Type to search product..." autocomplete="off" required>
                            <input type="hidden" id="mainProductId" name="productId">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" style="font-size:.875rem;">Component Product</label>
                            <input type="text" id="componentProductName" class="form-control" placeholder="Type to search product..." autocomplete="off" required>
                            <input type="hidden" id="componentProductId" name="componentProductId">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" style="font-size:.875rem;">Quantity per Unit</label>
                            <input type="number" step="0.001" name="quantity" class="form-control" value="1" onwheel="this.blur()" required>
                            <small class="text-muted">How many components per main product</small>
                        </div>
                        <button type="submit" class="btn btn-primary w-100" style="padding:.65rem;">
                            <i class="fas fa-save me-1"></i>Save Component
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

<script>
var contextPath = '<%=contextPath%>';

function openComponents(productId, productName, productCode) {
    $('#viewModalTitle').text(productName + ' — Components');
    $('#viewModalBody').html('<div class="text-center py-4"><div class="spinner-border spinner-border-sm text-primary"></div></div>');
    var modal = new bootstrap.Modal(document.getElementById('viewComponentsModal'));
    modal.show();
    $.getJSON(contextPath + '/product/master/components/getComponentsJson.jsp', { productId: productId }, function(data) {
        if (!data || data.length === 0) {
            $('#viewModalBody').html('<p class="text-muted text-center py-3"><i class="fas fa-inbox fa-2x d-block mb-2" style="opacity:.3;"></i>No components added yet.</p>');
            return;
        }
        var rows = data.map(function(c, idx) {
            return '<tr><td>' + (idx+1) + '</td><td>' + c.name + '</td><td>' + c.code + '</td><td>' + c.qty + '</td>'
                 + '<td class="text-center"><button class="btn btn-sm btn-danger" onclick="deleteComp(' + c.id + ',' + productId + ',\'' + productName.replace(/'/g,"\\'") + '\')"><i class="fas fa-trash"></i></button></td></tr>';
        }).join('');
        $('#viewModalBody').html('<div class="table-responsive"><table class="table table-sm mb-0"><thead><tr><th>#</th><th>Component</th><th>Code</th><th>Qty</th><th></th></tr></thead><tbody>' + rows + '</tbody></table></div>');
    }).fail(function() {
        $('#viewModalBody').html('<p class="text-danger text-center">Failed to load components.</p>');
    });
}

function deleteComp(compId, productId, productName) {
    if (!confirm('Delete this component?')) return;
    $.post(contextPath + '/product/master/components/deleteComponent.jsp', { id: compId, productId: productId, productName: productName, ajax: '1' }, function() {
        openComponents(productId, productName, '');
    }).fail(function() { alert('Delete failed.'); });
}

$(function () {
    function makeProductAutocomplete(inputId, hiddenId) {
        var $input  = $("#" + inputId);
        var $hidden = $("#" + hiddenId);

        $input.autocomplete({
            appendTo: "#addComponentModal",
            source: function (request, response) {
                $.ajax({
                    url: contextPath + "/product/master/components/auto_complet.jsp",
                    type: "GET",
                    dataType: "json",
                    data: { productSearch: request.term },
                    success: function (data) { response(data); }
                });
            },
            minLength: 2,
            focus: function (event, ui) { $input.val(ui.item.label); return false; },
            select: function (event, ui) {
                $input.val(ui.item.label);
                $hidden.val(ui.item.value);
                $input.removeClass("is-invalid");
                return false;
            }
        });

        $input.on("keydown", function (e) {
            if ((e.keyCode === 9 || e.keyCode === 13) && $input.autocomplete("widget").is(":visible")) {
                var first = $input.autocomplete("widget").find(".ui-menu-item").first();
                if (first.length) {
                    var item = first.data("ui-autocomplete-item");
                    if (item) {
                        $input.val(item.label);
                        $hidden.val(item.value);
                        $input.autocomplete("close");
                        $input.removeClass("is-invalid");
                        if (e.keyCode === 9) return;
                        e.preventDefault();
                    }
                }
            }
        });

        $input.on("input", function () { $hidden.val(""); });
    }

    makeProductAutocomplete("mainProductName",      "mainProductId");
    makeProductAutocomplete("componentProductName", "componentProductId");

    $("#addComponentForm").on("submit", function () {
        var valid = true;
        if ($("#mainProductId").val() === "") {
            $("#mainProductName").addClass("is-invalid").focus();
            valid = false;
        }
        if ($("#componentProductId").val() === "") {
            $("#componentProductName").addClass("is-invalid");
            if (valid) $("#componentProductName").focus();
            valid = false;
        }
        return valid;
    });

    // Clear form when modal closes
    $("#addComponentModal").on("hidden.bs.modal", function () {
        $("#mainProductName").val("").removeClass("is-invalid");
        $("#mainProductId").val("");
        $("#componentProductName").val("").removeClass("is-invalid");
        $("#componentProductId").val("");
        $("[name='quantity']").val("1");
    });
});
</script>
</body>
</html>
