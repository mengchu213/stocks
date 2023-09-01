require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  describe '#perform_later' do
    it 'enqueues the job' do
      expect {
        described_class.perform_later
      }.to have_enqueued_job(described_class)
    end
  end
end