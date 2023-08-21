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
            queryClueByConditionForPage(1, 10);
            $(".nextContact").datetimepicker({
                language: 'zh-CN',//语言
                format: 'yyyy-mm-dd',//日期的格式
                minView: 'month',//可以选择的最小视图
                initialDate: new Date(),//初始化选择的日期
                autoclose: true,//设置选择完日期或者时间后是否自动关闭日历
                todayBtn: true,
                clearBtn: true//设置是否显示清空按钮
            });

            $("#createClueBtn").click(function () {
                $("#createClueModal").modal("show");
                $("#createClueForm")[0].reset();//重置表单
            });
            //为保存按钮添加添加单击事件
            $("#saveClueBtn").click(function () {
                //获取参数
                var owner = $("#create-clueOwner").val();
                var company = $.trim($("#create-company").val());
                var appellation = $("#create-call").val();
                var fullName = $.trim($("#create-surname").val());
                var job = $.trim($("#create-job").val());
                var email = $.trim($("#create-email").val());
                var phone = $.trim($("#create-phone").val());
                var website = $.trim($("#create-website").val());
                var mphone = $.trim($("#create-mphone").val());
                var state = $("#create-status").val();
                var source = $("#create-source").val();
                var description = $.trim($("#create-describe").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $.trim($("#create-address").val());
                //对参数进行判断
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司不能为空~");
                    return;
                }
                if (fullName == "") {
                    alert("姓名不能为空~");
                    return;
                }
                // var reg=/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
                // if(!reg.test(phone)){
                //     alert("不符合电话号码的格式~");
                //     return;
                // }
                $.ajax({
                    url: 'workbench/clue/saveClue',
                    data: {
                        fullname: fullName,
                        owner: owner,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address,
                        appellation: appellation
                    },
                    dataType: 'JSON',
                    type: 'POST',
                    success: function (resp) {
                        if (resp.code == "1") {
                            //1.关闭模态窗口
                            $("#createClueModal").modal("hide");
                            //2.刷新数据
                            queryClueByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert(resp.message);
                            $("#createClueModal").modal("show");
                        }

                    }
                });
            });
            //为查询按钮绑定事件
            $("#searchBtn").click(function () {
                queryClueByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));

            });
            //给全选加上事件
            $("#checkAllBtn").click(function () {
                if (this.checked) {
                    $("#clueListBody input[type='checkbox']").prop("checked", true);
                } else {
                    $("#clueListBody input[type='checkbox']").prop("checked", false);
                }
            });
            $("#clueListBody").on("click", function () {
                if ($("#clueListBody input[type='checkbox']:checked").size() == $("#clueListBody input[type='checkbox']").size()) {
                    $("#checkAllBtn").prop("checked", true);
                } else {
                    $("#checkAllBtn").prop("checked", false);
                }
            });
            //删除
            $("#deleteClueBtn").click(function () {
                var clueIds = $("#clueListBody input[type='checkbox']:checked");
                console.log(clueIds);
                if (clueIds.size() == 0) {
                    alert("请选择你要删除的线索~");
                    return;
                }
                //遍历clueIds数组，拼接
                if (window.confirm("你确定要删除吗~")) {
                    var id = "";
                    $.each(clueIds, function () {// id的格式为：id=xxx&id=xxx&id=xxx&id=xxx&id=xxx..
                        // 这个this是checkbox选择框dom对象
                        id += "id=" + this.value + "&"; // 这个id是怎么获取到的：checkbox的value值，在查询数据时将id值赋给了checkbox
                    })
                    id = id.substr(0, id.length - 1);

                    $.ajax({
                        url: 'workbench/clue/deleteClueByIds',
                        type: 'POST',
                        dataType: 'JSON',
                        data: id,
                        //data: {id:id}那么传过去的参数形式就是 id=xxx&id=xxx&id=xxx&id=xxx&id=xxx.. 方法中的参数就不能解析成 对应正确的参数形式
                        success: function (resp) {
                            if (resp.code == "1") {
                                alert("删除成功");
                                queryClueByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'))
                            } else {
                                alert(resp.message);
                            }
                        }
                    });
                }


            })
            //修改
            //点击修改按钮，打开模态窗口将原始数据展示到模态窗口中
            $("#editClueBtn").click(function () {
                var editId = $("#clueListBody input[type='checkbox']:checked");
                if (editId.size() == 0) {
                    alert("请选择你要修改线索~");
                    return;
                }
                if (editId.size() > 1) {
                    alert("一次只能修改一条喔~")
                    return;
                }
                // 获取选中的市场活动id,通过这个id查询对应的线索活动
                var id = editId.val();
                console.log(id)
                $.ajax({
                    url: 'workbench/clue/queryClueById',
                    type: 'POST',
                    dataType: 'JSON',
                    data: {
                        id: id
                    },
                    success: function (resp) {
                        console.log(resp)
                        $("#edit-id").val(resp.id);
                        $("#edit-clueOwner").val(resp.owner); // 通过设置value值（owner的id）循环遍历出来owner
                        $("#edit-company").val(resp.company);
                        $("#edit-call").val(resp.appellation);
                        $("#edit-fullname").val(resp.fullname);
                        $("#edit-job").val(resp.job);
                        $("#edit-email").val(resp.email);
                        $("#edit-phone").val(resp.phone);
                        $("#edit-website").val(resp.website);
                        $("#edit-mphone").val(resp.mphone);
                        $("#edit-state").val(resp.state);
                        $("#edit-source").val(resp.source);
                        $("#edit-describe").val(resp.description);
                        $("#edit-contactSummary").val(resp.contactSummary);
                        $("#edit-nextContactTime").val(resp.nextContactTime);
                        $("#edit-address").val(resp.address);
                        // 显示模态窗口
                        $("#editClueModal").modal("show");
                    }
                });
            });
            //点击更新按钮，获参数、传参数到后面、完成更新
            $("#updateClueBtn").click(function () {
            //获取参数
                var id = $("#edit-id").val(); // 隐藏input标签value值
                var fullname = $.trim($("#edit-fullname").val());
                var appellation = $("#edit-call").val();
                var owner = $("#edit-clueOwner").val();
                var company = $.trim($("#edit-company").val());
                var job = $.trim($("#edit-job").val());
                var email = $.trim($("#edit-email").val());
                var phone = $.trim($("#edit-phone").val());
                var website = $.trim($("#edit-website").val());
                var mphone = $.trim($("#edit-mphone").val());
                var state = $("#edit-state").val();
                var source = $("#edit-source").val();
                var description = $.trim($("#edit-describe").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $.trim($("#edit-nextContactTime").val());
                var address = $.trim($("#edit-address").val());
                $.ajax({
                    url:'workbench/clue/updateClueById',
                    type:'POST',
                    dataType:'JSON',
                    data:{
                        id:id,
                        fullname:fullname,
                        appellation:appellation,
                        owner:owner,
                        company:company,
                        job:job,
                        email:email,
                        phone:phone,
                        website:website,
                        mphone:mphone,
                        state:state,
                        source:source,
                        description:description,
                        contactSummary:contactSummary ,
                        nextContactTime:nextContactTime,
                        address:address
                    },
                    success:function (resp) {
                    if(resp.code=="1"){
                        // 关闭模态窗口
                        $("#editClueModal").modal("hide");
                        $("#checkAllBtn").prop("checked",false);
                        // 刷新线索列表，显示第一页数据，保持每页显示条数不变
                        queryClueByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),
                            $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
                    } else {
                        // 提示信息
                        alert(resp.message);
                        // 模态窗口不关闭
                        $("#editClueModal").modal("show");
                    }
                    }
                })
            })

        });

        function queryClueByConditionForPage(pageNo, pageSize) {
            var company = $("#companyForPage").val();
            var phone = $("#phoneForPage").val();
            var mphone = $("#myphoneForPage").val();
            var state = $("#stateForPage option:selected").text(); // 获取下拉框选中的线索状态
            var source = $("#sourceForPage option:selected").text(); // 获取下拉框选中的线索来源
            var owner = $("#ownerForPage").val();
            var name = $("#nameForPage").val();
            $.ajax({
                url: 'workbench/clue/queryClueByConditionForPage',
                data: {
                    company: company,
                    phone: phone,
                    mphone: mphone,
                    state: state,
                    source: source,
                    owner: owner,
                    name: name,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type: 'POST',
                dataType: 'JSON',
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp.clueList, function (i, e) {
                        htmlStr += '                           <tr>\n' +
                            '                                    <td><input  type="checkbox" value=' + e.id + ' /></td>\n' +
                            '                                    <td><a style="text-decoration: none; cursor: pointer;"\n' +
                            '                                           onclick="window.location.href=\'workbench/clue/toDetailIndex?id='+e.id+'\';">' + e.fullname + '</a></td>\n' +
                            '                                    <td>' + e.company + '</td>\n' +
                            '                                    <td>' + e.phone + '</td>\n' +
                            '                                    <td>' + e.mphone + '</td>\n' +
                            '                                    <td>' + e.source + '</td>\n' +
                            '                                    <td>' + e.owner + '</td>\n' +
                            '                                    <td>' + e.state + '</td>\n' +
                            '                                </tr>'

                    });
                    $("#clueListBody").html(htmlStr);
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
                            queryClueByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        },
                    });
                }
            });
        }
    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createClueForm">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                                <%--									  <option>zhangsan</option>--%>
                                <%--									  <option>lisi</option>--%>
                                <%--									  <option>wangwu</option>--%>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <%--                                <option value="先生">先生</option>--%>
                                <%--                                <option value="夫人">夫人</option>--%>
                                <%--                                <option value="女士">女士</option>--%>
                                <%--                                <option value="博士">博士</option>--%>
                                <%--                                <option value="教授">教授</option>--%>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-status">
                                <option></option>
                                <%--                                <option value="试图联系">试图联系</option>--%>
                                <%--                                <option value="将来联系">将来联系</option>--%>
                                <%--                                <option value="已联系">已联系</option>--%>
                                <%--                                <option value="虚假线索">虚假线索</option>--%>
                                <%--                                <option value="丢失线索">丢失线索</option>--%>
                                <%--                                <option value="未联系">未联系</option>--%>
                                <%--                                <option value="需要条件">需要条件</option>--%>
                                <c:forEach items="${clueStateList}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <%--                                <option value="广告">广告</option>--%>
                                <%--                                <option value="推销电话">推销电话</option>--%>
                                <%--                                <option value="员工介绍">员工介绍</option>--%>
                                <%--                                <option value="外部介绍">外部介绍</option>--%>
                                <%--                                <option value="在线商场">在线商场</option>--%>
                                <%--                                <option value="合作伙伴">合作伙伴</option>--%>
                                <%--                                <option value="公开媒介">公开媒介</option>--%>
                                <%--                                <option value="销售邮件">销售邮件</option>--%>
                                <%--                                <option value="合作伙伴研讨会">合作伙伴研讨会</option>--%>
                                <%--                                <option value="内部研讨会">内部研讨会</option>--%>
                                <%--                                <option value="交易会">交易会</option>--%>
                                <%--                                <option value="web下载">web下载</option>--%>
                                <%--                                <option value="web调研">web调研</option>--%>
                                <%--                                <option value="聊天">聊天</option>--%>
                                <c:forEach items="${sourceList}" var="sourceState">
                                    <option value="${sourceState.id}">${sourceState.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
                                <input type="text" class="form-control nextContact" readonly
                                       id="create-nextContactTime">
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
                <button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <!--设置一个隐藏标签，用来存放id，供后面修改数据时操作-->
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <%--                                <option>zhangsan</option>--%>
                                <%--                                <option>lisi</option>--%>
                                <%--                                <option>wangwu</option>--%>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
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
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
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
                <button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="nameForPage">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="companyForPage">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="phoneForPage">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="sourceForPage">
                            <option></option>
                            <%--                            <option value="广告">广告</option>--%>
                            <%--                            <option value="推销电话">推销电话</option>--%>
                            <%--                            <option value="员工介绍">员工介绍</option>--%>
                            <%--                            <option value="外部介绍">外部介绍</option>--%>
                            <%--                            <option value="在线商场">在线商场</option>--%>
                            <%--                            <option value="合作伙伴">合作伙伴</option>--%>
                            <%--                            <option value="公开媒介">公开媒介</option>--%>
                            <%--                            <option value="销售邮件">销售邮件</option>--%>
                            <%--                            <option value="合作伙伴研讨会">合作伙伴研讨会</option>--%>
                            <%--                            <option value="内部研讨会">内部研讨会</option>--%>
                            <%--                            <option value="交易会">交易会</option>--%>
                            <%--                            <option value="web下载">web下载</option>--%>
                            <%--                            <option value="web调研">web调研</option>--%>
                            <%--                            <option value="聊天">聊天</option>--%>
                            <c:forEach items="${sourceList}" var="sourceState">
                                <option value="${sourceState.id}">${sourceState.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="ownerForPage">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="myphoneForPage">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="stateForPage">
                            <option></option>
                            <%--                            <option value="试图联系">试图联系</option>--%>
                            <%--                            <option value="将来联系">将来联系</option>--%>
                            <%--                            <option value="已联系">已联系</option>--%>
                            <%--                            <option value="虚假线索">虚假线索</option>--%>
                            <%--                            <option value="丢失线索">丢失线索</option>--%>
                            <%--                            <option value="未联系">未联系</option>--%>
                            <%--                            <option value="需要条件">需要条件</option>--%>
                            <c:forEach items="${clueStateList}" var="clueState">
                                <option value="${clueState.id}">${clueState.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createClueBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editClueBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"
                ></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAllBtn"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueListBody">
                <%--                                <tr>--%>
                <%--                                    <td><input type="checkbox"/></td>--%>
                <%--                                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                                           onclick="window.location.href='detail.jsp';">李四先生</a></td>--%>
                <%--                                    <td>动力节点</td>--%>
                <%--                                    <td>010-84846003</td>--%>
                <%--                                    <td>12345678901</td>--%>
                <%--                                    <td>广告</td>--%>
                <%--                                    <td>zhangsan</td>--%>
                <%--                                    <td>已联系</td>--%>
                <%--                                </tr>--%>
                <%--                <tr class="active">--%>
                <%--                    <td><input type="checkbox"/></td>--%>
                <%--                    <td><a style="text-decoration: none; cursor: pointer;"--%>
                <%--                           onclick="window.location.href='detail.jsp';">李四先生</a></td>--%>
                <%--                    <td>动力节点</td>--%>
                <%--                    <td>010-84846003</td>--%>
                <%--                    <td>12345678901</td>--%>
                <%--                    <td>广告</td>--%>
                <%--                    <td>zhangsan</td>--%>
                <%--                    <td>已联系</td>--%>
                <%--                </tr>--%>
                </tbody>
            </table>
            <div id="demo_pag1"></div>
        </div>

        <%--        <div style="height: 50px; position: relative;top: 60px;">--%>
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
</body>
</html>