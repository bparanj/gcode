rails g model location address latitude:float longitude:float
rails db:migrate

<!DOCTYPE html>
<html>
  <head>
    <title>Gcode</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <div id="container">
    <% flash.each do |name, msg| %>
      <%= content_tag :div, msg, :id => "flash_#{name}" %>
    <% end %>

    <%= yield %>
  </div>

</html>

geocoder version : 1.4.1


gem 'geocoder'

rails g controller locations

class LocationsController < ApplicationController
  def index
    if params[:search].present?
      @locations = Location.near(params[:search], 50, :order => :distance)
    else
      @locations = Location.all
    end
  end

  def show
    @location = Location.find(params[:id])
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(allowed_params)
    if @location.save
      redirect_to @location, :notice => "Successfully created location."
    else
      render :new
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(allowed_params)
      redirect_to @location, :notice  => "Successfully updated location."
    else
      render :edit
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    
    redirect_to locations_url, :notice => "Successfully destroyed location."
  end
  
  private
  
  def allowed_params
    params.require(:location).permit(:id, :address, :latitude, :longitude)
  end
end


class Location < ApplicationRecord
  geocoded_by :address       # can also be an IP address
  after_validation :geocode  # auto-fetch coordinates
end

locations/_form.html.erb:

<%= form_for @location do |f| %>
  <p>
    <%= f.label :address %><br />
    <%= f.text_field :address %>
  </p>
  <p>
    <%= f.label :latitude %><br />
    <%= f.text_field :latitude %>
  </p>
  <p>
    <%= f.label :longitude %><br />
    <%= f.text_field :longitude %>
  </p>
  <p><%= f.submit %></p>
<% end %>

edit.html.erb:

<%= render 'form' %>

<p>
  <%= link_to "Show", @location %> |
  <%= link_to "View All", locations_path %>
</p>

index.html.erb:

<%= form_tag locations_path, :method => :get do %>
  <p>
    <%= text_field_tag :search, params[:search] %>
    <%= submit_tag "Search Near", :name => nil %>
  </p>
<% end %>

<table>
  <tr>
    <th>Address</th>
    <th>Latitude</th>
    <th>Longitude</th>
  </tr>
  <% for location in @locations %>
    <tr>
      <td><%= location.address %></td>
      <td><%= location.latitude %></td>
      <td><%= location.longitude %></td>
      <td><%= link_to "Show", location %></td>
      <td><%= link_to "Edit", edit_location_path(location) %></td>
      <td><%= link_to "Destroy", location, :confirm => 'Are you sure?', :method => :delete %></td>
    </tr>
  <% end %>
</table>

<p><%= link_to "New Location", new_location_path %></p>


new.html.erb:

<%= render 'form' %>

<p><%= link_to "Back to List", locations_path %></p>

show.html.erb:

<p>
  <strong>Address:</strong>
  <%= @location.address %>
</p>
<p>
  <strong>Latitude:</strong>
  <%= @location.latitude %>
</p>
<p>
  <strong>Longitude:</strong>
  <%= @location.longitude %>
</p>

<%= image_tag "http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false&zoom=16&markers=#{@location.latitude}%2C#{@location.longitude}" %>

<h3>Nearby locations</h3>
<ul>
<% for location in @location.nearbys(10) %>
  <li><%= link_to location.address, location %> (<%= location.distance.round(2) %> miles)</li>
<% end %>
</ul>

<p>
  <%= link_to "Edit", edit_location_path(@location) %> |
  <%= link_to "Destroy", @location, :confirm => 'Are you sure?', :method => :delete %> |
  <%= link_to "View All", locations_path %>
</p>



routes.rb:

  resources :locations
  
You can now create locations.

https://github.com/alexreisner/geocoder




