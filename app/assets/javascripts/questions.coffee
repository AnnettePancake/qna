# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow_question'

  received: (data) ->
    $('.questions-list').append data
})
