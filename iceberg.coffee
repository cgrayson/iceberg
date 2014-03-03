$ = jQuery

# regular expressions to use in finding which buttons to highlight as 'big'
SIZE_BUTTONS = {
  btn1mb: /[0-9][0-9]*M|.*G|.*T/
  btn10mb: /[0-9][0-9][0-9]*M|.*G|.*T/
  btn100mb: /[0-9][0-9][0-9]M|.*G|.*T/
  btn1gb: /[0-9][0-9]*G|.*T/
  btn10gb: /[0-9][0-9][0-9]*G|.*T/
  btn100gb: /[0-9][0-9][0-9]G|.*T/
}

$ ->
  # click-handler for size selection buttons
  $('#size-buttons button').click ->
    highlight_big_folders(SIZE_BUTTONS[$(this).attr('id')])

  # click-handler for folder buttons: expand folder (changing icon) and highlight big folders in sub-folder
  $('.filebrowser button.enabled').click ->
    toggle_folder $(this)

  # highlight & open folder at first level of hierarchy; highlight initial folders
  highlight_folder(get_size_setting(), $('#folders').children(':first').children('.size'))
  toggle_folder($('div#folders > div.folder > button'))

  $('#loading').hide()

get_size_setting = ->
  SIZE_BUTTONS[$('#size-buttons .btn.active').attr('id')]

# toggle the folder open or closed, including data-open attribute for use by highlight_big_folders()
toggle_folder = (element) ->
  subfolder = element.parent().next("div")
  subfolder.toggle()

  open = element.parent().data('open')
  open ?= false
  element.parent().data('open', !open) # toggle data-open attribute

  toggle_label element
  highlight_big_folders(get_size_setting(), subfolder)

# toggle the folder-open and folder-close icons on directory buttons
toggle_label = (element) ->
  element.children(":first").toggleClass('icon-folder-open')
  element.children(":first").toggleClass('icon-folder-close')


highlight_folder = (size_regex, element) ->
  if size_regex.test(element.text())
    element.prev('button').addClass 'btn-danger'
  else
    element.prev('button').removeClass 'btn-danger'


# Recursively highlight folders that are 'big' according to selected size button.
# Optional 2nd parm specifies parent element of tree to highlight from.
highlight_big_folders = (size_regex, parent_el = $('#folders')) ->
  parent_el.children().children('.size').each ->
    highlight_folder(size_regex, $(this))
    if $(this).parent().data('open')
      highlight_big_folders(size_regex, $(this).parent().next('div'))
