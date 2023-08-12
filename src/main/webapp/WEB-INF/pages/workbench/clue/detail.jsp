<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            })

            // $(".myHref").mouseover(function () {
            //     $(this).children("span").css("color", "red");
            // });
            $("#remarkDivList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            })
            //
            // $(".myHref").mouseout(function () {
            //     $(this).children("span").css("color", "#E6E6E6");
            // });
            //

            $("#remarkDivList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            $("#saveClueRemarkBtn").click(function () {
                var noteContent = $.trim($("#remark").val());
                var clueId = '${clue.id}';
                if (noteContent == "") {
                    alert("请输入内容~");
                    return;
                }
                $.ajax({
                    url: 'workbench/clue/saveClueRemark',
                    data: {
                        clueId: clueId,
                        noteContent: noteContent
                    },
                    dataType: 'JSON',
                    type: 'POST',
                    success: function (resp) {
                        console.log(resp.retData.noteContent)
                        if (resp.code == "1") {
                            $("#remark").val("");
                            var htmlStr = "";
                            htmlStr += '<div class="remarkDiv" style="height: 60px;" id="div_"+' + resp.retData.id + '>\n' +
                                '        <img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">\n' +
                                '        <div style="position: relative; top: -40px; left: 40px;">\n' +
                                '            <h5>' + resp.retData.noteContent + '</h5>\n' +
                                '            <font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}}</b> <small style="color: gray;">\n' +
                                '            ' + resp.retData.createTime + ' 由${sessionScope.sessionUser.name}创建</small>\n' +
                                '            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">\n' +
                                '                <a class="myHref" name="editA" href="javascript:void(0);"  remarkId=' + resp.retData.id + '><span class="glyphicon glyphicon-edit"\n' +
                                '                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>\n' +
                                '                &nbsp;&nbsp;&nbsp;&nbsp;\n' +
                                '                <a class="myHref" name="deleteA" href="javascript:void(0);" remarkId=' + resp.retData.id + '><span class="glyphicon glyphicon-remove"\n' +
                                '                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>\n' +
                                '            </div>\n' +
                                '        </div>\n' +
                                '    </div>';
                            $("#remarkDiv").before(htmlStr);
                        } else {
                            alert(resp.message);
                        }
                    }
                });
            });

            $("#remarkDivList").on("click", "a[name='editA']", function () {
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_" + id + " h5").text();
                $("#edit-id").val(id);
                $("#edit-noteContent").val(noteContent);
                $("#editClueRemarkModal").modal("show");
            });

            $("#remarkDivList").on("click", "a[name='deleteA']", function () {
                var id = $(this).attr("remarkId");
                $.ajax({
                    url: 'workbench/clue/deleteClueRemarkById',
                    data: {
                        id: id
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            alert("删除成功~");
                            $("#div_" + id).remove(); // remove()会从dom树中删除匹配元素
                        } else {
                            alert(resp.message);
                        }
                    }
                })

            })

            $("#updateClueRemarkBtn").click(function () {
                var noteContent = $.trim($("#edit-noteContent").val());
                var id = $("#edit-id").val();
                if (noteContent == "") {
                    alert("内容不能为空~");
                    return;
                }
                $.ajax({
                    url: 'workbench/clue/updateClueRemarkById',
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            alert("修改成功~")
                            $("#editClueRemarkModal").modal("hide");
                            $("#div_" + resp.retData.id + " h5").text(resp.retData.noteContent);
                            $("#div_" + resp.retData.id + " small").text(" " + resp.retData.editTime + "由${sessionScope.sessionUser.name}修改")
                        } else {
                            alert(resp.message);
                            $("#editClueRemarkModal").modal("show");
                        }

                    }
                })


            });

            $("#addActivityHref").click(function () {//关联完毕后要及时刷新
                $("#searchActivityText").val("");
                $("#tBody").html(""); // 清空之前显示的数据
                $("#checkAll").prop("checked", false); // 将全选按钮取消选中
                $("#bundModal").modal("show");
            });


            //给搜索框添加键盘弹起事件
            $("#searchActivityText").keyup(function () {
                queryActivityForDetailByNameAndClueId();

            });
            $("#checkAll").click(function () {
                if (this.checked) {
                    $("#tBody input[type='checkbox']").prop("checked", true);
                } else {
                    $("#tBody input[type='checkbox']").prop("checked", false);
                }
            });
            $("#tBody").on("click", function () {
                if ($("#tBody input[type='checkbox']:checked").size() == $("#tBody input[type='checkbox']").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });
//关联
            $("#relateBtn").click(function () {
                var activityIds = $("#tBody input[type='checkbox']:checked");
                if (activityIds.size() == 0) {
                    alert("请选择相关的市场活动~");
                    return;
                }
                var clueId = '${clue.id}';
                var id = "";
                $.each(activityIds, function () {
                    id += "activityId=" + this.value + "&";
                });
                id += "clueId=" + clueId;
                $.ajax({
                    url: 'workbench/clue/saveBound',
                    data: id,//形参的名字是activityId 这里的id=activityId=xxxx&activityId=xxxx....
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#bundModal").modal("hide");
                            var htmlStr = "";
                            $.each(resp.retData, function (i, e) {
                                htmlStr += '                      <tr id="tr_"+' + e.id + '>\n' +
                                    '                                    <td>' + e.name + '</td>\n' +
                                    '                                    <td>' + e.startDate + '</td>\n' +
                                    '                                    <td>' + e.endDate + '</td>\n' +
                                    '                                    <td>' + e.owner + '</td>\n' +
                                    '                                    <td><a href="javascript:void(0);" style="text-decoration: none;" activityId=' + e.id + '><span\n' +
                                    '                                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>\n' +
                                    '                                </tr>';

                            });
                            $("#actTbody").append(htmlStr);
                        } else {
                            alert(resp.message);
                            $("#boundModal").modal("show");
                        }
                    }
                });

            });

            //动态解除关联
            $("#actTbody").on("click", "a", function () {//如果不止一个a标签那么可以再加一个name属性 则"a"--->"a[name='']"
                var activityId = $(this).attr("activityId");
                var clueId = '${clue.id}';
                if (window.confirm("确定解除关联吗~")) {
                    $.ajax({
                        url: 'workbench/clue/deleteBound',
                        type: 'POST',
                        dataType: 'JSON',
                        data: {
                            activityId: activityId,
                            clueId: clueId
                        },
                        success: function (resp) {
                            if (resp.code == "1") {
                                $("#tr_" + activityId).remove();
                            } else {
                                alert(resp.message)
                            }

                        }
                    })
                }
            })

            //回车Bug
            $("#searchActivityText").keydown(function (e) {
                if (e.keyCode == 13) {
                    queryActivityForDetailByNameAndClueId();
                }
            });
        });

        function queryActivityForDetailByNameAndClueId() {
            var activityName = $("#searchActivityText").val();
            var clueId = '${clue.id}';
            $.ajax({
                url: 'workbench/clue/queryActivityForDetailByNameAndClueId',
                data: {
                    activityName: activityName,
                    clueId: clueId
                },
                type: 'POST',
                dataType: 'JSON',
                success: function (resp) {
                    // console.log(resp)
                    var htmlStr = "";
                    $.each(resp, function (i, e) {
                        console.log((e.id))
                        htmlStr += '                          <tr>\n' +
                            '                                            <td><input  type="checkbox" value=' + e.id + ' /></td>\n' +
                            '                                            <td>' + e.name + '</td>\n' +
                            '                                            <td>' + e.startDate + '</td>\n' +
                            '                                            <td>' + e.endDate + '</td>\n' +
                            '                                            <td>' + e.owner + '</td>\n' +
                            '                                        </tr>'
                    });
                    $("#tBody").html(htmlStr);
                }
            });
        }
    </script>

</head>
<body>
<!-- 修改线索活动备注的模态窗口 -->
<div class="modal fade" id="editClueRemarkModal" role="dialog">
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
                <button type="button" class="btn btn-primary" id="updateClueRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" id="searchActivityText"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="checkAll"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="tBody">
                    <%--                                        <tr>--%>
                    <%--                                            <td><input type="checkbox"/></td>--%>
                    <%--                                            <td>发传单</td>--%>
                    <%--                                            <td>2020-10-10</td>--%>
                    <%--                                            <td>2020-10-20</td>--%>
                    <%--                                            <td>zhangsan</td>--%>
                    <%--                                        </tr>--%>
                    <%--                    <tr>--%>
                    <%--                        <td><input type="checkbox"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="relateBtn">关联</button>
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
        <h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='convert.html';"><span
                class="glyphicon glyphicon-retweet"></span> 转换
        </button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;">
            <b>${clue.fullname}${clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${clueRemarkList}" var="remark">
        <div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}</b>
                <small style="color: gray;">${remark.editFlag=='1'?remark.editTime:remark.createTime}由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>
    <!-- 备注1 -->
    <%--    <div class="remarkDiv" style="height: 60px;">--%>
    <%--        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--        <div style="position: relative; top: -40px; left: 40px;">--%>
    <%--            <h5>哎呦！</h5>--%>
    <%--            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;">--%>
    <%--            2017-01-22 10:10:10 由zhangsan</small>--%>
    <%--            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"--%>
    <%--                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--                &nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"--%>
    <%--                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--            </div>--%>
    <%--        </div>--%>
    <%--    </div>--%>

    <%--    <!-- 备注2 -->--%>
    <%--    <div class="remarkDiv" style="height: 60px;">--%>
    <%--        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--        <div style="position: relative; top: -40px; left: 40px;">--%>
    <%--            <h5>呵呵！</h5>--%>
    <%--            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;">--%>
    <%--            2017-01-22 10:20:10 由zhangsan</small>--%>
    <%--            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"--%>
    <%--                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--                &nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"--%>
    <%--                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--            </div>--%>
    <%--        </div>--%>
    <%--    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveClueRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="actTbody">

                <c:forEach items="${activityList}" var="activity">
                    <tr id="tr_${activity.id}">
                        <td>${activity.name}</td>
                        <td>${activity.startDate}</td>
                        <td>${activity.endDate}</td>
                        <td>${activity.owner}</td>
                        <td><a href="javascript:void(0);" activityId="${activity.id}"
                               style="text-decoration: none;"><span
                                class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                    </tr>
                </c:forEach>
                <%--                                <tr>--%>
                <%--                                    <td>发传单</td>--%>
                <%--                                    <td>2020-10-10</td>--%>
                <%--                                    <td>2020-10-20</td>--%>
                <%--                                    <td>zhangsan</td>--%>
                <%--                                    <td><a href="javascript:void(0);" style="text-decoration: none;"><span--%>
                <%--                                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--                                </tr>--%>
                <%--                <tr>--%>
                <%--                    <td>发传单</td>--%>
                <%--                    <td>2020-10-10</td>--%>
                <%--                    <td>2020-10-20</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td><a href="javascript:void(0);" style="text-decoration: none;"><span--%>
                <%--                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="addActivityHref"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>