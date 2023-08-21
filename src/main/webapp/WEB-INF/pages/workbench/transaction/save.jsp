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
</head>

<script type="text/javascript">
    $(function () {
        //日期插件
        $(".date").datetimepicker({
            language: 'zh-CN',//语言
            format: 'yyyy-mm-dd',//日期的格式
            minView: 'month',//可以选择的最小视图
            initialDate: new Date(),//初始化选择的日期
            autoclose: true,//设置选择完日期或者时间后是否自动关闭日历
            todayBtn: true,
            clearBtn: true//设置是否显示清空按钮
        });
        // 当容器加载完成之后，对容器调用工具函数  自动补全插件
        $("#create-customerName").typeahead({
            source:function (jquery,process) {
                // 每次键盘弹起，都自动触发本函数；向后台送请求，查询客户表中所有的名称，把客户名称以[]字符串形式返回前台，赋值给source
                // process：是个函数，能够将['xxx','xxxxx','xxxxxx',.....]字符串赋值给source，从而完成自动补全
                // jquery：在容器中输入的关键字
                // 发送查询请求
                $.ajax({
                    url:'workbench/transaction/queryCustomerNameByFuzzyName',
                    data:{
                        customerName:jquery
                    },
                    type:'post',
                    dataType:'json',
                    success:function (data) {//['xxx','xxxxx','xxxxxx',.....]
                        process(data); // 将后端查询的名称字符串通过process传给source
                    }
                });
            }
        });


        $("#cancelBtn").click(function () {
            // window.location.href = "workbench/transaction/toTranIndex";
            window.history.back()
        });
        $("#searchActivityBtn").click(function () {
            // 初始化工作
            // 清空搜索框
            $("#searchTxt").val("");
            // 清空搜索列表
            $("#tbody").html("");
            // 弹出搜索市场活动的模态窗口
            $("#findMarketActivity").modal("show");
        });
        $("#searchTxt").keyup(function () {
            var activityName = $.trim($("#searchTxt").val());
            $.ajax({
                url: 'workbench/transaction/queryAllActivityByActivityName',
                data: {
                    activityName: activityName,
                },
                type: 'post',
                dataType: 'json',
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp, function (i, e) {
                        htmlStr += ' <tr>\n' +
                            '                        <td><input type="radio"  name="activity" value="' + e.id + '" activityName=' + e.name + ' /></td>\n' +
                            '                        <td>' + e.name + '</td>\n' +
                            '                        <td>' + e.startDate + '</td>\n' +
                            '                        <td>' + e.endDate + '</td>\n' +
                            '                        <td>' + e.owner + '</td>\n' +
                            '                    </tr>';
                    });
                    $("#tbody").html(htmlStr);
                }
            });
        });
        $("#tbody").on("click", "input[type='radio']", function () {
            var activityName = $(this).attr("activityName");
            var id = this.value;
            $("#create-activitySrc").val(activityName);
            $("#activityId").val(id);
            $("#findMarketActivity").modal("hide");

        })

        $("#searchContactsBtn").click(function () {
            $("#findContacts").modal("show");
            $("#searchContactsTxt").val("");
        });
        $("#searchContactsTxt").keyup(function () {
            var contactsName = $.trim($("#searchContactsTxt").val());
            $.ajax({
                url: 'workbench/transaction/queryContactsByContactsName',
                type: 'POST',
                dataType: 'JSON',
                data: {
                    contactsName: contactsName
                },
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp, function (i, e) {
                        htmlStr += '                    <tr>\n' +
                            '                        <td><input type="radio" name="contacts" value="' + e.id + '"contactsName=' + e.fullname + ' /></td>\n' +
                            '                        <td>' + e.fullname + '</td>\n' +
                            '                        <td>' + e.email + '</td>\n' +
                            '                        <td>' + e.mphone + '</td>\n' +
                            '                    </tr>';
                    });
                    $("#contactsBody").html(htmlStr);
                }
            });
        });

        $("#contactsBody").on("click", "input[type='radio']", function () {
            var contactsName = $(this).attr("contactsName");
            var id = this.value;
            $("#contactsId").val(id);
            $("#create-contactsName").val(contactsName);
            $("#findContacts").modal("hide");
        })
        $("#create-transactionStage").change(function () {
            var stage = $("#create-transactionStage option:selected").text();
            if(stage == ""){
                // 清空可能性输入框
                $("#create-possibility").val("");
                return;
            }
            $.ajax({
                url: 'workbench/transaction/getPossibilityByStage',
                type: 'POST',
                dataType: 'JSON',
                data: {
                    stage:stage
                },
                success: function (resp) {
                    $("#create-possibility").val(resp)
                }
            });
        });


        $("#saveTranBtn").click(function () {
            //获取参数
            // 收集参数
            var owner = $("#create-owner").val();
            var money = $.trim($("#create-amountOfMoney").val());
            var name = $.trim($("#create-transactionName").val());
            var expectedDate = $("#create-expectedClosingDate").val();
            var customerName = $.trim($("#create-customerName").val());
            var stage = $("#create-transactionStage").val();
            var type = $("#create-transactionType").val();
            var source = $("#create-clueSource").val();
            var activityId = $("#activityId").val();
            var contactsId = $("#contactsId").val();
            var description = $.trim($("#create-describe").val());
            var contactSummary = $.trim($("#create-contactSummary").val());
            var nextContactTime = $("#create-nextContactTime").val();
            //表单验证
            if(name == "") {
                alert("名称不能为空")
                return;
            }
            if(expectedDate == "") {
                alert("预计成交日期不能为空")
                return;
            }
            if(customerName == "") {
                alert("客户名称不能为空")
                return;
            }
            if(stage == "" || stage == null) {
                alert("阶段不能为空")
                return;
            }
            //发送请求
            $.ajax({
                url:'workbench/transaction/saveCreateTransaction',
                data:{
                    owner:owner,
                    money:money,
                    name:name,
                    expectedDate:expectedDate,
                    customerId:customerName,
                    stage:stage,
                    type:type,
                    source:source,
                    activityId:activityId,
                    contactsId:contactsId,
                    description:description,
                    contactSummary:contactSummary,
                    nextContactTime:nextContactTime
                },
                type:'post',
                dataType:'json',
                success:function (resp) {
                    if(resp.code=="1"){
                        // 跳转到交易主页面
                        // window.location.href = "workbench/transaction/toTranIndex";
                        window.history.back();
                    }else{

                        // 提示信息
                        alert(resp.message);
                    }
                }
            });
        });

    });
</script>
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
                    <tbody id="tbody">
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
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="searchContactsTxt" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
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
                    <tbody id="contactsBody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
        <button type="button" class="btn btn-default" id="cancelBtn">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-owner">
                <c:forEach items="${userList}" var="user">
                    <option value="${user.id}">${user.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control date" id="create-expectedClosingDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
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
                <c:forEach items="${transactionType}" var="type">
                    <option value="${type.id}">${type.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility">
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
                                                                                           id="searchActivityBtn"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="activityId">
            <input type="text" class="form-control" id="create-activitySrc">
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            id="searchContactsBtn"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="contactsId">
            <input type="text" class="form-control" id="create-contactsName">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label ">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control date" id="create-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>