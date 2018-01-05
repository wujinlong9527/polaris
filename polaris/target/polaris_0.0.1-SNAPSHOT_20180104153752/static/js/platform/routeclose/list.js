/**
 * Created by Administrator on 2016/12/5.
 */
var url;
var mesTitle;

window.onload = function () {

    searchOrder();
    $('#dlgorderAction').combobox({
        onSelect: function (record) {
            $("#dlgbankId").combobox("setValue", "");
            $("#dlgbankId").combobox("setText", "");
            $.ajax({
                type: "POST",
                url: getRootPath()+"/routeclose/getbankname?orderAction=" + record.id,
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#dlgbankId").combobox("loadData", data.rows);
                }
            });
        }
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/routeclose/getchannel",
        cache: false,
        dataType: "json",
        success: function (data) {
            $("#dlgchannelId").combobox("loadData", data.rows);
        }
    });

    $('#dlgbankId').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: '100',//自动高度适合
        valueField: 'id',
        textField: 'bankName',
        onSelect: function (record) {
        }
    });

    $('#dlgchannelId').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: '100',//自动高度适合
        valueField: 'id',
        textField: 'dealSubChannel',
        onSelect: function (record) {
        }
    });

}

//格式换显示状态
function formatIsdel(val, row) {
    var repeatDate = row.repeatDate;
    var openTime = row.openTime;
    var v_repeatDate = '';
    var reValue = '';
    var reDate = '';
    if (repeatDate != null && repeatDate != '') {
        if (repeatDate.length > 3 && repeatDate.length !=0) {
            v_repeatDate = repeatDate.split(",");
            for (var i = 0; i <= v_repeatDate.length; i++) {
                repeatDate = v_repeatDate[i];
                if (repeatDate != null && repeatDate != '' && repeatDate != ',') {
                    if (repeatDate == "MON") {
                        reValue = "周一";
                    } else if (repeatDate == "TUE") {
                        reValue = "周二";
                    } else if (repeatDate == "WED") {
                        reValue = "周三";
                    } else if (repeatDate == "THU") {
                        reValue = "周四";
                    } else if (repeatDate == "FRI") {
                        reValue = "周五";
                    } else if (repeatDate == "SAT") {
                        reValue = "周六";
                    } else if (repeatDate == "SUN") {
                        reValue = "周日";
                    }
                    reDate = reDate + '' + reValue;
                }
            }
            row.repeatDate = reDate;
        }
    } else {
        if (repeatDate == "MON") {
            row.repeatDate = "周一";
        } else if (repeatDate == "TUE") {
            row.repeatDate = "周二";
        } else if (repeatDate == "WED") {
            row.repeatDate = "周三";
        } else if (repeatDate == "THU") {
            row.repeatDate = "周四";
        } else if (repeatDate == "FRI") {
            row.repeatDate = "周五";
        } else if (repeatDate == "SAT") {
            row.repeatDate = "周六";
        } else if (repeatDate == "SUN") {
            row.repeatDate = "周日";
        }
    }
    if (val == 1) {
        if (openTime == null || openTime == '') {
            return '<span>' + '已启用' + '</span>';
        } else {
            return '<span>' + '已启用(定时)' + '</span>';
        }
    } else if (val == 0) {
        if(openTime != null && openTime != ''){
            return '<span style="color:red;">' + '已关闭(定时)' + '</span>';
        }else {
            return '<span style="color:red;">' + '已关闭' + '</span>';
        }
    }
}
//查询列表
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath()+"/routeclose/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#bankname").textbox('setValue', "");
    $("#dealChannel").textbox('setValue', "");
    $("#dealSubChannel").textbox('setValue', "");
    $("#isdel").combobox("setValue", "");

    $("#datagrid").datagrid("options").url = getRootPath()+"/routeclose/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '新增');
    $('#configfm').form('clear');
    mesTitle = '提示';
}

//新增保存
function saveConfig() {
    $.ajax({
        type:"POST",
        url: getRootPath() + "/routeclose/addrouteClose",
        data:$('#configfm').serialize(),
        error: function () {
            alert("Connection failed");
        },
        success: function (result) {
            if (result.success) {
                $('#configdlg').dialog('close');
                $('#datagrid').datagrid('reload');
                mesTitle = '提示';
            } else {
                mesTitle = '提示';
            }
            $.messager.show({
                title: mesTitle,
                msg: result.msg
            });
        }
    });
}

//启用
function recoverConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 1) {
            $.messager.alert('错误提示', "通道已启用，不需要再次启用！");
            return;
        }
        $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
                $.post(getRootPath()+'/routeclose/upRouteCloseState',
                    {isdel: 1, id: record.id},
                    function (result) {
                        console.log(result);
                        if (result.success) {
                            $.messager.alert('消息提示', "启用成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/routeclose/datagrid?" + $("#fmorder").serialize();
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


function save() {
    //去空格 replace(/(^\s*)|(\s*$)/, "")
    if ($('#delReason').val().replace(/(^\s*)|(\s*$)/, "") == "") {
        $.messager.alert('提示', '禁用原因不能为空！');
        return;
    }
    var record = $("#datagrid").datagrid('getSelected');
    $.post(getRootPath()+'/routeclose/upRouteCloseState',
        {isdel: 1, delReason: $('#delReason').val(), id: record.id},
        function (result) {
            if (result.success) {
                $('#delreasondlg').dialog('close');
                $.messager.alert('消息提示', "禁用成功");
                $("#datagrid").datagrid("options").url = getRootPath()+"/routeclose/datagrid?" + $("#fmorder").serialize();
                $("#datagrid").datagrid("load");
            } else {
                $.messager.alert('错误提示', "禁用失败");
            }
        });
}

function removeConfig() {
    var record = $("#datagrid").datagrid('getSelected');
    if (record) {
        if (record.isdel == 0) {
            $.messager.alert('错误提示', "通道为关闭状态，不需要再次关闭！");
            return;
        }
        $.messager.confirm("关闭", "是否关闭", function (r) {
            if (r) {
                $.post(getRootPath()+'/routeclose/upRouteCloseState',
                    {isdel: 0, id: record.id},
                    function (result) {
                        console.log(result);
                        if (result.success) {
                            $.messager.alert('消息提示', "关闭成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+"/routeclose/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "关闭失败");
                        }
                    });
            }
        });

    } else {
        $.messager.alert('提示', '请先选中要关闭的行');
    }
}

function editConfig() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        $.post(getRootPath()+'/routeclose/selectRouteClose',
            {id: row.id},
            function (result) {
                if (result.success) {
                    $("#dlgisdel").val(row.isdel);
                    $("#oldbankId").val(result.obj.bankId);
                    $("#oldchannelId").val(result.obj.channelId);
                    $("#id").val(result.obj.id);
                    $("#dlgchannelId").combobox("setValue", result.obj.channelId);
                    $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                    $("#dlgcardType").combobox("setValue", result.obj.cardType);
                    $("#dlgbankId").combobox("setValue", result.obj.bankId);
                    $("#dlgbankId").combobox("setText", result.obj.bankName);
                    $("#dlgremark").val(result.obj.remark);
                    $('#configdlg').dialog('open').dialog('setTitle', '编辑');

                } else {
                    $.messager.alert('错误提示', "编辑失败");
                }
            });

    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function formatCardType(val, row) {
    if (val == 1) {
        return '<span>' + '借记卡' + '</span>';
    } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
    }
    else if (val == 10) {
        return '<span>' + '全部' + '</span>';
    }
}

function formatOperate(val, row){
    return '<a class="editcls" onclick="editRow(\'' + row.id + '\')" href="javascript:void(0)">设置</a>';
}

function editRow(id) {
    $('#iframe1')[0].src = getRootPath()+'/routeclose/getTiming?id=' + id;
    $('#openRoleDiv').dialog('open');
}

function closeRoleDiv() {
    $('#openRoleDiv').dialog('close');
    $.messager.alert('消息提示', "定时设置成功");
    $("#datagrid").datagrid("options").url = getRootPath()+"/routeclose/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//添加Redis
function addRedisConfig() {
    $('#addredis').linkbutton({disabled:true});
    $.post(getRootPath()+'/routeclose/addredis?'+ $("#fmorder").serialize(),
        function (result) {
            if (result.success==true) {
                $.messager.alert('提示', result.msg);
            }else{
                $.messager.alert('提示', "更新失败");
            }
            $('#addredis').linkbutton({disabled:false});
        });
}