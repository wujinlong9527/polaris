var url;
var mesTitle;
formatterDate = function (date) {
    var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
    var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
    + (date.getMonth() + 1);
    return date.getFullYear() + '-' + month + '-' + day;
    searchOrder();
};

window.onload = function () {
    var end = new Date();
    $('#beginTime').datebox('setValue', formatterDate(new Date(end.valueOf() - 5 * 24 * 60 * 60 * 1000)));
    $('#endTime').datebox('setValue', formatterDate(new Date()));
    $("#datagrid").datagrid("options").url = getRootPath() + "/dotask/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
    $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
    $('#datagrid').datagrid({
        view: detailview,
        detailFormatter: function (rowIndex, rowData) {
            tmp=rowData.length;
            return '<table>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><b>返回bankReturnmsg数据：</b></td>'
                + '</tr>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><xmp>' + rowData.bankReturnmsg + '</xmp></td>'
                + '</tr>'
                + '<tr>'
                + '</table>';
        }
    });
}


function searchOrder() {
    if(null == $("#sourceSubChannel").combobox("getValue") || "" == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
    }
    $("#datagrid").datagrid("options").url = getRootPath() +"/dotask/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}
//确认修改提示框
function Confirm(msg, control) {
    $.messager.confirm("确认提示", "确认重新查询 ？", function (r) {
        if (r) {
            ReQuery();
            return true;
        }
    });
    return false;
}

function ReQuery() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        var payOderId = record.payOrderid;
        $.post( getRootPath() + '/dotask/requery?payOrderId='+payOderId,
            function (result) {
                //var result = eval('(' + result + ')');
                if (result.success) {
                    $.messager.alert('消息提示', "查询修改成功");
                    $("#datagrid").datagrid("options").url = getRootPath() + "/dotask/datagrid?" + $("#fmorder").serialize();
                    $("#datagrid").datagrid("load");
                } else {
                    $.messager.alert('错误提示', "查询修改失败");
                }
            });
    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function onReset() {
    $('#beginTime').datebox('setValue', formatterDate(new Date()));
    $('#endTime').datebox('setValue', formatterDate(new Date()));
    $("#name").textbox('setValue', "");
    $("#cardNo").textbox('setValue', "");
    $("#cardBankName").textbox('setValue', "");
    $("#phone").textbox('setValue', "");
    $("#payMoney").textbox('setValue', "");
    $("#dealChannel").textbox('setValue', "");
    $("#payOrderid").textbox('setValue', "");
    $("#fcOrderid").textbox('setValue', "");
    $("#sourceSubChannel").combobox('setValue', "");
    $("#orderAction").combobox('setValue', "");
    $("#sendTimes").textbox('setValue', "");
    $("#datagrid").datagrid("options").url = getRootPath() + "/dotask/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function dotask() {
    $.messager.confirm("处理", "是否将查询次数大于5的更新为当前时间！", function (r) {
        if (r) {
            $.post(getRootPath() +'/dotask/updateDoTask',
                {sendTimes: 5},
                function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $.messager.alert('消息提示', "处理完成");
                        $("#datagrid").datagrid("options").url = getRootPath() + "/dotask/datagrid?" + $("#fmorder").serialize();
                        $("#datagrid").datagrid("load");
                    } else {
                        $.messager.alert('错误提示', "处理失败");
                    }
                });
        }
    });
}

//
function formatCardType(val, row) {
    if (val == 1) {
        return '<span>' + '借记卡' + '</span>';
    } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
    }
}

function formatIsGet(val, row) {
    if (val == 0) {
        return '<span>' + '否' + '</span>';
    } else if (val == 1) {
        return '<span>' + '是' + '</span>';
    }
}

function formatIsSuc(val, row) {
    if (val == 0) {
        return '<span>' + '处理中' + '</span>';
    } else if (val == 1) {
        return '<span>' + '成功' + '</span>';
    } else if (val == -1) {
        return '<span>' + '失败' + '</span>';
    }
}
function formatIschannel(val, row) {
    if (val == 'deduct') {
        return '<span>' + '理财1.0(deduct)' + '</span>';
    } else if (val =='harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
    } else if (val =='harbor_sms') {
        return '<span>' + '借款2.0(harbor_sms)' + '</span>';
    } else if (val =='loan') {
        return '<span>' + '借款1.0(loan)' + '</span>';
    }
    else if (val =='loan_force') {
        return '<span>' + '借款强扣1.0(loan_force)' + '</span>';
    }
    else if (val =='storm') {
        return '<span>' + '理财2.0(storm)' + '</span>';
    }
    else if (val =='taurus') {
        return '<span>' + '闪电分期(taurus)' + '</span>';
    }
    else {
        return '<span>' + val + '</span>';
    }
}