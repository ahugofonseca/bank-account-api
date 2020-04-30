# frozen_string_literal: true

# Execute validations with dry-validation after initialize any Service
module ValidableContract
  def after_initialize(args)
    validate_contract_class!(args)
  end

  def self.included(base_service)
    class << base_service
      alias_method :_new, :new

      define_method :new do |**args, &block|
        _new(args, &block).tap do |instance|
          instance.send(:after_initialize, args)
        end
      end
    end
  end

  # VALIDATE CONTRACT CLASS
  def validate_contract_class!(args)
    raise NotImplementedError if service_contract.nil?

    inputs_validation = service_contract.call(args)

    return if inputs_validation.success?

    raise ServiceContractError, inputs_validation.errors.to_h
  end

  def service_contract
    self.class.to_s.gsub('UseCases', 'ServiceContracts').safe_constantize&.new
  end
end
