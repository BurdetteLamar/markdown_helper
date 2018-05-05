require_relative '../use_case'

class IncludeUseCase < UseCase

  attr_accessor :use_case_dir_name

  def initialize(use_case_dir_name)
    super
    self.use_case_dir_name = use_case_dir_name
  end

  def use_case_dir_path
    File.join(File.absolute_path(File.dirname(__FILE__)), use_case_dir_name)
  end

end
