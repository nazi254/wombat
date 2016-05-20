<#macro base_page_head cssFile='' title=''>
<!DOCTYPE html>
<!--[if lt IE 7]><html class="no-js lt-ie9 lt-ie8 lt-ie7"><![endif]-->
<!--[if IE 7]><html class="no-js lt-ie9 lt-ie8"><![endif]-->
<!--[if IE 8]><html class="no-js lt-ie9"><![endif]-->
<!--[if IE 9]><html class="no-js ie9"><![endif]-->
<!--[if gt IE 9]><!-->
<html class="no-js">
<!--<![endif]-->
<head>
  <meta charset="utf-8">
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <#include "../macro/removeTags.ftl" />
    <#include "../common/title/titleFormat.ftl" />
    <#if article??>
        <#if article.date??>
          <meta name="citation_date" content="${article.date?date("yyyy-MM-dd")}"/>
        </#if>
        <#if article.title??>
          <meta name="citation_title" content="${article.title?replace('<.+?>',' ','r')?html}"/>
        </#if>
        <#if article.doi??>
          <meta name="citation_doi" content="${article.doi}"/>
        </#if>
    </#if>
    <style type='text/css'>
    @-ms-viewport {
      width: device-width;
    }

    @-o-viewport {
      width: device-width;
    }

    @viewport {
      width: device-width;
    }
    </style>
    <title><@titleFormat removeTags(title) /></title>
    <@cssLink target="resource/css/base.css" />
    <@cssLink target="resource/css/interface.css" />
    <@cssLink target="resource/css/mobile.css" />
    <#if cssFile?has_content>
        <@cssLink target="resource/css/${cssFile}" />
    </#if>
    <@cssLink target="resource/css/metrics.css" />


    <#include "../cssLinks.ftl" />

  <script src="<@siteLink path="resource/js/vendor/vendor.min.js" />"></script>
    <@js src="resource/js/vendor/underscore-min.js"/>
    <@js src="resource/js/vendor/underscore.string.min.js"/>
    <@renderCssLinks />
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
</head>
</#macro>

<#macro page_head_extra>

</#macro>

<#macro page_head cssFile='' title=''>
    <@base_page_head cssFile title />
  <body>
    <div id="container-main">
    <#include "../common/header/headerContainer.ftl" />
  <@page_head_extra />
</#macro>

<#macro base_page_footer>

</#macro>

<#macro page_footer>
    <@base_page_footer />
    <#include "../common/footer/footer.ftl" />

  </div><#-- end container-main -->

    <#include "../common/siteMenu/siteMenu.ftl" />
    <#include "../common/bodyJs.ftl" />

  </body>
  </html>
</#macro>

<#macro page_content>

</#macro>

<#macro render_page cssFile='' title=''>
  <@page_head cssFile title />
  <@page_content />
  <@page_footer />
</#macro>
