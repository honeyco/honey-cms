class CMS::Routes < SimpleDelegator
  def draw
    namespace :cms do
      get 'description' => 'root#description'
      get '' => 'root#index'

      CMS::Configuration.types.each do |type|
        resources type.model_name.route_key
      end

      resources :topic_datas, :community_maps, :downtowns
    end
  end
end
