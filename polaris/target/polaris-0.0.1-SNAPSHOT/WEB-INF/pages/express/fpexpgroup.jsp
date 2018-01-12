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
        var loading;
        function show(checkid) {
            var s = '#check_' + checkid;
            /*选子节点*/
            var nodes = $("#test").treegrid("getChildren", checkid);
            for (i = 0; i < nodes.length; i++) {//当父节点被选中，则其孩子都被选中
                $(('#check_' + nodes[i].id))[0].checked = $(s)[0].checked;
            }
            //选上级节点
            if (!$(s)[0].checked) {     //如果子节点中有没有选中的，则父节点就不会被选中
                var parent = $("#test").treegrid("getParent", checkid);
                $(('#check_' + parent.id))[0].checked = false;
                while (parent) {
                    parent = $("#test").treegrid("getParent", parent.id);
                    $(('#check_' + parent.id))[0].checked = false;
                }
            } else {//如果子节点全部被选中，则父节点被选中
                var parent = $("#test").treegrid("getParent", checkid);
                var flag = true;
  /*              if (flag){
                    $(('#check_' + parent.id))[0].checked = true;//如果子节点中不存在没有选中的，则flag为true，父节点被选中
                }*/
            }
        }

        function formatcheckbox(val, row) {
            return "<input type='checkbox' onclick=show('" + row.id + "') id='check_" + row.id + "' />";
        }

        function save() {
            window.parent.linkDisable();
            var expid = $("#expressid").val();
            var idList = "";
            $("input:checked").each(function () {
                var id = $(this).attr("id");
                if (id.indexOf('check_type') == -1 && id.indexOf("check_") > -1)
                    idList += id.replace("check_", '') + ',';
            });
            if (idList != "") {
                $.post('${path}/express/dealfpexpuser',
                        {ids: idList, id: expid},
                        function (result) {
                            var result = eval('(' + result + ')');
                            if (result.success) {
                                parent.$.messager.alert('消息提示',  result.msg,'info');
                                parent.$('#openRoleDiv').window('close');
                            } else {
                                $.messager.alert('错误提示', result.msg,'error');
                            }
                            window.parent.linkShow();
                        });
            } else {
                window.parent.linkShow();
                $.messager.alert('提示', "请选择要分配的快递员！",'warning');
            }
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
    <input id="expressid" name="expressid" type="hidden" value="${express.id}"></td>
    <body>
    <input id="successful" name="successful" type="hidden"></td>
    <table id="test" class="easyui-treegrid" style="width:400px;height:500px"
           fit="true" toolbar="#toolbar" fitColumns="false" data-options="
        url: '${path}/express/selectexpuser',
        method: 'post',
        rownumbers: true,
        idField: 'id',
        treeField: 'name'
      ">
        <thead>
        <tr>
            <th data-options="field:'name'" width="180">货运组名称/快递员</th>
            <th data-options="field:'size'" width="60" align="center" formatter="formatcheckbox">订单分配</th>
        </tr>
        </thead>
    </table>
    </body>

</div>

</body>
</html>
