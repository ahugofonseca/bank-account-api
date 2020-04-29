# frozen_string_literal: true

# Template class to implement Services (UseCases) class
class ApplicationService
  include ValidableContract

  def satisfied_all?
    Array(execute_specifications).none? false
  end

  def call
    execute_specifications  # BUSINESS VALIDATIONS
    execute_use_case        # PERFORM WORK
  end

  def response
    use_case_response
  end

  private

  def execute_specifications
    raise NotImplementedError
  end

  def execute_use_case
    raise NotImplementedError
  end

  def use_case_response
    raise NotImplementedError
  end
end
