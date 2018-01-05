/**
 * Created by Administrator on 2016/12/1.
 */
var url;
var mesTitle;

window.onload = function () {
        $("#datagrid").datagrid("options").url
            = getRootPath()+"/orderconsume/msgdatagrid?dealChannel=" + $('#dealChannel').val() + "&cardBankName=" + $('#cardBankName').val()
            + "&sourceSubchannel=" + $('#sourceSubchannel').val() + "&insertTime=" + $('#insertTime').val()
            + "&finalTime=" + $('#finalTime').val();
        $("#datagrid").datagrid("load");
    }
