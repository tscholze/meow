$ ->
  $('.cat_thumbnail img').each (index, element) =>
    if /\.gif$/.test $(element).attr('src')
      $(element).hover =>
        if ($(element).hasClass 'animated') == false
          $(element).attr('src', $(element).data('full')).css('width', '200px').addClass('animated')
    return
  return
