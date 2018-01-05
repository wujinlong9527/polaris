var url;
var mesTitle;

window.onload = function () {
    $("#datagrid").datagrid("options").url
        = getRootPath() + "/configdeal/datagridDetail?dealSubChannel=" + $('#hdealSubChannel').val() + "&strategy=" + $('#hstrategy').val();
    $("#datagrid").datagrid("load");

    $('#dealChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'dealChannel',
        textField: 'dealChannel'
    });

    $.ajax({
        type: "POST",
        url: getRootPath() + "/configdeal/getDealchannel",
        cache: false,
        dataType: "json",
        success: function (data) {

            $("#dealChannel").combobox("loadData", data.rows);
        }
    });

    $('#dealSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/configdeal/getDealSubChannel",
        cache: false,
        dataType: "json",
        success: function (data) {

            $("#dealSubChannel").combobox("loadData", data.rows);
        }
    });

    $('#strategy').combobox({
        editable: true, //不可编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'strategy',
        textField: 'strategy'
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/configdeal/getStrategy",
        cache: false,
        dataType: "json",
        success: function (data) {

            $("#strategy").combobox("loadData", data.rows);
        }
    });

    $('#cardBankName').combobox({
        editable: true, //不可编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'cardBankName',
        textField: 'cardBankName'
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+ "/configdeal/getCardBnkName",
        cache: false,
        dataType: "json",
        success: function (data) {

            $("#cardBankName").combobox("loadData", data.rows);
        }
    });

}

//格式换显示状态
function formatIsdel(val, row) {
    if (val == 1) {
        return '<span style="color:red;">' + '已删除' + '</span>';
    } else {
        return '<span>' + '未删除' + '</span>';
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


//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '添加路由策略');
    $('#configfm').form('clear');
    mesTitle = '保存成功';
}

//新增保存
function saveConfig() {

    $('#dealChannel').combobox("setValue", $("#dealChannel").combobox("getText"));
    $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    $("#strategy").combobox("setValue", $("#strategy").combobox("getText"));
    $("#cardBankName").combobox("setValue", $("#cardBankName").combobox("getText"));

    $.ajax({
        type: "POST",
        url:getRootPath() + "/configdeal/addConfigDeal",
        data:$('#configfm').serialize(),
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url
                    = getRootPath()+"/configdeal/datagridDetail?dealSubChannel=" + $('#hdealSubChannel').val() + "&strategy=" + $('#hstrategy').val();
                $('#datagrid').datagrid('reload');
            } else {
                mesTitle = '新增路由策略失败';
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
    $.post(getRootPath()+'/configdeal/upConfigDealState',
        {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#delreasondlg').dialog('close');
                $.messager.alert('消息提示', "删除策略成功");
                $("#datagrid").datagrid("options").url = getRootPath()+"/configdeal/datagridDetail?dealSubChannel=" + $('#hdealSubChannel').val() + "&strategy=" + $('#hstrategy').val();
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

                $.post(getRootPath()+'/configdeal/upConfigDealState',
                    {isdel: 0, delReason: "", gid: record.gid},
                    function (result) {
                        //var result = eval('(' + result + ')');
                        if (result.success) {
                            $.messager.alert('消息提示', "恢复策略成功");
                            $("#datagrid").datagrid("options").url = getRootPath()+ "/configdeal/datagridDetail?dealSubChannel=" + $('#hdealSubChannel').val() + "&strategy=" + $('#hstrategy').val();
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


function editConfig() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        /*if (row.isdel == 1) {
            $.messager.alert('错误提示', "数据为删除状态,不需要修改！");
            return;
        }*/

        $.post(getRootPath()+'/configdeal/selectConfigDeal',
            {gid: row.gid},
            function (result) {
                //var result = eval('(' + result + ')');
                if (result.success) {
                    $("#gid").val(result.obj.gid);
                    $("#dealChannel").combobox("setValue", result.obj.dealChannel);
                    $("#dealSubChannel").combobox("setValue", result.obj.dealSubChannel);
                    $("#merId").val(result.obj.merId);
                    $("#merName").val(result.obj.merName);
                    $("#strategy").combobox("setValue", result.obj.strategy);
                    $("#cardBankName").combobox("setValue", result.obj.cardBankName);
                    $("#minMoney").val(result.obj.minMoney);
                    $("#maxMoney").val(result.obj.maxMoney);
                    $("#level").val(result.obj.level);
                    $("#cardType").combobox("setValue", result.obj.cardType);

                    $("#oldstrategy").val(result.obj.strategy);
                    $("#olddealChannel").val(result.obj.dealChannel);
                    $("#olddealSubChannel").val(result.obj.dealSubChannel);
                    $("#oldcardBankName").val(result.obj.cardBankName);

                    $('#configdlg').dialog('open').dialog('setTitle', '编辑路由策略');
                } else {
                    $.messager.alert('错误提示', "恢复策略失败");
                }
            });

    } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
    }
}

function copyConfig() {
    var row = $('#datagrid').datagrid('getSelected');
    if (row) {
        $.post(getRootPath()+'/configdeal/selectConfigDeal',
            {gid: row.gid},
            function (result) {
                //var result = eval('(' + result + ')');
                if (result.success) {
                    $("#gid").val("");
                    $("#dealChannel").combobox("setValue", result.obj.dealChannel);
                    $("#dealSubChannel").combobox("setValue", result.obj.dealSubChannel);
                    $("#merId").val(result.obj.merId);
                    $("#merName").val(result.obj.merName);
                    $("#strategy").combobox("setValue", result.obj.strategy);
                    $("#cardBankName").combobox("setValue", result.obj.cardBankName);
                    $("#minMoney").val(result.obj.minMoney);
                    $("#maxMoney").val(result.obj.maxMoney);
                    $("#level").val(result.obj.level);
                    $("#cardType").combobox("setValue", result.obj.cardType);
                    $('#configdlg').dialog('open').dialog('setTitle', '添加路由策略');
                } else {
                    $.messager.alert('错误提示', "保存策略失败");
                }
            });

    } else {
        $.messager.alert('提示', '请选择要复制的记录！', 'error');
    }
}

//查询列表
function searchOrder() {
    $("#datagrid").datagrid("options").url
        = getRootPath()+"/configdeal/datagridDetail?dealSubChannel=" + $('#hdealSubChannel').val()
        + "&strategy=" + $('#hstrategy').val() + "&cardBankName=" + $('#scardBankName').val();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#scardBankName").textbox('setValue', "");
    $("#datagrid").datagrid("options").url
        = getRootPath()+ "/configdeal/datagridDetail?dealSubChannel=" + $('#hdealSubChannel').val() + "&strategy=" + $('#hstrategy').val();
    $("#datagrid").datagrid("load");
}