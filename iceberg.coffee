$ = jQuery

# regular expressions to use in finding which buttons to highlight as 'big'
SIZE_BUTTONS = {
  btn1mb: /[0-9][0-9]*M|.*G/
  btn10mb: /[0-9][0-9][0-9]*M|.*G/
  btn100mb: /[0-9][0-9][0-9]M|.*G/
  btn1gb: /[0-9][0-9]*G/
  btn10gb: /[0-9][0-9][0-9]*G/
  btn100gb: /[0-9][0-9][0-9]G/
}

$ ->
  # click-handler for size selection buttons
  $('#size-buttons button').click ->
    highlight_big_folders(SIZE_BUTTONS[$(this).attr('id')])

  # click-handler for folder buttons: expand folder (changing icon) and highlight big folders in sub-folder
  $('.filebrowser button.enabled').click ->
    subfolder = $(this).parent().next("div")
    subfolder.toggle()
    toggle_label $(this)
    highlight_big_folders(SIZE_BUTTONS[$('#size-buttons .btn.active').attr('id')], subfolder)

  # open folder at first level of hierarchy
  $('#folders > .folder > button').click()

  # highlight big folders for default size
  highlight_big_folders(SIZE_BUTTONS['btn1gb'])

  $('#loading').hide()


# toggle the folder-open and folder-close icons on directory buttons
toggle_label = (element) ->
  element.children(":first").toggleClass('icon-folder-open')
  element.children(":first").toggleClass('icon-folder-close')


# Highlight folders that are 'big' according to selected size button.
# Optional 2nd parm specifies parent element of tree to highlight from.
highlight_big_folders = (size_regex, parent_el = $('#folders')) ->
  num_highlighted = 0
  parent_el.find("div.folder:visible .size").each ->
    size = $(this).text()
    if size_regex.test(size)
      $(this).prev('button').addClass 'btn-danger'
    else
      $(this).prev('button').removeClass 'btn-danger'
