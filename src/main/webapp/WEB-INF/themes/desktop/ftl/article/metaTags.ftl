<#--
  ~ Copyright (c) 2017 Public Library of Science
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining a
  ~ copy of this software and associated documentation files (the "Software"),
  ~ to deal in the Software without restriction, including without limitation
  ~ the rights to use, copy, modify, merge, publish, distribute, sublicense,
  ~ and/or sell copies of the Software, and to permit persons to whom the
  ~ Software is furnished to do so, subject to the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be included in
  ~ all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  ~ IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  ~ FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  ~ THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  ~ LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  ~ FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  ~ DEALINGS IN THE SOFTWARE.
  -->

<#include "../common/twitterConfig.ftl" />
<#include "../macro/doiResolverLink.ftl" />

<#--//analytics related meta tags - description and keywords-->
<#if article.doi??>
<#-- Provide an evergreen URL (not articlePtr) for the canonical article URL. -->
  <@siteLink handlerName="article" absoluteLink=true queryParameters={"id" : article.doi} ; articleUrl>
  <link rel="canonical" href="${articleUrl}" />
  </@siteLink>
</#if>
<#if article.description??>
  <#assign articleDescription><@xform xml=article.description textOnly=true/></#assign>
  <meta name="description" content="${articleDescription}" />
</#if>
<#assign articleTitle><@xform xml=article.title textOnly=true/></#assign>

<#if categoryTerms??>
  <meta name="keywords" content="<#list categoryTerms as categoryTerm>${categoryTerm}<#if categoryTerm_has_next>,</#if></#list>" />
</#if>


<meta name="citation_doi" content="${article.doi}"/>
<#if authors??>
<#list authors as author>
<meta name="citation_author" content="${author.fullName}"/>
  <#list author.affiliations as affiliation>
  <meta name="citation_author_institution" content="${affiliation?trim}"/>
  </#list>
</#list>
</#if>

<meta name="citation_title" content="${articleTitle}"/>
<meta itemprop="name" content="${articleTitle}"/>
<meta name="citation_journal_title" content="${article.journal.title}"/>
<meta name="citation_journal_abbrev" content="${article.journal.title}"/>
<meta name="citation_date" content="${article.publicationDate?date("yyyy-MM-dd")}"/>
<#if article.eLocationId?has_content><meta name="citation_firstpage" content="${article.eLocationId}"/></#if>
<#if article.issue?has_content><meta name="citation_issue" content="${article.issue}"/></#if>
<#if article.volume?has_content><meta name="citation_volume" content="${article.volume}"/></#if>
<#if article.eIssn?has_content><meta name="citation_issn" content="${article.eIssn}"/></#if>
<#if article.publisherName?has_content><meta name="citation_publisher" content="${article.publisherName}"/></#if>

<#if articleItems?? && articleItems[article.doi].files?keys?seq_contains("printable")>
<#-- Uses articlePtr to point to the PDF for this particular revision. -->
  <@siteLink handlerName="assetFile" queryParameters=(articlePtr + {"type": "printable"}) absoluteLink=true ; citationPdfUrl>
  <meta name="citation_pdf_url" content="${citationPdfUrl}">
  </@siteLink>
</#if>


<#--//crossmark identifier-->
<meta name="dc.identifier" content="${article.doi}" />

<#if article.strikingImage??>
<#-- Provide an evergreen URL (not articlePtr) for striking image. Assumes striking image DOI will not change between revisions. -->
  <#assign strikingImageUrl><@siteLink handlerName="figureImage" absoluteLink=true queryParameters={"id" : article.strikingImage.doi, "size": "inline"}/></#assign>
</#if>

<#if twitterUsername?has_content>
  <meta name="twitter:card" content="summary" />
  <meta name="twitter:site" content="${twitterUsername}"/>
  <#if article.title??>
    <meta name="twitter:title" content="${articleTitle}" />
  </#if>
  <#if article.description??>
    <meta property="twitter:description" content="${articleDescription}" />
  </#if>
  <#if strikingImageUrl??>
    <meta property="twitter:image" content="${strikingImageUrl}" />
  </#if>
</#if>

<meta property="og:type" content="article" />
<#-- Provide an evergreen URL (not articlePtr) for the canonical article URL. -->
<@siteLink handlerName="article" absoluteLink=true queryParameters={"id" : article.doi} ; articleUrl>
<meta property="og:url" content="${articleUrl}"/>
</@siteLink>
<meta property="og:title" content="${articleTitle}"/>
<#if articleDescription??>
<meta property="og:description" content="${articleDescription}"/>
</#if>
<#if strikingImageUrl??>
<meta property="og:image" content="${strikingImageUrl}"/>
</#if>

<#--All of this data must be HTML char stripped to compensate for some XML in the database. If not, an ending tag can
 break out of the head and input all of the citation data directly into the visible dom. To further optimize,
 consider using a macro or function instead of the regex replace used below, or try to clean the data in the controller
 layer.-->
<#if references??><#-- 'references' should always be present for the main body tab, but not other tabs -->
  <#list references as reference>
    <#if reference.title??>
    <meta name="citation_reference" content="<#t>
          <#if reference.chapterTitle??>citation_title=${reference.chapterTitle?replace('<.+?>',' ','r')?html};<#t>
            <#if reference.title??>citation_inbook_title=${reference.title?replace('<.+?>',' ','r')?html};</#if><#t>
          <#else>citation_title=${reference.title?replace('<.+?>',' ','r')?html};<#t>
          </#if>
          <#if reference.authors?has_content>
            <#list reference.authors as author>citation_author=${author.fullName?replace('<.+?>',' ','r')?html};</#list></#if><#t>
          <#if reference.journal??>citation_journal_title=${reference.journal?replace('<.+?>',' ','r')?html};</#if><#t>
          <#if reference.volume??>citation_volume=${reference.volume?replace('<.+?>',' ','r')?html};</#if><#t>
          <#if reference.volumeNumber??>citation_number=${reference.volumeNumber};</#if><#t>
          <#if reference.issue??>citation_issue=${reference.issue?replace('<.+?>',' ','r')?html};</#if><#t>
          <#if reference.fPage??>citation_first_page=${reference.fPage?replace('<.+?>',' ','r')?html};</#if><#t>
          <#if reference.lPage??>citation_last_page=${reference.lPage?replace('<.+?>',' ','r')?html};</#if><#t>
          <#if reference.isbn??>citation_isbn=${reference.isbn?replace('<.+?>',' ','r')?html};</#if><#t>
          <#if reference.year??>citation_publication_date=${reference.year?string.computer};</#if><#t>
          <#if reference.publisherName??>citation_publisher=${reference.publisherName?replace('<.+?>',' ','r')?html}</#if><#t>"/>
    <#elseif reference.unStructuredReference??>
    <meta name="citation_reference" content="${reference.unStructuredReference?replace('<.+?>',' ','r')?html}<#t>"/>
    </#if>
  </#list>
</#if>
