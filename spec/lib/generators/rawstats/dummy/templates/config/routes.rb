Rails.application.routes.draw do
  mount Rawstats::Engine, :at => '/rawstats'
end
