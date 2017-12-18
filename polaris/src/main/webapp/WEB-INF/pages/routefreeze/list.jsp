<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>用户管理</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <!-- 对话框的样式 -->
    <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript">
        var url;
        var mesTitle;
        window.onload = function () {
            $("#datagrid").datagrid("options").url = "${path}/routefreeze/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");

            $('#datagrid').datagrid({
                onLoadSuccess:function(data){
                    MergeCells("datagrid","bankName");
                }
            });
        }

        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/routefreeze/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
            $('#datagrid').datagrid({
                onLoadSuccess:function(data){
                    MergeCells("datagrid","bankName");
                }
            });
        }
        function onReset() {

            $("#bankName").textbox('setValue', "");
            $("#dealChannel").textbox('setValue', "");
            $("#delFlag").combobox("setValue", "");
            $("#datagrid").datagrid("options").url = "${path}/routefreeze/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }
        //
        function formatCardType(val, row) {
            if (val == 1) {
                return '<span>' + '借记卡' + '</span>';
            } else if (val == 2) {
                return '<span>' + '信用卡' + '</span>';
            } else if (val == 10) {
                return '<span>' + '所有' + '</span>';
            }
        }
        function formatDel(val, row) {
            if (val ==0) {
                return '<span style="color:green">' + '有效' + '</span>';
            }
            else
            {
                return '<span  style="color:red">' + '无效' + '</span>';
            }
        }
        function formateMoney(val, row){
            return val/100;
        }
        function MergeCells(tableID, fldList) {
            var Arr = fldList.split(",");
            var dg = $('#' + tableID);
            var fldName;
            var RowCount = dg.datagrid("getRows").length;
            var span;
            var PerValue = "";
            var CurValue = "";
            var length = Arr.length - 1;
            for (i = length; i >= 0; i--) {
                fldName = Arr[i];
                PerValue = "";
                span = 1;
                for (row = 0; row <= RowCount; row++) {
                    if (row == RowCount) {
                        CurValue = "";
                    }
                    else {
                        CurValue = dg.datagrid("getRows")[row][fldName];
                    }
                    if (PerValue == CurValue) {
                        span += 1;
                    }
                    else {
                        var index = row - span;
                        dg.datagrid('mergeCells', {
                            index: index,
                            field: fldName,
                            rowspan: span,
                            colspan: null
                        });
                        span = 1;
                        PerValue = CurValue;
                    }
                }
            }
        }


    </script>


</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 任务信息列表 -->
    <table id="datagrid" title="预授权路由查询" class="easyui-datagrid" fit="true"
    <%--url="${path}/orderfreeze/datagrid" --%>
           toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true" >
        <thead frozen="true">
        <tr>
            <%--<th field="orderAction" width="150">类型</th>--%>
            <th field="bankName" width="150">银行名称</th>
        </tr>
        </thead>
        <thead>
        <tr>

            <%--<th field="strategy" width="130">策略名称</th>--%>
            <%--<th field="strategylevel" width="50">策略优先级</th>--%>
            <th field="dealChannel" width="100">处理渠道</th>
            <th field="dealSubChannel" width="100" >处理子渠道</th>
            <%--<th field="channellevel" width="30">渠道优先级</th>--%>
            <th field="cardType" width="80" formatter="formatCardType">银行卡类型</th>
            <th field="minMoney" width="100" formatter="formateMoney">单笔最小金额</th>
            <th field="maxMoney" width="100" formatter="formateMoney">单笔最大金额</th>
            <th field="channelDayMoney" width="100" formatter="formateMoney">渠道单日限额</th>
            <th field="delFlag" width="80" formatter="formatDel">路由是否有效</th>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">

                <label>&nbsp&nbsp开户行:</label> <input id="bankName" name="bankName" class="easyui-textbox"
                                                     style="width: 100px">
                <label>&nbsp处理渠道:</label> <input id="dealChannel" name="dealChannel" class="easyui-textbox"
                                                 style="width: 120px">
                <label>路由是否有效:</label> <input id="delFlag" name="delFlag" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'有效'},{id:'1',text:'无效'}]">
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>

        </form>

    </div>

</div>

</body>
</html>
