class CMS::Routes < SimpleDelegator
  def draw
    namespace :cms do
      get 'description' => 'root#description'
      get '' => 'root#index'

      CMS::Configuration.types.each do |type|
        resources type.model_name.route_key
      end

      yield if block_given?
    end

    CMS::Configuration.pages.each do |page|
      get page => "cms/pages#show", page: page.dup, as: "cms_#{page}"
    end
  end
end
