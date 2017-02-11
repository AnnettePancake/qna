shared_examples 'API List' do
  it 'returns list of objects' do
    expect(response.body).to have_json_size(2)
  end
end
