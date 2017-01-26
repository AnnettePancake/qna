# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  App.cable.subscriptions.create({channel: 'AnswersChannel', question_id: gon.question_id}, {
    connected: ->
      @perform 'follow_answer'

    received: (data) ->
      console.log data
      $('.answers').append(JST["skim/answer"]({
        answer: data.answer,
        question: data.question,
        attachments: data.attachments
      }));
  })
