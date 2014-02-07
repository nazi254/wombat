<#include "../macro/pathUp.ftl" />
<#include "title/titleFormat.ftl" />

<head>
  <meta charset="utf-8">
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

  <title><@titleFormat title /></title>
<#assign target><@pathUp depth!0 "static/css/base.css" /></#assign>
<@cssLink target=target />
<#assign target><@pathUp depth!0 "static/css/interface.css" /></#assign>
<@cssLink target=target />
<#assign target><@pathUp depth!0 "static/css/mobile.css" /></#assign>
<@cssLink target=target />
<#include "../cssLinks.ftl" />

  <script src=<@pathUp depth!0 "static/js/vendor/vendor.min.js" />></script>
<@renderCssLinks />
</head>