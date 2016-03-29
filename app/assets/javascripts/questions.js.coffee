# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question').show()

  $('.question-vote-area .vote-up, .question-vote-area .vote-down, .question-vote-area .vote-delete').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)

    if response.voted
      $('.question-vote-area .vote-delete').removeClass('hide');
      $('.question-vote-area .vote-up').addClass('hide');
      $('.question-vote-area .vote-down').addClass('hide');
    else
      $('.question-vote-area .vote-delete').addClass('hide');
      $('.question-vote-area .vote-up').removeClass('hide');
      $('.question-vote-area .vote-down').removeClass('hide');
    $('.question-vote-area .rating').text(response.rating)
  PrivatePub.subscribe '/questions',(data, channel) ->
    questionData = $.parseJSON(data['question'])
    $('.questions').append(JST["templates/questions"]({question_data: questionData}))

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
