platform :ios, '13.0'

plugin 'cocoapods-keys', {
  :project => "MeuDeputado",
  :keys => [
    "MeuDeputadoAPIClientKey",
    "MeuDeputadoId"
]}

target 'MeuDeputado' do
  use_frameworks!

  # Pods for MeuDeputado
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
	pod 'RxSwiftExt'
  pod 'Parse', '~> 1'

  target 'MeuDeputadoTests' do
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'

  end
  
end
