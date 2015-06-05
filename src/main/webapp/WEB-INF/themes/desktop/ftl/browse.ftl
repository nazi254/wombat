<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      lang="en" xml:lang="en"
      itemscope itemtype="http://schema.org/Article"
      class="no-js">


<#include "common/journalStyle.ftl" />
<body class="static ${journalStyle}">

<#assign title = "PLOS - Browse" />
<#assign depth = 0 />
<#include "common/head.ftl" />

<body id="page-browse" class="plosone">

<div id="container-main">
<#include "common/header/header.ftl" />

<style>
  .areas {
    background: #242424;
  }

  .areas .wrapper {
    width: 960px;
    padding: 17px 0 21px;
    margin: 0 auto;
  }

  /* breadcrumb */
  .areas .breadcrumb {
    font-size: 14px;
    font-weight: bold;
    line-height: 18px;
    color: #fff;
    margin: 0 0 31px;
  }

  .areas .breadcrumb strong {
    color: #ccc;
    padding: 0 5px 0 0;
  }

  .areas .breadcrumb a {
    color: #f8af2d;
  }

  /* levels */
  #taxonomy-browser {
    /*display: none;*/
    border-bottom: solid #efefef 21px;
  }

  .levels {
    padding: 0 41px;
    position: relative;
  }

  .levels .prev, .levels .next {
    display: none;
    width: 35px;
    height: 41px;
    background: url(../resource/img/level-carousel.png) no-repeat;
    cursor: default;
    position: absolute;
    top: 97px;
    left: 0;
  }

  .levels .next {
    background-position: -35px 0;
    left: auto;
    right: 0;
  }

  .levels .prev.active {
    background-position: 0 -41px;
    cursor: pointer;
  }

  .levels .next.active {
    background-position: -35px -41px;
    cursor: pointer;
  }

  .levels .prev.active:hover {
    background-position: 0 -82px;
  }

  .levels .next.active:hover {
    background-position: -35px -82px;
  }

  .levels-container {
    width: 878px;
    height: 232px;
    overflow: hidden;
    position: relative;
  }

  .touch .levels-container {
    overflow-x: auto;
  }

  .levels-container::-webkit-scrollbar {
    display: none;
  }

  .levels-position {
    width: 99999px;
    padding: 21px 0;
    position: absolute;
    top: 0;
    left: 0;
  }

  .level {
    float: left;
    width: 256px;
    height: 164px;
    font-size: 16px;
    font-weight: bold;
    line-height: 18px;
    color: #666;
    padding: 12px 15px;
    border: 1px solid #616161;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    margin: 0 7px 0 0;
    position: relative;
  }

  .level-scroll {
    width: 286px;
    height: 188px;
    margin: -12px -15px;
    overflow: hidden;
    position: relative;
    -webkit-overflow-scrolling: touch;
  }

  .touch .level-scroll {
    overflow: auto;
  }

  .level-scroll::-webkit-scrollbar {
    display: none;
  }

  .level ul {
    width: 286px;
    list-style-type: none;
    padding: 0;
    margin: 0;
    position: absolute;
    top: 0;
    left: 0;
  }

  .level ul li {
    margin: 0 0 2px;
  }

  .level ul li a {
    display: block;
    padding: 9px 20px 9px 15px;
  }

  .level .level-scroll a {
    text-decoration: none;
    color: #333;
  }

  .no-touch .level .level-scroll a:hover {
    color: #fff;
    background: url(../resource/img/level-arrow-selected.png) right 50% no-repeat #3c63af;
  }

  a.no-children {
    background-image: none !important;
  }

  /* active levels */
  .level-active {
    border: 1px solid #efefef;
    background: #efefef;
  }

  .level-active a {
    background: url(../resource/img/level-arrow-active.png) right 50% no-repeat;
  }

  .level-active .up, .level-active .down {
    display: none;
    width: 288px;
    height: 21px;
    background: url(../resource/img/level-scroll.png) no-repeat;
    position: absolute;
    top: -22px;
    left: -1px;
  }

  .level-active-over .up, .level-active-over .down {
    display: block;
  }

  .level-active .up {
    border-bottom: 3px solid #efefef;
  }

  .level-active .down {
    border-top: 3px solid #efefef;
    background-position: 0 -21px;
    top: auto;
    bottom: -22px;
  }

  .level-active .up:hover {
    background-position: 0 -42px;
  }

  .level-active .down:hover {
    background-position: 0 -63px;
  }

  /* levels with selections made */
  .level-selection {
    border: 1px solid #3b3b3b;
    background: #3b3b3b;
  }

  .level-selection .level-scroll a {
    color: #999;
    background: url(../resource/img/level-arrow-selection.png) right 50% no-repeat;
  }

  .level-selection .level-scroll a.active {
    color: #fff;
    background: url(../resource/img/level-arrow-selected.png) right 50% no-repeat #3c63af;
  }

  /* levels disabled */
  .areas .disabled {
    -webkit-opacity: 0.5;
    -moz-opacity: 0.5;
    filter: alpha(opacity=50);
    opacity: 0.5;
  }

  .areas .disabled a {
    text-decoration: none;
    cursor: default;
  }

  .areas .disabled a:hover {
    color: #999;
    background: url(../resource/img/level-arrow-selection.png) right 50% no-repeat;
  }

  .areas .disabled .selected a {
    color: #fff;
    background: url(../resource/img/level-arrow-selected.png) right 50% no-repeat #3c63af;
  }
</style>


<#include "common/footer/footer.ftl" />

</div><#-- end container-main -->

<@js src="resource/js/global.js" />
<@js src="resource/js/taxonomy-browser.js" />

<@renderJs />

</body>
</html>
