var url;
var mesTitle;

window.onload = function () {
    searchOrder();
}

//格式换显示状态
function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color:#ff0000;">' + '已删除' + '</span>';
    } else if (val == 0) {
        return '<span>' + '未删除' + '</span>';
    }
}

//查询列表
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath() + "/configrate/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#merName").textbox('setValue', "");
    $("#rateType").combobox('setValue', "");
    $("#isdel").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+ "/configrate/datagrid";
    $("#datagrid").datagrid("load");
}

//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增商户');
    $('#configfm').form('clear');
    mesTitle = '新增成功';
}

//新增保存
function saveConfig() {
    $.ajax({
        type: "POST",
        url:getRootPath() + "/configrate/addConfigRate",
        data:$('#configfm').serialize(),
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/configrate/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
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
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 1) {
            $.messager.alert('错误提示', "数据已经删除,不需要再次删除！");
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

    if ($('#delReason').val().replace(/(^\s*)|(\s*$)/, "") == "") {
        $.messager.alert('提示', '删除原因不能为空！');
        return;
    }

    var record = $("#datagrid").datagrid('getSelected');
    $.post(getRootPath()+'/configrate/upconfigRateState',
        {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#delreasondlg').dialog('close');
                $.messager.alert('消息提示', "删除成功");
                $("#datagrid").datagrid("options").url = getRootPath()+ "/configrate/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                $.messager.alert('错误提示', "删除失败");
            }
        });
}

function recoverConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 0) {
            $.messager.alert('错误提示', "数据为未删除状态,不需要恢复！");
            return;
        }
        $.messager.confirm("恢复", "是否恢复", function (r) {
            if (r) {

                $.post(getRootPath()+'/configrate/upconfigRateState',
                    {isdel: 0, gid: record.gid},
                    function (result) {
                        if (result.success) {
                            $.messager.alert('消息提示', "恢复成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/configrate/datagrid?" + $("#fmorder").serialize();
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

function editConfig() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        $.post(getRootPath()+'/configrate/selectConfigRate',
            {gid: row.gid},
            function (result) {
                //var result = eval('(' + result + ')');
                if (result.success) {
                    $("#gid").val(result.obj.gid);
                    $("#dlgmerId").val(result.obj.merId);
                    $("#dlgmerName").val(result.obj.merName);
                    $("#dlgrateType").combobox("setValue", result.obj.rateType);
                    $("#dlgrate").val(result.obj.rate);
                    $("#dlgminRate").val(result.obj.minRate);
                    $("#dlgmaxRate").val(result.obj.maxRate);
                    $("#dlglevel").val(result.obj.level);
                    $("#dlgminMoney").val(result.obj.minMoney);
                    $("#dlgmaxMoney").val(result.obj.maxMoney);
                    $("#dlgorderAction").val(result.obj.orderAction);
                    $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                } else {
                    $.messager.alert('错误提示', "编辑失败");
                }
            });

    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function addRedisConfig() {
    $('#addredis').linkbutton({disabled:true});
    $.post(getRootPath()+'/configrate/addredis?'+ $("#fmorder").serialize(),
        function (result) {
            //var result = eval('(' + result + ')');
            console.info(result);
            if (result.success==true) {
                $.messager.alert('提示', result.msg);
            } else {
                $.messager.alert('错误提示',result.msg);
            }
            $('#addredis').linkbutton({disabled:false});
        });
}