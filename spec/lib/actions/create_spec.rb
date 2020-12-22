require "spec_helper"

describe Intacct::Actions::Create do
  class TestModel < Intacct::Base
    include Intacct::Actions::Create::Helper
  end

  describe "create" do
    subject { TestModel.new(client_double, {}) }
    let(:options) { {} }
    let(:create_double) { instance_double(described_class) }
    let(:client_double) { instance_double(Intacct::Client) }
    let(:response_double) do
      instance_double(
        Intacct::Response,
        errors: ["error"],
        body: { "recordno" => "12345" },
        raw_response: { "raw" => "response" }
      )
    end

    before do
      allow(described_class).to receive(:new).with(client_double, subject, "create", options) { create_double }
      allow(create_double).to receive(:perform) { response_double }
    end

    context "when successful" do
      before do
        allow(response_double).to receive(:success?) { true }
      end

      it "performs the action and adds response data to the model instance" do
        expect(subject.create).to be_truthy
        expect(subject.errors).to eq response_double.errors
        expect(subject.raw_response).to eq response_double.raw_response
        expect(subject.recordno).to eq response_double.body["recordno"]
      end
    end

    context "when unsuccessful" do
      before do
        allow(response_double).to receive(:success?) { false }
      end

      it "performs the action and adds errors to the model instance" do
        expect(subject.create).to be_falsey
        expect(subject.errors).to eq response_double.errors
        expect(subject.raw_response).to eq response_double.raw_response
      end
    end
  end
end