var url;
var mesTitle;

window.onload = function () {
    $('#dlgdealSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
    });

    $('#dealSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        //panelHeight: 'auto',//自动高度适合
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
    });

    $.ajax({
        type: "POST",
        url: getRootPath() + "/codemsg/selectDealSubChannel",
        cache: false,
        dataType: "json",
        success: function (data) {
            $("#dealSubChannel").combobox("loadData", data.rows);
            $("#dlgdealSubChannel").combobox("loadData", data.rows);
        }
    });

    $('#dlgcode').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: '100',//自动高度适合
        valueField: 'rowNum',
        textField: 'code',
        onSelect: function (record) {
            $("#dlgmsg").combobox("setValue", $("#dlgcode").combobox("getValue"));
        }
    });

    $('#dlgmsg').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: '100',//自动高度适合
        valueField: 'rowNum',
        textField: 'msg',
        onSelect: function (record) {
            $("#dlgcode").combobox("setValue", $("#dlgmsg").combobox("getValue"));
        }
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/codemsg/getCodeList",
        cache: false,
        dataType: "json",
        success: function (data) {
            $("#dlgcode").combobox("loadData", data.rows);
            $("#dlgmsg").combobox("loadData", data.rows);
        }
    });

    $('#dlglocalCode').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: '100',//自动高度适合
        valueField: 'rowNum',
        textField: 'localCode',
        onSelect: function (record) {
            $("#dlglocalMsg").combobox("setValue", $("#dlglocalCode").combobox("getValue"));
        }
    });

    $('#dlglocalMsg').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: '100',//自动高度适合
        valueField: 'rowNum',
        textField: 'localMsg',
        onSelect: function (record) {
            $("#dlglocalCode").combobox("setValue", $("#dlglocalMsg").combobox("getValue"));
        }
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/codemsg/getLocalCodeList",
        cache: false,
        dataType: "json",
        success: function (data) {
            $("#dlglocalCode").combobox("loadData", data.rows);
            $("#dlglocalMsg").combobox("loadData", data.rows);
        }
    });
    searchOrder();
}

//格式换显示状态
function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color:red;">' + '已删除' + '</span>';
    } else if (val == 0) {
        return '<span>' + '未删除' + '</span>';
    } else if (val == 2) {
        return '<span style="color:green;">' + '未审核' + '</span>';
    }
}

//查询列表
function searchOrder() {
    $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    $("#datagrid").datagrid("options").url = getRootPath()+"/codemsg/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#dealSubChannel").combobox('setValue', "");
    $("#code").textbox('setValue', "");
    $("#msg").textbox('setValue', "");
    $("#localMsg").textbox('setValue', "");
    $("#isdel").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+ "/codemsg/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增错误码');
    $('#configfm').form('clear');
    mesTitle = '新增成功';
}

//新增保存
function saveConfig() {

    $("#dlgdealSubChannel").combobox("setValue", $("#dlgdealSubChannel").combobox("getText"));
    $("#dlgcode").combobox("setValue", $("#dlgcode").combobox("getText"));
    $("#dlgmsg").combobox("setValue", $("#dlgmsg").combobox("getText"));
    $("#dlglocalCode").combobox("setValue", $("#dlglocalCode").combobox("getText"));
    $("#dlglocalMsg").combobox("setValue", $("#dlglocalMsg").combobox("getText"));

    $.ajax({
        type: "POST",
        url:getRootPath() + "/codemsg/addCodeMsg",
        data:$('#configfm').serialize(),
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                if ($("#gid").val() != '') {
                    $('#configdlg').dialog('close');
                }
                $('#datagrid').datagrid('reload');
            } else {
                mesTitle = '新增失败';
            }
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });
}

//删除
function removeConfig() {

    var array = $('#datagrid').datagrid('getChecked');
    if (array.length > 1) {
        $.messager.alert('错误提示', "删除数据只能选择一条数据！");
        return;
    }

    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 1) {
            $.messager.alert('错误提示', "数据已经删除,不需要再次删除！");
            return;
        }
        if (record.isdel == 2) {
            $.messager.alert('错误提示', "未审核数据,不能删除！");
            return;
        }
        $.messager.confirm("删除", "是否删除", function (r) {
            if (r) {
                $('#delreasondlg').dialog('open').dialog('setTitle', '删除原因');
                $('#delReason').val("");
            }
        });

    } else {
        $.messager.alert('提示', '请先选中要删除的行');
    }
}


function save() {
    //去空格 replace(/(^\s*)|(\s*$)/, "")
    if ($('#delReason').val().replace(/(^\s*)|(\s*$)/, "") == "") {
        $.messager.alert('提示', '删除原因不能为空！');
        return;
    }

    var record = $("#datagrid").datagrid('getSelected');
    $.post(getRootPath()+'/codemsg/upCodeMsgState',
        {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#delreasondlg').dialog('close');
                $.messager.alert('消息提示', "删除成功");
                $("#datagrid").datagrid("options").url = getRootPath()+"/codemsg/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                $.messager.alert('错误提示', "删除失败");
            }
        });
}

function recoverConfig() {

    var array = $('#datagrid').datagrid('getChecked');
    if (array.length > 1) {
        $.messager.alert('错误提示', "恢复数据只能选择一条数据！");
        return;
    }

    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 0) {
            $.messager.alert('错误提示', "数据为未删除状态,不需要恢复！");
            return;
        }
        if (record.isdel == 2) {
            $.messager.alert('错误提示', "未审核数据,不能恢复！");
            return;
        }
        $.messager.confirm("恢复", "是否恢复", function (r) {
            if (r) {

                $.post(getRootPath()+'/codemsg/upCodeMsgState',
                    {isdel: 0, delReason: "", gid: record.gid},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "恢复成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/codemsg/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "恢复失败");
                        }
                    });
            }
        });

    } else {
        $.messager.alert('提示', '请先选中要恢复的行');
    }
}


function BatchAudit() {
    var array = $('#datagrid').datagrid('getChecked');
    var ids = "";
    for (var i = 0; i < array.length; i++) {//组成一个字符串，ID主键之间用逗号隔开
        if (array[i].isdel == 2) {
            if (ids == "") {
                ids = array[i].gid;
            } else {
                ids = ids + "," + array[i].gid;
            }
        }
    }

    if (array.length > 0) {
        if (ids == "") {
            $.messager.alert('消息提示', "没有需要审核的数据，请重新勾选！");
            return;
        }
        $.messager.confirm("审核", "是否批量审核", function (r) {
            if (r) {
                $.post(getRootPath()+'/codemsg/batchAudit',
                    {ids: ids},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "批量审核成功,审核条数："+result.msg);
                            $("#datagrid").datagrid("options").url = getRootPath()+"/codemsg/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "审核失败");
                        }
                    });
            }
        });
    } else {
        $.messager.alert('提示', "请选择要审核的信息，复选框选中！");
    }
}

function editConfig() {

    var array = $('#datagrid').datagrid('getChecked');
    if (array.length > 1) {
        $.messager.alert('错误提示', "编辑数据只能选择一条数据！");
        return;
    }

    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        $.post(getRootPath()+'/codemsg/selectCodeMsg',
            {gid: row.gid},
            function (result) {
                //var result = eval('(' + result + ')');
                if (result.success) {
                    $("#gid").val(result.obj.gid);
                    $("#dlgdealSubChannel").combobox("setValue", result.obj.dealSubChannel);
                    //$("#dlgorderAction").val(result.obj.orderAction);
                    $("#dlgcode").combobox("setValue", result.obj.code);
                    $("#dlgmsg").combobox("setValue", result.obj.msg);
                    $("#dlglocalCode").combobox("setValue", result.obj.localCode);
                    $("#dlglocalMsg").combobox("setValue", result.obj.localMsg);
                    $("#dlgsolution").val(result.obj.solution);
                    $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                } else {
                    $.messager.alert('错误提示', "编辑失败");
                }
            });

    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}
