<#include "citation.ftl" />
<#macro amendmentNotice amendmentGroup title linkText>
<div class="amendment amendment-${amendmentGroup.type} toc-section">
  <#assign tocTitle>
    <#t/>${title}<#if amendmentGroup.amendments?size gt 1> (${amendmentGroup.amendments?size})</#if>
  </#assign>
  <a data-toc="amendment-${amendmentGroup.type}" title="${tocTitle}" id="amendment-${amendmentGroup.type}" name="amendment-${amendmentGroup.type}"></a>

  <h2>${title}</h2>
  <#list amendmentGroup.amendments as amendment>
    <#if amendment.body??>
      <div class="amendment-body">
      ${amendment.body}
      </div>
    </#if>
    <div class="amendment-citation">
      <p>
        <#if amendment.date??>
          <span class="amendment-date">
            <@formatJsonDate date="${amendment.date}" format="d MMM yyyy" />:
          </span>
        </#if>

        <@displayCitation amendment false />

        <#if amendment.doi??>

          <@siteLink path="article?id=" ; path>
            <span class="link-separator"> </span>
            <a href="${path + amendment.doi}" class="amendment-link">
            ${linkText}</a>
          </@siteLink>
        </#if>
      </p>
    </div>
  </#list>
</div>
</#macro>

<#list amendments as amendmentGroup>
  <#if amendmentGroup.type == 'correction'>
    <@amendmentNotice amendmentGroup,
    (amendmentGroup.amendments?size == 1)?string("Correction", "Corrections"),
    "View correction" />
  </#if>
  <#if amendmentGroup.type == 'eoc'>
    <@amendmentNotice amendmentGroup "Expression of Concern" "View expression of concern" />
  </#if>
  <#if amendmentGroup.type == 'retraction'>
    <@amendmentNotice amendmentGroup "Retraction" "View retraction" />
  </#if>
</#list>
