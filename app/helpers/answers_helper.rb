module AnswersHelper
  def toggle_best_link(answer)
    link_to toggle_best_answer_path(id: answer.id), method: :post, remote: true, class: 'btn',
                                                      id: "toggle_best_#{answer.id}" do
      content_tag(:span, nil, class: "glyphicon glyphicon-ok #{'selected' if answer.best}")                                                  
    end
  end
end
