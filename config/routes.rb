Rails
  .application
  .routes
  .draw do
    namespace 'api' do
      namespace 'fumoto' do
        namespace 'v1' do
          get 'check_reservation', to: 'fumoto#index'
        end
      end
    end
  end
