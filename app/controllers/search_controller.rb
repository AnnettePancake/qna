# frozen_string_literal: true
class SearchController < ApplicationController
  skip_authorization_check

  def show
    sanitized = ThinkingSphinx::Query.escape(params[:search_query].to_s)
    @result = ThinkingSphinx.search sanitized, classes: search_classes
    respond_with(@result)
  end

  private

  def search_classes
    if params[:search_entity].blank?
      search_entities_collection.map(&:constantize)
    else
      [params[:search_entity].constantize]
    end
  end
end
