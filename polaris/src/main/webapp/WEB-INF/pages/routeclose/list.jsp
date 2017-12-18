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

            $('#dlgorderAction').combobox({
                onSelect: function (record) {
                    $("#dlgbankId").combobox("setValue", "");
                    $("#dlgbankId").combobox("setText", "");
                    $.ajax({
                        type: "POST",
                        url: "${path}/routeclose/getbankname?orderAction=" + record.id,
                        cache: false,
                        dataType: "json",
                        success: function (data) {
                            $("#dlgbankId").combobox("loadData", data.rows);
                        }
                    });
                }
            });

            $.ajax({
                type: "POST",
                url: "${path}/routeclose/getchannel",
                cache: false,
                dataType: "json",
                success: function (data) {
                    $("#dlgchannelId").combobox("loadData", data.rows);
                }
            });

            $('#dlgbankId').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: '100',//自动高度适合
                valueField: 'id',
                textField: 'bankName',
                onSelect: function (record) {
                }
            });

            $('#dlgchannelId').combobox({
                editable: true, //编辑状态
                cache: false,
                panelHeight: '100',//自动高度适合
                valueField: 'id',
                textField: 'dealSubChannel',
                onSelect: function (record) {
                }
            });

        }

        //格式换显示状态
        function formatIsdel(val, row) {
            var repeatDate = row.repeatDate;
            var openTime = row.openTime;
            var v_repeatDate = '';
            var reValue = '';
            var reDate = '';
            if (repeatDate != null && repeatDate != '') {
                if (repeatDate.length > 3 && repeatDate.length !=0) {
                    v_repeatDate = repeatDate.split(",");
                    for (var i = 0; i <= v_repeatDate.length; i++) {
                        repeatDate = v_repeatDate[i];
                        if (repeatDate != null && repeatDate != '' && repeatDate != ',') {
                            if (repeatDate == "MON") {
                                reValue = "周一";
                            } else if (repeatDate == "TUE") {
                                reValue = "周二";
                            } else if (repeatDate == "WED") {
                                reValue = "周三";
                            } else if (repeatDate == "THU") {
                                reValue = "周四";
                            } else if (repeatDate == "FRI") {
                                reValue = "周五";
                            } else if (repeatDate == "SAT") {
                                reValue = "周六";
                            } else if (repeatDate == "SUN") {
                                reValue = "周日";
                            }
                            reDate = reDate + '' + reValue;
                        }
                    }
                    row.repeatDate = reDate;
                }
            } else {
                if (repeatDate == "MON") {
                    row.repeatDate = "周一";
                } else if (repeatDate == "TUE") {
                    row.repeatDate = "周二";
                } else if (repeatDate == "WED") {
                    row.repeatDate = "周三";
                } else if (repeatDate == "THU") {
                    row.repeatDate = "周四";
                } else if (repeatDate == "FRI") {
                    row.repeatDate = "周五";
                } else if (repeatDate == "SAT") {
                    row.repeatDate = "周六";
                } else if (repeatDate == "SUN") {
                    row.repeatDate = "周日";
                }
            }
            if (val == 1) {
                if (openTime == null || openTime == '') {
                    return '<span>' + '已启用' + '</span>';
                } else {
                    return '<span>' + '已启用(定时)' + '</span>';
                }
            } else if (val == 0) {
                if(openTime != null && openTime != ''){
                    return '<span style="color:red;">' + '已关闭(定时)' + '</span>';
                }else {
                    return '<span style="color:red;">' + '已关闭' + '</span>';
                }
            }
        }
        //查询列表
        function searchOrder() {
            $("#datagrid").datagrid("options").url = "${path}/routeclose/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //重置
        function onReset() {
            $("#bankname").textbox('setValue', "");
            $("#dealChannel").textbox('setValue', "");
            $("#dealSubChannel").textbox('setValue', "");
            $("#isdel").combobox("setValue", "");

            $("#datagrid").datagrid("options").url = "${path}/routeclose/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //弹出新增界面
        function addConfig() {
            $('#configdlg').dialog('open').dialog('setTitle', '新增');
            $('#configfm').form('clear');
            mesTitle = '新增成功';
        }

        //新增保存
        function saveConfig() {
            $('#configfm').form('submit', {
                url: path + "/routeclose/addrouteClose",
                onSubmit: function () {
                    return $(this).form('validate');
                },
                success: function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                        if ($("#id").val() != '') {
                            $('#configdlg').dialog('close');
                        }
                        //
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

        //删除
        function recoverConfig() {
            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                if (record.isdel == 1) {
                    $.messager.alert('错误提示', "通道已启用，不需要再次启用！");
                    return;
                }
                $.messager.confirm("启用", "是否启用", function (r) {
//                    if (r) {
//                        $('#delreasondlg').dialog('open').dialog('setTitle', '删除原因');
//                        $('#delReason').val("");
//                    }
                    if (r) {
                        $.post('${path}/routeclose/upRouteCloseState',
                                {isdel: 1, id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
//                                    $('#delreasondlg').dialog('close');
                                        $.messager.alert('消息提示', "启用成功");
                                        $("#datagrid").datagrid("options").url = "${path}/routeclose/datagrid?" + $("#fmorder").serialize();
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "启用失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要启用的行');
            }
        }


        function save() {
            //去空格 replace(/(^\s*)|(\s*$)/, "")
            if ($('#delReason').val().replace(/(^\s*)|(\s*$)/, "") == "") {
                $.messager.alert('提示', '禁用原因不能为空！');
                return;
            }

            var record = $("#datagrid").datagrid('getSelected');
            $.post('${path}/routeclose/upRouteCloseState',
                    {isdel: 1, delReason: $('#delReason').val(), id: record.id},
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#delreasondlg').dialog('close');
                            $.messager.alert('消息提示', "禁用成功");
                            $("#datagrid").datagrid("options").url = "${path}/routeclose/datagrid?" + $("#fmorder").serialize();
                            $("#datagrid").datagrid("load");
                        } else {
                            $.messager.alert('错误提示', "禁用失败");
                        }
                    });
        }

        function removeConfig() {

            var record = $("#datagrid").datagrid('getSelected');
            if (record) {
                if (record.isdel == 0) {
                    $.messager.alert('错误提示', "通道为关闭状态，不需要再次关闭！");
                    return;
                }
                $.messager.confirm("关闭", "是否关闭", function (r) {
                    if (r) {
                        $.post('${path}/routeclose/upRouteCloseState',
                                {isdel: 0, id: record.id},
                                function (result) {
                                    var result = eval('(' + result + ')');
                                    if (result.success) {
                                        $.messager.alert('消息提示', "关闭成功");
                                        $("#datagrid").datagrid("options").url = "${path}/routeclose/datagrid?" + $("#fmorder").serialize();
                                        $("#datagrid").datagrid("load");
                                    } else {
                                        $.messager.alert('错误提示', "关闭失败");
                                    }
                                });
                    }
                });

            } else {
                $.messager.alert('提示', '请先选中要关闭的行');
            }
        }

        function editConfig() {
            var row = $('#datagrid').datagrid('getSelected');
            if (row) {
                if (row.isdel == 0) {
                    $.messager.alert('错误提示', "通道已经禁用,不需要编辑！");
                    return;
                }
                $.post('${path}/routeclose/selectRouteClose',
                        {id: row.id},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                $("#oldbankId").val(result.obj.bankId);
                                $("#oldchannelId").val(result.obj.channelId);
                                $("#id").val(result.obj.id);
                                $("#dlgbankId").combobox("setValue", result.obj.bankId);
                                $("#dlgbankId").combobox("setText", result.obj.bankName);
                                $("#dlgchannelId").combobox("setValue", result.obj.channelId);
                                $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                                $("#dlgcardType").combobox("setValue", result.obj.cardType);
                                $("#dlgremark").val(result.obj.remark);
                                $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                            } else {
                                $.messager.alert('错误提示', "编辑失败");
                            }
                        });

            } else {
                $.messager.alert('提示', '请选择要编辑的记录！', 'error');
            }
        }

        function formatCardType(val, row) {
            if (val == 1) {
                return '<span>' + '借记卡' + '</span>';
            } else if (val == 2) {
                return '<span>' + '信用卡' + '</span>';
            }
            else if (val == 10) {
                return '<span>' + '全部' + '</span>';
            }
        }

        function formatOperate(val, row){
            return '<a class="editcls" onclick="editRow(\'' + row.id + '\')" href="javascript:void(0)">设置</a>';
        }

        function editRow(id) {
            $('#iframe1')[0].src = '${path}/routeclose/getTiming?id=' + id;
            $('#openRoleDiv').dialog('open');
        }

        function closeRoleDiv() {
            $('#openRoleDiv').dialog('close');
            $.messager.alert('消息提示', "定时设置成功");
            $("#datagrid").datagrid("options").url = "${path}/routeclose/datagrid?" + $("#fmorder").serialize();
            $("#datagrid").datagrid("load");
        }

        //添加Redis
        function addRedisConfig() {
            $('#addredis').linkbutton({disabled:true});
            $.post('${path}/routeclose/addredis?'+ $("#fmorder").serialize(),
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success==true) {
                            $.messager.alert('提示', result.msg);
                        }else{
                            $.messager.alert('提示', "更新失败");
                        }
                        $('#addredis').linkbutton({disabled:false});
                    });
        }


    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <!-- 错误信息列表 -->
    <table id="datagrid" title="渠道管理" class="easyui-datagrid" fit="true"
           url="${path}/routeclose/datagrid" toolbar="#toolbar" pagination="true"
           fitColumns="true" singleSelect="true" rownumbers="true"
           border="false" nowrap="false">
        <thead>
        <tr>
            <th field="id" width="80" hidden="true">id</th>
            <th field="bankId" width="80" hidden="true">bankId</th>
            <th field="channelId" width="80" hidden="true">channelId</th>
            <th field="bankName" width="100">银行</th>
            <th field="cardType" width="50" formatter="formatCardType">卡别</th>
            <th field="sourceSubChannel" width="100">来源子渠道</th>
            <th field="dealChannel" width="100">处理渠道</th>
            <th field="dealSubChannel" width="100">处理子渠道</th>
            <th field="orderAction" width="100">类型</th>
            <th field="isdel" width="80" formatter="formatIsdel">通道状态</th>
            <%--<th field="insertTime" width="150">创建时间</th>--%>
            <%--<th field="operateTime" width="150">修改时间</th>--%>
            <th field="remark" width="120">备注</th>
            <th field="openTime" width="60">开启时间</th>
            <th field="closeTime" width="60">关闭时间</th>
            <th field="repeatDate" width="80">重复日期</th>
            <th data-options="field:'opt',width:80" formatter="formatOperate">操作</th>

        </tr>
        </thead>
    </table>

    <!-- 按钮 -->

    <div id="toolbar" class="easyui-layout"
         style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <form id="fmorder" name="fmorder" method="post">
            <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
                <label>银行:</label> <input id="bankname" name="bankname" class="easyui-textbox"
                                          style="width: 120px">
                <label>处理渠道:</label> <input id="dealChannel" name="dealChannel"
                                            class="easyui-textbox" style="width: 120px">
                <label>处理子渠道:</label> <input id="dealSubChannel" name="dealSubChannel"
                                             class="easyui-textbox" style="width: 120px">
                <label>卡别:</label> <input id="cardType" name="cardType" class="easyui-combobox" style="width: 80px"
                                          data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
    data:[{id:'',text:'不限'},{id:'1',text:'借记卡'},{id:'2',text:'信用卡'},{id:'10',text:'全部'}]">
                <label>通道状态:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                          data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'1',text:'已启用'},{id:'0',text:'已关闭'}]">

                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
                <a href="javascript:void(0);" class="easyui-linkbutton"
                   iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
            </div>
        </form>
        <c:if test="${button.size()>0}">
            <div id="toolbar">
                <c:forEach var="button" items="${button}">
                    <c:if test="${button.menu_button == 'add'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-add" plain="true" onclick="addConfig();">添加</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'edit'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="editConfig();">编辑</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'delete'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="removeConfig();">关闭</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'recover'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton"
                           iconCls="icon-remove" plain="true" onclick="recoverConfig();">启用</a>
                    </c:if>
                    <c:if test="${button.menu_button == 'addredis'}">
                        <a href="javascript:void(0);" class="easyui-linkbutton" id="addredis"
                       iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新到Redis</a>
                    </c:if>

                </c:forEach>
            </div>
        </c:if>
    </div>


    <!-- 对话框 -->
    <div id="configdlg" class="easyui-dialog"
         style="width:300px;height:250px;padding:10px 20px" closed="true"
         buttons="#configdlg-buttons">
        <form id="configfm" method="post" novalidate>
            <table>
                <input id="id" name="id" type="hidden"></td>
                <input id="oldbankId" name="oldbankId" type="hidden"></td>
                <input id="oldchannelId" name="oldchannelId" type="hidden"></td>
                <tr>
                    <td align="right">*类别:</td>
                    <td><input id="dlgorderAction" name="orderAction" style="width: 150px" class="easyui-combobox"
                               data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'消费',text:'消费'},{id:'预授权',text:'预授权'},{id:'鉴权验证',text:'鉴权验证'}]" required="true"></td>
                </tr>
                <tr>
                    <td align="right">*银行:</td>
                    <td><input id="dlgbankId" name="bankId" style="width:150px" required="true"></td>
                </tr>
                <td align="right">卡别:</td>
                <td><input id="dlgcardType" name="cardType" class="easyui-combobox" style="width: 150px"
                           data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
    data:[{id:'1',text:'借记卡'},{id:'2',text:'信用卡'},{id:'10',text:'全部'}]" required="true">
                </td>
                <tr>
                    <td align="right">*处理子渠道:</td>
                    <td><input id="dlgchannelId" name="channelId" style="width:150px" required="true"></td>
                </tr>
                <tr>
                    <td align="right">备注:</td>
                    <td><input id="dlgremark" name="remark" type="text" class="easyui-validatebox"></td>
                </tr>

            </table>
        </form>
    </div>

    <div id="delreasondlg" class="easyui-dialog"
         style="width:300px;height:120px;padding:10px 20px" closed="true"
         buttons="#delreason-buttons">
        <tr>
            <td>*删除原因:</td>
            <td><input id="delReason" name="delReason" type="text"></td>
        </tr>
    </div>

    <!-- 对话框按钮 -->
    <div id="configdlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:60px">取消</a>
    </div>

    <!-- 对话框按钮 -->
    <div id="delreason-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="save()" style="width:60px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#delreasondlg').dialog('close')"
            style="width:60px">取消</a>
    </div>
</div>

<div id="openRoleDiv" class="easyui-dialog" closed="true" modal="false" title="定时设置"
         buttons="#buttons" style="width:480px;height:210px;">
    <iframe scrolling="auto" id='iframe1' frameborder="0"
            style="width:100%;height:100%;"></iframe>
</div>
</body>
</html>
