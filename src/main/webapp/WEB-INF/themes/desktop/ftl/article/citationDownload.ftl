<html>
<#assign title = "" /> <#-- use default -->
<#assign cssFile="site-content.css"/>
<#include "../common/head.ftl" />

<#include "../common/journalStyle.ftl" />
<body class="${journalStyle}">
<#include "../common/header/headerContainer.ftl" />

<article>
  <h1>Download Citation</h1>

  <p>
    <span>Article Source:</span>
    <a href="<@siteLink handlerName="article" queryParameters={'id': article.doi} />"
       title="Back to original article">
      <strong>${article.title}</strong>
    </a>
    <br/>
  <#include "citation.ftl" />
  <@displayCitation article false />
  </p>

  <h2>Download the article citation in the following formats:</h2>
  <ul>
    <li>
      <a href="<@siteLink handlerName="downloadRisCitation" queryParameters={'id': article.doi} />"
         title="RIS Citation">
        RIS
      </a> (compatible with EndNote, Reference Manager, ProCite, RefWorks)
    </li>
    <li>
      <a href="<@siteLink handlerName="downloadBibtexCitation" queryParameters={'id': article.doi} />"
         title="BibTex Citation">
        BibTex
      </a> (compatible with BibDesk, LaTeX)
    </li>
  </ul>
</article>

<#include "../common/footer/footer.ftl" />
</body>
</html>