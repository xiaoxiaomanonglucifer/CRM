<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core_1_1" %>
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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">

        $(function () {
            // 当容器加载完成之后，对容器调用工具函数  自动补全插件
            $("#create-customerName").typeahead({
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
                language: 'zh-CN',//语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month',//可以选择的最小视图
                initialDate: new Date(),//初始化选择的日期
                autoclose: true,//设置选择完日期或者时间后是否自动关闭日历
                todayBtn: true,
                clearBtn: true//设置是否显示清空按钮
            });
            queryContactsForPage(1, 10);
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });
            //展示页面及模糊查询
            $("#searchBtn").click(function () {
                queryContactsForPage(1, $("#page").bs_pagination('getOption', 'rowsPerPage'))
            });
            //创建联系人
            $("#createConBtn").click(function () {
                $("#createContactsModal").modal("show");
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
                            $("#createContactsModal").modal("hide");
                            queryContactsForPage(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert(resp.message);
                        }
                    }
                });

            });
//修改
            $("#editConBtn").click(function () {
                //获取的id
                var checkIds = $("#conBody input[type='checkbox']:checked");
                if (checkIds.size() == 0) {
                    alert("请选择一个用户~");
                    return;
                }
                if (checkIds.size() > 1) {
                    alert("只能选择一项");
                    return;
                }
                var id = checkIds.val();
                //根据id查联系人并展示到修改页面上
                $.ajax({
                    url: 'workbench/contacts/queryContactsById',
                    data: {
                        id: id
                    },
                    dataType: 'JSON',
                    type: 'POST',
                    success: function (data) {
                        console.log(data)
                        // 给修改界面的模态窗口的标签赋值
                        $("#edit-id").val(data.id);
                        $("#edit-owner option[value='"+data.owner+"']").attr("selected","selected");
                        $("#edit-source option[value='"+data.source+"']").attr("selected","selected");
                        $("#edit-fullname").val(data.fullname);
                        $("#edit-appellation option[value='"+data.appellation+"']").attr("selected","selected");
                        $("#edit-job").val(data.job);
                        $("#edit-mphone").val(data.mphone);
                        $("#edit-email").val(data.email);
                        $("#edit-customerId").val(data.customerId);
                        $("#edit-description").val(data.description);
                        $("#edit-contactSummary").val(data.contactSummary);
                        $("#edit-nextContactTime").val(data.nextContactTime);
                        $("#edit-address").val(data.address);
                        // 显示模态窗口
                        $("#editContactsModal").modal("show");
                    }
                });

            });

            $("#saveEditContactsBtn").click(function () {
                // 收集参数
                var id = $("#edit-id").val(); // 隐藏input标签value值
                var owner = $("#edit-owner").val();
                var source = $("#edit-source").val();
                var fullname = $.trim($("#edit-fullname").val());
                var appellation = $("#edit-appellation").val();
                var job = $.trim($("#edit-job").val());
                var mphone = $.trim($("#edit-mphone").val());
                var email = $.trim($("#edit-email").val());
                var customerId = $.trim($("#edit-customerId").val());
                var description = $.trim($("#edit-description").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $.trim($("#edit-nextContactTime").val());
                var address = $.trim($("#edit-address").val());
// 发送请求
                $.ajax({
                    url: 'workbench/contacts/updateContacts',
                    data: {
                        id: id,
                        owner: owner,
                        source: source,
                        fullname: fullname,
                        appellation: appellation,
                        job: job,
                        mphone: mphone,
                        email: email,
                        customerId: customerId,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1") {
                            // 关闭模态窗口
                            $("#editContactsModal").modal("hide");
                            // 刷新联系人列表，显示第一页数据，保持每页显示条数不变
                            queryContactsForPage($("#page").bs_pagination('getOption', 'currentPage'),
                                $("#page").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            // 提示信息
                            alert(data.message);
                            // 模态窗口不关闭
                            $("#editContactsModal").modal("show");
                        }
                    }

                });
            });

            //删除所选
            $("#checkAll").click(function () {
                if (this.checked) {
                    $("#conBody input[type='checkbox']").prop("checked", true);
                } else {
                    $("#conBody input[type='checkbox']").prop("checked", false);
                }
            });
            $("#conBody").on("click", function () {
                if ($("#conBody input[type='checkbox']").size() == $("#conBody input[type='checkbox']:checked").size()) {
                    $("#checkAll").prop("checked", true);
                } else {
                    $("#checkAll").prop("checked", false);
                }
            });

            $("#delConBtn").click(function () {
                //获取参数
                var checkIds = $("#conBody input[type='checkbox']:checked");
                if (checkIds.size() == 0) {
                    alert("请选择你要删除的客户");
                    return;
                }
                if (window.confirm("确定删除吗？？")) {
                    var id = "";
                    $.each(checkIds, function () {
                        id += "id=" + this.value + "&";
                    });
                    id = id.substr(0, id.length - 1);
                    $.ajax({
                        url: 'workbench/contacts/deleteContactByIds',
                        data: id,
                        type: 'POST',
                        dataType: 'JSON',
                        success: function (resp) {
                            if (resp.code == "1") {
                                //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                                queryContactsForPage(1, $("#page").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert(resp.message);
                            }
                        }
                    });
                }

            });

        });

        function queryContactsForPage(pageNo, pageSize) {
            //收集参数
            var owner = $("#owner").val();
            var name = $("#name").val();
            var customerName = $("#customerName").val();
            var source = $("#source option:selected").text();
            var address = $("#address").val();
            //进行判断
            $.ajax({
                url: 'workbench/contacts/queryContactsForPage',
                dataType: 'JSON',
                type: 'POST',
                data: {
                    owner: owner,
                    name: name,
                    customerId: customerName,
                    source: source,
                    address: address,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp.contactsList, function (i, e) {
                        htmlStr += '                 <tr>\n' +
                            '                                    <td><input type="checkbox" value="' + e.id + '"/></td>\n' +
                            '                                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/toConDetailIndex?id=' + e.id + '\';">' + e.fullname + '</a>\n' +
                            '                                    </td>\n' +
                            '                                    <td>' + e.customerId + '</td>\n' +
                            '                                    <td>' + e.owner + '</td>\n' +
                            '                                    <td>' + e.source + '</td>\n' +
                            '                                    <td>' + e.address + '</td>\n' +
                            '                                </tr>';
                    });
                    $("#conBody").html(htmlStr);
                    var totalPages = 1;
                    // totalPages=resp.totalCount/pageSize;
                    if (resp.totalCount % pageSize == 0) {
                        totalPages = resp.totalCount / pageSize;
                    } else {
                        totalPages = parseInt(resp.totalCount / pageSize) + 1;
                    }

                    $("#page").bs_pagination({
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
                            queryContactsForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        },

                    });
                }

            });
        }

    </script>
</head>
<body>


<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog"  >
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建联系人</h4>
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
                                   placeholder="支持自动补全，输入客户不存在则新建">
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
                                <input type="text" class="form-control date" id="create-nextContactTime" readonly>
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

<!-- 修改联系人的模态窗口 -->
<div class="modal fade" id="editContactsModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <!--设置一个隐藏标签，用来存放id，供后面修改数据时操作-->
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-source" class="col-sm-2 control-label">来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="李四">
                        </div>
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellation}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-customerId" class="col-sm-2 control-label">客户名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control customerSearch" id="edit-customerId"
                                   placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条联系人的描述信息</textarea>
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
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditContactsBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>联系人列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">姓名</div>
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="customerName">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">地址</div>
                        <input class="form-control" type="text" id="address">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createConBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editConBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delConBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 20px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>姓名</td>
                    <td>客户名称</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>地址</td>
                </tr>
                </thead>
                <tbody id="conBody">
                </tbody>
            </table>
        </div>

        <%--		--%>

        <div id="page"></div>
    </div>

</div>
</body>
</html>