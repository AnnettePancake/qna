# frozen_string_literal: true
shared_examples_for 'API Commentable' do
  context 'comments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path('comments')
    end

    %w(id body created_at updated_at commentable_id commentable_type).each do |attr|
      it "contains #{attr}" do
        expect(response.body)
          .to be_json_eql(comment.send(attr.to_sym).to_json)
          .at_path("comments/0/#{attr}")
      end
    end
  end
end
