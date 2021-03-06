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

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      lang="en" xml:lang="en"
      itemscope itemtype="http://schema.org/Article"
      class="no-js">
<#assign cssFile="browse-issue.css"/>
<#include "../common/title/issuesTitle.ftl" />
<#assign title = issuesTitle />

<#include "../macro/removeTags.ftl" />
<#include "../macro/doiResolverLink.ftl" />
<#include "../common/head.ftl" />
<#include "../common/journalStyle.ftl" />
<body class="browse-issue ${journalStyle}">

<#include "../common/header/headerContainer.ftl" />

<section >
<#include "issuesBody.ftl" />
</section>

<#include "../common/footer/footer.ftl" />

<@js src="resource/js/components/scroll.js"/>
<@js src="resource/js/components/floating_nav.js"/>
<@js src="resource/js/pages/browse-issues.js"/>

<@renderJs />

</body>
</html>
