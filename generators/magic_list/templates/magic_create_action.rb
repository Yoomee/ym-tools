def magic_create
  if request.xhr?
    render :update do |page|
      @<%=singular_name%> = <%=class_name%>.new(params[:<%=singular_name%>])
      if @<%=singular_name%>.save
        page["magic_<%=singular_name%>_list"].append(render("<%=plural_name%>/magic_list_item", :<%=singular_name%> => @<%=singular_name%>))
        @<%=singular_name%> = <%=class_name%>.new
      end
      page["magic_<%=singular_name%>_form"].replace_html(render("<%=plural_name%>/magic_form", :<%=singular_name%> => @<%=singular_name%>))
    end
  end
end