/**
 * Created by Administrator on 2016/12/2.
 */
var url;
var mesTitle;
window.onload = function () {
    $("#datagrid").datagrid("options").url = getRootPath() + "/routeauth/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
    $('#datagrid').datagrid({
        onLoadSuccess: function (data) {
            MergeCells("datagrid", "bankName");
        }
    });
}
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath() + "/routeauth/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
    $('#datagrid').datagrid({
        onLoadSuccess: function (data) {
            MergeCells("datagrid", "bankName");
        }
    });
}
function onReset() {

    $("#bankName").textbox('setValue', "");
    $("#dealChannel").textbox('setValue', "");
    $("#delFlag").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath() + "/routeauth/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}
//
function formatCardType(val, row) {
    if (val == 1) {
        return '<span>' + '借记卡' + '</span>';
    } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
    } else if (val == 10) {
        return '<span>' + '所有' + '</span>';
    }
}
function formatDel(val, row) {
    if (val == 0) {
        return '<span style="color:green">' + '有效' + '</span>';
    }
    else {
        return '<span  style="color:red">' + '无效' + '</span>';
    }
}
function MergeCells(tableID, fldList) {
    var Arr = fldList.split(",");
    var dg = $('#' + tableID);
    var fldName;
    var RowCount = dg.datagrid("getRows").length;
    var span;
    var PerValue = "";
    var CurValue = "";
    var length = Arr.length - 1;
    for (i = length; i >= 0; i--) {
        fldName = Arr[i];
        PerValue = "";
        span = 1;
        for (row = 0; row <= RowCount; row++) {
            if (row == RowCount) {
                CurValue = "";
            }
            else {
                CurValue = dg.datagrid("getRows")[row][fldName];
            }
            if (PerValue == CurValue) {
                span += 1;
            }
            else {
                var index = row - span;
                dg.datagrid('mergeCells', {
                    index: index,
                    field: fldName,
                    rowspan: span,
                    colspan: null
                });
                span = 1;
                PerValue = CurValue;
            }
        }
    }
}