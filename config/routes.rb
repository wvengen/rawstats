Rawstats::Engine.routes.draw do
  root to: 'rawstats#show'
  get 'xml_stats(.php)', to: 'rawstats#stats', defaults: {format: 'xml'}
  get ':year(/:month)', to: 'rawstats#show'
end
