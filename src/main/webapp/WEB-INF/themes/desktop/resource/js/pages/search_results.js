(function ($) {

  function handleUndefinedOrZeroMetric(metric) {
    return metric == undefined || metric == 0 ? 'None' : metric;
  }

  function appendOrRemoveLink(link, metric) {
    metric = handleUndefinedOrZeroMetric(metric);
    if (metric == 'None') {
      link.html(link.html() + ' ' + metric);
      link.contents().unwrap();
    } else {
      link.append(metric);
    }
  }

  $(document).ready(function() {
    RangeDatepicker.init($('#dateFilterStartDate'), $('#dateFilterEndDate'));

    $('.search-results-alm').each(function () {
      var $alm = $(this);
      var doi = $alm.data('doi');
      $alm.getArticleSummary(doi, function (almData) { //success function

        var almLinks = $alm.find('a');
        var viewsLink = $(almLinks[0]);
        appendOrRemoveLink(viewsLink, almData.viewed);

        var citationsLink = $(almLinks[1]);
        appendOrRemoveLink(citationsLink, almData.cited);

        var savesLink = $(almLinks[2]);
        appendOrRemoveLink(savesLink, almData.saved);

        var sharesLink = $(almLinks[3]);
        appendOrRemoveLink(sharesLink, almData.shared);

        $alm.siblings('.search-results-alm-loading').fadeOut('slow', function () {
          $alm.fadeIn();
        })
      }, function () { //error function
        $alm.siblings('.search-results-alm-loading').fadeOut('slow', function () {
          $alm.siblings('.search-results-alm-error').fadeIn();
        })
      });
    });

    $('#sortOrder').on('change', function() {
      $(this).parents('form').submit();
    });

    $('#resultsPerPageDropdown').on('change', function() {

      // Due to the way the CSS for the page currently works, it's difficult to have the <form>
      // extend all the way down to this dropdown, so we instead set a hidden field here.
      $('#resultsPerPage').val($('#resultsPerPageDropdown').val());
      $('#searchControlBarForm').submit();
    });

    // Code to make tooltips around disabled controls work on tablets.

    var $visibleTooltip;

    $('[data-js-tooltip-hover=trigger]').on('click', function() {

      // Since the two icons are close together, we have to hide the adjacent
      // tooltip first if it is visible.
      if ($visibleTooltip !== undefined) {
        $visibleTooltip.removeClass('visible');
      }
      $visibleTooltip = $(this).find('[data-js-tooltip-hover=target]');
      $visibleTooltip.addClass('visible');

      // handling click on whole document is not working, and
      // probably not a good idea anyway. So I am auto-hiding the
      // tooltip after a timeout.
      var $toolTip = $visibleTooltip;
      setTimeout(function() {
        $toolTip.removeClass('visible');
      }, 5000);
    });
  });
  // making the checkbox also link in the filter column
  $('#searchFilters li a input').on('change',function(){
    var filterlink = $(this).parent('a').attr('href');
     window.location.assign(filterlink);
  })

  // initialize toggle for search filter item list
  plos_toggle.init();

  // Advanced search behaviour
  $('.search-results-advanced-search-submit').on('click', function (e) {
    e.preventDefault();
    $('.search-results-advanced-search-submit').toggle();
    if (AdvancedSearch.isInitialized('.advanced-search-container')) {
      $('.advanced-search-container').slideUp(function () {
        // Only destroy after it has been hidden
        AdvancedSearch.destroy('.advanced-search-container');
      });
    } else {
      AdvancedSearch.init('.advanced-search-container', function (err) {
        if (err) return console.log(err.message);
        // Only show after it has been initialized
        $('.advanced-search-container').slideDown();
      });
    }
  });

})(jQuery);