<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.net.InetAddress"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ======= #27. tile1 중 header 페이지 만들기 (#26.번은 없다 샘이 장난침.) ======= --%>
<%
   String ctxPath = request.getContextPath();
%>
    <!-- 상단 네비게이션 시작 -->
   <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top mx-4 py-3">
      <!-- Brand/logo --> 
      <a class="navbar-brand" href="<%= ctxPath %>/index.dowell" style="margin-right: 5%;"><span style="font-weight: bold;">두웰쇼핑몰</span></a>
      
      <!-- 아코디언 같은 Navigation Bar 만들기 -->
       <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
        <span class="navbar-toggler-icon"></span>
       </button>
      
      
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
	    <ul class="navbar-nav mr-auto">
		       <%-- 고객리스트 시작 --%>
		      <li class="nav-item">
		        <a class="nav-link " href="<%= ctxPath %>/customerList.dowell" id="navbar" role="button" aria-expanded="false">
		          	고객리스트
		        </a>
		      </li>
		      <%-- 고객리스트 끝 --%>
		       
		      <%-- 고객정보조회 시작 --%>
		      <li class="nav-item">
		        <a class="nav-link" href="<%= ctxPath %>/viewCustomer.dowell" id="navbar" role="button" aria-expanded="false">
		        	고객정보조회
		        </a>
		      </li>
		      <%-- 고객정보조회 끝 --%>
		      
		       <%-- 매장월별실적조회 시작 --%>
		       <li class="nav-item">
		        <a class="nav-link" href="<%= ctxPath %>/viewStorePerformance.dowell" id="navbar" role="button" aria-expanded="false">
		          	매장월별실적조회
		        </a>
		      </li>
		      <%-- 매장월별실적조회 끝 --%>
	      
	          <%-- 고객판매관리 시작 --%>
		      <li class="nav-item">
		        <a class="nav-link" href="<%= ctxPath %>/custSalManagement.dowell" id="navbar" role="button" aria-expanded="false">
		        	고객판매관리
		        </a>
		      </li>
		      <%-- 고객판매관리 끝 --%>
	      	  
	      <c:if test="${empty sessionScope.loginuser}">
	      	<li class="nav-item right">	
	      		<a class="nav-link" id="navbar" role="button" aria-expanded="false" href="<%=ctxPath%>/login.dowell">로그인(임시)</a>
	      	</li>
	      </c:if>
	    </ul>
	  </div>
      
      <!-- === #49. 로그인이 성공되어지면 로그인되어진 사용자의 이메일 주소를 출력하기 === -->
      <c:if test="${not empty sessionScope.loginuser}">
         <div style="float: right;">
         	<li class="nav-item dropdown login_dropdown">
              <a class="nav-link text-info" href="#" id="navbarDropdown" data-toggle="dropdown">
              		<img src="<%= ctxPath%>/resources/images/mu.png" id="memberProfile" />
              </a> 
              <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                  <a class="dropdown-item" href="<%=ctxPath%>/logout.dowell">로그아웃</a>
              </div>
              
            </li>
           
           <span style="color: navy; font-weight: bold;">${sessionScope.loginuser.USER_NM}</span> 님 환영합니다!
         </div>
      </c:if>
   </nav>
   <!-- 상단 네비게이션 끝 -->

  