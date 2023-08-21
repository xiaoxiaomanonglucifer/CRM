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

        $(function () {
            $("#createBtn").click(function () {
                window.location.href = 'workbench/transaction/toSaveIndex';
            });


            $("#editBtn").click(function () {
                var checkId = $("#tBody input[type='checkbox']:checked");
                if (checkId.size() > 1) {
                    alert("一次只能修改一次~");
                    return;
                }
                if (checkId.size() == 0) {
                    alert("请选择你要修改的~");
                    return;
                }
                var id = checkId.val();
                window.location.href = 'workbench/transaction/toEditIndex?id=' + id;
            });
            //页面一加载就查询
            queryTranByConditionForPage(1, 10);
            $("#searchBtn").click(function () {
                queryTranByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
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

            $("#delTranBtn").click(function () {

                //获取id
                var checkIds = $("#tBody input[type='checkbox']:checked");
                if (checkIds.size() == 0) {
                    alert("请选择 ~");
                    return;
                }
                if (window.confirm("你确定要删除吗~")) {
                    var id = "";
                    $.each(checkIds, function () {
                        id = "id=" + this.value + "&";
                    });
                    id = id.substr(0, id.length - 1);
                    $.ajax({
                        url: 'workbench/transaction/deleteTranByIds',
                        data: id,
                        dataType: 'JSON',
                        type: 'POST',
                        success: function (resp) {
                            if (resp.code == "1") {
                                queryTranByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
                            } else {
                                alert(resp.message);
                            }
                        }
                    });
                }
            });
        });

        function queryTranByConditionForPage(pageNo, pageSize) {
            var owner = $.trim($("#owner").val());
            var name = $.trim($("#name").val());
            var customerId = $.trim($("#customerName").val());
            var stage = $("#stage option:selected").text();
            var type = $("#type option:selected").text();
            var source = $("#source option:selected").text();
            var contactsId = $.trim($("#contactsName").val());

            $.ajax({
                url: 'workbench/transaction/queryTranByConditionForPage',
                type: 'POST',
                dataType: 'JSON',
                data: {
                    owner: owner,
                    name: name,
                    customerId: customerId,
                    stage: stage,
                    type: type,
                    source: source,
                    contactsId: contactsId,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp.tranList, function (i, e) {
                        htmlStr += ' <tr>\n' +
                            '                    <td><input type="checkbox" value="' + e.id + '" /></td>\n' +
                            '                    <td><a style="text-decoration: none; cursor: pointer;"\n' +
                            '                          onclick="window.location.href=\'workbench/transaction/toDetailIndex?id=' + e.id + '\';">' + e.name + '</a></td>\n' +
                            '                    <td>' + e.customerId + '</td>\n' +
                            '                    <td>' + e.stage + '</td>\n' +
                            '                    <td>' + e.type + '</td>\n' +
                            '                    <td>' + e.owner + '</td>\n' +
                            '                    <td>' + e.source + '</td>\n' +
                            '                    <td>' + e.contactsId + '</td>\n' +
                            '                </tr>'
                    });
                    $("#tBody").html(htmlStr);
                    $("#checkAll").prop("checked", false); // 换页时将全选按钮取消选中
                    var totalPages = 1;
                    if (resp.totalCount % pageSize == 0) {
                        totalPages = resp.totalCount / pageSize;
                    } else {
                        totalPages = resp.totalCount / pageSize + 1;
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
                            queryTranByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        },
                    });

                }
            });
        }

    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
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
                        <div class="input-group-addon">名称</div>
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
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="stage">
                            <option></option>
                            <c:forEach items="${stageList}" var="stage">
                                <option value="${stage.id}">${stage.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="type">
                            <option></option>
                            <c:forEach items="${transactionTypeList}" var="tran">
                                <option value="${tran.id}">${tran.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

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
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="contactsName">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delTranBtn"><span
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
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tBody">
                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>

</body>

</html>