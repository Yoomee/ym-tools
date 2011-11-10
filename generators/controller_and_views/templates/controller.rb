class <%=plural_name.camelize%>Controller < ApplicationController

  before_filter :get_<%=singular_name%>, :only => [:destroy, :edit, :show, :update]

  def create
    @<%=singular_name%> = <%=class_name%>.new(params[:<%=singular_name%>])
    if @<%=singular_name%>.save
      flash[:notice] = "Successfully created <%=singular_name%>."
      redirect_to @<%=singular_name%>
    else
      render :action => 'new'
    end
  end

  def destroy
    @<%=singular_name%>.destroy
    flash[:notice] = "Successfully deleted <%=singular_name%>."
    redirect_to_waypoint_after_destroy
  end

  def edit

  end
  
  def index
    @<%=plural_name%> = <%=class_name%>.all
  end  
  
  def new
    @<%=singular_name%> = <%=class_name%>.new
  end

  def show

  end

  def update
    if @<%=singular_name%>.update_attributes(params[:<%=singular_name%>])
      flash[:notice] = "Successfully updated <%=singular_name%>."
      redirect_to @<%=singular_name%>
    else
      render :action => 'edit'
    end
  end
  
  private
  def get_<%=singular_name%>
    @<%=singular_name%> = <%=class_name%>.find(params[:id])
  end

end