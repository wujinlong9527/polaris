/**
 * Created by Administrator on 2016/12/2.
 */
var url;
var mesTitle;

window.onload = function () {
    $("#datagrid").datagrid("options").url = getRootPath()+"/routechannel/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//格式换显示状态
function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color:red;">' + '禁用' + '</span>';
    } else if (val == 0) {
        return '<span>' + '启用' + '</span>';
    }
}

function formatIsSms(val, row) {
    if (val == 1) {
        return '<span>' + '是' + '</span>';
    } else if (val == 0) {
        return '<span>' + '否' + '</span>';
    }
}

//查询列表
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath()+"/routechannel/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#dealChannel").textbox('setValue', "");
    $("#dealSubChannel").textbox('setValue', "");
    $("#orderAction").combobox('setValue', "");
    $("#isdel").combobox("setValue", "");

    $("#datagrid").datagrid("options").url = getRootPath()+"/routechannel/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增渠道');
    $('#configfm').form('clear');
    mesTitle = '新增成功';
}

//新增保存
function saveConfig() {
    $.ajax({
        url: getRootPath() + "/routechannel/addrouteChannel",
        data:$('#configfm').serialize(),
        type:"POST",
        error:function(){
            alert("Connection failed");
        },
        success: function (result) {
            if (result.success) {
                if ($("#id").val() != '') {
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
    $('#configdlg').dialog('close');
}

//删除
function removeConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 1) {
            $.messager.alert('错误提示', "数据已经禁用,不需要再次禁用！");
            return;
        }
        $.messager.confirm("禁用", "是否禁用", function (r) {
            if (r) {
                $.post(getRootPath()+'/routechannel/upRouteChannelState',
                    {isdel: 1, id: record.id},
                    function (result) {
                        if (result.success) {
                            $.messager.alert('消息提示', "禁用成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/routechannel/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
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


function save() {
    //去空格 replace(/(^\s*)|(\s*$)/, "")
    if ($('#delReason').val().replace(/(^\s*)|(\s*$)/, "") == "") {
        $.messager.alert('提示', '禁用原因不能为空！');
        return;
    }
    var record = $("#datagrid").datagrid('getSelected');
    $.post(getRootPath()+'/routechannel/upRouteChannelState',
        {isdel: 1, delReason: $('#delReason').val(), id: record.id},
        function (result) {
            if (result.success) {
                $('#delreasondlg').dialog('close');
                $.messager.alert('消息提示', "禁用成功");
                $("#datagrid").datagrid("options").url = getRootPath()+"/routechannel/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                $.messager.alert('错误提示', "禁用失败");
            }
        });
}

function recoverConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 0) {
            $.messager.alert('错误提示', "数据为启用状态,不需要启用！");
            return;
        }
        $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
                $.post(getRootPath()+'/routechannel/upRouteChannelState',
                    {isdel: 0, id: record.id},
                    function (result) {
                        if (result.success) {
                            $.messager.alert('消息提示', "启用成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/routechannel/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
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

function editConfig() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        /*if (row.isdel == 1) {
            $.messager.alert('错误提示', "数据已经禁用,不需要编辑！");
            return;
        }*/
        $.post(getRootPath()+'/routechannel/selectRouteChannel',
            {id: row.id},
            function (result) {
                if (result.success) {
                    $("#id").val(result.obj.id);
                    $("#dlgisdel").val(row.isdel);
                    $("#dlgdealChannel").val(result.obj.dealChannel);
                    $("#dlgdealSubChannel").val(result.obj.dealSubChannel);
                    $("#dlgfrontChannel").val(result.obj.frontChannel);
                    $("#dlgmerId").val(result.obj.merId);
                    $("#dlgsignMark").val(result.obj.signMark);
                    $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                    $("#dlgisSms").combobox("setValue", result.obj.isSms);
                    $("#dlgdc").val(result.obj.dc);
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
    $.post(getRootPath()+'/routechannel/updredis?'+ $("#fmorder").serialize(),
        function (result) {
            console.info(result);
            if (result.success==true) {
                $.messager.alert('提示', result.msg);
            } else {
                $.messager.alert('错误提示',result.msg);
            }
            $('#addredis').linkbutton({disabled:false});
        });
}