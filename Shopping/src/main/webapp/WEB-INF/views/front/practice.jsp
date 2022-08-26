<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%
	String ctxPath = request.getContextPath();
%>   

<style type="text/css">
	div#large {
		background-color: red;
	}
	div#small {
		background-color: blue;
	}
</style>

<script type="text/javascript">

</script>

<div id="large" class="row" style="width: 90%; margin: auto; text-align: center;">
	<h1>여기는 큰 곳입니다.</h1>
    <div id="small" class="col-md-12">안녕</div>
    <div id="small" class="col-md-4">하</div>
    <div id="small" class="col-md-4">세</div>
    <div id="small" class="col-md-4">요</div>
</div>