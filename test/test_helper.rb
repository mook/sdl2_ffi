require 'minitest/autorun'
require 'pry'
require 'approvals'


FIXTURE_DIR = File.expand_path('../fixtures/',__FILE__)
def fixture(file)
  File.expand_path(file, FIXTURE_DIR)
end

Approvals.configure do |c|
  c.approvals_path = File.expand_path('../approvals/',__FILE__)+'/'
end