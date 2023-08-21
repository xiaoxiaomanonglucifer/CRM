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
    <%--    JQuery框架加--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--    bs框架--%>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%--    翻页插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <%--    日历插件--%>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>

    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function () {
            $(".mydate").datetimepicker({
                language: 'zh-CN',//语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month',//可以选择的最小视图
                initialDate: new Date(),//初始化选择的日期
                autoclose: true,//设置选择完日期或者时间后是否自动关闭日历
                todayBtn: true,
                clearBtn: true//设置是否显示清空按钮
            });
            //给创建按钮添加单击事件
            $("#createActivityBtn").click(function () {
                //重置表单
                $("#createActivityForm")[0].reset();

                $("#createActivityModal").modal("show")//打开模拟窗口  $("模态窗口的id").modal("show")---modal是一个内置属性
            });
            //查询id所代表 的市场 然后查询
            $("#editActivityBtn").click(function () {
                // $("#editActivityModal").modal("show")//打开模拟窗口  $("模态窗口的id").modal("show")---modal是一个内置属性
                var checkIds = $("#tBody input[type='checkbox']:checked");
                if (checkIds.size() == 0) { // 如果没有选中的市场活动
                    alert("请选择要修改的市场活动");
                    return;
                }
                if (checkIds.size() > 1) { // 如果选中的市场活动数目大于1，则不能修改
                    alert("每次只能修改一条市场活动");
                    return;
                }
                // 获取选中的市场活动id
                var id = checkIds.val();
                $.ajax({
                    url: 'workbench/activity/queryActivityById',
                    dataType: 'JSON',
                    type: 'POST',
                    data: {
                        id: id
                    },
                    success: function (resp) {
                        $("#edit-id").val(resp.id);
                        $("#edit-marketActivityName").val(resp.name);
                        $("#edit-startTime").val(resp.startDate);
                        $("#edit-endTime").val(resp.endDate);
                        $("#edit-cost").val(resp.cost);
                        $("#edit-describe").val(resp.description);
                        $("#editActivityModal").modal("show");
                    }
                });
            });
            // 更新
            $("#updateActivity").click(function () {
                var id = $("#edit-id").val(); // 隐藏input标签value值
                var owner = $("#edit-marketActivityOwner").val();
                var name = $.trim($("#edit-marketActivityName").val());
                var startDate = $("#edit-startTime").val();
                var endDate = $("#edit-endTime").val();
                var cost = $.trim($("#edit-cost").val());
                var description = $.trim($("#edit-describe").val());
                //表单验证
                // console.log("startDate"+startDate);
                // console.log("endDate"+endDate);
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空~");
                    return;
                }
                if (startDate != "" && endDate != "") {
                    //方法1将字符串转成Date对象 比较毫秒数
                    //方法2直接比较字符串
                    if (endDate <= startDate) {
                        alert("结束日期不能比开始日期小~");
                        return;
                    }
                }
                //正则表达式检验输入的值是非负整数，不能是小数和小于零的数
                //非负整数的正则表示:
                var reg = /^(([1-9]\d*)|0)$/;
                if (!reg.test(cost)) {
                    alert("成本只能是非负整数~");
                    return;
                }

                $.ajax({
                    url: "workbench/activity/editActivity",
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description
                    },
                    dataType: 'JSON',
                    type: 'POST',
                    success: function (resp) {
                        if (resp.code == "1") {
                            //保存成功后1.关闭模态窗口
                            $("#editActivityModal").modal("hide");
                            alert("修改成功")
                            $("#checkAll").prop("checked", false);
                            // 刷新市场活动列，显示更新候的数据所在页面
                            queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),
                                $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert(resp.message);
                            $("#editActivityModal").modal("show");
                        }
                    }
                });
            });
            // 点击保存

            $("#save").click(function () {
                //获取表单里面的所有值
                var owner = $("#create-marketActivityOwner").val();
                var name = $.trim($("#create-marketActivityName").val());
                var startDate = $("#create-startTime").val();
                var endDate = $("#create-endTime").val();
                var cost = $.trim($("#create-cost").val());
                var description = $.trim($("#create-describe").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空~");
                    return;
                }
                if (startDate != "" && endDate != "") {
                    //方法1将字符串转成Date对象 比较毫秒数
                    //方法2直接比较字符串
                    if (endDate <= startDate) {
                        alert("结束日期不能比开始日期小~");
                        return;
                    }
                }
                //正则表达式检验输入的值是非负整数，不能是小数和小于零的数
                //非负整数的正则表示:
                var reg = /^(([1-9]\d*)|0)$/;
                if (!reg.test(cost)) {
                    alert("成本只能是非负整数~");
                    return;
                }
                $.ajax({
                    url: "workbench/activity/saveCreateActivity",
                    data: {
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description
                    },
                    dataType: 'JSON',
                    type: 'POST',
                    success: function (resp) {
                        if (resp.code == "1") {
                            //保存成功后1.关闭模态窗口
                            $("#createActivityModal").modal("hide");
                            //2.刷新数据，将保存的最新一条放在最前面，就是要重新查询数据重新展示
                            queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert(resp.message);
                            $("#createActivityModal").modal("show")
                        }
                    }
                });
            });
            //页面一加载就查询数据展示数据
            queryActivityByConditionForPage(1, 10);

            //给查询加单击事件
            $("#queryActivityBtn").click(function () {

                //查询完后 每页显示的页数不变
                queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
            });
            //修改发送
            $("#checkAll").click(function () {
                // if(this.checked){
                //     $("#tBody input[type='checkbox']").prop("checked",true);
                // }else {
                //     $("#tBody input[type='checkbox']").prop("checked", false);
                // }
                $("#tBody input[type='checkbox']").prop("checked", this.checked);
            });
            $("#tBody").on("click", function () {
                $("#checkAll").prop("checked",
                    $("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size())
            });
            $("#deleteActivity").click(function () {
                var activityIds = $("#tBody input[type='checkbox']:checked");

                if (activityIds.size() == 0) {
                    alert("请选择你要删除的活动");
                    return
                }
                if (window.confirm("确定删除吗？？")) {
                    var id = ""; // 所有id拼接成的字符串变量
                    // 遍历数组
                    $.each(activityIds, function () { // id的格式为：id=xxx&id=xxx&id=xxx&id=xxx&id=xxx..
                        // 这个this是checkbox选择框dom对象
                        id += "id=" + this.value + "&"; // 这个id是怎么获取到的：checkbox的value值，在查询数据时将id值赋给了checkbox
                    });
                    id = id.substr(0, id.length - 1);
                    $.ajax({
                        url: 'workbench/activity/deleteActivityByIds',
                        data: id,
                        type: 'POST',
                        dataType: 'JSON',
                        success: function (resp) {
                            if (resp.code == "1") {
                                //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                                queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert(resp.message);
                            }
                        }
                    });

                }
            });

            $("#exportActivityAllBtn").click(function () {
                window.location.href = "workbench/activity/exportAllActivities";
            })
            $("#exportActivityXzBtn").click(function () {//// id的格式为：id=xxx&id=xxx&id=xxx&id=xxx&id=xxx..
                var activityIds = $("#tBody input[type='checkbox']:checked");
                if (activityIds.size() == 0) {
                    alert("请选择你要导出的数据~");
                    return;
                }
                var id = "?";
                $.each(activityIds, function () {
                    id += "id=" + this.value + "&";
                });
                id = id.substr(0, id.length - 1)//将最后面一个&去掉
                window.location.href = "workbench/activity/exportActivityByIds" + id;
                //地址栏?id=xxx&id=xxx&id=xxx
            });
            $("#importActivityBtn").click(function () {
                var activityFileName = $("#activityFile").val();
                var suffix = activityFileName.substr(activityFileName.lastIndexOf(".") + 1);
                suffix = suffix.toLocaleLowerCase();
                if (suffix != "xls") {
                    alert("只支持xls文件");
                    return;
                }
                var activityFile = $("#activityFile")[0].files[0];
                if (activityFile.size > 5 * 1024 * 1024) {
                    alert("文件大小不能超过5MB");
                    return;
                }
                // FormData是ajax提供的接口,可以模拟键值对向后台提交参数;
                // FormData最大的优势是不但能提交文本数据，还能提交二进制数据
                var formData = new FormData();
                formData.append("activityFile", activityFile);
                $.ajax({
                    url: 'workbench/activity/importActivity',
                    type: 'POST',
                    processData: false, // 设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true--是,false--不是,默认是true
                    contentType: false, // 设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true--是,false--不是，默认是true
                    data: formData,
                    success: function (resp) {
                        if (resp.code == "1") {
                            //提示导入成功的记录数
                            alert("成功导入" + resp.retData + "条记录");
                            $("#importActivityModal").modal("hide");
                            queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            // 提示信息
                            alert(data.message);
                            // 模态窗口不关闭
                            $("#importActivityModal").modal("show");
                        }
                    }
                });


            })

        });

        //将查询封装成函数
        function queryActivityByConditionForPage(pageNo, pageSize) {
            //页面加载完成显示页面
            var name = $("#query-name").val();
            var owner = $("#query-owner").val();
            var startDate = $("#query-startDate").val();
            var endDate = $("#query-endDate").val();
            // var pageNo = pageNo;
            // var pageSize = pageSize;
            $.ajax({
                url: 'workbench/activity/queryActivityByConditionForPage',
                data: {
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate,
                    pageNo: pageNo,
                    pageSize: pageSize
                    //data的参数名紫色的需要和controller形参中括号里的一样
                },
                type: 'POST',
                dataType: 'JSON',
                success: function (resp) {
                    //没用工具插件时的显示页数
                    //显示总条数
                    //   $("#totalCountB").text(resp.totalCount);
                    //显示市场活动的列表
                    var htmlStr = "";
                    // console.log(resp.activityList)
                    $.each(resp.activityList, function (i, e) {
                        htmlStr += "<tr class=\"active\">\n" +
                            "                            <td><input type=\"checkbox\"  value=\"" + e.id + "\"/></td>\n" +
                            "                            <td><a style=\"text-decoration: none; cursor: pointer;\"\n" +
                            "                        onclick=\"window.location.href='workbench/activity/toDetailIndex?id="+e.id+"';\">" + e.name + "</a></td>\n" +
                            "                        <td>" + e.owner + "</td>\n" +
                            "                        <td>" + e.startDate + "</td>\n" +
                            "                        <td>" + e.endDate + "</td>\n" +
                            "                        </tr>";
                    });
                    $("#tBody").html(htmlStr);
                    var totalPages = 1;
                    // totalPages=resp.totalCount/pageSize;
                    if (resp.totalCount % pageSize == 0) {
                        totalPages = resp.totalCount / pageSize;
                    } else {
                        totalPages = parseInt(resp.totalCount / pageSize) + 1;
                    }
                    //调用共库函数，显示翻页信息
                    $("#demo_pag1").bs_pagination({
                        currentPage: pageNo,//当前页,相当于pageNo
                        /*下面三条数据需要保持一致 数据从*/
                        rowsPerPage: pageSize,//每页记录数 相当于pageSize
                        totalRows: resp.totalCount,//总条数totalCount  数据库
                        totalPages: totalPages,//总页数 自己计算totalCount除于pageSize

                        visiblePageLinks: 5,//可见的页连接 1-5 设置最多可以显示的卡片数

                        showGoToPage: true,//是否显示直达页数的框  默认是true
                        showRowsPerPage: true,//是否显示每页条数
                        showRowsInfo: true,//是否显示记录的信息 默认是true

                        onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
                            //当用户每次切换页号时 会执行这个函数
                            queryActivityByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);

                        },

                    });


                }
            });
        }


    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                    <%--提交到后台的是user的id--%>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-startTime" readonly>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="create-endTime" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <%--                <button type="button" class="btn btn-primary" data-dismiss="modal">保存</button>   --%>
                <%--               data-dismiss="modal"无论成功还是失败，窗口都会自己关掉 应该是保存成功窗口关闭，保存不成功 窗口不关 --%>
                <button type="button" class="btn btn-primary" id="save">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <!--设置一个隐藏标签，用来存放id，供后面修改数据时操作-->
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" id="owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                    <%--									提交到后台的是user的id--%>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateActivity">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="query-startDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="query-endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createActivityBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editActivityBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteActivity"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>2020-10-10</td>--%>
                <%--                    <td>2020-10-20</td>--%>
                <%--                </tr>--%>
                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>2020-10-10</td>--%>
                <%--                    <td>2020-10-20</td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>

        <%--        <div style="height: 50px; position: relative;top: 30px;">--%>
        <%--            <div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalCountB">50</b>条记录--%>
        <%--                </button>--%>
        <%--            </div>--%>
        <%--            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
        <%--                <div class="btn-group">--%>
        <%--                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
        <%--                        10--%>
        <%--                        <span class="caret"></span>--%>
        <%--                    </button>--%>
        <%--                    <ul class="dropdown-menu" role="menu">--%>
        <%--                        <li><a href="#">20</a></li>--%>
        <%--                        <li><a href="#">30</a></li>--%>
        <%--                    </ul>--%>
        <%--                </div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
        <%--            </div>--%>
        <%--            <div style="position: relative;top: -88px; left: 285px;">--%>
        <%--                <nav>--%>
        <%--                    <ul class="pagination">--%>
        <%--                        <li class="disabled"><a href="#">首页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">上一页</a></li>--%>
        <%--                        <li class="active"><a href="#">1</a></li>--%>
        <%--                        <li><a href="#">2</a></li>--%>
        <%--                        <li><a href="#">3</a></li>--%>
        <%--                        <li><a href="#">4</a></li>--%>
        <%--                        <li><a href="#">5</a></li>--%>
        <%--                        <li><a href="#">下一页</a></li>--%>
        <%--                        <li class="disabled"><a href="#">末页</a></li>--%>
        <%--                    </ul>--%>
        <%--                </nav>--%>
        <%--            </div>--%>
        <%--        </div>--%>

        <%--    </div>--%>

        <%--</div>--%>
</body>
</html>