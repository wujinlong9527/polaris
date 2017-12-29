var url;
var mesTitle;

formatterDate = function (date) {
    var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
    var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
    + (date.getMonth() + 1);
    return date.getFullYear() + '-' + month + '-' + day;
    searchOrder();
};

window.onload = function () {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#finalTime').datebox('setValue', formatterDate(new Date()));

    $("#datagrid").datagrid("options").url = getRootPath() + "/userinfo/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");

    $('#datagrid').datagrid({
        view: detailview,
        detailFormatter: function (rowIndex, rowData) {
            return '<table>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><b>返回数据：</b></td>'
                + '</tr>'
                + '<tr>'
                + '<td style="border:0;padding:3px"><xmp>' + rowData.bankReturnMsg + '</xmp></td>'
                + '</tr>'
                + '</table>';
        }
    });
    //页面加载时即加载所有渠道，用于查询条件中渠道下拉
    getDealchannel();
}

function searchOrder() {
    $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    $("#datagrid").datagrid("options").url = getRootPath() + "/userinfo/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

function onReset() {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#finalTime').datebox('setValue', formatterDate(new Date()));
    $("#fullName").textbox('setValue', "");
    $("#cardNo").textbox('setValue', "");
    $("#idCard").textbox('setValue', "");
    $("#phone").textbox('setValue', "");
    $("#dealSubChannel").combobox('setValue', "");
    $("#datagrid").datagrid("options").url = getRootPath() + "/userinfo/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
}

//
function formatCardType(val, row) {
    if (val == 1) {
        return '<span>' + '借记卡' + '</span>';
    } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
    }
}

function formatIsSuc(val, row) {
    if (val == 0) {
        return '<span>' + '处理中' + '</span>';
    } else if (val == 1) {
        return '<span>' + '成功' + '</span>';
    } else if (val == -1) {
        return '<span>' + '失败' + '</span>';
    }
}
function formatIschannel(val, row) {
    if (val == 'deduct') {
        return '<span>' + '理财1.0(deduct)' + '</span>';
    } else if (val == 'harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
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
    }
    else {
        return '<span>' + val + '</span>';
    }
}

//获取所有渠道，给渠道combobox赋值
function getDealchannel() {
    $('#dealSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel',
        // value: "全部"//默认显示全部选项
    });
    $.ajax({
        type: "POST",
        url: getRootPath() + "/userinfo/getDealChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            // data.rows.unshift({"dealSubChannel":"全部"});//第一列加上全部选项
            $("#dealSubChannel").combobox("loadData", data.rows).val();
        }
    })
}

//弹出新增界面
function addConfig() {
    var orderAction = "鉴权验证";
    //ajax加载鉴权验证类型的渠道
    $.ajax({
        type: "POST",
        url: getRootPath() + "/routechannel/getDealchannel",
        data: {orderAction: orderAction},
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            $("#dealSubChannelAdd").combobox("loadData", data.rows);
        }
    })
    $('#configdlg').dialog('open').dialog('setTitle', '扣款查询');
    $('#configfm').form('clear');
    mesTitle = '新增成功';
}

function addRedisConfig() {
    $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
    $('#addredis').linkbutton({disabled: true});
    $.post(getRootPath() + '/userinfo/updchannel?' + $("#fmorder").serialize(),
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success == true && result.msg > 0) {
                $.messager.alert('提示', "更新" + result.msg + "条数据");
            } else if (result.success == true) {
                $.messager.alert('提示', "没有可更新的数据");
            } else {
                $.messager.alert('提示', "更新失败");
            }
            $('#addredis').linkbutton({disabled: false});
        });

}

function addAllRedisConfig() {
    $('#addredis').linkbutton({disabled: true});
    $.post(getRootPath() + '/userinfo/updallchannel?' + $("#fmorder").serialize(),
        function (result) {
            //var result = eval('(' + result + ')');
            if (result.success == true && result.msg > 0) {
                $.messager.alert('提示', "更新" + result.msg + "条数据");
            } else if (result.success == true) {
                $.messager.alert('提示', "没有可更新的数据");
            } else {
                $.messager.alert('提示', "更新失败");
            }
            $('#addredis').linkbutton({disabled: false});
        });

}

//新增保存
function saveConfig() {
    $('#configfm').form('submit', {
        url: getRootPath() + "/userinfo/adduserinfo",
        onSubmit: function () {
            return $(this).form('validate');
        },
        success: function (result) {
            //var result = eval('(' + result + ')');

            if (result.success) {
                $('#configdlg').dialog('close');
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