# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.answers .vote-up,.answers .vote-down,.answers .vote-delete').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.answer').addClass("dsdsd");
    if response.voted
      $('#answer-'+ response.post_id +' .vote-delete').removeClass('hide');
      $('#answer-'+ response.post_id +' .vote-up').addClass('hide');
      $('#answer-'+ response.post_id +' .vote-down').addClass('hide');
    else
      $('#answer-'+ response.post_id +' .vote-delete').addClass('hide');
      $('#answer-'+ response.post_id +' .vote-up').removeClass('hide');
      $('#answer-'+ response.post_id +' .vote-down').removeClass('hide');
    $('#answer-'+ response.post_id +' .rating').text(response.rating)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
