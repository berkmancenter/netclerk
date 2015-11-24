describe Request do
  let(:request) { create(:request) }

  it 'has a valid factory' do
    expect(request).to be_valid
  end

  it { is_expected.to respond_to(:page) }
  it { is_expected.to respond_to(:country) }
  it { is_expected.to respond_to(:proxy) }
  it { is_expected.to respond_to(:unproxied_ip) }
  it { is_expected.to respond_to(:proxied_ip) }
  it { is_expected.to respond_to(:local_dns_ip) }
  it { is_expected.to respond_to(:response_time) }
  it { is_expected.to respond_to(:response_status) }
  it { is_expected.to respond_to(:response_headers) }
  it { is_expected.to respond_to(:response_length) }
  it { is_expected.to respond_to(:response_delta) }

  describe '.value' do
    subject { Request.value(requests) }

    context 'when requests only have response statuses of 404' do
      let(:requests) { create_pair(:request, response_status: 404) }

      it { is_expected.to eq(0) }
    end

    context 'when requests only have response statuses of 500' do
      let(:requests) { create_pair(:request, response_status: 500) }

      it { is_expected.to eq(0) }
    end

    context 'when there are no response statuses of 200' do
      let(:requests) { create_pair(:request, response_status: 403) + create_pair(:request, response_status: 500) }

      it { is_expected.to eq(0) }
    end

    context 'when there are more response statuses of 404 than 200' do
      let(:requests) { create_list(:request, 3, response_status: 404) + create_pair(:request, response_status: 200) }

      it { is_expected.to eq(0) }
    end

    context 'when requests have response statuses of 200' do
      context 'when average delta is > 0.75' do
        let(:requests) { create_pair(:request, response_status: 200, response_delta: 0.76) }

        it { is_expected.to eq(1) }
      end

      context 'when average delta is > 0.4 and <= 0.75' do
        let(:requests) { create_pair(:request, response_status: 200, response_delta: 0.75) }

        it { is_expected.to eq(2) }
      end

      context 'when average delta is <= 0.4' do
        let(:requests) { create_pair(:request, response_status: 200, response_delta: 0.4) }

        it { is_expected.to eq(3) }
      end
    end
  end

  describe '.diff' do
    subject { diff }

    context 'with equal texts' do
      let(:diff) { Request.diff('00000', '00000') }

      it { is_expected.to eq(0) }
    end

    context 'with one delete and insert' do
      let(:diff) { Request.diff('00000', '00100') }

      it { is_expected.to eq(0.004) }
    end

    context 'with one move' do
      let(:diff) { Request.diff('01000', '00010') }

      it { is_expected.to eq(0) }
    end

    context 'with html and language change' do
      let(:diff) { Request.diff('<body><h1>Hello!</h1></body>', '<body><h1>Bonjour!</h1></body>') }

      it { is_expected.to eq(0.103) }
    end
  end

  describe '#to_laapi' do
    let(:laapi) { request.to_laapi }

    it 'returns a hash with the correct key/value pairs' do
      expect(laapi[:type]).to eq('requests')
    end
  end
end
