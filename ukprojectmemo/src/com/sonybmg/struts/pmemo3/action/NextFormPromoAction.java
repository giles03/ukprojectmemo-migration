// Decompiled by Jad v1.5.8e. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.geocities.com/kpdus/jad.html
// Decompiler options: packimports(5) braces fieldsfirst noctor nonlb space lnc 
// Source File Name:   NextFormPromoAction.java

package com.sonybmg.struts.pmemo3.action;

import com.sonybmg.struts.pmemo3.model.ProjectMemo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class NextFormPromoAction extends Action {


            public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
/*  46*/        HttpSession session = request.getSession();
/*  49*/        ProjectMemo pm = (ProjectMemo)session.getAttribute("projectMemo");
/*  54*/        String forward = "success";
/*  56*/        if (pm.isPhysical()) {
/*  57*/            forward = "physical";
                } else {
/*  59*/            forward = "complete";
                }
/*  63*/        return mapping.findForward(forward);
            }
}
