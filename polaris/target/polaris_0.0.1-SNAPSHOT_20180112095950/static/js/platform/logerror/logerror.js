var url;
var mesTitle;

window.onload = function () {
    searchOrder();
}
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath() + "/logerror/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $("#orderId").textbox('setValue', "");
    $("#errorName").textbox('setValue', "");
    $("#datagrid").datagrid("options").url = getRootPath() + "/logerror/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}