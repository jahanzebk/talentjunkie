class Developers::DocsController < PublicController
  
  skip_before_filter :redirect_if_session_exists
  
  def index
  end
  
end