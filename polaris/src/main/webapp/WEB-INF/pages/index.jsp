<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
    <title>北极星订单管理系统</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <link href="${path}/css/default.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src='${path}/js/outlook.js'></script>
    <script type="text/javascript">

        function addTab(bankName, bankId, isdel, orderAction) {
//            if (isdel == 1) {
//                $.messager.alert('错误提示', "数据已经禁用,不需要编辑！");
//                return;
//            }
            var src = path + '/routestrategy/list?bankId=' + bankId + '&orderAction=' + orderAction;
            var tabs = $('#mainTabs');
            var opts = {
                title: bankName,
                closable: true,
                iconCls: "icon-sh",
                content: $.formatString('<iframe src="{0}" allowTransparency="true" style="border:0;width:100%;height:99%;" frameBorder="0"></iframe>', src),
                border: false,
                fit: true
            };
            if (tabs.tabs('exists', opts.title)) {
                tabs.tabs('select', opts.title);
            } else {
                tabs.tabs('add', opts);
            }
        }

        function alertPsw() {
            $('#configfm').form('clear');
            $('#account').val("<%=request.getSession().getAttribute("user") %>");
            $('#configdlg').dialog('open').dialog('setTitle', '修改密码');
            mesTitle = '修改密码成功';
        }

        function save() {
            if ($('#password').val().replace(/(^\s*)|(\s*$)/, "") == "") {
                $.messager.alert('提示', '旧密码不能为空！');
                return;
            }
            if ($('#newpassword').val().replace(/(^\s*)|(\s*$)/, "") == "") {
                $.messager.alert('提示', '新密码不能为空！');
                return;
            }

            if($('#newpassword').val().length < 6){
                $.messager.alert('提示', '密码长度必须大于6位！');
                return;
            }
            if ($('#cpassword').val().replace(/(^\s*)|(\s*$)/, "") == "") {
                $.messager.alert('提示', '确认密码不能为空！');
                return;
            }

            if ($('#newpassword').val() != $('#cpassword').val()) {
                $.messager.alert('提示', '新密码和确认密码不一致！');
                return;
            }

            //var record = $("#datagrid").datagrid('getSelected');
            $.post('${path}/user/uppsw',
                    {
                        account: $('#account').val(),
                        password: $('#password').val(),
                        newpassword: $('#newpassword').val()
                    },
                    function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                            $('#configdlg').dialog('close');
                            $.messager.alert('消息提示', result.msg);
                        } else {
                            mesTitle = '修改失败';
                            $.messager.alert('消息提示', result.msg);
                        }
        /*                $.messager.show({
                            title: mesTitle,
                            msg: result.msg
                        });*/
                    });
        }


    </script>

</head>
<body class="easyui-layout">
<!-- 正上方panel -->
<%--<div region="north" style="height:65px;padding:8px;">--%>
<div data-options="region:'north',border:false"
     style="height:65px;background:#1B8BCB url(${ctx}/images/images/top_bg.jpg) no-repeat center;padding:10px">
    <h2>
        <span style="font-size:17px;color:#ffffff">
            北极星订单管理系统V1.0
            </span>
        <span style="float: right;font-size:12px;">
            <a class="editcls" style="font-size: 12px;color: White; text-decoration: underline;"
               href="javascript:alertPsw();">修改密码</a>
            <a>&nbsp;&nbsp;&nbsp;&nbsp;</a>
            <a class="editcls" style="font-size: 12px;color: White; text-decoration: underline;" href="${path}/exit">安全退出</a>
            </span>
    </h2>
</div>

<!-- 左侧菜单 -->
<div data-options="region:'west',href:''" hide="true" split="true" title="菜单" style="width: 200px; padding: 10px;">
    <div id='wnav' class="easyui-accordion" fit="true" border="false">
    </div>
    <%--<ul id="mainMenu"></ul>--%>
    <%--</div>--%>
</div>

<!-- 正中间panel -->
<div region="center" title="">
    <div class="easyui-tabs" id="mainTabs" fit="true" border="false">
        <div title="欢迎页" style="padding:20px;overflow:hidden;margin-top:20px;">
<span style="float:center;font-size:18px;color: #0052A3">
你好<%=request.getSession().getAttribute("user") %>，欢迎来到北极星订单管理系统
</span>
        </div>
    </div>
</div>


<!-- 正下方panel -->
<%--<div region="south" style="height:20px;" align="left" >--%>
<div data-options="region:'south',border:'false'"
     style="height:40px;background:#e2e2e2;padding:10px; line-height:20px; vertical-align:middle; text-align:center;">
    <span style="float:center;font-size:14px;color: #0052A3">Copyright 安徽北极星信息科技有限公司版权所有</span>
</div>


<div id="configdlg" class="easyui-dialog"
     style="width:310px;height:200px;padding:10px 20px" closed="true"
     buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
        <table>
            <input id="account" name="account" type="hidden">
            <tr>
                <td align="right">*旧密码:</td>
                <td><input id="password" name="password" style="width: 150px" class="easyui-validatebox"
                           type="password" required="true"></td>
            </tr>
            <tr>
                <td align="right">*新密码:</td>
                <td><input id="newpassword" name="newpassword" style="width: 150px" class="easyui-validatebox"
                           type="password" required="true"></td>
            </tr>
            <tr>
                <td align="right">*确认新密码:</td>
                <td><input id="cpassword" name="cpassword" style="width: 150px" class="easyui-validatebox"
                           type="password" required="true"></td>
            </tr>
        </table>
    </form>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton c6"
           iconCls="icon-ok" onclick="save()" style="width:90px">保存</a> <a
            href="javascript:void(0)" class="easyui-linkbutton"
            iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
            style="width:90px">取消</a>
    </div>
</div>

</body>
</html>
