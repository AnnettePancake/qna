shared_examples 'API Question attributes' do
  %w(id title body created_at updated_at).each do |attr|
    it "question object contains #{attr}" do
      expect(response.body)
        .to be_json_eql(question.send(attr.to_sym).to_json)
        .at_path("#{path}#{attr}")
    end
  end
end
