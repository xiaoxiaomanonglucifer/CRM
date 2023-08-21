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

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function () {

            $("#create-transactionStage option[value='${editTran.stage}']").attr("selected", "selected");
            $("#create-transactionType option[value='${editTran.type}']").attr("selected", "selected");
            $("#create-clueSource option[value='${editTran.source}']").attr("selected", "selected");
            $("#create-accountName").typeahead({
                source: function (jquery, process) {
                    // 每次键盘弹起，都自动触发本函数；向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
                    // process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
                    // jquery：在容器中输入的关键字
                    // 发送查询请求
                    $.ajax({
                        url: 'workbench/transaction/queryCustomerNameByFuzzyName',
                        data: {
                            customerName: jquery
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {//['xxx','xxxxx','xxxxxx',.....]
                            process(data); // 将后端查询的名称字符串通过process传给source
                        }
                    });
                }
            });
            $(".date").datetimepicker({
                language: 'zh-CN', // 语言设为中文
                format: 'yyyy-mm-dd', // 日期格式
                minView: 'month', // 可以选择的最小视图
                initialDate: new Date(), // 初始化显示的日期
                autoclose: true, // 选择完日期后是否自动关闭
                todayBtn: true, // 显示‘今天’按钮
                clearBtn: true // 清空按钮
            });

            $("#searchAct").click(function () {
                var id = '${tran.id}';
                $("#findMarketActivity").modal("show");
                $("#tranId").val(id);
            });

            $("#searchTxt").keyup(function () {
                var activityName = $("#searchTxt").val();
                var id = $("#tranId").val();
                $.ajax({
                    url: 'workbench/activity/queryActivityByActivityNameAndTranId',
                    data: {
                        tranId: id,
                        activityName: activityName
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        var htmlStr = "";
                        $.each(resp, function (i, e) {
                            htmlStr += ' <tr>\n' +
                                '                        <td><input type="radio" value="' + e.id + '" activityName=' + e.name + '/></td>\n' +
                                '                        <td>' + e.name + '</td>\n' +
                                '                        <td>' + e.startDate + '</td>\n' +
                                '                        <td>' + e.endDate + '</td>\n' +
                                '                        <td>' + e.owner + '</td>\n' +
                                '                    </tr>';
                        });
                        $("#actBody").html(htmlStr);
                    }
                });

            });

            $("#actBody").on("click", "input[type='radio']", function () {
                var id = this.value;
                var activityName = $(this).attr("activityName");
                $("#activityId").val(id);
                $("#create-activitySrc").val(activityName);
                $("#findMarketActivity").modal("hide");
            });

            $("#searchCon").click(function () {
                $("#findContacts").modal("show");
                var id = '${tran.id}';
                $("#ttId").val(id);
            });
            $("#searchConTxt").keyup(function () {
                var contactsName = $("#searchConTxt").val();
                var tranId = $("#ttId").val();
                $.ajax({
                    url: 'workbench/contacts/queryContactsByContactsNameAndTranId',
                    data: {
                        tranId: tranId,
                        contactsName: contactsName
                    },
                    type: 'POST',
                    dataType: 'JSON',
                    success: function (resp) {
                        var htmlStr = "";
                        $.each(resp, function (i, e) {
                            htmlStr += '  <tr>\n' +
                                '                        <td><input type="radio" value="' + e.id + '" contactsName=' + e.fullname + ' /></td>\n' +
                                '                        <td>' + e.fullname + '</td>\n' +
                                '                        <td>' + e.email + '</td>\n' +
                                '                        <td>' + e.mphone + '</td>\n' +
                                '                    </tr>';
                        });
                        $("#conBody").html(htmlStr);
                    }
                });

            });

            $("#conBody").on("click", "input[type='radio']", function () {
                var id = this.value;
                var contactsName = $(this).attr("contactsName");
                $("#findContacts").modal("hide");
                $("#create-contactsName").val(contactsName);
                $("#contactsId").val(id);
            });

            //保存
            $("#editTranBtn").click(function () {
                var id = '${tran.id}';
                ///获取参数
                var owner = $("#create-transactionOwner").val();
                var money = $.trim($("#create-amountOfMoney").val());
                var name = $.trim($("#create-transactionName").val());
                var expectedDate = $("#create-expectedClosingDate").val();
                var customerName = $.trim($("#create-accountName").val());
                var stage = $("#create-transactionStage option:selected").val();
                var type = $("#create-transactionType option:selected").val();
                var source = $("#create-clueSource option:selected").val();
                var activityId = $("#activityId").val();
                var contactsId = $("#contactsId").val();
                var description = $.trim($("#create-describe").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                //发送请求
                $.ajax({
                    url: 'workbench/transaction/editTransaction',
                    data: {
                        id: id,
                        owner: owner,
                        money: money,
                        name: name,
                        expectedDate: expectedDate,
                        customerId: customerName,
                        stage: stage,
                        type: type,
                        source: source,
                        activityId: activityId,
                        contactsId: contactsId,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (resp) {
                        if (resp.code == "1") {
                            // 跳转到交易主页面
                            // window.location.href = "workbench/transaction/toTranIndex";
                            window.history.back();
                        } else {

                            // 提示信息
                            alert(resp.message);
                        }
                    }
                });
            });
            $("#create-transactionStage").change(function () {
                var stage = $("#create-transactionStage option:selected").text();
                if (stage == "") {
                    // 清空可能性输入框
                    $("#create-possibility").val("");
                    return;
                }
                $.ajax({
                    url: 'workbench/transaction/getPossibilityByStage',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        stage: stage
                    },
                    success: function (resp) {
                        $("#create-possibility").val(resp)
                    }
                });
            });

            $("#")
        });
    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <input type="hidden" id="tranId">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询" id="searchTxt">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="actBody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <input type="hidden" id="ttId">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询"
                                   id="searchConTxt">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="conBody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>修改交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="editTranBtn">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back()">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <input type="hidden" id="actId">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner">
                <c:forEach items="${userList}" var="user">
                    <option value="${user.id}">${user.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney" value="${tran.money}">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName" value="${tran.name}">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control date" id="create-expectedClosingDate" readonly
                   value="${tran.expectedDate}">
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建"
                   value="${tran.customerId}">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage">
                <option></option>
                <c:forEach items="${stageList}" var="stage">
                    <option value="${stage.id}">${stage.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType">
                <option></option>
                <c:forEach items="${typeList}" var="type">
                    <option value="${type.id}">${type.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" value="${tran.possibility}">
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource">
                <option></option>
                <c:forEach items="${sourceList}" var="source">
                    <option value="${source.id}">${source.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                           id="searchAct"
        ><span
                class="glyphicon glyphicon-search"></span></a></label>
        <input type="hidden" id="activityId">
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activitySrc" value="${tran.activityId}">
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            id="searchCon"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="contactsId">
            <input type="text" class="form-control" id="create-contactsName" value="${tran.contactsId}">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe">${tran.description}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary">${tran.contactSummary}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control date" id="create-nextContactTime" readonly
                   value="${tran.nextContactTime}">
        </div>
    </div>

</form>
</body>
</html>