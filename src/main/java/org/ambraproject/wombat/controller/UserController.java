package org.ambraproject.wombat.controller;

import com.google.common.collect.Maps;
import org.ambraproject.wombat.config.site.Site;
import org.ambraproject.wombat.config.site.SiteParam;
import org.ambraproject.wombat.config.site.Siteless;
import org.ambraproject.wombat.service.remote.ArticleApi;
import org.ambraproject.wombat.util.HttpDebug;
import org.apache.http.HttpHeaders;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * Controller for user related actions
 */
@Controller
public class UserController extends WombatController {
  private static final Logger log = LoggerFactory.getLogger(UserController.class);

  @Autowired
  private ArticleApi articleApi;

  @RequestMapping(name = "userLogin", value = "/user/secure/login")
  public ModelAndView redirectToOriginalLink(HttpServletRequest request, @RequestParam("page") String page) {
    // page param should contain the url to the location we want to send the user to
    String contextPath = request.getContextPath();
    int index = page.indexOf(contextPath);
    if (index != -1) {
      page = page.substring(index + contextPath.length());
    }

    try {
      /*
       * Post a record of this user logging in.
       *
       * Posting here (in response to a "/user/secure/login" request) is less robust against redundancy than Ambra.
       * Ambra sets a session variable that prevents the record from being written again in the same session. Here, we
       * exploit the fact that a user typically hits this redirect only once each time they log in, and never sees a
       * link to it in normal browsing behavior.
       *
       * Because any request to the "/user/secure/login" mapping (regardless of its session state) will trigger a
       * write, it is a bit simpler than in Ambra to imagine a scenario where we get spammed with bogus records. This
       * is a simplifying trade-off that we are making. It is not any less secure than Ambra against active malice.
       */
      recordLogin(request);
    } catch (Exception e) {
      if (log.isErrorEnabled()) { // don't rely on log.error's string-builder because HttpDebug.dump itself is expensive
        String requestDump = HttpDebug.dump(request);
        log.error(String.format("Failed to record login (%s)", requestDump), e);
      }
    }

    return new ModelAndView("redirect:" + page);
  }

  private void recordLogin(HttpServletRequest request) throws IOException {
    String remoteUser = request.getRemoteUser();
    HttpSession session = request.getSession(false);
    String sessionId = (session == null) ? null : session.getId();
    String ipAddress = request.getRemoteAddr();
    String userAgent = request.getHeader(HttpHeaders.USER_AGENT);

    Map<String, String> persist = Maps.newHashMapWithExpectedSize(3);
    persist.put("sessionId", sessionId);
    persist.put("IP", ipAddress);
    persist.put("userAgent", userAgent);
    articleApi.postObject("user?authId=" + remoteUser, persist);
  }

  @Siteless
  @RequestMapping(name = "userLogout", value = "/user/logout")
  public ModelAndView redirectToSignOut(@RequestHeader(value = "Referer", required = false) String referrer) {
    if (referrer == null) {
      // We expect a typical user never to navigate to this page unless referred there by the logout service.
      // If we used 'required = true' on the referrer param, the user would be an unstyled 500 page when it is missing.
      // Here, we define that we instead want to indicate that no content is at the URL.
      throw new NotFoundException();
    }
    return new ModelAndView("redirect:" + referrer);
  }

  @RequestMapping(name = "userInfo", value = "/user/{displayName}")
  public String displayUserInfo(Model model, @SiteParam Site site, @PathVariable String displayName) throws IOException {
    String userMetaUrl = "user?displayName=" + displayName;
    Map<String, Object> userMetadata = articleApi.requestObject(userMetaUrl, Map.class);
    model.addAttribute("user", userMetadata);
    return site.getKey() + "/ftl/user/userInfo";
  }
}
