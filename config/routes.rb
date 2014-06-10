Rawstats::Engine.routes.draw do
  root to: 'rawstats#show'
  get ':year(/:month)', to: 'rawstats#show'
end
