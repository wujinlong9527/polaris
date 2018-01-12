var url;
var mesTitle;

window.onload = function () {

    $('#openRoleDiv').dialog({
        onClose: function () {
            $("#datagrid").datagrid("options").url = getRootPath()+"/configdealbank/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }
    });

    $('#dlgdealChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'dealChannel',
        textField: 'dealChannel'
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/configdeal/getDealchannel",
        cache: false,
        dataType: "json",
        success: function (data) {

            $("#dlgdealChannel").combobox("loadData", data.rows);
        }
    });

    $('#dlgdealSubChannel').combobox({
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

            $("#dlgdealSubChannel").combobox("loadData", data.rows);
        }
    });

    $('#dlgstrategy').combobox({
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

            $("#dlgstrategy").combobox("loadData", data.rows);
        }
    });

    $('#dlgcardBankName').combobox({
        editable: true, //不可编辑状态
        cache: false,
        panelHeight: 'auto',//自动高度适合
        valueField: 'cardBankName',
        textField: 'cardBankName'
    });

    $.ajax({
        type: "POST",
        url: getRootPath()+"/configdeal/getCardBnkName",
        cache: false,
        dataType: "json",
        success: function (data) {

            $("#dlgcardBankName").combobox("loadData", data.rows);
        }
    });
    searchOrder();
}

//格式换显示状态
function formatdata(val, row) {
    return '<a class="editcls" onclick="editRow(\'' + row.cardBankName + '\',\'' + row.cardType + '\')" href="javascript:void(0)">查看</a>';
}

//查询列表
function searchOrder() {
    $("#datagrid").datagrid("options").url = getRootPath()+"/configdealbank/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//重置
function onReset() {
    $("#strategy").textbox('setValue', "");
    $("#dealSubChannel").textbox('setValue', "");
    //$("#cardType").combobox("setValue", "");
    $("#cardBankName").textbox('setValue', "");
    $("#isdel").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+"/configdealbank/datagrid";
    $("#datagrid").datagrid("load");
}

function editRow(cardBankName, cardType) {
    $('#iframe1')[0].src = getRootPath()+'/configdealbank/dealinfo?cardBankName=' + cardBankName
        + '&cardType=' + cardType + '&menu_button=' + $("#menu_button").val();
    $('#openRoleDiv').dialog('open');
}

//弹出新增界面
function addConfig() {
    $('#configdlg').dialog('open').dialog('setTitle', '添加路由策略');
    $('#configfm').form('clear');
    mesTitle = '保存成功';
}

//新增保存
function saveConfig() {

    $('#dlgdealChannel').combobox("setValue", $("#dlgdealChannel").combobox("getText"));
    $("#dlgdealSubChannel").combobox("setValue", $("#dlgdealSubChannel").combobox("getText"));
    $("#dlgstrategy").combobox("setValue", $("#dlgstrategy").combobox("getText"));
    $("#dlgcardBankName").combobox("setValue", $("#dlgcardBankName").combobox("getText"));

    $.ajax({
        type: "POST",
        url:getRootPath() + "/configdeal/addConfigDeal",
        data:$('#configfm').serialize(),// 你的formid
        async: false,
        error: function(data) {
            alert("Connection error");
        },
        success: function(result) {
            //var result = eval('(' + result + ')');
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/configdealbank/datagrid";
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

function formatCardType(val, row) {
    if (val == 1) {
        return '<span>' + '借记卡' + '</span>';
    } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
    }
}