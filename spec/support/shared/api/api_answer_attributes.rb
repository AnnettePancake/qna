shared_examples 'API Answer attributes' do
  %w(id body created_at updated_at).each do |attr|
    it "contains #{attr}" do
      expect(response.body)
        .to be_json_eql(answer.send(attr.to_sym).to_json)
        .at_path("#{answer_path}#{attr}")
    end
  end
end
