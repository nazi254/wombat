<#include "../macro/removeTags.ftl" />
<#include "title/titleFormat.ftl" />

<@themeConfig map="journal" value="journalKey" ; journalKey>
  <#assign journalKey = journalKey />
</@themeConfig>

<head prefix="og: http://ogp.me/ns#">
  <title><@titleFormat removeTags(title) /></title>
  <@cssLink target="resource/css/screen.css"/>
  <@renderCssLinks />
    <!--[if IE 8]>
  <link rel="stylesheet" type="text/css" href="<@siteLink path="resource/css/ie.css" />"/>
    <![endif]-->


  <script type="text/javascript" src="<@siteLink path="resource/js/vendor/modernizr-v2.7.1.js"/>"></script>
  <!--html5shiv. js and respond.js - enable the use of foundation's dropdowns to work in IE8 -->
  <!--[if IE 8]>
  <script src="<@siteLink path="resource/js/vendor/html5shiv.js"/>"></script>
  <script src="<@siteLink path="resource/js/vendor/respond.min.js"/>"></script>
<script src="<@siteLink path="resource/js/vendor/rem.min.js"/>"></script>
  <![endif]-->
  <link rel="shortcut icon" href="<@siteLink path="resource/img/favicon.ico"/>" type="image/x-icon"/>

<#include "analytics.ftl" />

</head>
<#--references js that it foundational like jquery and foundation.js. JS output is printed at the bottom of the body.
-->

<#include "baseJs.ftl" />

