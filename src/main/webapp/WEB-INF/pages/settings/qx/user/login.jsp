<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	//动态获取路径
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
	<%--<script type="text/javascript" src="../../../jquery/jquery-1.11.1-min.js"></script>--%>
	<script type="text/javascript" src="${pageContext.request.contextPath}/jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function () {
				$(window).keydown(function (e) {
					if(e.keyCode==13){
						$("#loginBtn").click()
						//按回车登录
					}
				});

			$("#loginBtn").click(function () {
<%--				<%=	 System.out.println("路径等于"+request.getContextPath())%>--%>
				//获取参数
				var loginAct = $.trim($("#loginAct").val());//$.trim()防止用户输入有空格
				var loginPwd = $.trim($("#loginPwd").val());
				var isRemPwd = $("#isRemPwd").prop("checked");
				//验证参数是否合法
				if (loginAct == "") {
					alert("用户名不能为空");
					return;
				}
				if (loginPwd == "") {
					alert("密码不能为空~");
					return;
				}
				// $("#msg").html("正在验证~");
				//异步发送请求
				$.ajax({
					url: 'settings/qx/user/login',
					data: {
						loginAct:loginAct,//紫色的参数名要和后端controller接受参数的名称一致
						loginPwd:loginPwd,
						isRemPwd:isRemPwd
					},
					type:'post',
					dataType:'json',
					success:function (resp) {
						if(resp.code=="1"){
							//登陆成功 不能直接跳到在WEB-INF目录下的index.jsp，要通过controller映射
							window.location.href="workbench/toIndex";
						}else{
							$("#msg").html(resp.message);
						}
					},
					beforeSend:function () {//当ajax向后台发送请求之前，会自动执行此函数、若该函数为true则发送ajax请求
						$("#msg").html("正在验证~");
						return true;
					}
				})
			})
		});


	</script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
	<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
	<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
		CRM &nbsp;<span style="font-size: 12px;">&copy;2023&nbsp;DGUT</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
	<div style="position: absolute; top: 0px; right: 60px;">
		<div class="page-header">
			<h1>登录</h1>
		</div>
		<form action="workbench/index.html" class="form-horizontal" role="form">
			<div class="form-group form-group-lg">
				<div style="width: 350px;">
					<input class="form-control" id="loginAct" type="text" placeholder="用户名" value="${cookie.loginAct.value}">
				</div>
				<div style="width: 350px; position: relative;top: 20px;">
					<input class="form-control" id="loginPwd" type="password" placeholder="密码"value="${cookie.loginPwd.value}">
				</div>
				<div class="checkbox" style="position: relative;top: 30px; left: 10px;">
					<label>
						<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
							<input type="checkbox" id="isRemPwd" checked> 十天内免登录
						</c:if>
						<c:if test="${ empty cookie.loginAct or  empty cookie.loginPwd}">
							<input type="checkbox" id="isRemPwd" > 十天内免登录
						</c:if>
					</label>
					&nbsp;&nbsp;
					<span id="msg" style="color: red"></span>
				</div>
				<%--因为submit是同步请求无论成功与否都会改变<button type="submit" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>--%>
				<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"
						style="width: 350px; position: relative;top: 45px;">登录
				</button>
			</div>
		</form>
	</div>
</div>
</body>
</html>