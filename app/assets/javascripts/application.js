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
//= require jquery.ui.all
//= require turbolinks
//= require_tree .

Cufon.replace('span#motto', {fontFamily: 'Gabriola', hover:true});
Cufon.replace('#heading > h1', {fontFamily: 'Copse', hover:true})

function showLoginModal(){
    alert( 'TODO: showLoginModal' );
}

function dialog(title,data){
    return $('<div class="dialog"><div class="title">' + title + '</div><div class="content">' + data + '</div></div>')
}

function showEmbedDialog(url){
    dialog('Embed Me!', '<textarea id="embed-text" style="font: normal 12px/16px Consolas,Menlo,monospace;height: 200px;margin: 0;width: 515px;"><script type="text/javascript" src="' + url + '"></script></textarea>').dialog();
}

$( function(){
    $('#show-all-langs').hover( 
    function(){
        $('#all-langs').show();
    },
    function(){
        $('#all-langs').hide();
    });
});
