<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@page import="com.sonybmg.struts.pmemo3.model.*,java.util.*,
				java.text.*,
				java.text.SimpleDateFormat,
				com.sonybmg.struts.pmemo3.db.*,
				com.sonybmg.struts.pmemo3.util.*,
				java.net.URLEncoder"%>



<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested"%>
<script>
<%--function showhide(id){
	if (document.getElementById){
		obj = document.getElementById(id);
			if (obj.style.display == "none"){
				obj.style.display = "block";
			} else {
				obj.style.display = "none";
			}
	}
}

--%>
function openDiv(anchor){
    window.location.href = anchor;
}
</script>

	<%		LinkedHashMap hPhysMap = null;		
			ProjectMemo pm2Details = null;
			String productLink;
			String counter = "";
			String pageLink = "";
			if (request.getAttribute("physicalDetails") != null) {
				hPhysMap = (LinkedHashMap) request.getAttribute("physicalDetails");			
				ProjectMemoDAO pmDAO = ProjectMemoFactoryDAO.getInstance();
				Iterator iter = hPhysMap.values().iterator();

			while (iter.hasNext()) {

				ProjectMemo pm3 = (ProjectMemo) iter.next();
				counter = "p"+pm3.getPhysicalDetailId();
				pageLink = "#"+counter;
				ArrayList tracks = pmDAO.getPhysicalTrackDetailsForView(pm3.getMemoRef(), pm3.getPhysicalDetailId());
				String format = pmDAO.getSpecificProductFormat(pm3.getPhysFormat());
				String priceLine = pmDAO.getSpecificPriceLine(pm3.getPhysPriceLine());
				String packSpec = pmDAO.getSpecificPackagingSpec(pm3.getPhysPackagingSpec());
				Date date = java.sql.Date.valueOf(pm3.getPhysReleaseDate().substring(0, 10));
				DateFormat dateFormat = DateFormat.getDateInstance();
				SimpleDateFormat sf = (SimpleDateFormat) dateFormat;
				sf.applyPattern("dd-MMMM-yyyy");
				String modifiedReleaseDate = dateFormat.format(date);
				String modifiedRestrictDate = "";
				String modifiedCustRestrictDate = "";
				String isrcNumber = "    T.B.C    ";
				FormHelper fh = new FormHelper();
				productLink = "";
				String comments = "";
	  			String userName;
				String userRole = "";					
				UserDAO uDAO = UserDAOFactory.getInstance();			
					ProjectMemoUser user = null;
		  			
					if(session.getAttribute("user") != null) {
				 		user =  (ProjectMemoUser) session.getAttribute("user");
					}		
			 		userName = user.getId();
			 		userRole = user.getRole();
					ProjectMemoUser currentEditingUser = null;		  			
					String userId = fh.getUserIdFromLatestDraft(pm3.getMemoRef());
					currentEditingUser = uDAO.getAnyUserFromUsername(userId);
				    
	
					//Build the link text for the hide/show functionality on the view page
					
					if(pm3.getCatalogNumber()!=null){
					    productLink = productLink + pm3.getCatalogNumber()+" ";
					} 
					  if(pm3.getSupplementTitle()!=null){
					    productLink = productLink+pm3.getSupplementTitle()+" ";
					}    
					 //there will always be a format so no if statement required
					productLink = productLink+format;
					%>
<a href="#" onclick="showhide('<%=counter%>'); openDiv('<%=pageLink%>'); return false;"><span style="color:green;"><%=productLink%></span></a>
<span id="<%=counter%>" style="display:none">

	<table align="center" width="95%" border="1">
	<a href="#<%=pageLink%>" name="p<%=pm3.getPhysicalDetailId()%>"></a>
		<tr>
			<td width="25%">
				
				<table align="left" width="320px">
				
		<%
		if ((pm3.getSupplementTitle() != null)
							&& (!pm3.getSupplementTitle().equals("null"))) {
	%>
	<tr valign="top">
	<td>	
		<span style='white-space: nowrap'>Product Title:</span>
	</td>
	<td colspan="2"><%=pm3.getSupplementTitle()%></td></tr>	
	<%}
	if ((pm3.getAdditTitle() != null)
				&& (!pm3.getAdditTitle().equals("null"))) {
	%>
	<tr valign="top">
	<td>	
	<span style='white-space: nowrap'>Product Comments</span>
	</td>
	<td colspan="2"><%=pm3.getAdditTitle()%>
	</td>
	</tr>
	<%} %>	
	
	<tr>				
					<tr>
						<td colspan="2">
<% if ((fh.isMemoCurrentlyBeingEdited(pm3.getMemoRef()).equals("Y") && (!fh.isCurrentUserEditingDraft(pm3.getMemoRef(),userName)))
	|| (userRole.equals(Consts.VIEW))) {%>
			
								Format: <b><%=format%></b>
				
	<%} else { 
				    HashMap editParams = new HashMap();
					editParams.put("memoRef", pm3.getMemoRef());
					editParams.put("formatType", "p"+pm3.getPhysicalDetailId());					
					pageContext.setAttribute("editParams", editParams);
	%>
	
			    Format: <html:link action="/onePageLink.do" name="editParams"><%=format%></html:link> 
						</td>
					</tr>			    
								    
	<%} if ((format.equals("CD/DVD")) || (format.equals("DVD")) || (format.equals("Boxset"))){%>
		
					<tr>
						<td>
							<span style='white-space: nowrap'>DVD Format:</span>
						</td>
						<td>
						
							<span style='white-space: nowrap'><strong><%=pm3.getDvdFormat()==null ? "T.B.C." : pm3.getDvdFormat()%></strong></span>
						</td>
					</tr>	
					<tr>
						<td>
							<span style='white-space: nowrap'>Region Code:</span>
						</td>
						<td>
							<span style='white-space: nowrap'><strong><%=pm3.getRegionCode()==null ? "T.B.C." : pm3.getRegionCode() %></strong></span>
						</td>
					</tr>
		
	<%}%>
	
					
					<tr>
						<td>
							<span style='white-space: nowrap'>Release Date:</span>
						</td>
						<td>

							<span style='white-space: nowrap'><strong><%=modifiedReleaseDate%></strong></span>
						</td>
					</tr>
						<tr valign="top">
					<td>	
						<span style='white-space: nowrap'>Schedule in GRPS?</span>
					</td>
					<td><strong>	
						<%if ((pm3.getPhysScheduleInGRPS()==null)||(pm3.getPhysScheduleInGRPS().equals(""))) {%>
						<span style='font-size: 13'>T.B.C</span>
						<%} else if (pm3.getPhysScheduleInGRPS().equals("Y")){%>
							<span style='color:GREEN'>YES</span>
						<%} else{ %>
						<span style='color:RED;font-size: 13'>NO</span>	
						</strong>
						<%} %>
					</td>						
					</tr>	
					<tr>
					<td>	
						<span style='white-space: nowrap'>GRAS Confidential?</span>
					</td>	
				
					<td>	
						<strong>
					<%
						if (pm3.isGrasConfidentialPhysicalProduct()) {
							%>
							<span style='color:RED;'>YES</span>	
						<%
							} else {
						%>
							<span style='color:GREEN'>NO</span>	
						<%
							}
						%>	
						</strong>		
					</td>
					</tr>						
					<tr>
						<td>
							<span style='white-space: nowrap'>Catalogue Number:</span>
						</td>
						<td>

							<%if (pm3.getCatalogNumber() == null) {%>
							<span style="color:red">T.B.C.</span>
							<%} else {%>
							<%=pm3.getCatalogNumber()%>&nbsp;<a href='https://prod.smedx.net/dxWeb/#Product:<%=pm3.getCatalogNumber()%>' target='_blank'><img src="/pmemo3/images/dx_link_small.png" border="0"/></a>
							<%}%>

						</td>
					</tr>
					<tr>
						<td>
							<span style='white-space: nowrap'>Local Catalogue Number:</span>
						</td>

						<td>


							<%if (pm3.getLocalCatNumber() == null) {%>
							<span style="color:red">T.B.C.</span>
							<%} else {%>
							<span style='white-space: nowrap'><strong><%=pm3.getLocalCatNumber()%></strong></span>
							<%}%>


						</td>
					</tr>
					<tr>
						<td valign="top">
							<span style='white-space: nowrap'>Barcode:</span>
						</td>
						<td colspan="2">
							<%if ((pm3.getPhysicalBarcode() != null) && (!pm3.getPhysicalBarcode().equals("null"))) {%>
							<%=pm3.getPhysicalBarcode()%>
							<%}%>
					</tr>
			<%  if (pm3.getAssociatedDigitalFormatDetailId() != null) { 
			
			  
				String digiEquiv = (ProjectMemoFactoryDAO.getInstance().returnLinkedDigitalGNum(pm3.getMemoRef(),pm3.getRevisionID(),pm3.getAssociatedDigitalFormatDetailId()));					
				String resultToPrint = (digiEquiv != null ? digiEquiv : ""); %>
					
					<tr>
						<td valign="top">
							<span style='white-space: nowrap'>Digital Equivalent Number</span>
						</td>
						<td>
							
							<strong><%=resultToPrint%></strong>
							 					
						</td>
					</tr>
					
				<%} %>	
				
				
				
					<tr>
					<td>	
						Exclusive :
					</td>
					<td><strong>
					
						<%
								if (pm3.isExclusive()) {
							%>
							<img src="/pmemo3/images/tickmark.jpg" border='0'>
						<%
							} else {
						%>
							<img src="/pmemo3/images/cross_ic.jpg" border='0'>
						<%
							}
						%>	
						</strong>
					</td>
					</tr>
						<%
							if (pm3.isExclusive()) {
						%>
						<tr>
							<td>
								Exclusive to:
							</td>
							<td>
								<strong> <%
				 	if (pm3.getExclusiveTo() != null) {
				 %> <span style='white-space: nowrap'><%=pm3.getExclusiveTo()%></span> <%
				 	} else {
				 %> <%
				 	}
				 %> </strong>
					</td>
				</tr>

				<tr>
					<td>
						<span style='white-space: nowrap'>Exclusivity Details:</span>
					</td>
					<td>
					<strong> <%
				 	if (pm3.getExclusivityDetails() != null) {
				 %> <%=pm3.getExclusivityDetails()%> <%
				 	} else {
				 %> <%
				 	}
				 %> </strong>
					</td>
					</tr>
				<%
					}
						
					if (pm3.isExplicit()) {	%>					
					<tr>
						<td>	
						Explicit :
					   </td>
						<td><strong>
								<img src="/pmemo3/images/parental_advisory_thumb.jpg" border='0'>
							</strong>
						</td>
					</tr>	
					<%}%>	
				<tr>
					<td>
						<span style='white-space: nowrap'>Price Line:</span>
					</td>
					<td>
						<%=priceLine%>
					</td>
				</tr>
				<tr>
						<td>
							<span style='white-space: nowrap'>Packaging Spec:</span>
						</td>
						<td>
							<span style=" font-size:13px"><%=packSpec%></span>
						</td>
					</tr>
					<tr>
						<td>
							<span style='white-space: nowrap'>Physical Import:</span>
						</td>
						<td>

							<%if (pm3.isPhysImport()) {%>
							<img src="/pmemo3/images/tickmark.jpg" border='0'>
							<%} else {%>
							<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>
						</td>
					</tr>
					<tr>
						<td>
							<span style='white-space: nowrap'>VMP:</span>
						</td>
						<td>

							<%if (pm3.isVmp()) {%>
							<img src="/pmemo3/images/tickmark.jpg" border='0'>
							<%} else {%>
							<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>
						</td>
					</tr>					
					<tr>
						<td>
							<span style='white-space: nowrap'>UK Sticker:</span>
						</td>
						


						<%if (pm3.isPhysUkSticker()) {%>
						<td>
							<img src="/pmemo3/images/tickmark.jpg" border='0'>
						</td>
					</tr>
					<tr>
						<td>
							<span style='white-space: nowrap'>Sticker Position:</span>
						</td>
						
						<td>	
							<strong><%= pmDAO.getStringFromId(pm3.getPhysStickerID(), "SELECT STICKER_POS_DESC FROM PM_UK_STICKER_POSITION WHERE STICKER_POS_ID=")%>
							</strong>
						</td>	
					</tr>
					<tr>
						<td>
							<span style='white-space: nowrap'>Init. Manuf Order Only?</span>
						</td>	
						<td>
							<%if (pm3.getInitManufOrderOnly()!=null && pm3.getInitManufOrderOnly().equals("Y")) {%>
								<img src="/pmemo3/images/tickmark.jpg" border='0'>
								<%} else {%>
								<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>
						</td>
					   </tr>
						<%} else {%>
			
							<td>
							<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							</td>
						</tr>	
						<%}%>
							
					<tr>
						<td>
							<span style='white-space: nowrap'>Shrinkwrap Required:</span>
						</td>
						<td>

							<%if (pm3.isPhysShrinkwrapRequired()) {%>
							<img src="/pmemo3/images/tickmark.jpg" border='0'>
							<%} else {%>
							<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>
						</td>
					</tr>
					<tr>
						<td>
							<span style='white-space: nowrap'>Insert Requirements:</span>
						</td>
						<td>

							<%if (pm3.isPhysInsertRequirements()) {%>
							<img src="/pmemo3/images/tickmark.jpg" border='0'>
							<%} else {%>
							<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>
						</td>
					</tr>

					<tr>
						<td>
							<span style='white-space: nowrap'>Limited Edition:</span>
						</td>
						<td>

							<%if (pm3.isPhysLimitedEdition()) {%>
							<img src="/pmemo3/images/tickmark.jpg" border='0'>
							<%} else {%>
							<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>
						</td>
					</tr>
					<tr>
						<td>
							<span style='white-space: nowrap'>Components:</span>
						</td>
						<td>
							<span style='white-space: nowrap'><strong><%=pm3.getPhysNumberDiscs()%></strong></span>
						</td>
					</tr>

	

					<tr>
						<td valign="top">
							<span style='white-space: nowrap'>Dealer Price:</span>
						</td>
						<td colspan="2">
							<%if ((pm3.getDealerPrice()!= null) && (!pm3.getDealerPrice().equals(""))) {%>
							<%=pm3.getDealerPrice()%>
							<%}%>
							</td>
					</tr>
					
					<%-- <tr valign="top">
						<td>	
							<span style='white-space: nowrap'>International Release:</span>
						</td>
						<td><strong>	
							<%if (pm3.getPhysicalIntlRelease()!=null && pm3.getPhysicalIntlRelease().equals("Y")) {%>
								<img src="/pmemo3/images/tickmark.jpg" border='0'>
							<%} else {%>
								<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>	
							</strong>
						</td>						
					</tr>--%>
					<tr valign="top">
						<td>	
							<span style='white-space: nowrap'>GRAS Set Complete:</span>
						</td>
						<td><strong>	
							<%if (pm3.getGrasSetComplete().equals("Y")) {%>
								<img src="/pmemo3/images/tickmark.jpg" border='0'>
							<%} else {%>
								<img src="/pmemo3/images/cross_ic.jpg" border='0'>
							<%}%>	
							</strong>
						</td>						
					</tr>					
					<tr>
						<td valign="top">
							<span style='white-space: nowrap'>Digital Equivalent?</span>
						</td>
						<td>

							<%if (pm3.getDigiEquivCheck().equals("Y")){
							if ((pm3.getDigiEquivCheck().equals("N")) || (pm3.getDigiEquivCheck().equals(""))){%>
									<img src="/pmemo3/images/cross_ic.jpg" border='0'>
						</td>
					</tr>				
							<%} else {%>
									<img src="/pmemo3/images/tickmark.jpg" border='0'>
							
							<%} %>
						</td>
					</tr>	
					<%} if ((pm3.getAgeRating() == null)|| (pm3.getAgeRating().equals(""))) {
								// Do nothing					
				 	  } else {
				 		 String ageRating = pmDAO.getStringFromId(pm3.getAgeRating(), "SELECT AGE_RATING_DESC FROM PM_AGE_RATING WHERE AGE_RATING_ID="); 
				 	  %>
					<tr>
						<td valign="top">
							<span style='white-space: nowrap'>Age Rating:</span>
						</td>
						<td>
							<b><%= ageRating %></b>		  			
						</td>
					</tr>						
					<%} if (pm3.getCustFeedRestrictDate() != null) {							
							Date custRestrictDate = java.sql.Date.valueOf(pm3.getCustFeedRestrictDate().substring(0, 10));
							modifiedCustRestrictDate = dateFormat.format(custRestrictDate);
						}%>
				<tr valign="top">
						<td>	
							<span style='white-space: nowrap'>Restrict from Customer Feed?</span>
						</td>
						<td><strong>	
							<%if (pm3.getCustFeedRestrictDate() != null) {%>
								<span style='color:red; font-size: 13'>RESTRICT UNTIL: </br><%=modifiedCustRestrictDate%> </span>
							<%} else {%>
								<span style='color:GREEN'>DISPLAY</span>
							<%}%>	
							</strong>
						</td>						
				</tr>			
					
								
					<% if (pm3.getRestrictDate() != null) {							
							Date restrictDate = java.sql.Date.valueOf(pm3.getRestrictDate().substring(0, 10));
							modifiedRestrictDate = dateFormat.format(restrictDate);
						}%>
				<tr valign="top">
						<td>	
							<span style='white-space: nowrap'>Display on Schedule?</span>
						</td>
						<td><strong>	
							<%if (pm3.getRestrictDate() != null) {%>
								<span style='color:red; font-size: 13'>RESTRICT UNTIL: </br><%=modifiedRestrictDate%> </span>
							<%} else {%>
								<span style='color:GREEN'>DISPLAY</span>
							<%}%>	
							</strong>
						</td>						
				</tr>			
					<td valign="top">
						<% if (pm3.getPhysicalD2C() != null) { %>
							<b><%=pm3.getPhysicalD2C()%></b>
						<%}%>
					</td>
					<td>
					</td>
				</tr>

					<tr valign="top">
						<td>
							<u><i><b>Product Comments:</b></i></u>
						</td>
					</tr>
					<tr>
					 	<td colspan="2" width=320 style="WORD-WRAP:break-word">		
					 	<%if ((pm3.getPhysComments() != null) && (!pm3.getPhysComments().equals("null"))){%>					
							<%=pm3.getPhysComments().replaceAll("\n", "<br />")%><br>	
						<%} %>							
								<a href=# onclick="window.open('viewProductCommentsAction.do?memoRef=<%=pm3.getMemoRef()%>&detailId=<%=pm3.getPhysicalDetailId()%>&format=physical', '_blank', 'location=yes,height=370,width=950,scrollbars=yes,status=yes');"><span style='font-size: 12;'><u>Comments History</u></span></a>
						</td>							
					</tr>
					
					<tr valign="top">
						<td>
							<u><i><b>Scope Comments:</b></i></u>
						</td>
					</tr>
					<tr>
						<td colspan="2" width=320 style="WORD-WRAP:break-word">	
						<%if ((pm3.getPhysScopeComments() != null) && (!pm3.getPhysScopeComments().equals("null"))){%>						
							<%=pm3.getPhysScopeComments().replaceAll("\n", "<br />")%>
						<%}%>
							<a href=# onclick="window.open('viewScopeCommentsAction.do?memoRef=<%=pm3.getMemoRef()%>&detailId=<%=pm3.getPhysicalDetailId()%>&format=physical', '_blank', 'location=yes,height=370,width=950,scrollbars=yes,status=yes');"><span style='font-size: 12;'><u>Comments History</u></span></a>
						</td>								
					</tr>
					

				</table>
				
			</td>
			
			<td valign="top">
			<br/>		
			<table align="left" border="0" width=825 style='table-layout:fixed'>
				<col width=15>
				<col width=315>
				<col width=120>
				<col width=220>
					<tr valign="top">
						<td colspan="4" align="left">
							<strong>TRACKLISTING :</strong>
						</td>
					</tr>

					<tr>
						<td></td>
						<td align="center">
							<b>Track Name</b>
						</td>
						<td align="center">
							<b>ISRC</b>
						</td>
						<td align="center">
							<b>Comments</b>
						</td>

					</tr>
				</table>
				
				<br>
				<br>
				<br>
			<div style="width:830px;overflow: auto ;overflow-x:hidden;">
				<table align="left" border="2" width=825 style='table-layout:fixed;border-collapse: collapse;'>
					<col width=15>
					<col width=325>
					<col width=125>
					<col width=220>


						<%Iterator iterator = tracks.iterator();
									while (iterator.hasNext()) {
									Track track2 = (Track) iterator.next();

								%>
						<tr class="grey_bg" valign="middle">
							<td width="15px" class="tracks">
								<span style=" font-size:13px"><%=track2.getTrackOrder()%></span>
							</td>
							<td width="325px" class="tracks">
								<span style=" font-size:13px"><%=track2.getTrackName()%></span>
							</td>
							<td width="125px" class="tracks">
								<span style=" font-size:13px"><%=track2.getIsrcNumber()== null ? "" :track2.getIsrcNumber()%></span>

							</td>
							<td class="tracks">
								<span style=" font-size:13px"><%=track2.getComments()== null ? "" :track2.getComments()%></span>
							</td>


						</tr>
						<%}%>
					</table>
					</div>
			</td>
			</tr>
			<br >
  			</table>
  			</span>
		<br>
		
		<%}
		}%>
	
			
	
