var url;
var mesTitle;
window.onload = function () {
    searchOrder();
}
//格式换显示状态
function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color:red;">' + '已删除' + '</span>';
    } else {
        return '<span>' + '未删除' + '</span>';
    }
}

//查询列表
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath()+ "/configsource/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#strategy").textbox('setValue', "");
    $("#orderAction").textbox('setValue', "");
    $("#isdel").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+ "/configsource/datagrid";
    $("#datagrid").datagrid("load");
}

//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增策略');
    $('#configfm').form('clear');
    mesTitle = '新增策略成功';
}

//新增保存
function saveConfig() {
    $.ajax({
        type: "POST",
        url: getRootPath() + "/configsource/addConfigSource",
        data:$('#configfm').serialize(),
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $('#datagrid').datagrid('reload');
            } else {
                mesTitle = '新增策略失败';
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
        $.messager.confirm("删除", "是否删除策略", function (r) {
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
    $.post(getRootPath()+'/configsource/upConfigSourceState',
        {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#delreasondlg').dialog('close');
                $.messager.alert('消息提示', "删除策略成功");
                $("#datagrid").datagrid("options").url = getRootPath()+"/configsource/datagrid";
                $("#datagrid").datagrid("load");
            } else {
                $.messager.alert('错误提示', "删除策略失败");
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
        $.messager.confirm("恢复", "是否恢复策略", function (r) {
            if (r) {

                $.post(getRootPath()+'/configsource/upConfigSourceState',
                    {isdel: 0, delReason: "", gid: record.gid},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "恢复策略成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/configsource/datagrid";
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "恢复策略失败");
                        }
                    });
            }
        });

    } else {
        $.messager.alert('提示', '请先选中要恢复的行');
    }
}