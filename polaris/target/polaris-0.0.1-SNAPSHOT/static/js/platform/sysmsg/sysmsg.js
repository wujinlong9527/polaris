var url;
var mesTitle;
window.onload = function () {
    $("#datagrid").datagrid("options").url = getRootPath() + "/sysmsg/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
    $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
}

function searchOrder() {
    $("#appid").textbox('setValue', $("#appid").textbox("getText"));
    if (null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
    }
    $("#datagrid").datagrid("options").url = getRootPath() + "/sysmsg/datagrid?" + $("#fmorder").serialize();

    $("#datagrid").datagrid("load");
}

function onReset() {
    $("#appid").textbox('setValue', "");
    $("#sourceSubChannel").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath() + "/sysmsg/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

/**/
function formatIschannel(val, row) {
    if (val == 'deduct') {
        return '<span>' + '理财1.0(deduct)' + '</span>';
    } else if (val == 'harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
    } else if (val == 'harbor_sms') {
        return '<span>' + '借款2.0(harbor_sms)' + '</span>';
    } else if (val == 'loan') {
        return '<span>' + '借款1.0(loan)' + '</span>';
    }
    else if (val == 'loan_force') {
        return '<span>' + '借款强扣1.0(loan_force)' + '</span>';
    }
    else if (val == 'storm') {
        return '<span>' + '理财2.0(storm)' + '</span>';
    }
    else if (val == 'taurus') {
        return '<span>' + '闪电分期(taurus)' + '</span>';
    } else {
        return '<span>' + val + '</span>';
    }
}

function dealChannel(val) {
    if (val == '理财1.0(deduct)') {
        return 'deduct';
    } else if (val == '借款2.0(harbor)') {
        return 'harbor';
    } else if (val == '借款2.0(harbor_sms)') {
        return 'harbor_sms';
    } else if (val == '借款1.0(loan)') {
        return 'loan';
    } else if (val == '借款强扣1.0(loan_force)') {
        return 'loan_force';
    } else if (val == '理财2.0(storm)') {
        return 'storm';
    } else if (val == '闪电分期(taurus)') {
        return 'taurus';
    } else if (val == '全部') {
        return '';
    } else {
        return val;
    }
}

function doDel() {
    var record = $("#datagrid").datagrid('getSelected');
//          alert(record.id);
    if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $.post(getRootPath() + '/sysmsg/dodel',
                    {id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "删除成功");
                            $("#datagrid").datagrid("options").url = getRootPath() + "/sysmsg/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', result.msg);
                        }
                    });
            }
        });

    } else {
        $.messager.alert('提示', '请先选中要删除的行');
    }
}

function editInfo() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        $('#edit').form('load', record);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
        $('#msg_editDlg').dialog('open').dialog('setTitle', '编辑信息');
    } else {
        $.messager.alert('提示', '请先选中要修改的行');
    }
}

function doupdate() {
    var record = $("#datagrid").datagrid('getSelected');
    var appid = $("#edit_aid").textbox("getText");
    var sourceSubChannel = $("#edit_subChannel").textbox("getText");
    if (appid == '') {
        alert("appid不能为空！");
    } else if (sourceSubChannel == '') {
        alert("来源子渠道不能为空！");
    } else {
        $.post(getRootPath() + '/sysmsg/doupdate?' + "id=" + record.id + "&appid=" + appid + "&sourceSubChannel=" + sourceSubChannel,
            function (result) {
                //var result = eval('(' + result + ')');
                console.info(result);
                if (result.success) {
                    mesTitle = '提示';
                    $("#datagrid").datagrid("options").url = getRootPath() + "/sysmsg/datagrid?" + $("#fmorder").serialize();
                    $("#datagrid").datagrid("load");
                } else {
                    mesTitle = '提示';
                }
                $('#msg_editDlg').dialog('close');
                $.messager.show({
                    title: mesTitle,
                    msg: result.msg
                });
            });
    }
}
//新增
function addInfo() {
    $('#msg_addDlg').dialog('open').dialog('setTitle', '新增');
    $('#add').form('clear');
}

function doadd() {
    var appid = $("#add_aid").val();
    var sourceSubChannel = $("#add_subChannel").val();
    if (appid == '') {
        alert("appid不能为空！");
    } else if (sourceSubChannel == '') {
        alert("来源子渠道不能为空！");
    } else {
        $.post(getRootPath() + '/sysmsg/doAdd?' + "appid=" + appid + "&sourceSubChannel=" + sourceSubChannel,
            function (result) {
                //var result = eval('(' + result + ')');
                console.info(result);
                if (result.success) {
                    mesTitle = '提示';
                    $("#datagrid").datagrid("options").url = getRootPath() + "/sysmsg/datagrid?" + $("#fmorder").serialize();
                    $("#datagrid").datagrid("load");
                } else {
                    mesTitle = '提示';
                }
                $('#msg_addDlg').dialog('close');
                $.messager.show({
                    title: mesTitle,
                    msg: result.msg
                });
            });
    }
}