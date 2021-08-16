Rails
  .application
  .routes
  .draw do
    namespace 'api' do
      namespace 'v1' do
        namespace 'fumoto' do
          get 'check_reservation', to: 'application#index'
        end
      end
    end
  end
