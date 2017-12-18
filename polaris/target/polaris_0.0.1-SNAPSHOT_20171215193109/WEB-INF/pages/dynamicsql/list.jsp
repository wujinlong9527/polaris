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
            $('#yujing').combobox({
                onSelect: function (record) {
                    if ($("#yujing").combobox("getValue") == 0) {
                        $("#sql1").val("select dealChannel,cardbankname,count(1) 总笔数, " +
                                "sum(case sucflag  when 1 then 1 else 0 end) 成功笔数 " +
                                "from ncmpi_order_consume where " +
                                "inserttime between date_add(NOW(), interval -20 minute) and NOW() " +
                                "and sourceSubChannel<>'闪电借款_强扣' and dealChannel<>'未知' " +
                                "and code not in ('51','UDWZ','13') " +
                                "group by dealChannel,cardbankname");
                    }
                    if ($("#yujing").combobox("getValue") == 1) {
                        $("#sql1").val("select dealChannel,cardbankname,count(1) 总笔数," +
                                "sum(case sucflag  when 1 then 1 else 0 end) 成功笔数 " +
                                "from ncmpi_order_Verify " +
                                "where inserttime between date_add(NOW(), interval -20 minute) and NOW() " +
                                "and dealChannel<>'未知'	and code not in ('51','UDWZ','13') " +
                                "group by dealChannel,cardbankname");
                    }
                }
            });
        }

        var option = {};
        function searchOrder() {

            if ($("#sql1").val() == "") {
                $.messager.alert('提示', "查询语句不能为空");
                return;
            }

            $('#datagrid').datagrid('loadData', {total: 0, rows: []});
            $.post('${path}/orderconsume/dynamicColumn',
                    {sql1: $("#sql1").val()},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success == true) {
                            option.columns = [result.columns];
                            $('#datagrid').datagrid(option)
                            $("#datagrid").datagrid("options").url = "${path}/orderconsume/dynamicdatagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            if (result.msg != "") {
                                $.messager.alert('错误提示', result.msg);
                            }
                            else {
                                $.messager.alert('错误提示', "查询失败");
                            }
                        }
                    });
        }

        function onReset() {
            $("#sql1").val("");
            $('#datagrid').datagrid('loadData', {total: 0, rows: []});
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 任务信息列表 -->
    <table id="datagrid" title="SQL查询" class="easyui-datagrid" fit="true"
           toolbar="#toolbar" pagination="false"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <%--<span style="color:green; float: right;font-size:12px">常用表提示--%>
                <%--<br><label style="color:black;">消费表：ncmpi_order_consume</label></br>--%>
                <%--<br><label style="color:black;">任务表：ncmpi_dotask</label></br>--%>
                <%--<br><label style="color:black;">预授权表：ncmpi_order_Freeze</label></br>--%>
                <%--</span>--%>
                <label>查询语句:</label> <textarea id="sql1" name="sql1" rows="3" cols="50"></textarea>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
                <label>预警项:</label> <input id="yujing" name="yujing" class="easyui-combobox" style="width: 150px"
                                           data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'0',text:'20分钟内消费全部失败'},{id:'1',text:'鉴权单个银行全失败'}]">
            </div>
        </form>
    </div>

</div>

</body>
</html>
