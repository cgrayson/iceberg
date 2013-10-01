// Generated by CoffeeScript 1.3.1
(function() {
  var $, SIZE_BUTTONS, highlight_big_folders, toggle_folder, toggle_label;

  $ = jQuery;

  SIZE_BUTTONS = {
    btn1mb: /[0-9][0-9]*M|.*G|.*T/,
    btn10mb: /[0-9][0-9][0-9]*M|.*G|.*T/,
    btn100mb: /[0-9][0-9][0-9]M|.*G|.*T/,
    btn1gb: /[0-9][0-9]*G|.*T/,
    btn10gb: /[0-9][0-9][0-9]*G|.*T/,
    btn100gb: /[0-9][0-9][0-9]G|.*T/
  };

  $(function() {
    $('#size-buttons button').click(function() {
      return highlight_big_folders(SIZE_BUTTONS[$(this).attr('id')]);
    });
    $('.filebrowser button.enabled').click(function() {
      return toggle_folder($(this));
    });
    $('div#folders > div.folder > button').click();
    return $('#loading').hide();
  });

  toggle_folder = function(element) {
    var open, subfolder;
    subfolder = element.parent().next("div");
    subfolder.toggle();
    open = element.parent().data('open');
    if (open == null) {
      open = false;
    }
    element.parent().data('open', !open);
    toggle_label(element);
    return highlight_big_folders(SIZE_BUTTONS[$('#size-buttons .btn.active').attr('id')], subfolder);
  };

  toggle_label = function(element) {
    element.children(":first").toggleClass('icon-folder-open');
    return element.children(":first").toggleClass('icon-folder-close');
  };

  highlight_big_folders = function(size_regex, parent_el) {
    if (parent_el == null) {
      parent_el = $('#folders');
    }
    return parent_el.children().children('.size').each(function() {
      var size;
      size = $(this).text();
      if (size_regex.test(size)) {
        $(this).prev('button').addClass('btn-danger');
      } else {
        $(this).prev('button').removeClass('btn-danger');
      }
      if ($(this).parent().data('open')) {
        return highlight_big_folders(size_regex, $(this).parent().next('div'));
      }
    });
  };

}).call(this);
