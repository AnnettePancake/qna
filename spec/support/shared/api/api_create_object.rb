# frozen_string_literal: true
shared_examples 'API Create object' do |entity|
  context 'authorized' do
    let!(:access_token) { create(:access_token) }

    context 'valid params' do
      let(:object) do
        post "/api/v1/questions/#{path}",
             params: { format: :json, access_token: access_token.token,
                       entity => attributes_for(entity) }
      end

      it 'returns 201 status code' do
        object
        expect(response.status).to eq(201)
      end

      it 'saves new answer in the database' do
        expect { object }.to change(entity.to_s.classify.constantize, :count).by(1)
      end
    end

    context 'invalid params' do
      let(:object) do
        post "/api/v1/questions/#{path}",
             params: { format: :json, access_token: access_token.token,
                       entity => attributes_for(:"invalid_#{entity}") }
      end

      it 'returns 422 status code' do
        object
        expect(response.status).to eq(422)
      end

      it 'does not save new answer in the database' do
        expect { object }.not_to change(entity.to_s.classify.constantize, :count)
      end
    end
  end
end
