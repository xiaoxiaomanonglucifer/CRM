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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $(".date").datetimepicker({
                language: 'zh-CN',//语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month',//可以选择的最小视图
                initialDate: new Date(),//初始化选择的日期
                autoclose: true,//设置选择完日期或者时间后是否自动关闭日历
                todayBtn: true,
                clearBtn: true//设置是否显示清空按钮
            });

            $("#saveRemarkBtn").click(function () {
                var noteContent = $("#remark").val();
                var contactsId = '${contacts.id}';
                $.ajax({
                    url: 'workbench/contacts/saveRemark',
                    data: {
                        noteContent: noteContent,
                        contactsId: contactsId
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#remark").val("");
                            var htmlStr = "";
                            htmlStr += ' <div id="div_"+' + resp.retData.id + '  class="remarkDiv" style="height: 60px;">\n' +
                                '        <img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">\n' +
                                '        <div style="position: relative; top: -40px; left: 40px;">\n' +
                                '            <h5>' + resp.retData.noteContent + '</h5>\n' +
                                '            <font color="gray">联系人</font> <font color="gray">-</font> <b>${contacts.fullname}${contacts.appellation}-${contacts.customerId}</b> <small style="color: gray;">\n' +
                                '            ' + resp.retData.createTime + ' 由${sessionScope.sessionUser.name}创建</small>\n' +
                                '            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">\n' +
                                '                <a class="myHref" href="javascript:void(0);" name="editA"  remarkId=' + resp.retData.id + '><span class="glyphicon glyphicon-edit"\n' +
                                '                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>\n' +
                                '                &nbsp;&nbsp;&nbsp;&nbsp;\n' +
                                '                <a class="myHref" href="javascript:void(0);"name="deleteA"  remarkId=' + resp.retData.id + '><span class="glyphicon glyphicon-remove"\n' +
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
//修改 备注弹窗
            $("#remarkDivList").on("click", "a[name='editA']", function () {
                var id = $(this).attr("remarkId");
                var noteContent = $("#div_" + id + " h5").text();
                $("#edit-id").val(id);
                $("#edit-noteContent").val(noteContent);
                $("#editRemarkModal").modal("show");
            });
//修改
            $("#updateRemarkBtn").click(function () {

                var id = $("#edit-id").val();
                var noteContent = $.trim($("#edit-noteContent").val());
                if (noteContent == "") {
                    alert("备注不能weikong~");
                }
                $.ajax({
                    url: 'workbench/contacts/updateRemark',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#editRemarkModal").modal("hide");
                            $("#div_" + resp.retData.id + " h5").text(resp.retData.noteContent);
                            $("#div_" + resp.retData.id + " small").text(" " + resp.retData.editTime + "由${sessionScope.sessionUser.name}修改")
                        } else {
                            alert(resp.message);
                        }
                    }
                })
            });
//删除
            $("#remarkDivList").on("click", "a[name='deleteA']", function () {
                var id = $(this).attr("remarkId");
                $.ajax({
                    url: 'workbench/contacts/deleteRemarkById',
                    data: {
                        id: id
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#div_" + id).remove();

                        } else {
                            alert(resp.message);
                        }
                    }

                });
            });

            //删除交易
            $("#tranBody").on("click", "a", function () {
                var tranId = $(this).attr("tranId");
                var id = "id=" + tranId;
                if (window.confirm("你确定要删除吗~")) {
                    $.ajax({
                        url: 'workbench/transaction/deleteTranByIds',
                        type: 'POST',
                        dataType: 'JSON',
                        data: id,
                        success: function (resp) {
                            if (resp.code == "1") {
                                $("#tr_" + tranId).remove();
                            } else {
                                alert(resp.message);
                            }
                        }
                    });
                }
            });
            //解除关联
            $("#activityBody").on("click", "a", function () {
                var activityId = $(this).attr("activityId");
                var contactsId = '${contacts.id}';
                if (window.confirm("确定解除关联吗~")) {
                    $.ajax({
                        url: 'workbench/contacts/deleteBound',
                        type: 'POST',
                        dataType: 'JSON',
                        data: {
                            activityId: activityId,
                            contactsId: contactsId
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

            $("#remarkDivList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });
            $("#remarkDivList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });
            $("#remarkDivList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });
            $("#remarkDivList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });
            //关联
            $("#releteBtn").click(function () {
                $("#checkAll").prop("checked", false);
                $("#searchTxt").val("");
                $("#bundActivityModal").modal("show");
            });
            $("#searchTxt").keyup(function () {
                var activityName = $("#searchTxt").val();
                var contactsId = '${contacts.id}';
                $.ajax({
                    url: 'workbench/activity/queryActivityByActivityNameAndContactsId',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        activityName: activityName,
                        contactsId: contactsId
                    },
                    success: function (resp) {
                        var htmlStr = "";
                        $.each(resp, function (i, e) {
                            htmlStr += ' <tr>\n' +
                                '                        <td><input type="checkbox" value="' + e.id + '"/></td>\n' +
                                '                        <td>' + e.name + '</td>\n' +
                                '                        <td>' + e.startDate + '</td>\n' +
                                '                        <td>' + e.endDate + '</td>\n' +
                                '                        <td>' + e.owner + '</td>\n' +
                                '                    </tr>';
                        });
                        $("#actBody").html(htmlStr);
                    }
                })

            });
            //给选择绑定事件
            $("#checkAll").click(function () {
                if (this.checked) {
                    $("#actBody input[type='checkbox']").prop("checked", true);
                } else {
                    $("#actBody input[type='checkbox']").prop("checked", false);
                }
            });
            $("#actBody input[type='checkbox']").on("click", function () {
                if ($("#actBody input[type='checkbox']:checked").size() == $("#actBody input[type='checkbox']").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }

            });

            //获取id
            $("#relBtn").click(function () {
                var activityIds = $("#actBody input[type='checkbox']:checked");
                var contactsId = '${contacts.id}';
                if (activityIds.size() == 0) {
                    alert("请选择相关的市场活动~");
                    return;
                }
                var id = "";
                $.each(activityIds, function () {
                    id += "activityId=" + this.value + "&";
                });
                id = id + "contactsId=" + contactsId;
                $.ajax({
                    url: 'workbench/contacts/saveBound',
                    dataType: 'JSON',
                    type: 'POST',
                    data: id,
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#bundActivityModal").modal("hide");
                            var htmlStr = "";
                            $.each(resp.retData, function (i, e) {
                                htmlStr += '                                    <tr>\n' +
                                    '                                                    <td><a href="workbench/activity/toDetailIndex?id="+' + e.id + ' style="text-decoration: none;">'+e.name+'</a></td>\n' +
                                    '                                                    <td>' + e.startDate + '</td>\n' +
                                    '                                                    <td>' + e.endDate + '</td>\n' +
                                    '                                                    <td>' + e.owner + '</td>\n' +
                                    '                                                    <td><a href="javascript:void(0);" activityId=' + e.id + '\n' +
                                    '                                                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>\n' +
                                    '                                                </tr>';

                            });
                            $("#activityBody").append(htmlStr);
                        } else {
                            alert(resp.message);
                            $("#bundActivityModal").modal("show");
                        }
                    }
                });
            });

            $("#editBtn").click(function () {
                var id='${contacts.id}';
                $("#editContactsModal").modal("show");
                $("#edit_id").val(id);
            });
            //更新客户信息
            $("#updateBtn").click(function () {
                var id=$("#edit_id").val();
                //获取参数
                var owner = $("#edit-contactsOwner").val();
                var source = $("#edit-clueSource").val();
                var fullname = $.trim($("#edit-surname").val());
                var appellation = $("#edit-call").val();
                var job = $("#edit-job").val();
                var mphone = $("#edit-mphone").val();
                var email = $("#edit-email").val();
                var customerId = $("#edit-customerName").val();
                var description = $("#edit-describe").val();
                var contactSummary = $("#edit-contactSummary").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $("#edit-address").val();
                $.ajax({
                    url: 'workbench/contacts/updateContacts',
                    dataType: 'JSON',
                    type: 'POST',
                    data: {
                        id:id,
                        owner:owner,
                        source:source,
                        fullname:fullname,
                        appellation:appellation,
                        job:job,
                        mphone:mphone,
                        email:email,
                        customerId:customerId,
                        description:description,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        address:address
                    },
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#editContactsModal").modal("hide");
                            window.location.href = 'workbench/contacts/toConDetailIndex?id=' + '${contacts.id}';
                        } else {
                            alert(resp.message);
                        }
                    }
                });
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
                <h4 class="modal-title">修改备注</h4>
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
<!-- 解除联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="unbundActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">解除关联</h4>
            </div>
            <div class="modal-body">
                <p>您确定要解除该关联关系吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
            </div>
        </div>
    </div>
</div>

<!-- 联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="bundActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询" id="searchTxt">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable2" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
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
                    <tbody id="actBody">

                    <%--                    <tr>--%>
                    <%--                        <td><input type="checkbox"/></td>--%>
                    <%--                        <td>发传单</td>--%>
                    <%--                        <td>2020-10-10</td>--%>
                    <%--                        <td>2020-10-20</td>--%>
                    <%--                        <td>zhangsan</td>--%>
                    <%--                    </tr>--%>
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
                <button type="button" id="relBtn">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改联系人</h4>
            </div>
            <div class="modal-body">
                <input type="hidden" id="edit_id">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-contactsOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueSource">
                                <option selected="selected">${contacts.source}</option>
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="${contacts.fullname}">
                        </div>
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option selected="selected">${contacts.appellation}</option>
                                <option></option>
                                <c:forEach items="${appellation}" var="appe">
                                    <option value="${appe.id}">${appe.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="${contacts.job}">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="${contacts.mphone}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="${contacts.email}">
                        </div>
                        <label for="edit-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-birth">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" value="${contacts.customerId}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3"
                                      id="edit-describe">${contacts.description}</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3"
                                          id="edit-contactSummary">${contacts.contactSummary}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control date" id="edit-nextContactTime" readonly
                                       value="${contacts.nextContactTime}">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1"
                                          id="edit-address">${contacts.address}</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" id="updateBtn">更新</button>
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
        <h3>${contacts.fullname}${contacts.appellation} <small> - ${contacts.customerId}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;">
            <b>${contacts.fullname}${contacts.appellation}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.job}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${contacts.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${contacts.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${contacts.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${contacts.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${contacts.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${contacts.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${contacts.nextContactTime}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${contacts.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>
<!-- 备注 -->
<div style="position: relative; top: 20px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>
    <c:forEach items="${contactsRemarks}" var="remark">
        <div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
            <img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png"
                 style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">联系人</font> <font color="gray">-</font>
                <b>${contacts.fullname}${contacts.appellation}</b> <small
                    style="color: gray;"> ${remark.editFlag=="1"?remark.editTime:remark.createTime}
                由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
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

<!-- 交易 -->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>交易</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable3" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>金额</td>
                    <td>阶段</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>类型</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="tranBody">
                <%--                <tr>--%>
                <%--                    <td><a href="../transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>--%>
                <%--                    <td>5,000</td>--%>
                <%--                    <td>谈判/复审</td>--%>
                <%--                    <td>90</td>--%>
                <%--                    <td>2017-02-07</td>--%>
                <%--                    <td>新业务</td>--%>
                <%--                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal"--%>
                <%--                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
                <%--                </tr>--%>
                <c:forEach items="${tranList}" var="tran">
                    <tr id="tr_${tran.id}">
                        <td><a href="workbench/transaction/toDetailIndex?id=${tran.id}"
                               style="text-decoration: none;">${tran.name}</a></td>
                        <td>${tran.money}</td>
                        <td>${tran.stage}</td>
                        <td>${tran.possibility}</td>
                        <td>${tran.expectedDate}</td>
                        <td>${tran.type}</td>
                        <td><a href="javascript:void(0);" tranId="${tran.id}"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="workbench/transaction/toSaveIndex" style="text-decoration: none;" id="createTran"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--                                                <tr>--%>
                <%--                                                    <td><a href="../activity/detail.jsp" style="text-decoration: none;">发传单</a></td>--%>
                <%--                                                    <td>2020-10-10</td>--%>
                <%--                                                    <td>2020-10-20</td>--%>
                <%--                                                    <td>zhangsan</td>--%>
                <%--                                                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal"--%>
                <%--                                                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--                                                </tr>--%>
                <c:forEach items="${activityList}" var="activity">
                    <tr id="tr_${activity.id}">
                        <td><a href="workbench/activity/toDetailIndex?id=${activity.id}"
                               style="text-decoration: none;">${activity.name}</a></td>
                        <td>${activity.startDate}</td>
                        <td>${activity.endDate}</td>
                        <td>${activity.owner}</td>
                        <td><a href="javascript:void(0);" activityId="${activity.id}"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="releteBtn"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>