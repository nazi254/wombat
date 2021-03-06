/*
 * Copyright (c) 2017 Public Library of Science
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

/**
 *
 * DEPENDENCY:  resource/js/components/truncate_elem
 *              resource/js/components/show_onscroll
 *
 */

(function ($) {

  var s, float_header, is_author_list, spin_target, spin_opts, almspinner;

  float_header = {

    settings : {
      floater : $('#floatTitleTop'),
      hidden_div : 'topVisible',
      scroll_trigger : 420,
      width_trigger : 960,
      div_exists : 1
    },

    init : function () {
      s = this.settings;
      this.scroll_it();
      this.close_floater();
      this.get_width();
      this.check_positions();
    },

    check_div : function () {
      s.div_exists = s.floater.length;
      return s.div_exists;
    },

    check_positions : function () {
      var trigger_header = $(window).scrollTop();
      var new_width = $(window).width();
      if (trigger_header > s.scroll_trigger && new_width > s.width_trigger) {
        return s.floater.addClass(s.hidden_div);
      }
    },

    scroll_it :  function () {
      if (this.check_div() > 0) {
          return $(window).on('scroll', function () {
            var new_width = $(window).width();
            if (new_width > s.width_trigger) {
            show_onscroll(s.floater, s.hidden_div, s.scroll_trigger);
            }
          });
      }
    },

    get_width : function(){
      if (this.check_div() > 0) {
        $(window).resize(function () {
          var new_width = $(window).width();
          var trigger_header = $(window).scrollTop();
          if (new_width < 960) {
            $(s.floater).removeClass(s.hidden_div);
          } else if (trigger_header > s.scroll_trigger && new_width > s.width_trigger) {
              $(s.floater).addClass(s.hidden_div);
          }
        });
      }
    },

    close_floater : function () {
      s.floater.find('.logo-close').on('click', function () {
        s.floater.remove();
      });
    }
  };

 $( document ).ready(function() {

    $('.preventDefault').on('click', function (e) {
      e.preventDefault();
    });

    is_author_list = document.getElementById('floatAuthorList');
    if ( is_author_list != null) {
      truncate_elem.remove_overflowed('#floatAuthorList');

      // initialize tooltip for author info
      tooltip_component.init();
    }

    float_header.init();

     /* Load signposts */
     if ($.fn.signposts ) {
         var doi = $('meta[name=citation_doi]').attr('content');
         var signposts = new $.fn.signposts();
         signposts.getSignpostData(doi);
     }
    // initialize toggle for author list view more
   toggle_component.init();

    spin_opts = {
      width: 1,
      zIndex: 5000,
      top: '40%', // Top position relative to parent
      left: '50%' // Left position relative to parent
    };
    spin_target = document.getElementById('loadingMetrics');
    almspinner = new Spinner(spin_opts).spin(spin_target);


   //////// BIND IMAGES' TRIGGERS TO FIGURE LIGHTBOX ////////////
   //// Every trigger has a different way of obtaining the doi property
   //// of the image. Therefore, they are binded separate
   // carousel images on article page
    $('.lightbox-figure').on('click', function () {
      FigureLightbox.loadImage('#figure-lightbox-container', $(this).data('doi'));
    });

   // article inline images
   $('#artText div.img-box').on('click', function (e) {
     e.preventDefault();
     FigureLightbox.loadImage('#figure-lightbox-container', $(this).find('a').data('uri'));
   });

   // 'figure' item in article floating nav
   $('#nav-figures a').on('click', function () {
     FigureLightbox.loadImage('#figure-lightbox-container', $('.figure').eq(0).data('doi'));
   });
  });

}(jQuery));
