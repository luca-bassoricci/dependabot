# frozen_string_literal: true

describe Dependabot::DependencyFetcher do
  include_context "webmock"
  include_context "dependabot"

  subject do
    described_class.call(
      source: source,
      dependency_files: fetcher.files,
      package_manager: package_manager,
      allow: allow_conf,
      ignore: ignore_conf
    )
  end

  before do
    stub_gitlab
  end

  context "fetches dependencies" do
    context "without explicit filters" do
      let(:ignore_conf) { [] }

      it "and returns top level dependencies" do
        expect(subject.size).to eq(2)
      end
    end

    context "with all dependencies allowed" do
      let(:allow_conf) { [{ dependency_type: "all" }] }

      it "and returns top level dependencies" do
        expect(subject.size).to eq(19)
      end
    end

    context "with indirect dependencies allowed" do
      let(:allow_conf) { [{ dependency_type: "indirect" }] }

      it "and returns sub level dependencies" do
        expect(subject.size).to eq(17)
      end
    end

    context "with production dependencies allowed" do
      let(:allow_conf) { [{ dependency_type: "production" }] }

      it "and returns production dependencies" do
        expect(subject.size).to eq(13)
      end
    end

    context "with direct development dependencies allowed" do
      let(:allow_conf) { [{ dependency_type: "direct" }, { dependency_type: "development" }] }

      it "and returns only direct development dependencies" do
        expect(subject.size).to eq(1)
      end
    end

    context "with specific dependency ignored" do
      let(:ignore_conf) { [{ dependency_name: "rspec" }] }

      it "and returns top level dependencies without ignored" do
        expect(subject).to eq([dependency])
      end
    end

    context "with specific dependency allowed" do
      let(:allow_conf) { [{ dependency_name: "config" }] }

      it "and returns top level allowed dependencies" do
        expect(subject).to eq([dependency])
      end
    end
  end
end
