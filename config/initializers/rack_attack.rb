# frozen_string_literal: true

class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Allow all local traffic
  safelist('allow-localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  # Allow an IP address to make 10 requests every 10 seconds
  throttle('req/ip', limit: 5, period: 5, &:ip)

  # Throttle login attempts by cpf
  throttle('logins/cpf', limit: 5, period: 20.seconds) do |req|
    req.params['cpf'].presence if req.path == '/auth/login' && req.post?
  end
end
