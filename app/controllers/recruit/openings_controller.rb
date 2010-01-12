class Recruit::OpeningsController < Recruit::RecruitController
  
  def new
    @organization = Organization.find(params[:organization_id])
    @title = "New job opening at #{@organization.name}"
  end
  
  def create
    @organization = Organization.find(params[:organization_id])
    begin
      ActiveRecord::Base.transaction do
        if params[:position][:id].blank?
          @position = @organization.positions.find_by_title(params[:position][:title])
          unless @position
            @position = Position.new(params[:position])
            @position.save!
            @organization.positions << @position
          end
        else
          @position = Position.find(params[:position][:id])
        end
        
        @contract = Contract.new(params[:contract])
        @contract.position_id = @position.id
        
        if params[:date][:asap].blank?
          @contract.from = params[:date][:from_year], params[:date][:from_month]
        end
        
        if params[:date][:open].blank?
          @contract.to = params[:date][:to_year], params[:date][:to_month]
        end
        
        @contract.posted_by_user_id = current_user.id
        @contract.save!
      end
      
      Events::NewOpening.create!({:subject_id => @organization.id, :object_id => @contract.id})
      
      # create default statuses
      JobApplicationStatus.create!({:contract_id => @contract.id, :name => "Reviewing profile", :label => "R", :order => 1})
      JobApplicationStatus.create!({:contract_id => @contract.id, :name => "Candidate interviewed", :label => "I", :order => 2})
      JobApplicationStatus.create!({:contract_id => @contract.id, :name => "Offer-letter sent", :label => "S", :order => 3})
      JobApplicationStatus.create!({:contract_id => @contract.id, :name => "Offer accepted", :label => "A", :order => 4})
      
      flash[:success] = 'Opening was successfully created.'
      redirect_to my_recruitment_dashboard_path
    rescue
      render :template => "/recruit/openings/new.haml"
    end
  end  

  def edit
    @opening = Contract.find(params[:id])
    @organization = @opening.position.organization
  end
  
  def update
    begin
      ActiveRecord::Base.transaction do
        @organization = Organization.find(params[:organization_id])
        @position = _find_or_create_position(@organization, params[:position])
        
        @contract = Contract.find(params[:id])
        @contract.position_id = @position.id
        @contract.description = params[:contract][:description]
        @contract.benefits = params[:contract][:benefits]
        
        if params[:date][:asap].blank?
          @contract.from = params[:date][:from_year], params[:date][:from_month]
        end
        
        if params[:date][:open].blank?
          @contract.to = params[:date][:to_year], params[:date][:to_month]
        end
        
        @contract.posted_by_user_id = current_user.id
        @contract.save!
      end
    
      flash[:success] = 'Opening was successfully updated.'
      redirect_to my_recruitment_dashboard_path
    rescue
      raise
      render :template => "/recruit/openings/edit.haml"
    end
  end
  
  def _find_or_create_position(organization, params)
    if params[:id].blank?
      position = Position.new(params)
      position.save!
      organization.positions << position
    else
      position = Position.find(params[:id])
    end
    position
  end

end