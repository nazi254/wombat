package org.ambraproject.wombat.controller;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import org.ambraproject.wombat.config.site.RequestMappingContextDictionary;
import org.ambraproject.wombat.config.site.Site;
import org.ambraproject.wombat.config.site.SiteParam;
import org.ambraproject.wombat.config.site.url.Link;
import org.ambraproject.wombat.model.ScholarlyWorkId;
import org.ambraproject.wombat.service.ApiAddress;
import org.ambraproject.wombat.service.EntityNotFoundException;
import org.ambraproject.wombat.service.remote.ArticleApi;
import org.ambraproject.wombat.service.remote.ContentKey;
import org.ambraproject.wombat.service.remote.CorpusContentApi;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.UUID;

@Controller
public class ScholarlyWorkController extends WombatController {

  @Autowired
  private ArticleApi articleApi;
  @Autowired
  private RequestMappingContextDictionary requestMappingContextDictionary;
  @Autowired
  private CorpusContentApi corpusContentApi;

  @RequestMapping(name = "work", value = "/work")
  public String redirectToWork(HttpServletRequest request,
                               @SiteParam Site site,
                               ScholarlyWorkId workId)
      throws IOException {
    return getRedirectFor(site, workId).getRedirect(request);
  }

  Map<String, Object> getWorkMetadata(ScholarlyWorkId workId) throws IOException {
    ApiAddress address = workId.appendId(ApiAddress.builder("work"));
    try {
      return articleApi.requestObject(address, Map.class);
    } catch (EntityNotFoundException e) {
      throw new NotFoundException("No work exists with ID: " + workId, e);
    }
  }

  private String getTypeOf(ScholarlyWorkId workId) throws IOException {
    return (String) getWorkMetadata(workId).get("type");
  }

  private static final ImmutableMap<String, String> REDIRECT_HANDLERS = ImmutableMap.<String, String>builder()
      .put("article", "article")
      .put("figure", "figurePage")
      .put("table", "figurePage")
      // TODO: supp info
      .build();

  private Link getRedirectFor(Site site, ScholarlyWorkId workId) throws IOException {
    String handlerName = REDIRECT_HANDLERS.get(getTypeOf(workId));
    if (handlerName == null) {
      throw new RuntimeException("Unrecognized type: " + workId);
    }
    Link.Factory.PatternBuilder handlerLink = Link.toLocalSite(site)
        .toPattern(requestMappingContextDictionary, handlerName);
    return pointLinkToWork(handlerLink, workId);
  }

  private static Link pointLinkToWork(Link.Factory.PatternBuilder link, ScholarlyWorkId workId) {
    link.addQueryParameter("id", workId.getDoi());
    workId.getRevisionNumber().ifPresent(revisionNumber ->
        link.addQueryParameter("rev", revisionNumber));
    return link.build();
  }

  @RequestMapping(name = "workFile", value = "/work", params = {"fileType"})
  public void serveWorkFile(HttpServletResponse responseToClient,
                            @SiteParam Site site,
                            ScholarlyWorkId workId,
                            @RequestParam(value = "fileType", required = true) String fileType,
                            @RequestParam(value = "download", required = false) String isDownload)
      throws IOException {
    Map<String, ?> metadata = getWorkMetadata(workId);
    Map<String, ?> files = (Map<String, ?>) metadata.get("files");
    Map<String, ?> fileRepoKey = (Map<String, ?>) files.get(fileType);
    if (fileRepoKey == null) {
      String message = String.format("Unrecognized file type (\"%s\") for workId: %s", fileType, workId);
      throw new NotFoundException(message);
    }

    ContentKey contentKey = createKey(fileRepoKey);
    try (CloseableHttpResponse responseFromApi = corpusContentApi.request(contentKey, ImmutableList.of())) {
      forwardAssetResponse(responseFromApi, responseToClient, booleanParameter(isDownload));
    }
  }

  private static ContentKey createKey(Map<String, ?> fileRepoKey) {
    String key = (String) fileRepoKey.get("key");
    UUID uuid = UUID.fromString((String) fileRepoKey.get("uuid"));
    return ContentKey.createForUuid(key, uuid);
  }

}
