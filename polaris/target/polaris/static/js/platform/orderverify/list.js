/**
 * Created by Administrator on 2016/12/1.
 */

var url;
var mesTitle;

formatterDate = function (date) {
    var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
    var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"
    + (date.getMonth() + 1);
    return date.getFullYear() + '-' + month + '-' + day;
};

window.onload = function () {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#finalTime').datebox('setValue', formatterDate(new Date()));

    $("#datagrid").datagrid("options").url = getRootPath()+"/orderverify/datagrid?" + $("#fmorder").serialize();
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
    //页面加载时即加载总金额、成功率、单笔成本
    getPageDisplay();

    $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
    });
}


function searchOrder() {
    $("#dealChannel").combobox("setValue", $("#dealChannel").combobox("getText"));
    if(null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
    }
    $("#datagrid").datagrid("options").url = getRootPath()+"/orderverify/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
    //页面加载时即加载总金额、成功率、单笔成本
    getPageDisplay();
}

function onReset() {
    $('#insertTime').datebox('setValue', formatterDate(new Date()));
    $('#finalTime').datebox('setValue', formatterDate(new Date()));
    $("#fcOrderid").textbox('setValue', "");
    $("#fullName").textbox('setValue', "");
    $("#cardNo").textbox('setValue', "");
    $("#cardBankName").textbox('setValue', "");
    $("#phone").textbox('setValue', "");
    $("#payMoney").textbox('setValue', "");
    $("#dealChannel").combobox('setValue', "");
    $("#payOrderid").textbox('setValue', "");
    $("#sucFlag").combobox("setValue", "");
    $("#cardType").combobox("setValue", "");
    $("#sourceSubChannel").combobox("setValue", "");
    $("#datagrid").datagrid("options").url = getRootPath()+"/orderverify/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");

    //查询结果出来后加载总金额、成功率、单笔成本
    getPageDisplay();
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
    } else if (val =='harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
    } else if (val =='harbor_sms') {
        return '<span>' + '借款2.0(harbor_sms)' + '</span>';
    } else if (val =='loan') {
        return '<span>' + '借款1.0(loan)' + '</span>';
    }
    else if (val =='loan_force') {
        return '<span>' + '借款强扣1.0(loan_force)' + '</span>';
    }
    else if (val =='storm') {
        return '<span>' + '理财2.0(storm)' + '</span>';
    }
    else if (val =='taurus') {
        return '<span>' + '闪电分期(taurus)' + '</span>';
    }
    else {
        return '<span>' + val + '</span>';
    }
}

//获取所有渠道，给渠道combobox赋值
function getDealchannel() {
    $('#dealChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealChannel',
        textField: 'dealChannel',
        value: '全部'//默认显示全部选项
    });
    $.ajax({
        type: "POST",
        url: getRootPath()+"/orderverify/getDealChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            data.rows.unshift({"dealChannel":"全部"});//第一列加上全部选项
            $("#dealChannel").combobox("loadData", data.rows);
        }
    })
}

//弹出新增界面
function addConfig() {
    var orderAction = "鉴权验证";
    //ajax加载鉴权验证类型的渠道
    $.ajax({
        type: "POST",
        url: getRootPath()+"/routechannel/getDealchannel",
        data:{orderAction:orderAction},
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            $("#dealSubChannelAdd").combobox("loadData", data.rows);
        }
    })
    $('#configdlg').dialog('open').dialog('setTitle', '鉴权验证添加');
    $('#configfm').form('clear');
    mesTitle = '新增成功';
}

//新增保存
function saveConfig() {
    $.ajax({
        url: getRootPath() + "/orderverify/addOrderverify",
        data:$("#configfm").serialize(),
        type:"POST",
        error:function(){
          alert("Connection failed");
        },
        success: function (result) {
            if (result.success) {
                $('#configdlg').dialog('close');
                $("#datagrid").datagrid("options").url = getRootPath()+"/orderverify/datagrid?" + $("#fmorder").serialize();
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

//加载总金额、成功率、单笔成本
function getPageDisplay() {
    document.getElementById('successRate').innerHTML = "成功率:";
    document.getElementById('singleCost').innerHTML = "单笔成本（元）:";
    $.ajax({
        type: "POST",
        url: getRootPath()+"/orderverify/getPageDisplay",
        data:$('#fmorder').serialize(),
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
            if(null != data.successRate) {
                document.getElementById('successRate').innerHTML = " 成功率:"+data.successRate;
            }
            if(null != data.singleCost) {
                document.getElementById('singleCost').innerHTML = " 单笔成本（元）:"+data.singleCost;
            }
        }
    })
}