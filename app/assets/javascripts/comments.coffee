# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  App.cable.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id}, {
    connected: ->
      @perform 'follow_comment'

    received: (data) ->
      console.log data
      $("#comments-#{data.commentable.class}-#{data.commentable.id}").append(JST["skim/comment"]({
          comment: data.comment
        }));
  })
