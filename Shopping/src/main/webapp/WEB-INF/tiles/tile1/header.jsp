<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.net.InetAddress"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ======= #27. tile1 중 header 페이지 만들기 (#26.번은 없다 샘이 장난침.) ======= --%>
<%
   String ctxPath = request.getContextPath();

   // === #193. (웹채팅관련3) === 
   // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) ===
   InetAddress inet = InetAddress.getLocalHost(); 
   String serverIP = inet.getHostAddress();
   
 //  System.out.println("serverIP : " + serverIP);
 // serverIP : 192.168.0.3 (학원)
   
   // String serverIP = "211.238.142.72"; 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다.
   
   // === 서버 포트번호 알아오기   ===
   int portnumber = request.getServerPort();
 //  System.out.println("portnumber : " + portnumber);
 // portnumber : 9090
   
   String serverName = "http://"+serverIP+":"+portnumber; 
 // System.out.println("serverName : " + serverName);
 // serverName :  http://192.168.0.3:9090 
%>
    <!-- 상단 네비게이션 시작 -->
   <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top mx-4 py-3">
      
      <div class="collapse navbar-collapse" id="collapsibleNavbar">
	  <li class="nav-item left login_dropdown">
	  		<a class="nav-link" id="navbar" role="button" aria-expanded="false" href="<%=ctxPath%>/index.dowell">DowellCommunity</a>	
	  </li>
      </div>
      <c:if test="${empty sessionScope.loginuser}">
	      	<li class="nav-item right login_dropdown">	
	      		<a class="nav-link" id="navbar" role="button" aria-expanded="false" href="<%=ctxPath%>/login.dowell">로그인(임시)</a>
	      	</li>
      </c:if>
      <!-- === #49. 로그인이 성공되어지면 로그인되어진 사용자의 이메일 주소를 출력하기 === -->
      <!--
	      <c:if test="${not empty sessionScope.loginuser}">
	         <div style="float: right;">
	           <span style="color: navy; font-weight: bold;">${sessionScope.loginuser.email}</span> 님 로그인중.. 
	         </div>
	      </c:if>
      -->   
   </nav>
   <!-- 상단 네비게이션 끝 -->
   

      <p class="h5" style="margin: auto; width: 90%;">
         <marquee> 하나씩 하나씩 천천히 해봅시다~</marquee>
        </p>

  