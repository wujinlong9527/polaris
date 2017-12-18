/**
 * Created by Administrator on 2016/12/1.
 */
var url;
var mesTitle;

window.onload = function () {
    var cardBankName = $('#cardBankName').val();
    if (cardBankName == 'null') {
        cardBankName = "";
    }
    var dealChannel = $('#dealChannel').val();
    if (dealChannel == 'null') {
        dealChannel = "";
    }
    var sourceSubChannel = $('#sourceSubchannel').val();
    if (sourceSubChannel == 'null') {
        sourceSubChannel = "";
    }
    console.log("sourceSubChannel:",sourceSubChannel);
    $("#datagrid").datagrid("options").url
        = getRootPath()+"/orderconsume/msgdatagrid?dealChannel=" + dealChannel + "&cardBankName=" + cardBankName
        + "&sourceSubchannel=" + sourceSubChannel + "&insertTime=" + $('#insertTime').val()
        + "&finalTime=" + $('#finalTime').val();
    $("#datagrid").datagrid("load");
}