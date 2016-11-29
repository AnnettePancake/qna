# frozen_string_literal: true
module ApplicationHelper
  def question_content
    # div id="question_#{@question.id}"
      # h1= @question.title
      # .lead= @question.body

    content_tag(:div, id: "question_#{@question.id}") do
      content_tag(:h1, @question.title) +
      content_tag(:div, @question.body, class: 'lead')
    end
  end
end
