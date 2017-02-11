shared_examples_for 'API Attachable' do
  context 'attachments' do
    it 'included in question object' do
      expect(response.body).to have_json_size(1).at_path('attachments')
    end

    %w(id file created_at updated_at attachable_id attachable_type).each do |attr|
      it "contains #{attr}" do
        expect(response.body)
          .to be_json_eql(attachment.send(attr.to_sym).to_json)
          .at_path("attachments/0/#{attr}")
      end
    end

    it 'contains attachment url' do
      expect(response.body)
        .to be_json_eql(attachment.file.url.to_json)
        .at_path('attachments/0/url')
    end
  end
end
