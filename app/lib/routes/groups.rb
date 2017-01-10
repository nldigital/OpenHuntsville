Pakyow::App.routes(:groups) do
  include SharedRoutes

  expand :restful, :groups, '/groups', :before => :route_head do
    collection do
      get 'unapproved' do
        if cookies[:people].nil? || cookies[:people] == "" || cookies[:people].size == 0
          redirect '/errors/401'
        else
          person = People[cookies[:people]]
          unless person.admin
            redirect '/errors/403'
          end
        end
        subset = Array.new
        all =  Group.all
        all.each { |group|
          if group.approved.nil? || !(group.approved)
            subset.push(group)
          end
        }
        view.scope(:groups).apply(subset)
        view.scope(:head).apply(request)
        view.scope(:main_menu).apply(request)
      end
    end

    member do
      get 'removeadmin/:people_id' do
        person = People[params[:people_id]]
        group = Group[params[:groups_id]]
        if logged_in_user_is_manager_of_group(group) == false
          redirect "/errors/403"
        end
        unless person.nil? || group.nil?
          group.remove_person(person)
        end
        redirect '/groups/' + group.id.to_s + '/edit'
      end
    end

    # GET '/groups/new'
    action :new, :before => :is_admin_check do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      view.scope(:groups).with do
        bind(Group.new)
      end
      view.scope(:people).bind(people)
      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    #POST '/groups/'
    action :create, :before => :is_admin_check  do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      category_array = [params[:groups][:category_one],params[:groups][:category_two],params[:groups][:category_three]]
      c_params =
        {
          "name" => params[:groups][:name],
          "description" => params[:groups][:description],
          "approved" => true,
          "categories" => Sequel::Postgres::JSONHash.new(category_array)
        }
      group = Group.new(c_params)
      group.save

      admins = People.where("admin = true").all
      admins.each { |person|
        person.add_group(group)
      }

      redirect '/groups/' + group.id.to_s + '/edit'
    end

    # GET /groups; same as Index
    action :list, :before => :route_head do
      if session[:random].nil?
        session[:random] = (rand(0...100)).to_s
      end
      my_limit = 10
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          my_limit = 2
        end
      end
      ran = session[:random].to_i*100
      total_groups = Group.where("approved = true").count
      # If user is authenticated, don't show default
      page_no = 0
      unless cookies[:people].nil? || cookies[:people] == "" || cookies[:people].size == 0
        previous_link = {:class => 'hide',:value => 'hidden'}
        unless params[:page].nil? || params[:page].size == 0
          page_no = params[:page].to_i
          unless page_no == 0
            unless page_no == 1
              previous_link = {:class => 'previous-next-btns', :href => "/groups?page=#{page_no-1}"}
            else
              previous_link = {:class => 'previous-next-btns', :href => "/groups"}
            end
          end
        end
        current_last_profile_shown = (page_no + 1) * my_limit
        pp 'current  ' + current_last_profile_shown.to_s
        pp 'total_pgroups  ' + total_groups.to_s
        if current_last_profile_shown < total_groups
          next_link = {:class => 'previous-next-btns',:href=>"/groups?page=#{page_no+1}"}
        end
        more_links = {'previous_link'=>previous_link,'next_link'=>next_link}
        view.scope(:after_groups).bind(more_links)
        view.scope(:after_groups).use(:authenticated)
      else
        count = {'full-count' => total_groups.to_s}
        view.scope(:after_groups).bind(count)
        view.scope(:after_groups).use(:normal)
      end
      #groups = Group.where("approved = true AND image_url IS NOT NULL AND image_url != '/img/profile-backup.png'").limit(my_limit).offset(page_no*my_limit).all
      groups = Group.where("approved = true").limit(my_limit).offset(page_no*my_limit).all
      shuffled = groups.shuffle(random: Random.new(ran))

      view.scope(:groups).apply(shuffled)

      all_cats = Category.order(:slug).all
      parent_cats = []
      all_cats.each { |item|
        if item.parent_id.nil?
          parent_cats.push(item)
        end
      }
      parent_cats.unshift("everyone")
      view.scope(:categories_menu).apply(parent_cats)
      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
    end

    # GET /groups/:groups_id
    action :show do
      group = Group.where("id = ?", params[:groups_id]).first
      view.scope(:groups).apply(group)

      all_cats = Category.order(:slug).all
      parent_cats = []
      all_cats.each { |item|
        if item.parent_id.nil?
          parent_cats.push(item)
        end
      }
      parent_cats.unshift("everyone")
      view.scope(:categories_menu).apply(parent_cats)

      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    # GET /groups/:groups_id/edit
    action :edit do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      group = Group.where("id = ?", params[:groups_id]).first
      if logged_in_user_is_manager_of_group(group) == false
        redirect "/errors/403"
      end
      view.scope(:groups).apply([group, group])
      group_admins = group.people().sort_by(&:first_name)
      view.scope(:groups).scope(:group_admins).apply(group_admins)
      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    #PATCH '/groups/:groups_id'
    action :update do
      group = Group[params[:groups][:id]]
      if logged_in_user_is_manager_of_group(group) == false
        redirect "/errors/403"
      end
      unless group.nil?
        #if adding group admins, only update group admins
        unless params[:groups][:add_group_admin].nil? || params[:groups][:add_group_admin].length == 0
          person_to_add = People[params[:groups][:add_group_admin]]
          unless person_to_add.nil?
            group.add_person(person_to_add)
          end
        else
          group.name = params[:groups][:name]
          group.description = params[:groups][:description]
          category_array = [params[:groups][:category_one],params[:groups][:category_two],params[:groups][:category_three]]
          group.categories = Sequel::Postgres::JSONHash.new(category_array)
          group.save
        end
        redirect '/groups/' + params[:groups][:id].to_s + '/edit'
      end
    end
  end
end