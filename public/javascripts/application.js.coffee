$(document).ready ->
  if window.location.hash != ''
    $('a[href="' + window.location.hash + '"]').click()

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    window.location.hash = $(e.target).attr('href')
    $(document.body).scrollTop top: '0px'
