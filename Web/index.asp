<!-- #include file="inc/WebSvcURL.asp" -->
<!-- #include file="inc/function.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>江西科技师范大学教学工作量查询系统</title>
<link href="images/style.css" type="text/css" rel="stylesheet"/>
<SCRIPT language=javascript src="images/image.js"></SCRIPT>
<!-- #include file="inc/security.asp" -->
<%
    Dim TeacherNo,TeacherSfzh,XmlStuInfo,TeacherName,HintInfo
   
	'通过职工号获取工作量信息
	If Request.Cookies("TeacherNo")<>"" Then  
	 	TeacherNo=Request.Cookies("TeacherNo")
	 	TeacherName=Request.Cookies("TeacherName")
	End If
%>
</head>
<body onload="MM_preloadImages('images/exit.gif')">
<!--头部 -->
<DIV id=top></DIV>
<DIV id=sidebar>
		<UL>
			<LI class=exit><A class=red title=退出 href="logout.asp">安全退出</A></LI>
			<LI class=home><A class=red title=回首页 href="index.asp">回首页</A></LI>
			<LI class=title style="BACKGROUND-IMAGE: none">欢迎使用教学工作量查询系统!</A></LI>
		</UL>
</DIV>
<!--网页主体 -->
<div id=main>
  <!--左边按钮 -->
	<DIV class=leftbox id=leftbg>
		<DIV class=left_btn><A onmouseover="MM_swapImage('Image1','','images/zzjf.gif',1)" onmouseout=MM_swapImgRestore() href="showjxgzl.asp"><IMG id=Image1 height=52 src="images/zzjf2.gif" width=173 border=0 name=Image1></A>		</DIV>
	  <br>
		<DIV class=left_btn><A onmouseover="MM_swapImage('Image5','','images/exit.gif',1)" onmouseout=MM_swapImgRestore() 
href="logout.asp"><a onmouseover="MM_swapImage('Image5','','images/exit.gif',1)" onmouseout=MM_swapImgRestore() 
href="logout.asp"><img id=Image5 height=52 src="images/exit2.gif" width=173 border=0 name=Image5 /></a></DIV>
  </DIV>
	<!--右边-->
  <DIV id=rightbox>
		<DIV id=r_top></DIV>
		<DIV id=r_data>
			<TABLE height=60 cellSpacing=1 cellPadding=1 width=698 align=center bgColor=#78a5cd border=0>
  			<TBODY>
  			<TR>
    			<TD bgColor=#f8fcfe>
      			<TABLE id=table_tip height=60 cellSpacing=0 cellPadding=5 width="100%" align=center border=0>
        			<TBODY>
        			<TR>
          			<TD width="10%" valign=top background=images/bg_tip.gif><IMG height=49 src="images/icon_tip.gif" width=48></TD>
          			<TD width="90%" background=images/bg_tip.gif>
						<SPAN class=f_14_orange><%= TeacherName %>&nbsp;老师:您好<br />
				    今天是&nbsp;<%=Format_Time(now,4)%>&nbsp;<%=GetWeekStr(now)%></SPAN><br />
						欢迎使用江西科技师范大学<span class="title" style="BACKGROUND-IMAGE: none">教学工作量查询系统！</span>						</p>
					 </TD>
					 </TR>
				  </TBODY>
				  </TABLE>
			</TD></TR></TBODY></TABLE>
					<br>
			<TABLE id=table_bullit  cellSpacing=0 cellPadding=0 width=698 align=center border=0>
  			<TBODY>
  			<TR>
    			<TD height=37>
      			<TABLE cellSpacing=0 cellPadding=0 width=100% border=0>
        		<TBODY>
						  <TR><TD width=70 height=30 class=f_14_orange  background="images/bg_title.gif"><img src="images/icon_tip.gif" alt="" width="48" height="49" /></TD>
						  			<TD width="626"  background="images/bg_title.gif" class=f_14_orange>最新通知</TD>
						  </TR>
							<%
							'获取最新4条公告信息
							Dim BullitInfo		
							BullitInfo=objSOAPClient.GetBullitInfo(4)

							Dim objBulXml,objBulNode,objBulAtr,nCntChd,nCntAtr
							Set objBulXml=Server.CreateObject("Microsoft.XMLDOM") 
							objBulXml.Async=False	
							
							If objBulXml.loadXML(BullitInfo) Then
							
								Set objBulNode = objBulXml.documentElement.selectSingleNode("//ROWDATA")
								nCntChd=objBulNode.ChildNodes.length-1 
	
								'遍历记录（节点）
								Dim j
								for j=0 to nCntChd
									set objBulAtr=objBulNode.ChildNodes.item(j) 		
								%>
									<TR height=25><TD>&nbsp;</TD>
										<TD><%=objBulAtr.GetAttributeNode("xF1").Value %>&nbsp;&nbsp;<%=StrtoDate(objBulAtr.GetAttributeNode("ActionTime").Value) %></TD>
									</TR> 
								<%
								next 
															
								Set objBulAtr=Nothing 
								Set objBulNode=Nothing 
								Set objBulXml=Nothing
								%>
			  <%
							Else
							%>
								<TR height=15><TD>&nbsp;</TD>
									<TD>暂无公告</TD>
								</TR>
							<%
							End If
							%>
								<TR height=25><TD>&nbsp;</TD>
									<TD>&nbsp;</TD>
								</TR>
             </TBODY>
						</TABLE>
					</TD>
      </TR></TBODY></TABLE><br />
<TABLE height=60 cellSpacing=1 cellPadding=1 width=698 align=center bgColor=#78a5cd border=0>
  			<TBODY>
  			<TR>
    			<TD bgColor=#f8fcfe>
      			<TABLE id=table_tip height=60 cellSpacing=0 cellPadding=5 width="100%" align=center border=0>
        			<TBODY>
        			<TR>
          			<TD width="10%" valign=top background=images/bg_tip.gif><IMG height=49 src="images/icon_tip.gif" width=48></TD>
          			<TD width="90%" background=images/bg_tip.gif>
							<p class=f_14_orange>使用帮助:</p>
							<%
							'获取帮助信息
							Dim HelpInfo,XmlFileName	
							HelpInfo=objSOAPClient.GetHelpInfo
                     %>
							<pre><%=HelpInfo%></pre>
					  </TD>
					</TR>
					</TBODY>
				  </TABLE>
			</TD></TR></TBODY></TABLE>			
		</DIV>		
		<DIV id=r_bottom></DIV>
	</DIV>
</DIV>
<DIV id=bottom>
	<TABLE class=f_12_white cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
  	<TBODY>
  		<TR>
    		<TD vAlign=center align=right width="15%" rowSpan=3><A href="http://www.hd315.gov.cn/beian/view.asp?bianhao= " target=_blank><IMG height=36 hspace=5 src="images/biaozhi.gif" width=30 border=0></A><!--备案信息--></TD>
    		<TD vAlign=center noWrap align=left width="85%">&copy; 版权所有 江西科技师范大学版权所有 &nbsp;&nbsp;&nbsp;<A href="#" target=_blank>联系我们</A> |  <A href="#" target=_blank>服务电话：0791-83831019</A> 
				</TD>
	</TR></TBODY></TABLE>
</DIV>
</body>
</html>