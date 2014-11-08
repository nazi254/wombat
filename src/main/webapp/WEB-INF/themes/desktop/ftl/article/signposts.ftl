<#assign metricsUrl = legacyUrlPrefix +'article/metrics/info:doi/'+articleDoi />

<ul id="almSignposts" class="signposts">
  <li id="loadingMetrics">
    (spinner)<br>
    Loading metrics
  </li>

  <li id="almSaves" class="noshow">
    <div class="tools">
      <a class="metric-term" href="${metricsUrl}#savedHeader">Save</a>
      <p class="saves-tip noshow anime-hide"><a href="${metricsUrl}#savedHeader">Total Mendeley and CiteULike bookmarks.</a></p>
    </div>
  </li>

  <li id="almCitations" class="noshow">
    <div class="tools">
      <a class="metric-term" href="${metricsUrl}#citedHeader">Citation</a>
      <p class="citations-tip noshow anime-hide"><a href="${metricsUrl}#citedHeader">Paper's citation count computed by Scopus.</a></p>
    </div>
  </li>

  <li id="almViews" class="noshow">
    <div class="tools">
      <a class="metric-term" href="${metricsUrl}#viewedHeader">View</a>
      <p class="views-tip noshow anime-hide"><a href="${metricsUrl}#viewedHeader">Sum of PLOS and PubMed Central page views and downloads.</a></p>
    </div>
  </li>

  <li id="almShares" class="noshow">
    <div class="tools">
      <a class="metric-term" href="${metricsUrl}#sharedHeader">Share</a>
      <p class="shares-tip noshow anime-hide"><a href="${metricsUrl}#sharedHeader">Sum of Facebook and Twitter activity.</a></p>
    </div>
  </li>
</ul>
