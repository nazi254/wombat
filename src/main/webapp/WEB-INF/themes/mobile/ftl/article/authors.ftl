<#include "../common/htmlTag.ftl" />

<#assign title = "PLOS - Author Info" />
<#assign depth = 1 />
<#include "../common/head.ftl" />

<body id="page-authors">
<div id="container-main">
<#include "backToArticle.ftl" />

  <div id="author-content" class="content">
  <#list authors as author>
    <div class="about-author">
      <h3 class="comments-header">${author.fullName}</h3>
      <#list author.affiliations as affiliation>
        <p>${affiliation}</p>
      </#list>
    </div>
  </#list>

  <#if correspondingAuthors?? && correspondingAuthors?size gt 0>
    <#if correspondingAuthors?size == 1>
      <h2>Corresponding Author</h2>
    <#else>
      <h2>Corresponding Authors</h2>
    </#if>
    <#list correspondingAuthors as correspondingAuthor>
      <div class="about-author">${correspondingAuthor}</div>
    </#list>
  </#if>
  </div>
  <!--end content-->

<#include "../common/footer/footer.ftl" />

</div>
<!--end container main-->

<#include "../common/bodyJs.ftl" />
</body>
</html>