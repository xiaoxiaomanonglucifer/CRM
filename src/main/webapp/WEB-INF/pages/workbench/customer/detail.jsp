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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $(".date").datetimepicker({
                language: 'zh-CN', // 语言设为中文
                format: 'yyyy-mm-dd', // 日期格式
                minView: 'month', // 可以选择的最小视图
                initialDate: new Date(), // 初始化显示的日期
                autoclose: true, // 选择完日期后是否自动关闭
                todayBtn: true, // 显示‘今天’按钮
                clearBtn: true // 清空按钮
            });
            //展示原数据
            $("#editBtn").click(function () {
                var id = '${customer.id}';
                $.ajax({
                    url: 'workbench/customer/queryCustomerById',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        id: id
                    },
                    success: function (resp) {
                        // $("#edit-nextContactTime").attr("readonly",false);
                        $("#edit-id").val(id);
                        $("#edit-customerOwner").val(resp.owner); // 通过设置value值（owner的id）循环遍历出来owner
                        $("#edit-customerName").val(resp.name);
                        $("#edit-website").val(resp.website);
                        $("#edit-phone").val(resp.phone);
                        $("#edit-contactSummary").val(resp.contactSummary);
                        $("#edit-nextContactTime").val(resp.nextContactTime);
                        $("#edit-describe").val(resp.description);
                        $("#edit-address").val(resp.address);
                        // 显示模态窗口
                        $("#editCustomerModal").modal("show");
                    }
                });
            });
            //更新数据
            $("#updateBtn").click(function () {
                // 收集参数
                var id = $("#edit-id").val();
                var owner = $("#edit-customerOwner").val();
                var name = $("#edit-customerName").val();
                var website = $("#edit-website").val();
                var phone = $("#edit-phone").val();
                var description = $("#edit-describe").val();
                var contactSummary = $("#edit-contactSummary").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $("#edit-address").val();
                // 表单验证
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                $.ajax({
                    url: 'workbench/customer/editCustomer',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        website: website,
                        phone: phone,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#editCustomerModal").modal("hide");
                            window.location.href = 'workbench/customer/toDetailIndex?id=' + '${customer.id}';
                        } else {
                            alert(resp.message);
                        }
                    }
                });
            });
            $("#deleteBtn").click(function () {
                if (window.confirm("确定删除吗？？")) {
                    var id = '${customer.id}';
                    id = "id=" + id;
                    $.ajax({
                        url: 'workbench/customer/deleteCusByIds',
                        data: id,
                        type: 'POST',
                        dataType: 'JSON',
                        success: function (resp) {
                            if (resp.code == "1") {
                                alert("删除成功~");
                                window.location.href = 'workbench/customer/toCusIndex';
                            } else {
                                alert(resp.message);
                            }
                        }
                    });
                }
            });
            //备注展示


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
            })
            $("#remarkDivList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })

            $("#remarkDivList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            })
            $("#remarkDivList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });


            //添加备注，动态展示 对那个客户进行备注还需要 客户id
            $("#saveRemarkBtn").click(function () {
                var remark = $("#remark").val();
                var customerId = '${customer.id}';
                $.ajax({
                    url: 'workbench/customer/saveCustomerRemark',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        noteContent: remark,
                        customerId: customerId
                    },
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#remark").val("");
                            var htmlStr = "";
                            htmlStr += '       <div  id="div_'+resp.retData.id+'" class="remarkDiv" style="height: 60px;">\n' +
                                '            <img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">\n' +
                                '            <div style="position: relative; top: -40px; left: 40px;">\n' +
                                '                <h5>' + resp.retData.noteContent + '</h5>\n' +
                                '                <font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;">\n' +
                                '              ' + resp.retData.createTime + '由${sessionScope.sessionUser.name}创建</small>\n' +
                                '                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">\n' +
                                '                    <a class="myHref" name="editA" href="javascript:void(0);"remarkId=' + resp.retData.id + '><span class="glyphicon glyphicon-edit"\n' +
                                '                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>\n' +
                                '                    &nbsp;&nbsp;&nbsp;&nbsp;\n' +
                                '                    <a class="myHref" name="deleteA" href="javascript:void(0);"remarkId=' + resp.retData.id + '><span class="glyphicon glyphicon-remove"\n' +
                                '                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>\n' +
                                '                </div>\n' +
                                '            </div>\n' +
                                '        </div>';
                            $("#remarkDiv").before(htmlStr);
                        } else {
                            alert(resp.message);
                        }
                    }
                })
            })
            //修改备注
            $("#remarkDivList").on("click", "a[name='editA']", function () {
                var id = $(this).attr("remarkId");
                $("#editCusRemarkModal").modal("show");
                $("#editCus-id").val(id);
                var noteContent = $("#div_" + id + " h5").text();
                $("#edit-noteContent").val(noteContent);
            });
            $("#updateCusRemarkBtn").click(function () {
                var id = $("#editCus-id").val();
                var noteContent = $("#edit-noteContent").val();
                if (noteContent == "") {
                    alert("内容不能为空~");
                    return;
                }
                $.ajax({
                    url: 'workbench/customer/updateCusRemarkByRemarkId',
                    data: {
                        id: id,
                        noteContent: noteContent
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#editCusRemarkModal").modal("hide");
                            $("#div_" + resp.retData.id + " h5").text(resp.retData.noteContent);
                            $("#div_" + resp.retData.id + " small").text(" " + resp.retData.editTime + "由${sessionScope.sessionUser.name}修改")
                        } else {
                            alert(resp.message);
                        }

                    }
                })

            });
            //删除备注
            $("#remarkDivList").on("click", "a[name='deleteA']", function () {
                var id = $(this).attr("remarkId");
                $.ajax({
                    url: 'workbench/customer/deleteCusRemarkByRemarkId',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        id: id
                    },
                    success: function (resp) {
                        if (resp.code == "1") {
                            alert("删除成功~");
                            $("#div_" + id).remove();

                        } else {
                            alert(resp.message);
                        }
                    }
                });

            });
            //交易删除
            $("#tranTbody").on("click", "a", function () {
                var id = $(this).attr("tranId");
                $("#removeTransactionModal").modal("show");
                $("#del-id").val(id);
            })
            $("#sureDelBtn").click(function () {
                //获取id删除交易
                var tranId = $("#del-id").val();
                var id = "id=" + tranId;
                <%--var customerId = '${customer.id}'--%>
                $.ajax({
                    url: 'workbench/transaction/deleteTranByIds',
                    type: 'POST',
                    dataType: 'JSON',
                    data: id,
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#tr_" + tranId).remove();
                            $("#removeTransactionModal").modal("hide");
                        } else {
                            alert(resp.message)
                        }
                    }
                });
            });
            //新建联系人
            $("#saveConBtn").click(function () {
                $("#createContactsModal").modal("show");
                $("#saveConForm")[0].reset();
            });
            $("#saveContactsBtn").click(function () {
                var owner = $("#create-contactsOwner").val();
                var source = $("#create-clueSource").val();
                var fullname = $.trim($("#create-surname").val());
                var appellation = $("#create-call").val();
                var job = $.trim($("#create-job").val());
                var mphone = $.trim($("#create-mphone").val());
                var email = $.trim($("#create-email").val());
                var birth = $.trim($("#create-birth ").val());
                var customerId = $.trim($("#create-customerName").val());
                var description = $.trim($("#create-describe  ").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $.trim($("#create-nextContactTime").val());
                var address = $.trim($("#create-address").val());
                $.ajax({
                    url: 'workbench/contacts/saveContacts',
                    dataType: 'JSON',
                    type: 'POST',
                    data: {
                        owner: owner,
                        source: source,
                        fullname: fullname,
                        appellation: appellation,
                        job: job,
                        mphone: mphone,
                        email: email,
                        birth: birth,
                        customerId: customerId,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    success: function (resp) {
                        if (resp.code == "1") {
                            var htmlStr = "";
                            htmlStr += ' <tr id="tr_' + resp.retData.id + '">\n' +
                                '                        <td><a href="workbench/contacts/toConDetailIndex?id=' + resp.retData.id + '"\n' +
                                '                               style="text-decoration: none;">' + resp.retData.fullname + '</a></td>\n' +
                                '                        <td>' + resp.retData.email + '</td>\n' +
                                '                        <td>' + resp.retData.mphone + '</td>\n' +
                                '                        <td><a href="javascript:void(0);" contactsId="' + resp.retData.id + '" id="delContactBtn"\n' +
                                '                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>\n' +
                                '                        </td>\n' +
                                '                    </tr>';
                            $("#conBody").append(htmlStr);
                            $("#createContactsModal").modal("hide");
                        } else {
                            alert(resp.message);
                        }
                    }
                });

            });

            $("#conBody").on("click", "a[name='deleteB']", function () {
                var contactsId = $(this).attr("contactsId");
                $("#removeContactsModal").modal("show");
                $("#del_con_id").val(contactsId);
            });
            $("#delContactsBtn").click(function () {
                //根据customerId删除关联的联系人
                var contactsId = $("#del_con_id").val();
                var id = "id=" + contactsId;
                $.ajax({
                    url: 'workbench/contacts/deleteContactByIds',
                    type: 'POST',
                    dataType: 'JSON',
                    data: id,
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#removeContactsModal").modal("hide");
                            $("#tr_" + contactsId).remove();
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
<!-- 修改线索活动备注的模态窗口 -->
<div class="modal fade" id="editCusRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden " id="editCus-id">
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
                <button type="button" class="btn btn-primary" id="updateCusRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <!--设置一个隐藏标签，用来存放id，供后面修改数据时操作-->
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-customerOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control date" id="edit-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 删除联系人的模态窗口 -->
<div class="modal fade" id="removeContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除联系人</h4>
                <input type="hidden" id="del_con_id">
            </div>
            <div class="modal-body">
                <p>您确定要删除该联系人吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="delContactsBtn">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除交易的模态窗口 -->
<div class="modal fade" id="removeTransactionModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden " id="del-id">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">删除交易</h4>
            </div>
            <div class="modal-body">
                <p>您确定要删除该交易吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="sureDelBtn">删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="saveConForm">

                    <div class="form-group">
                        <label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-contactsOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueSource">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <c:forEach items="${appellation}" var="appe">
                                    <option value="${appe.id}">${appe.value}</option>
                                </c:forEach>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-birth" class="col-sm-2 control-label">生日</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-birth">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName"
                                   placeholder="支持自动补全，输入客户不存在则新建" readonly value="${customer.name}">
                        </div>
                    </div>

                    <div class="form-group" style="position: relative;">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-nextContactTime" value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveContactsBtn">保存</button>
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
        <h3>${customer.name} <small><a href="javascript:void(0);" target="_blank">${customer.website}</a></small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${customer.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${customer.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${customer.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 10px; left: 40px;" id="remarkDivList">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${customerRemarkList}" var="remark">
        <div class="remarkDiv" style="height: 60px;" id="div_${remark.id}">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>${remark.noteContent}</h5>
                <font color="gray">客户</font> <font color="gray">-</font> <b>${customer.name}</b> <small
                    style="color: gray;">
                    ${remark.editFlag=='1'?remark.editTime:remark.createTime}由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag=='1'?'修改':'创建'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" remarkId="${remark.id}" href="javascript:void(0);" name="editA"><span
                            class="glyphicon glyphicon-edit"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" remarkId="${remark.id}" href="javascript:void(0);" name="deleteA"><span
                            class="glyphicon glyphicon-remove"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
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
            <table id="activityTable2" class="table table-hover" style="width: 900px;">
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
                <tbody id="tranTbody">
                <c:forEach items="${tranList}" var="tran">
                    <tr id="tr_${tran.id}">
                        <td><a href="workbench/transaction/toDetailIndex?id=${tran.id}"
                               style="text-decoration: none;">${tran.name}</a></td>
                        <td>${tran.money}</td>
                        <td>${tran.stage}</td>
                        <td>${tran.possibility}</td>
                        <td>${tran.expectedDate}</td>
                        <td>${tran.type}</td>
                        <td><a href="javascript:void(0);" name="deleteTran" tranId="${tran.id}"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="workbench/transaction/toSaveIndex" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>新建交易</a>
        </div>
    </div>
</div>

<!-- 联系人 //根据customerId找联系人-->
<div>
    <div style="position: relative; top: 20px; left: 40px;">
        <div class="page-header">
            <h4>联系人</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>邮箱</td>
                    <td>手机</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="conBody">
                <%--                <tr>--%>
                <%--                    <td><a href="../contacts/detail.jsp" style="text-decoration: none;">李四</a></td>--%>
                <%--                    <td>lisi@bjpowernode.com</td>--%>
                <%--                    <td>13543645364</td>--%>
                <%--                    <td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal"--%>
                <%--                           style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
                <%--                </tr>--%>
                <c:forEach items="${contactsList}" var="contact">
                    <tr id="tr_${contact.id}">
                        <td><a href="workbench/contacts/toConDetailIndex?id=${contact.id}"
                               style="text-decoration: none;">${contact.fullname}</a></td>
                        <td>${contact.email}</td>
                        <td>${contact.mphone}</td>
                        <td><a href="javascript:void(0);" id="delContactBtn" contactsId="${contact.id}" name="deleteB"
                               style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="saveConBtn"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
        </div>
    </div>
</div>

<div style="height: 200px;"></div>
</body>
</html>