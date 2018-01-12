var url;
var mesTitle;

formatterDate = function (date) {
    var strDate = date.getFullYear() + "-";
    strDate += date.getMonth() + 1 + "-";
    strDate += date.getDate() + " ";
    strDate += date.getHours() + ":";
    strDate += date.getMinutes() + ":";
    strDate += date.getSeconds();
    return strDate;
};

window.onload = function () {
    $('#insertTime').datetimebox('setValue', formatterDate(new Date()));
    $('#finalTime').datetimebox('setValue', formatterDate(new Date()));
    $("#datagrid").datagrid("options").url = getRootPath()+"/orderconsume/consumeStatistics?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
    $('#sourceSubchannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });

    $('#dealSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
    });
    $.ajax({
        type: "POST",
        url: getRootPath()+"/orderconsume/selectDealSubChannel",
        cache: false,
        dataType: "json",
        success: function (data) {
            $("#dealSubChannel").combobox("loadData", data.rows);
            //$("#dlgmsg").combobox("loadData", data.rows);
        }
    });
}

function searchOrder() {
    var px = $("input[name='px']:checked").map(function () {
        return $(this).val();

    }).get().join(',');
    $("#types").val(px);
    if ($("input[id='ckdealChannel']:checked").val() == 'dealSubChannel') {
        $("#datagrid").datagrid('showColumn', 'dealSubChannel');
    }
    else {
        $("#datagrid").datagrid('hideColumn', 'dealSubChannel');
    }
    if ($("input[id='ckcardBankName']:checked").val() == 'cardBankName') {
        $("#datagrid").datagrid('showColumn', 'cardBankName');
    }
    else {
        $("#datagrid").datagrid('hideColumn', 'cardBankName');
    }
    if ($("input[id='cksourceSubchannel']:checked").val() == 'sourceSubchannel') {
        $("#datagrid").datagrid('showColumn', 'sourceSubchannel');
    }
    else {
        $("#datagrid").datagrid('hideColumn', 'sourceSubchannel');
    }

    if(null == $("#sourceSubchannel").combobox("getValue")) {
        $("#sourceSubchannel").combobox("setValue", $("#sourceSubchannel").combobox("getText"));
    }
    $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    $("#datagrid").datagrid("options").url = getRootPath()+"/orderconsume/consumeStatistics?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $('#insertTime').datetimebox('setValue', formatterDate(new Date()));
    $('#finalTime').datetimebox('setValue', formatterDate(new Date()));
    $("#sourceSubchannel").combobox('setValue', "");
    $("#dealSubChannel").textbox('setValue', "");
    $("#datagrid").datagrid("options").url = getRootPath()+"/orderconsume/consumeStatistics?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function formatdata(val, row) {
    return '<a onclick="editRow(\'' + row.cardBankName + '\',\'' + row.dealChannel + '\',\'' + row.sourceSubchannel + '\')" href="javascript:void(0)">查看</a>';
}

function editRow(cardBankName, dealChannel, sourceSubChannel) {
    if (cardBankName == 'undefined') {
        cardBankName = "";
    }
    if (dealChannel == 'undefined') {
        dealChannel = "";
    }
    if (sourceSubChannel == 'undefined') {
        sourceSubChannel = "";
    }
    $('#iframe1')[0].src = getRootPath()+'/orderconsume/returnmsg?dealChannel=' + dealChannel
        + '&cardBankName=' + cardBankName + '&sourceSubchannel=' + sourceSubChannel + '&insertTime='
        + $("#insertTime").datetimebox('getValue') + '&finalTime=' + $("#finalTime").datetimebox('getValue');
    $('#openRoleDiv').dialog('open');

}