//Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
//Jad home page: http://www.geocities.com/kpdus/jad.html
//Decompiler options: packimports(5) braces fieldsfirst noctor nonlb space lnc 
//Source File Name:   TracksAction.java

package com.sonybmg.struts.pmemo3.action;

import com.sonybmg.struts.pmemo3.db.ProjectMemoDAO;
import com.sonybmg.struts.pmemo3.db.ProjectMemoFactoryDAO;
import com.sonybmg.struts.pmemo3.form.TracksForm;
import com.sonybmg.struts.pmemo3.model.ProjectMemo;
import com.sonybmg.struts.pmemo3.model.ProjectMemoUser;
import com.sonybmg.struts.pmemo3.model.Track;
import com.sonybmg.struts.pmemo3.util.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class SaveTracksAction extends Action {
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		//TracksForm addTracksForm = (TracksForm)form;
		ProjectMemo pm = null;
		ProjectMemoDAO pmDAO = ProjectMemoFactoryDAO.getInstance();
		ArrayList list = null;
		ArrayList preOrderList = null;
		ArrayList tracksToSave = null;
		ArrayList preOrderTracksToSave = null;
		FormHelper fh = null;
		HttpSession session = request.getSession();
		String forward = "";
		String productType = null;
		HashMap productFormats = null;
		int count;
		int trackNum = 0;
		if (session.getAttribute("trackList") != null) {
			List tracks = (ArrayList)session.getAttribute("trackList");
			count = tracks.size();
		} else {
			List tracks = new ArrayList();
			count = 0;
		}

		if (session.getAttribute("projectMemo") != null) {
			
			pm = (ProjectMemo)session.getAttribute("projectMemo");
			productType = pmDAO.getPMHeaderDetailsFromDrafts(pm.getMemoRef()).getProductType();
		}
		
/*
 * ------------------------------------------------------------------------------------------------------------------
 * Editing Physical Track
 */
		if((pm.getPhysicalDetailId()!=null) && (pm.getPhysicalDetailId()!="")){
			fh = new FormHelper();
			if (fh.tracksExistForPhysicalFormat(pm.getMemoRef(), pm.getRevisionID(), pm.getPhysicalDetailId())) {
				fh.deleteAssociatedPhysicalTracks(pm.getMemoRef(), pm.getRevisionID(), pm.getPhysicalDetailId());
			}
	
				Track track = new Track();
				count = 0;
				if (session.getAttribute("trackList") != null) {
					list = (ArrayList)session.getAttribute("trackList");
					if (list.size() < 1) {
						list = null;
					}
				}
				if (list != null) {
					Track trackToSave = null;
					tracksToSave = (ArrayList)session.getAttribute("trackList");
					Iterator iter = tracksToSave.iterator(); 
					while(iter.hasNext()){
						trackToSave = (Track)iter.next();
						fh.savePhysicalTrack(pm, trackToSave);
					}
					
					session.setAttribute("trackList", list);
				}
				productFormats = fh.getPhysicalProductFormat(productType);
				
				/*
				 * need to return associated Digital detail id for this product to display as link on Edit Physical form page
				 */
				String digitalDetailId = fh.returnLinkedFormatDetailId(pm.getMemoRef(), pm.getRevisionID(), pm.getPhysicalDetailId());
				if(digitalDetailId!=null){
					String linkedDigitalFormatID = pmDAO.returnLinkedDigitalFormatId(pm.getMemoRef(), pm.getRevisionID(), digitalDetailId);				
					request.setAttribute("DigiEquivalent", "<a href='editDigitalDraft.do?memoRef="+pm.getMemoRef()+"&formatId="+linkedDigitalFormatID+"&revNo="+pm.getRevisionID()+"&detailId="+digitalDetailId+"'>"+(fh.getSpecificFormat(linkedDigitalFormatID))+"</a>");
				}
				forward = "newPhysicalFromEdit";

				
/*
 * ------------------------------------------------------------------------------------------------------------------
 * Editing Digital Track
 */
				
		}  else if((pm.getDigitalDetailId()!=null) && (pm.getDigitalDetailId()!="")){			
				fh = new FormHelper();
				if (fh.tracksExistForDigitalFormat(pm.getMemoRef(), pm.getRevisionID(), pm.getDigitalDetailId())) {
					fh.deleteAssociatedDigitalTracks(pm.getMemoRef(), pm.getRevisionID(), pm.getDigitalDetailId());
				}
				if (session.getAttribute("projectMemo") != null) {
					pm = (ProjectMemo)session.getAttribute("projectMemo");
				}
				Track track = new Track();
				count = 0;
				if (session.getAttribute("trackList") != null) {
					list = (ArrayList)session.getAttribute("trackList");
					if (list.size() < 1) {
						list = null;
					}
				}
				if (list != null) {
					tracksToSave = (ArrayList)session.getAttribute("trackList");
					Track trackToSave;
					Iterator iter = tracksToSave.iterator(); 
					while(iter.hasNext()){
						trackToSave = (Track)iter.next();
						trackToSave.setPreOrderOnlyFlag("N");							 
						fh.saveDigiTrack(pm, trackToSave); 											
					}
	
					session.setAttribute("trackList", list);
				}
				if (session.getAttribute("preOrderTracklisting") != null) {
					preOrderList = (ArrayList)session.getAttribute("preOrderTracklisting");
					if (preOrderList.size() < 1) {
						preOrderList = null;
					}
				}
				if (preOrderList != null) {
					Track preOrderTrackToSave = null;
					preOrderTracksToSave = (ArrayList)session.getAttribute("preOrderTracklisting");
					/*
					 * retrieve trackList arrayList, iterate through and save each track to db
					 */
					Iterator iter = preOrderTracksToSave.iterator(); 
					while(iter.hasNext()){
						preOrderTrackToSave = (Track)iter.next();
						preOrderTrackToSave.setPreOrderOnlyFlag("Y");
						fh.saveDigiTrack(pm, preOrderTrackToSave); 											
					}
	
					session.setAttribute("preOrderTracklisting", preOrderList);
				}
				productFormats = fh.getDigitalProductFormat(productType);	
				
				/*
				 * need to return associated Physical detail id for this product to display as link on Edit Physical form page
				 */
				String physicalDetailId = fh.returnLinkedFormatDetailId(pm.getMemoRef(), pm.getRevisionID(), pm.getDigitalDetailId());				
				if(physicalDetailId!=null){
					String linkedPhysicalFormatID = pmDAO.returnLinkedPhysicalFormatId(pm.getMemoRef(), pm.getRevisionID(), physicalDetailId);				
					request.setAttribute("newDigiEquivRequired", "<a href='editPhysicalDraft.do?memoRef="+pm.getMemoRef()+"&formatId="+linkedPhysicalFormatID+"&revNo="+pm.getRevisionID()+"&detailId="+physicalDetailId+"'>"+(fh.getSpecificFormat(linkedPhysicalFormatID))+"</a>");
				}
				
				HashMap preOrders = pmDAO.getAllPreOrders(pm.getMemoRef(), pm.getDigitalDetailId());
	            session.setAttribute("preOrderMap", preOrders);
				
				forward = "newDigitalFromEdit";
				
				
				
/*
 * ------------------------------------------------------------------------------------------------------------------
 * Editing Promo Track
 */
				
		}  else if((pm.getPromoDetailId()!=null) && (pm.getPromoDetailId()!="")){	
					fh = new FormHelper();
					if (fh.tracksExistForPromoFormat(pm.getMemoRef(), pm.getRevisionID(), pm.getPromoDetailId())) {
						fh.deleteAssociatedPromoTracks(pm.getMemoRef(), pm.getRevisionID(), pm.getPromoDetailId());
					}
					if (session.getAttribute("projectMemo") != null) {
						pm = (ProjectMemo)session.getAttribute("projectMemo");
					}
					Track track = new Track();
					count = 0;
					if (session.getAttribute("trackList") != null) {
						list = (ArrayList)session.getAttribute("trackList");
						if (list.size() < 1) {
							list = null;
						}
					}
					if (list != null) {
						tracksToSave = (ArrayList)session.getAttribute("trackList");
						Track trackToSave;
						for (Iterator iter = tracksToSave.iterator(); iter.hasNext(); fh.savePromoTrack(pm, trackToSave)) {
							trackToSave = (Track)iter.next();
							
						}
						
						session.setAttribute("trackList", list);
					}

					productFormats = fh.getPromoProductFormat(productType);
					forward = "newPromoFromEdit";	
		}
		
//remove project Memo session data
			session.setAttribute("projectMemo", null);
			request.setAttribute("productFormats", productFormats);
			request.setAttribute("projectMemo", pm);
			String artist = pmDAO.getStringFromId(pmDAO.getPMHeaderDetailsFromDrafts(pm.getMemoRef()).getArtist(),"SELECT ARTIST_NAME FROM PM_ARTIST WHERE ARTIST_ID=");
			request.setAttribute("artist", artist);
			fh.returnAllRelatedFormats(pm, request);

			session.removeAttribute("nextTrackNum");
			
			 ProjectMemoUser user = null;
             if (session.getAttribute("user") != null) {
             
               user = (ProjectMemoUser) session.getAttribute("user");
               
             }
            
             boolean localProduct = pmDAO.isLocalProductInDraftHeader(pm.getMemoRef());
             //Can user edit the GRAS Set Complete and DRA Clearance Complete checkboxes?
             if((localProduct) && (user.getId().equals("yearw01") |  
                 user.getId().equals("giles03") |
                 user.getId().equals("wijes01") | 
                 user.getId().equals("robe081") |
                 user.getId().equals("tier012") |
                 user.getId().equals("baxk003") |
                 user.getId().equals("woo0001") |
                 user.getId().equals("howm001") )){
               
               request.setAttribute("canEdit", true);
               
             } else if ((localProduct==false) && (user.getId().equals("lamp002"))){
               
               request.setAttribute("canEdit", true);
               
             } else {
               
               request.setAttribute("canEdit", false);
             }
             
             if(localProduct){
               request.setAttribute("localProduct", true);
             } else{
               request.setAttribute("localProduct", false);
             }
			
             
             if(pm.getGrasSetComplete()!=null && pm.getGrasSetComplete().equals("Y")){
               request.setAttribute("grasComplete", true);
             }
			return mapping.findForward(forward);
		
		
		
	}
}
