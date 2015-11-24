describe Proxy do
  let(:proxy) { create(:proxy, ip_and_port: '127.0.0.1:8080') }

  it 'has a valid factory' do
    expect(create(:proxy)).to be_valid
  end

  it { is_expected.to respond_to(:ip_and_port, :permanent, :country) }

  describe '#ip' do
    let(:ip) { proxy.ip }

    it 'returns the ip segment of an ip and port string' do
      expect(ip).to eq('127.0.0.1')
    end
  end

  describe '#port' do
    let(:port) { proxy.port }

    it 'returns the port segment of an ip and port string' do
      expect(port).to eq(8080)
    end
  end
end
