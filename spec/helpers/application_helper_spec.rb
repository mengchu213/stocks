# spec/helpers/application_helper_spec.rb
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#tailwind_class_for_flash' do
    it "returns 'bg-green-500 text-white p-4 rounded mb-4' for :success" do
      expect(helper.tailwind_class_for_flash(:success)).to eq('bg-green-500 text-white p-4 rounded mb-4')
    end

    it "returns 'bg-red-500 text-white p-4 rounded mb-4' for :error" do
      expect(helper.tailwind_class_for_flash(:error)).to eq('bg-red-500 text-white p-4 rounded mb-4')
    end

    it "returns 'bg-red-500 text-white p-4 rounded mb-4' for :alert" do
      expect(helper.tailwind_class_for_flash(:alert)).to eq('bg-red-500 text-white p-4 rounded mb-4')
    end

    it "returns 'bg-blue-500 text-white p-4 rounded mb-4' for :notice" do
      expect(helper.tailwind_class_for_flash(:notice)).to eq('bg-blue-500 text-white p-4 rounded mb-4')
    end

    it "returns 'bg-yellow-500 text-white p-4 rounded mb-4' for any other type" do
      expect(helper.tailwind_class_for_flash(:any_other_type)).to eq('bg-yellow-500 text-white p-4 rounded mb-4')
    end
  end
end
