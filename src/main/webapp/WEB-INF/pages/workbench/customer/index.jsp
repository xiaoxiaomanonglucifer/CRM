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
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">

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
            queryCustomerByConditionForPage(1, 10)
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //按查询绑定事件
            $("#searchBtn").click(function () {
                queryCustomerByConditionForPage(1, $("#page-master").bs_pagination('getOption', 'rowsPerPage'));
            });
            //创建新客户
            $("#createCusBtn").click(function () {
                // 清空之前表单输入的的信息
                $("#createCustomerForm").get(0).reset();
                // 弹出创建客户的模态窗口
                $("#createCustomerModal").modal("show");
            });
            //保存新客户
            $("#saveCusBtn").click(function () {
                // 收集参数
                var owner = $("#create-customerOwner").val();
                var name = $("#create-customerName").val();
                var website = $("#create-website").val();
                var phone = $("#create-phone").val();
                var description = $("#create-describe").val();
                var contactSummary = $("#create-contactSummary").val();
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $("#create-address").val();
                // 表单验证
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                // if (website != "") {
                //     var websiteRegExp = /^(?:(http|https|ftp):\/\/)?((?:[\w-]+\.)+[a-z0-9]+)((?:\/[^/?#]*)+)?(\?[^#]+)?(#.+)?$/i;
                //     if (!websiteRegExp.test(website)) {
                //         alert("网站格式错误");
                //         return;
                //     }
                // }
                // if (phone != "") {
                //     var phoneRegExp = /0\d{2,3}-\d{7,8}/; // 国内座机电话号码验证："XXX-XXXXXXX"
                //     if (!phoneRegExp.test(phone)) {
                //         alert("座机号码格式错误");
                //         return;
                //     }
                // }

                $.ajax({
                    url: 'workbench/customer/saveCustomer',
                    data: {
                        owner: owner,
                        name: name,
                        website: website,
                        phone: phone,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (resp) {
                        if (resp.code == "1") {
                            queryCustomerByConditionForPage(1, $("#page-master").bs_pagination('getOption', 'rowsPerPage'))
                            $("#createCustomerModal").modal("hide");

                        } else {
                            alert(resp.message);
                        }
                    }
                });
            });
            //设置单选和全选功能
            $("#checkAll").click(function () {
                if (this.checked) {
                    $("#cusTbody input[type='checkbox']").prop("checked", true);
                } else {
                    $("#cusTbody input[type='checkbox']").prop("checked", false);
                }
            });
            //如果全部选到了，则全选按钮也选上,因为是动态的所以用on
            $("#cusTbody").on("click", function () {
                if ($("#cusTbody input[type='checkbox']").size() == $("#cusTbody input[type='checkbox']:checked").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });
            //根据选择删除客户
            $("#deleteCusBtn").click(function () {

                //获取要删除的id所有 拼成id=xxx&id=XXX&id=xxx....
                var customerIds = $("#cusTbody input[type='checkbox']:checked");
                if (customerIds.size() == 0) {
                    alert("请选择你要删除的客户");
                    return
                }
                if (window.confirm("确定删除吗？？")) {
                    var id = "";
                    $.each(customerIds, function () {
                        id += "id=" + this.value + "&";
                    });
                    id = id.substr(0, id.length - 1);
                    $.ajax({
                        url: 'workbench/customer/deleteCusByIds',
                        data: id,
                        type: 'POST',
                        dataType: 'JSON',
                        success: function (resp) {
                            if (resp.code == "1") {
                                //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                                queryCustomerByConditionForPage(1, $("#page-master").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert(resp.message);
                            }
                        }
                    });
                }
            });

            //修改功能
            $("#editCusBtn").click(function () {
                //获取id查询数据，将原数据战士在窗口中
                var checkId = $("#cusTbody input[type='checkbox']:checked");
                if (checkId.size() == 0) {
                    alert("请选择一个客户");
                    return;
                }
                if (checkId.size() > 1) {
                    alert("只能选择一项");
                    return;
                }
                var id = checkId.val();
                $.ajax({
                    url: 'workbench/customer/queryCustomerById',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        id: id
                    },
                    success: function (resp) {
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
            //点击更新获取数据 完成修改
            $("#editbtn").click(function () {
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
                            queryCustomerByConditionForPage($("#page-master").bs_pagination('getOption', 'currentPage'),
                                $("#page-master").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert(resp.message);
                        }
                    }
                });
            });

            //跳转明细页面

        });

        function queryCustomerByConditionForPage(pageNo, pageSize) {
            //获取参数
            var name = $("#query-name").val();
            var owner = $("#query-owner").val();
            var website = $("#query-website").val();
            var phone = $("#query-phone").val();
            $.ajax({
                url: 'workbench/customer/queryCustomerByConditionForPage',
                data: {
                    name: name,
                    owner: owner,
                    website: website,
                    phone: phone,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'POST',
                dataType: 'JSON',
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp.customerList, function (i, e) {
                        htmlStr += '<tr>\n' +
                            '\t\t\t\t\t\t\t<td><input type="checkbox" value="' + e.id + '" /></td>\n' +
                            '\t\t\t\t\t\t\t<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/toDetailIndex?id='+e.id+'\';">' + e.name + '</a></td>\n' +
                            '\t\t\t\t\t\t\t<td>' + e.owner + '</td>\n' +
                            '\t\t\t\t\t\t\t<td>' + e.phone + '</td>\n' +
                            '\t\t\t\t\t\t\t<td>' + e.website + '</td>\n' +
                            '\t\t\t\t\t\t</tr>';
                    });
                    $("#cusTbody").html(htmlStr);
                    //将全选框false
                    $("#checkAll").prop("checked", false);
                    //配置插件
                    var totalPages = 1;
                    if (resp.totalCount % pageSize == 0) {
                        totalPages = resp.totalCount / pageSize;
                    } else {
                        totalPages = parseInt(resp.totalCount / pageSize) + 1; // 页数不能是小数，将小数转换为整数
                    }
                    //对容器调用bs_pagination工具函数，显示翻页信息
                    $("#page-master").bs_pagination({
                        currentPage: pageNo, // 当前页号,相当于pageNo
                        rowsPerPage: pageSize, // 每页显示条数,相当于pageSize
                        totalRows: resp.totalCount, // 总条数
                        totalPages: totalPages,  // 总页数,必填参数.
                        visiblePageLinks: 5, // 最多可以显示的卡片数
                        showGoToPage: true, // 是否显示"跳转到"部分，默认true显示
                        showRowsPerPage: true, // 是否显示"每页显示条数"部分，默认true显示
                        showRowsInfo: true, // 是否显示记录的信息，默认true显示

                        // 用户每次切换页号，都自动触发本函数;
                        // 每次返回切换页号之后的pageNo和pageSize
                        onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
                            // 重写发送当前页数和每页显示的条数（这也就意味着每次换页都将向后端 发送请求 查询当页数据）
                            queryCustomerByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });

        }
    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createCustomerForm">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-customerOwner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
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
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control date" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCusBtn">保存</button>
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
                <button type="button" class="btn btn-primary" id="editbtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
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
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="query-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="query-website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createCusBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editCusBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteCusBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
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
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="cusTbody">
                <%--						<tr>--%>
                <%--							<td><input type="checkbox" /></td>--%>
                <%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td>010-84846003</td>--%>
                <%--							<td>http://www.bjpowernode.com</td>--%>
                <%--						</tr>--%>
                <%--                        <tr class="active">--%>
                <%--                            <td><input type="checkbox" /></td>--%>
                <%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>--%>
                <%--                            <td>zhangsan</td>--%>
                <%--                            <td>010-84846003</td>--%>
                <%--                            <td>http://www.bjpowernode.com</td>--%>
                <%--                        </tr>--%>
                </tbody>
            </table>
            <div id="page-master"></div>
        </div>

        <%--        <div style="height: 50px; position: relative;top: 30px;">--%>
        <%--            <div>--%>
        <%--                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
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

    </div>

</div>
</body>
</html>