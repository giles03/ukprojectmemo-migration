<%@ page language= "java"%>

<%@page import="com.sonybmg.struts.pmemo3.model.*,java.util.*,com.sonybmg.struts.pmemo3.db.*"%>



<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
	<link rel="stylesheet" href="/pmemo3/css/index.css" type="text/css" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">






<script type="text/javascript">
function disableButton()
{

var myButton = document.getElementById('dummy');
var myDeleteButton = document.getElementById('dummy2');


}


function submitform()
{
	
document.forms[0].elements['img'].value='Insert';
document.forms[0].submit();
  
}









</script>




<html:html>
  <head>
    <title>Add Tracks</title>
  </head>
 
  <body>
  <div align="right" style="float: right; color: blue; font-size: 22px"><a href="/pmemo3/myMemo_Online Help_files/slide0861.htm" target="_blank"><img src="/pmemo3/images/help_smaller.gif" border='0'></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
  
	 <strong>TRACKLISTING - Add/ Edit Details</strong>	
	<br><br>
	<left><a href="/pmemo3/enter.do"><img src="/pmemo3/images/myMemo3.jpg" border='0'></a></left>
	<br>
	<br>
 	 <%String currentForm = "";
			ProjectMemoDAO pmDAO = null;
			Integer parsedTrackNum = null;
			ArrayList trackList = null;
			ArrayList preOrderTracklisting = null;
			HashMap params = new HashMap();
			int counter = 0;
			int preOrderTrackCounter = 0;
			String preOrderTrackCounterAsString = null;
			//currentForm = (String) session.getAttribute("returningPage");
			ProjectMemo pm = (ProjectMemo) request.getAttribute("projectMemo");
			pmDAO = ProjectMemoFactoryDAO.getInstance();
			
			



			//request.setAttribute("fromTracksAction", "FROM_TRACKS");
			
			if(request.getAttribute("anchor")!=null){%>
			
			
			
			<script>document.location='#pageBottom';</script>
			<%} 
			
			if(session.getAttribute("preOrderTracklisting")!=null){
				
			
				preOrderTracklisting = (ArrayList)session.getAttribute("preOrderTracklisting");	
						
			}
			if (preOrderTracklisting!=null) {
				
				//trackList = (ArrayList) session.getAttribute("trackList");	
				
				// PreOrder track ordering needs to be assigned dynamically using the size of the trackList

				preOrderTrackCounter = trackList.size()+1;	
				
				preOrderTrackCounterAsString= preOrderTrackCounter+"";	
									
			
			} 
			
			
			if (session.getAttribute("trackList")!=null){
				trackList = (ArrayList) session.getAttribute("trackList");	
			} else{
				trackList = new ArrayList();	
			}	
				
				if (session.getAttribute("trackList")!=null){
				trackList = (ArrayList) session.getAttribute("trackList");	
			} 
			
			String formatDescription = (String)request.getAttribute("trackSummary");
	
			
			%> 
			

   	<strong>
   	&nbsp;&nbsp;Artist : <%=pm.getArtist()%><br>
	&nbsp;&nbsp;Title  : <%=pm.getTitle()%><br>
	&nbsp;&nbsp;Memo Ref  : <%=pm.getMemoRef()%><br>
	&nbsp;&nbsp;Format : <%=formatDescription%></strong>
 	
   		 
	<center><b>Tracklistings currently for this format (Click in a track to edit)</b></center>
   <br>
   	
<table width="100%" border="2" id="table-1" style="table-layout: fixed; border-collapse: collapse;">	
   <tr bgcolor="#eeeeee">
 	<td  width="5%">
	
 	</td>
 	 <td  width="3%">
	
 	</td>

 		<td width="4%" align="center">
 			<u>Track</u>
 		</td>
 		<td  width="35%" align="center">
 			<u>Track Name</u>
 		</td> 		
		
  		<td width="11%" align="center">
 			<u>ISRC Number</u>
 		</td>

		<%if (pm.getConfigurationId()!=null && pmDAO.isProductInMobile(pm.getConfigurationId())) {%>
			<td width="11%" align="center">
				<u>G Number</u>
					
			</td>
			<td width="24%" align="center">
				<u>Comments</u>
			</td>
			<%} else {%>

			<td width="36%" align="center">
				<u>Comments</u>
			</td>
			<%}%>
		</tr>	

   <%if (trackList != null) {

				Track track;
				Iterator iterator = trackList.iterator();

				while (iterator.hasNext()) {
					int trackToDelete = 2;
					track = (Track) iterator.next();

					++counter;

					parsedTrackNum = new Integer(track.getTrackOrder());
					String trackNumAsString = parsedTrackNum.toString();
					System.out.println("number as string =" + trackNumAsString);
					
					

	
	
	 
	

					%>
		<html:form name="myForm" method="POST" action="/editTrack.do" type="com.sonybmg.struts.pmemo3.form.TracksForm" >
			<tr>	
		   			<td align="center" valign="bottom" width="3%">
		   					<html:submit property="button" style="width: 0px;">Update</html:submit>
		   					<html:submit property="button" style="height: 18px;font-size:9;background: #dde6ec; border-style: thin" >Delete</html:submit>
		   			</td>		   			
		   			<%if ((trackList.size()>1) && track.getTrackOrder() != trackList.size()){%>
		   			<td align="center" valign="bottom" width="3%">		
		   			<html:submit property="button" style="height:18px;font-size:9;background: #dde6ec; border-style: thin" >ins</html:submit>   				
		   			</td>
		   			<%}else{%>
		   			<td align="center" valign="bottom" width="7%">		   						   					 
		   			</td>
		   			<%}%>
		   			<td align = "center">	   		
		   				<%=trackNumAsString%>
		   				<html:hidden property="trackOrder" value="<%=trackNumAsString%>" />	
		   			</td>
		   			<td >		   		
		   				<html:text property="trackName" size="68" maxlength="100" value="<%=track.getTrackName()%>"  onchange="submit()" onmouseout="submit()" ></html:text>		   				
		   			</td>
		   			<td>		   		
		   				<html:text property="isrcNumber" size="17" maxlength="20" value="<%=track.getIsrcNumber()%>" onchange="submit()" onmouseout="submit()" ></html:text>
		   			</td>
				    <%if (pm.getConfigurationId()!=null && pmDAO.isProductInMobile(pm.getConfigurationId())) {%>
		   			<td>		   		
		   				<html:text property="gridNumber" size="17" maxlength="20" value="<%=track.getGridNumber()%>" onchange="submit()" onmouseout="submit()" ></html:text>
		   			</td>		   			
		   			<td>		   		
		   				<html:text property="comments" size="55" maxlength="200" value="<%= track.getComments() %>"  onchange="submit()" onmouseout="submit()"  ></html:text>		   			
		   			</td>	
		   			<%} else {%>
		   			<td>		   		
		   				<html:text property="comments" size="70" maxlength="200" value="<%= track.getComments() %>"  onchange="submit()" onmouseout="submit()"  ></html:text>		   			
		   			</td>
		   			<%} %>				
		   		</tr>		   		
		</html:form>
		   	<%}
			}%>
		
		<html:form name="myForm2" method="POST" action="/addNewTrack.do" type="com.sonybmg.struts.pmemo3.form.TracksForm">
		<tr valign="middle" height="35px">
		<td colspan="2" align="center"><html:submit style="height:20px;font-size:10;background: #dde6ec; border-style: thin" >Add Track</html:submit>
		</td>
		</tr>
		</html:form>
    </table>
    

    <%if(pm.getPreOrder()!=null &&  pm.getPreOrder().equals("Y")){
   
	%>
    <table width="100%" border="2" id="table-2" style="table-layout: fixed; border-collapse: collapse;">
    	
   <tr>
 	<td  width="5%">
	
 	</td>
 	 <td  width="3%">
	
 	</td>

 		<td width="4%" align="center">
 			<u></u>
 		</td>
 		<td  width="35%" align="center">
 			<u><b>Pre-Order Only Tracks</b></u>
 		</td> 		
		
  		<td width="11%" align="center">
 			<u></u>
 		</td>

		<%if (pm.getConfigurationId()!=null && pmDAO.isProductInMobile(pm.getConfigurationId())) {%>
			<td width="11%" align="center">									
			</td>
			<td width="24%" align="center">				
			</td>
			<%} else {%>

			<td width="36%" align="center">
			</td>
			<%}%>
		</tr>	

	<%

	    
    if (( preOrderTracklisting!=null ) && ( preOrderTracklisting.size()>0 )) {

				Track preOrderTrack;

				Iterator iterator = preOrderTracklisting.iterator();

				while (iterator.hasNext()) {
					
					preOrderTrack = (Track) iterator.next();
					
					parsedTrackNum = new Integer(preOrderTrack.getTrackOrder());
					String trackOrderAsString = preOrderTrackCounter+"";

	 %>

		<html:form name="editPreOrderTracksForm" method="POST" action="/editPreOrderTrack.do"  type="com.sonybmg.struts.pmemo3.form.TracksForm" >
			
			
			
			
				<tr>	
				
					
					
		   			<td align="center" valign="bottom" width="3%">
		   					<html:submit property="button" style="width: 0px;">Update</html:submit>
		   					<html:submit property="button" style="height: 18px;font-size:9;background: #dde6ec; border-style: thin" >Delete</html:submit>

		   			</td>		   			
		   		
		   			<td align="center" valign="bottom" width="3%">		
		   					<%System.out.println("preOrderTrackCounter = "+preOrderTrackCounter);
		   					  System.out.println("trackOrderAsString = "+trackOrderAsString);		   					
  		   					  System.out.println("preOrderTrackListing size = "+(preOrderTracklisting.size()+ (trackList.size())));
		   					if ( preOrderTrackCounter < (preOrderTracklisting.size() + trackList.size())){%>
		 		   			<html:submit property="button" style="height:18px;font-size:9;background: #dde6ec; border-style: thin" >ins</html:submit>   				 				
							<%}%> 
		   			</td>
		   		
		   			<td align = "center">	   		
		   				<%=preOrderTrackCounter%>
		   				<html:hidden property="trackOrder" value="<%=trackOrderAsString%>" />		
		   			</td>
		   			<td >		   		
		   				<html:text property="trackName" size="68" maxlength="100" value="<%=preOrderTrack.getTrackName()%>" onchange="submit();" ></html:text>		   				   			
	
		   			</td>
		   			<td>		   		
		   				<html:text property="isrcNumber" size="17" maxlength="20" value="<%=preOrderTrack.getIsrcNumber()%>" onchange="submit()" ></html:text>		   				
		   			</td>
		   			 <%if (pm.getConfigurationId()!=null && pmDAO.isProductInMobile(pm.getConfigurationId())) {%>
		   			<td>		   		
		   				<html:text property="gridNumber" size="17" maxlength="20" value="<%=preOrderTrack.getGridNumber()%>" onchange="submit()" ></html:text>
		   			</td>		   			
		   			<td>		   		
		   				<html:text property="comments" size="55" maxlength="200" value="<%= preOrderTrack.getComments() %>" onchange="submit()"  ></html:text>		   			
		   			</td>	
		   			<%} else {%>
		   			<td>		   		
		   				<html:text property="comments" size="70" maxlength="200" value="<%= preOrderTrack.getComments() %>" onchange="submit()"  ></html:text>		   			
		   			</td>

		   			<%} %>	
		   			
		   			
		   			
			
		   		</tr>
			
			</html:form>
			
			<% preOrderTrackCounter++;
			}}%>	
				
					
		   		
		
	
		
		<html:form name="myForm4" method="POST" action="/addNewPreOrderTrack.do" type="com.sonybmg.struts.pmemo3.form.TracksForm">
		<tr valign="middle" height="35px">
		<td colspan="2" align="center"><html:submit style="height:20px;font-size:8;background: #dde6ec; border-style: thin" >Add Pre-Order</html:submit>
		</td>
		</tr>
		</html:form>
    </table>
    <%}%>
    
  

    
      
       <table align="center">
       <tr>
       <td>
       <br><br>
      <%-- <html:link action="/addNewTrack.do">Add Track</html:link>&nbsp; &nbsp;  &nbsp;    --%>
      <a name="pagebottom"></a>
       <html:link action="/deleteAllTracks.do" onclick="return confirm('This will delete all tracks. Continue?')"><img src="/pmemo3/images/deletealltrcks.jpg" border='0'/></html:link> &nbsp;&nbsp;        
       <html:link action="/saveTracks.do"><img src="/pmemo3/images/saveandreturn.jpg" border='0'/></html:link> &nbsp;&nbsp; 
      <%if(formatDescription.contains("Physical Format")){ 
      				params.put("memoRef", pm.getMemoRef());	
					params.put("formatId",pm.getPhysFormat());
					params.put("revNo", pm.getRevisionID());
					params.put("detailId", pm.getDetailId());					
					pageContext.setAttribute("paramsName", params);%>					
       <html:link action="/editPhysicalDraft.do" name="paramsName"><img src="/pmemo3/images/cancelandrtrn.jpg" border='0'/></html:link>
          
       <%} else if(formatDescription.contains("Digital Format")){ 
      				params.put("memoRef", pm.getMemoRef());	
					params.put("formatId",pm.getConfigurationId());
					params.put("revNo", pm.getRevisionID());
					params.put("detailId", pm.getDigitalDetailId());					
					pageContext.setAttribute("paramsName", params);%>					
       <html:link action="/editDigitalDraft.do" name="paramsName"><img src="/pmemo3/images/cancelandrtrn.jpg" border='0'/></html:link>
        <%} %>
       </td>
       </tr>
       </table>
        
       
  </body>
</html:html> 
