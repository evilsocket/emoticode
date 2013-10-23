// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function($) {
  var $button = $('#showcp');
  var $menu = $('#cp');

  $button.hover(
    function(){
      $menu.css( 'left', $button.offset().left - $menu.outerWidth() + $button.outerWidth() ).show();
    },
    function(){
      $menu.hide();
    }
  );

  var $tbutton = $('#showalllangs');
  var $tmenu = $('#alllangs');

  $tbutton.hover(
    function(){
      $tmenu.css( 'left', $tbutton.offset().left - $tmenu.outerWidth() + $tbutton.outerWidth() ).show();
    },
    function(){
      $tmenu.hide();
    }
  );

  var $lbutton = $('#browse_langs');
  var $lmenu = $('#all_langs');

  $lbutton.hover(
    function(){
      $lmenu.show();
    },
    function(){
      $lmenu.hide();
    }
  );

  $(window).scroll( function()
  {
    var $elem = $('#subnav');
    if( isScrolledIntoView( $elem ) )
      $('#hiddenmenu').fadeOut('fast');
    else
      $('#hiddenmenu').fadeIn('fast');
  });

  $(".ttip").tipTip({'maxWidth': 300});
});

function showLoginModal(){
    $('#login').modal();
}

function replyToComment( id, username ){
    $('#comments form #comment_parent_id').val(id);
    $('#comments form input[type="submit"]').val('Reply');
    $('#comments form textarea').attr( 'placeholder', 'Leave a reply to ' + username + ' ...' ).focus();
}

function isScrolledIntoView(elem){
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();

    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();

    return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
}