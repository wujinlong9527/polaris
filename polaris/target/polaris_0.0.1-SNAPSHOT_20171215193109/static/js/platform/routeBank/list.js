var url;
var mesTitle;
window.onload = function () {
    $("#datagrid").treegrid({
        url:getRootPath()+"/routebank/datagrid",
        idField:'id',
        treeField:'bankName'
    });
    $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
    $('#dlgsourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
}
//查询列表
function searchOrder() {
    if(null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
    }
    $("#datagrid").treegrid("options").url = getRootPath()+"/routebank/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").treegrid("load");

}

//重置
function onReset() {
    $("#bankName").textbox('setValue', "");
    $("#isdel").combobox("setValue", "");
    $("#orderAction").combobox("setValue", "");
    $("#sortOrder").combobox("setValue",0);
    $("#datagrid").treegrid("options").url = getRootPath()+"/routebank/datagrid";
    $("#datagrid").treegrid("load");
}

var url1 = "";
//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增');
    $('#configfm').form('clear');
    mesTitle = '新增成功';
    url = getRootPath()+ "/routebank/addrouteBank?isStart=0";
}
//更新到redis按钮
function addRedisConfig() {
    $('#addredis').linkbutton({disabled:true});
    $.post(getRootPath()+'/routebank/updchannel',
        function (result) {
            if (result) {
                $.messager.alert('提示', "更新成功");
            } else {
                $.messager.alert('错误提示', "更新失败");
            }
            $('#addredis').linkbutton({disabled:false});
        });
}
//编辑按钮
function editConfig() {
    var row = $('#datagrid').treegrid('getSelected');
    if (row) {
        if (row.parentId == 0) {
            $.messager.alert('错误提示', "根节点，不需要编辑！");
            return;
        }
        if (row.isdel == 1) {
            $.messager.alert('错误提示', "数据已经禁用,不需要编辑！");
            return;
        }
        url1 = getRootPath()+ "/routebank/addrouteBank";
        $.post(getRootPath()+'/routebank/selectRouteBank',
            {id: row.id},
            function (result) {
                if (result.success) {
                    $("#oldbankName").val(result.obj.bankName);
                    $("#oldorderAction").val(result.obj.orderAction);
                    $("#id").val(result.obj.id);
                    $("#dlgbankName").val(result.obj.bankName);
                    $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                    $("#dlgsourceChannel").val(result.obj.sourceChannel);
                    //$("#dlgsourceSubChannel").val(result.obj.sourceSubChannel);
                    $("#dlgsourceSubChannel").combobox("setValue", result.obj.sourceSubChannel);
                    $("#dlgpri_level").val(result.obj.pri_level);
                    $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                } else {
                    $.messager.alert('错误提示', "编辑失败");
                }
            });

    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

//复制添加按钮
function copyConfig(val, row) {
    var row = $('#datagrid').treegrid('getSelected');
    if (row) {
        if (row.parentId == 0) {
            $.messager.alert('错误提示', "根节点，不能复制！");
            return;
        }
        url1 = getRootPath()+ "/routebank/copyRouteBank";
        $.post(getRootPath()+'/routebank/selectRouteBank',
            {id: row.id},
            function (result) {
                if (result.success) {
                    $("#oldbankName").val(result.obj.bankName);
                    $("#oldorderAction").val(result.obj.orderAction);
                    $("#id").val(result.obj.id);
                    $("#dlgbankName").val(result.obj.bankName);
                    $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                    $("#dlgsourceChannel").val(result.obj.sourceChannel);
                    //$("#dlgsourceSubChannel").val(result.obj.sourceSubChannel);
                    $("#dlgsourceSubChannel").combobox("setValue", result.obj.sourceSubChannel);
                    $("#dlgpri_level").val(result.obj.pri_level);
                    $('#configdlg').dialog('open').dialog('setTitle', '复制');
                } else {
                    $.messager.alert('错误提示', "复制失败");
                }
            });

    } else {
        $.messager.alert('提示', '请选择要复制的记录！', 'error');
    }
}

//新增保存
function saveConfig() {
    //alert($("#dlgsourceSubChannel").combobox("getText"));
    $("#dlgsourceSubChannel").combobox("setValue", $("#dlgsourceSubChannel").combobox("getText"));
    $.ajax({
        type:"POST",
        url: url1,
        data:$("#configfm").serialize(),
        success: function (result) {
            if (result.success) {
                $('#configdlg').dialog('close');
                $('#datagrid').treegrid('reload');
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

//格式换显示状态
function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color:red;">' + '禁用' + '</span>';
    } else if (val == 0) {
        return '<span>' + '启用' + '</span>';
    }
}

//格式换显示状态
function formatdata(val, row) {
    if (row.parentId != 0) {
        return '<a class="editcls" onclick="parent.addTab(\'' + row.bankName + '-' + row.orderAction + '-渠道配置\',' +
            '\'' + row.id + '\',\''
            + row.isdel + '\',\'' + row.orderAction + '\')" href="javascript:void(0)">配置</a>';
    }
}

//禁用按钮
function removeConfig() {
    var record = $("#datagrid").treegrid('getSelected');
    if (record) {

        if (record._parentId == 0) {
            $.messager.alert('错误提示', "根节点，不能禁用！");
            return;
        }

        if (record.isdel == 1) {
            $.messager.alert('错误提示', "数据已经禁用,不需要再次禁用！");
            return;
        }
        $.messager.confirm("禁用", "是否禁用", function (r) {
            if (r) {
                $.post(getRootPath()+'/routebank/upRouteBank',
                    {isdel: 1, id: record.id},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "禁用成功");
                            $("#datagrid").treegrid("options").url = getRootPath()+"/routebank/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").treegrid("load");
                        } else {
                            $.messager.alert('错误提示', "禁用失败");
                        }
                    });
            }
        });

    } else {
        $.messager.alert('提示', '请先选中要禁用的行');
    }
}
//启用按钮
function recoverConfig() {

    var record = $("#datagrid").treegrid('getSelected');
    if (record) {

        if (record._parentId == 0) {
            $.messager.alert('错误提示', "根节点，不能启用！");
            return;
        }
        if (record.isdel == 0) {
            $.messager.alert('错误提示', "数据为启用状态,不需要启用！");
            return;
        }
        $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
                $.post(getRootPath()+'/routebank/upRouteBank',
                    {isdel: 0, id: record.id},
                    function (result) {
                        if (result.success) {
                            $.messager.alert('消息提示', "启用成功");
                            $("#datagrid").treegrid("options").url = getRootPath()+"/routebank/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").treegrid("load");
                        } else {
                            $.messager.alert('错误提示', "启用失败");
                        }
                    });
            }
        });

    } else {
        $.messager.alert('提示', '请先选中要启用的行');
    }
}

//更新银行同步
function update() {
    $.post(getRootPath()+'/routebank/update?isStart=0',
        function (result) {
            if (result.success()) {
                $.messager.alert('提示', "更新成功");
            } else {
                $.messager.alert('错误提示', "更新失败");
            }
        });
}