# frozen_string_literal: true

describe "File handlers" do
  include_context "webmock"

  before do
    stub_gitlab
  end

  context FileFetcher do
    it "returns file fetcher" do
      expect(FileFetcher.call(source)).to be_an_instance_of(Dependabot::Bundler::FileFetcher)
    end
  end

  context FileParser do
    it "parses dependency information" do
      files = FileFetcher.call(source).files

      expect(FileParser.call(dependency_files: files, source: source)).to be_an_instance_of(
        Dependabot::Bundler::FileParser
      )
    end
  end
end
