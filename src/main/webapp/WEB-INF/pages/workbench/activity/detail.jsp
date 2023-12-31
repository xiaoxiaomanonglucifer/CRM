<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
//动态获取路径
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {

            $("#saveRemarkBtn").click(function () {
                var noteContent = $.trim($("#remark").val());
                var activityId = '${activity.id}';
                if (noteContent == "") {
                    alert("备注内容不能为空~");
                    return;
                }
                $.ajax({
                    url: 'workbench/activity/saveCreateActivityRemark',
                    data: {
                        noteContent: noteContent,
                        activityId: activityId
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#remark").val("");
                            //刷新列表
                            var htmlStr = "";
                            htmlStr += "  <div class=\"remarkDiv\" id=\"div_" + resp.retData.id + "\" style=\"height: 60px;\">\n" +
                                "            <img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">\n" +
                                "            <div style=\"position: relative; top: -40px; left: 40px;\">\n" +
                                "                <h5>" + resp.retData.noteContent + "</h5>\n" +
                                "                <!--显示创建时间或者修改时间，进行判断jstl库里面的cif  没有else所以写两个cif判断-->\n" +
                                "                    <%--<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small style=\"color: gray;\"><c:if test=\"${remark.editFlag=='1'}\">${remark.editTime}</c:if><c:if test=\"${remark.editFlag!='1'}\">${remark.createTime}</c:if> 由zhangsan</small>--%>\n" +
                                "                    <%--或者el表达式的三木运算符 但必须是作用域里面的数据--%>\n" +
                                "                <font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small\n" +
                                "                    style=\"color: gray;\">" + resp.retData.createTime + " 由${sessionScope.sessionUser.name}创建</small>\n" +
                                "                <div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">\n" +
                                "                    <a class=\"myHref\" name=\"editA\" href=\"javascript:void(0);\" remarkId=\"" + resp.retData.id + "\"><span class=\"glyphicon glyphicon-edit\"\n" +
                                "                                                                       style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                "                    &nbsp;&nbsp;&nbsp;&nbsp;\n" +
                                "                    <a class=\"myHref\" name=\"deleteA\" href=\"javascript:void(0);\" remarkId=\"" + resp.retData.id + "\"><span class=\"glyphicon glyphicon-remove\"\n" +
                                "                                                                       style=\"font-size: 20px; color: #E6E6E6;\"></span></a>\n" +
                                "                </div>\n" +
                                "            </div>\n" +
                                "        </div>"
                            $("#remarkDiv").before(htmlStr);
                        } else {
                            alert(resp.message);
                        }
                    }
                });
            });
            // 给所有的"删除"图标添加单击事件   如果删除按钮用id的话，那么每一个备注的删除按钮的id都是重复的
            $("#remarkDivList").on("click", "a[name='deleteA']", function () {
                var id = $(this).attr("remarkId");//获取自定义标签的值
                $.ajax({
                    url: 'workbench/activity/deleteActivityRemark',
                    type: 'POST',
                    data: {
                        id: id
                    },
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            alert("删除成功~");
                            $("#div_" + id).remove(); // remove()会从dom树中删除匹配元素
                        } else {
                            alert(resp.message);
                        }

                    }
                });

            });

            $("#remarkDivList").on("click","a[name='editA']",function () {//第二个参数是选择器的意思 a标签,
                var id = $(this).attr("remarkId"); // 通过自定义标签获取
                var noteContent = $("#div_"+id+" h5").text();
                $("#edit-id").val(id);//将id传到模态窗口中
                $("#edit-noteContent").val(noteContent); // 写入备注的内容
                $("#editRemarkModal").modal("show");
            });
            // $("#a[name='editA']").click(function () {
            //     var id = $(this).attr("remarkId"); // 通过自定义标签获取
            //     var noteContent = $("#div_"+id+" h5").text();
            //     $("#edit-id").val(id);//将id传到模态窗口中
            //     $("#edit-noteContent").val(noteContent); // 写入备注的内容
            //     $("#editRemarkModal").modal("show");
            // })

            $("#updateRemarkBtn").click(function () {
                var id = $("#edit-id").val(); // 修改备注的模态窗口的备注id
                var noteContent = $.trim($("#edit-noteContent").val()); // 修改备注的模态窗口的备注内容
                //表单验证
                if (noteContent == "") {
                    alert("备注内容不能为空");
                    return;
                }
                $.ajax({
                    url: 'workbench/activity/updateActivityRemarkById',
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            alert("修改成功~")
                            $("#editRemarkModal").modal("hide");
                            $("#div_"+resp.retData.id+" h5").text(resp.retData.noteContent); // 备注前端显示修改后的数据
                            $("#div_"+resp.retData.id+" small").text(" "+resp.retData.editTime+" 由${sessionScope.sessionUser.name}修改");

                        } else {
                            alert(resp.message);
                            $("#editRemarkModal").modal("show");
                        }
                    }
                });
            });

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            // $(".remarkDiv").mouseover(function () {
            //     $(this).children("div").children("div").show();
            // });

            $("#remarkDivList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            // $(".remarkDiv").mouseout(function () {
            //     $(this).children("div").children("div").hide();
            // });
            $("#remarkDivList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            // $(".myHref").mouseover(function () {
            //     $(this).children("span").css("color", "red");
            // });

            $("#remarkDivList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });
            // $(".myHref").mouseout(function () {
            //     $(this).children("span").css("color", "#E6E6E6");
            // });

            $("#remarkDivList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });
        });

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden " id="edit-id">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${activity.name}<small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${activity.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${activity.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                <%--					市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等--%>
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${activityRemarkList}" var="remark">
        <div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">市场活动</font> <font color="gray ">-</font> <b>${activity.name}</b> <small
                    style="color: gray;">${remark.editFlag=='1'?remark.editTime:remark.createTime}由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="editA" id="editA" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteA" id="deleteA" remarkId="${remark.id}"
                       href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                        style="xfont-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>
    <!-- 备注1 -->
    <%--		<div class="remarkDiv" style="height: 60px;">--%>
    <%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
    <%--				<h5>哎呦！</h5>--%>
    <%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
    <%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--				</div>--%>
    <%--			</div>--%>
    <%--		</div>--%>
    <%--		--%>
    <%--		<!-- 备注2 -->--%>
    <%--		<div class="remarkDiv" style="height: 60px;">--%>
    <%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
    <%--				<h5>呵呵！</h5>--%>
    <%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
    <%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--				</div>--%>
    <%--			</div>--%>
    <%--		</div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>