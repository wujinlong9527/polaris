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
            $("#datagrid").datagrid("options").url
                    = "${path}/configdealbank/datagridDetail?cardBankName=" + $('#hcardBankName').val()
                    + '&cardType=' + $('#hcardType').val();
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
                url: "${path}/configdeal/getDealchannel",
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
                url: "${path}/configdeal/getDealSubChannel",
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
                url: "${path}/configdeal/getStrategy",
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
                url: "${path}/configdeal/getCardBnkName",
                cache: false,
                dataType: "json",
                success: function (data) {

                    $("#cardBankName").combobox("loadData", data.rows);
                }
            });

//            $('#datagrid').datagrid({
//                rowStyler:function(index,row){
//                    if (row.dealChannel.indexOf("所有开户行") > 0){
//                        return 'background-color:#70DB93;color:blue;font-weight:bold;';
//                    }
//                }
//            });

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

            $('#configfm').form('submit', {
                url: path + "/configdeal/addConfigDeal",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        $('#configdlg').dialog('close');
                        $("#datagrid").datagrid("options").url
                                = "${path}/configdealbank/datagridDetail?cardBankName=" + $('#hcardBankName').val() + '&cardType=' + $('#hcardType').val();
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

                if (record.dealChannel.indexOf("所有开户行") > 0) {
                    $.messager.confirm("删除", "此策略包含所有开户行，是否删除请慎重！！！\r\n是否删除？", function (r) {
                        if (r) {
                            $('#delreasondlg').dialog('open').dialog('setTitle', '删除原因');
                            $('#delReason').val("");
                        }
                    });
                }
                else {
                    $.messager.confirm("删除", "是否删除策略", function (r) {
                        if (r) {
                            $('#delreasondlg').dialog('open').dialog('setTitle', '删除原因');
                            $('#delReason').val("");
                        }
                    });
                }


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
            $.post('${path}/configdeal/upConfigDealState',
                    {isdel: 1, delReason: $('#delReason').val(), gid: record.gid},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "删除策略成功");
                            $("#datagrid").datagrid("options").url = "${path}/configdealbank/datagridDetail?cardBankName=" + $('#hcardBankName').val() + '&cardType=' + $('#hcardType').val();
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

                        $.post('${path}/configdeal/upConfigDealState',
                                {isdel: 0, delReason: "", gid: record.gid},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "恢复策略成功");
                                        $("#datagrid").datagrid("options").url = "${path}/configdealbank/datagridDetail?cardBankName=" + $('#hcardBankName').val() + '&cardType=' + $('#hcardType').val();
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
                if (row.isdel == 1) {
                    $.messager.alert('错误提示', "数据为删除状态,不需要修改！");
                    return;
                }

                $.post('${path}/configdeal/selectConfigDeal',
                        {gid: row.gid},
                        function (result) {
                            var result = eval('(' + result + ')');
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
                $.post('${path}/configdeal/selectConfigDeal',
                        {gid: row.gid},
                        function (result) {
                            var result = eval('(' + result + ')');
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
                    = "${path}/configdealbank/datagridDetail?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#sstrategy").textbox('setValue', "");
            $("#sdealSubChannel").textbox('setValue', "");
//            $("#scardType").combobox("setValue", "");
            $("#isdel").combobox("setValue", "");
            $("#datagrid").datagrid("options").url
                    = "${path}/configdealbank/datagridDetail?cardBankName=" + $('#hcardBankName').val() + '&cardType=' + $('#hcardType').val();
            $("#datagrid").datagrid("load");
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 策略信息列表 -->
    <table id="datagrid" class="easyui-datagrid" fit="true"
           url="" toolbar="#toolbar" pagination="true"
           fitColumns="false" singleSelect="true" rownumbers="true"
           border="false" nowrap="true">
        <thead>
        <tr>
            <th field="strategy" width="70">策略名称</th>
            <th field="dealChannel" width="150">处理渠道</th>
            <th field="dealSubChannel" width="130">处理子渠道</th>
            <th field="cardType" width="50" formatter="formatCardType">卡别</th>
            <th field="sourceSubChannel" width="150">来源子渠道</th>
            <th field="minMoney" width="60" align="right">最小金额</th>
            <th field="maxMoney" width="90" align="right">最大金额</th>
            <th field="level" width="50">优先级</th>
            <th field="isdel" width="70" formatter="formatIsdel">删除标识</th>
            <%--<th field="insertTime" width="130">创建时间</th>--%>
            <%--<th field="operateTime" width="130">操作时间</th>--%>
            <th field="delReason" width="100">删除原因</th>
        </tr>
        </thead>
    </table>


    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>策略名称:</label> <input id="sstrategy" name="strategy" class="easyui-textbox" style="width: 100px">
                <%--<label>卡别:</label> <input id="scardType" name="cardType" class="easyui-combobox" style="width: 80px"--%>
                <%--data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',--%>
                <%--data:[{id:'',text:'不限'},{id:'1',text:'借记卡'},{id:'2',text:'信用卡'}]">--%>
                <label>处理子渠道:</label> <input id="sdealSubChannel" name="dealSubChannel" class="easyui-textbox"
                                             style="width: 100px">
                <label>删除标识:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                            data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'未删除'},{id:'1',text:'已删除'}]">
                <input id="hcardBankName" name="cardBankName" type="hidden" value="${configdeal.cardBankName}"></td>
                <input id="hcardType" name="cardType" type="hidden" value="${configdeal.cardType}"></td>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
                <span style="color:green; float: right;font-size:14px"><span
                        style="color:black;">开户行：</span>${configdeal.cardBankName}&nbsp&nbsp<span
                    <%--style="color:black;">策略：</span>${configdeal.strategy}&nbsp&nbsp<span--%>
                    <%--style="color:black;">来源子渠道：</span>${configdeal.sourceSubChannel}--%>
                </span>
            </div>
        </form>

        <c:if test="${button.size()>0}">
            <div id="toolbar1">
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'add'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'copy'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="copyConfig();">复制添加</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'edit'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-edit" plain="true" onclick="editConfig();">编辑</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'delete'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="removeConfig();">删除</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'recover'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="recoverConfig();">恢复</a>
                    </c:if>
                </c:forEach>
            </div>
        </c:if>
        <%--<input id="hstrategy" name="strategy" type="hidden" value="${configdeal.strategy}"></td>--%>
    </div>


    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:310px;height:360px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>

            <table>
                <input id="gid" name="gid" type="hidden"></td>
                <input id="province" name="province" type="hidden" value="所有"></td>
                <input id="city" name="city" type="hidden" value="所有"></td>
                <input id="olddealChannel" name="olddealChannel" type="hidden"></td>
                <input id="olddealSubChannel" name="olddealSubChannel" type="hidden"></td>
                <input id="oldstrategy" name="oldstrategy" type="hidden"></td>
                <input id="oldcardBankName" name="oldcardBankName" type="hidden"></td>
                <tr>
                    <td align="right">*处理渠道:</td>
                    <td><input id="dealChannel" name="dealChannel" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*处理子渠道:</td>
                    <td><input id="dealSubChannel" name="dealSubChannel" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*商户号:</td>
                    <td><input id="merId" name="merId" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*商户名称:</td>
                    <td><input id="merName" name="merName" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*策略名称:</td>
                    <td><input id="strategy" name="strategy" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*开户行:</td>
                    <td><input id="cardBankName" name="cardBankName" style="width: 150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*卡别:</td>
                    <td><input id="cardType" name="cardType" style="width: 150px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'借记卡'},{id:'2',text:'信用卡'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*最小金额:</td>
                    <td><input id="minMoney" name="minMoney" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*最大金额:</td>
                    <td><input id="maxMoney" name="maxMoney" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
                <tr>
                    <td align="right">*优先级:</td>
                    <td><input id="level" name="level" type="text" style="width: 145px" class="easyui-validatebox"
                               required="true"></td>
                </tr>
            </table>
        </form>
    </div>


    <!-- 对话框按钮 -->
    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:60px">取消</a>
    </div>


    <div id="delreasondlg" class="easyui-dialog"
         style="width:300px;height:120px;padding:10px 20px" closed="true"
         buttons="#delreason-buttons">
        <tr>
            <td>*删除原因:</td>
            <td><input id="delReason" name="delReason" type="text"></td>
        </tr>
    </div>

    <div id="delreason-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="save()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#delreasondlg').dialog('close')"
            style="width:60px">取消</a>
    </div>

</div>

</body>
</html>
