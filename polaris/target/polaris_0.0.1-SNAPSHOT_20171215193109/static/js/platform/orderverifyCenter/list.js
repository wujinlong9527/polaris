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
    return;

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

}


function searchOrder() {
    var fcOrderid = document.getElementById("fcOrderid").value;
    var fullName = document.getElementById("fullName").value;
    var phone = document.getElementById("phone").value;
    var cardNo = document.getElementById("cardNo").value;
    var payOrderid = document.getElementById("payOrderid").value;
    if((fcOrderid == null || fcOrderid == '')&&(fullName== null || fullName == '')&&(phone == null || phone == '')&&(cardNo == null || cardNo == '')&&(payOrderid == null || payOrderid == ''))
    {
        alert("fcOrderid、姓名、手机号、银行卡号、银联流水号,请至少输入一项进行查询!");
        return;
    }


    $("#datagrid").datagrid("options").url = getRootPath()+"/orderverify/datagrid?" + $("#fmorder").serialize();
    $("#datagrid").datagrid("load");
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
    $("#dealChannel").textbox('setValue', "");
    $("#payOrderid").textbox('setValue', "");
    $("#sucFlag").combobox("setValue", "");
    $("#cardType").combobox("setValue", "");
    $("#sourceSubChannel").combobox("setValue", "");

    return;

    $("#datagrid").datagrid("options").url = getRootPath()+"/orderverify/datagrid?" + $("#fmorder").serialize();
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
    } else if (val =='harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
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