require 'pp'
Pakyow::App.bindings :people do
	scope :people do
		restful :people

		options(:category_one) do
			get_nested_category_id_and_category_name()
		end
		options(:category_two) do
			get_nested_category_id_and_category_name()
		end
		options(:category_three) do
			get_nested_category_id_and_category_name()
		end

		binding(:id) do
			{
				:value => bindable.id
			}
		end
		binding(:member_number) do
			{
				:content => bindable.id,
				:class => bindable.id
			}
		end
		binding(:approve_profile_url) do
			{
				:href => '/people/approve/' + bindable.id.to_s
			}
		end
		binding(:spam_profile_url) do
			{
				:href => '/people/spam/' + bindable.id.to_s
			}
		end

		binding(:company) do
			{
				:content => bindable.company
			}
		end

		binding(:twitter_link) do

			show = "hide"
			title = ""
			link = ""
			content = ""
			if cookies[:userinfo].nil?
				show = "show"
				title = "Log in to view " + bindable.email + "'s Twitter profile"
				link = "/auth/auth0"
				content = "Log in to view"
			else
				unless bindable.nil? || bindable.twitter.nil? || bindable.twitter.length ==	 0
					show = "show"
				end
				unless bindable.email.nil?
					title = bindable.email + "'s profile on Twitter"
				end
				link = "/clicks/people/" + bindable.custom_url + "/twitter"
				content = "Twitter"
			end
			{
				:target => "_blank",
				:href => link,
				:class => show,
				:title => title,
				:content => content
			}
		end

		binding(:linkedin_link) do

			show = "hide"
			title = ""
			link = ""
			content = ""
			if cookies[:userinfo].nil?
				show = "show"
				title = "Log in to view " + bindable.email + "'s Twitter profile"
				link = "/auth/auth0"
				content = "Log in to view"

			else
				content = "LinkedIn"
				unless bindable.nil? || bindable.linkedin.nil? || bindable.linkedin.length == 0
					show = "show"
					link = "/clicks/people/" + bindable.custom_url + "/linkedin"
				end
				unless bindable.email.nil?
					title = bindable.email + "'s profile on LinkedIn"
				end
			end
			{
				:title => title,
				:href => link,
				:class => show,
				:target => "_blank",
				:content => content
			}
		end

		binding(:url_link) do
			show = "hide"
			title = ""
			link = ""
			content = ""
			if cookies[:userinfo].nil?
					show = "show"
					title = "Log in to view " + bindable.email + "'s Website"
					link = "/auth/auth0"
					content = "Log in to view"
			else
				content = "Website"
				if bindable.nil? || bindable.url.nil? || bindable.url.length == 0

				else
					show = "show"
					link = "/clicks/people/" + bindable.custom_url + "/url"
				end

				unless bindable.email.nil?
					title = bindable.email + "'s URL"
				end
			end
			{
				:target => "_blank",
				:href => link,
				:class => show,
				:title => title,
				:content => content
			}
		end

		binding(:twitter) do
			{
				:content => bindable.twitter
			}
		end

		binding(:linkedin) do
			{
				:content => bindable.linkedin
			}
		end

		binding(:url) do
			{
				:content => bindable.url
			}
		end

		binding(:other_info) do
			{
				:content => bindable.other_info
			}
		end

		binding(:email_link) do
			if bindable.email.nil?
				bindable.email = "webmaster@openhsv.com"
			end
			{
				:content => bindable.email,
				:href => "mailto:" + bindable.email
			}
		end

		binding(:email) do
			if bindable.email.nil?
				bindable.email = "email"
			end
			{
				:content => bindable.email
			}
		end

		binding(:people_card_title) do
			puts bindable.inspect
			title = bindable.first_name.to_s + " " + bindable.last_name.to_s
			if bindable.last_name.to_s.empty?
				title = bindable.first_name
			end
			if bindable.first_name.to_s.empty?
				title = bindable.email
			end

			if title.to_s.empty?
				title = "Anonymous"
			end
			{
				:content => title
			}
		end

		binding(:categories_string) do
			{
				:content => bindable.categories_string
			}
		end

		binding (:category_one_link) do
			href = ""
			content = ""
			unless bindable.nil? || bindable.categories.nil?
				jsn = bindable.categories.to_s
				unless jsn.nil? || jsn.length == 0
					array = JSON.parse(jsn)

					unless array[0].nil? || array[0].length == 0
					    category = Category[array[0]]
						href = "#"
						content = category.category
						href = category.url
					end
				end
			end
			{
				:href => href,
				:content => content
			}
		end

		binding (:category_two_link) do
			href = ""
			content = ""
			unless bindable.nil? || bindable.categories.nil?
				jsn = bindable.categories.to_s
				unless jsn.nil? || jsn.length == 0
					array = JSON.parse(jsn)
					unless array[1].nil? || array[1].length == 0

					    category = Category[array[1]]
						href = "#"
						content = category.category
						href = category.url
					end
				end
			end
			{
				:href => href,
				:content => content
			}
		end

		binding (:category_three_link) do
			href = ""
			content = ""
			unless bindable.nil? || bindable.categories.nil?
				jsn = bindable.categories.to_s
				unless jsn.nil? || jsn.length == 0
					array = JSON.parse(jsn)

					unless array[2].nil? || array[2].length == 0
					   category = Category[array[2]]
						href = "#"
						content = category.category
						href = category.url
					end
				end
			end
			{
				:href => href,
				:content => content
			}
		end

		binding(:category_one) do
			bindable.category_one_id
		end

		binding(:category_two) do
			bindable.category_two_id
		end
		binding(:category_spacer_one) do
			log_debug("/app/lib/bindings.rb :: category_spacer_one :: ", bindable.categories_string.to_s)
			cat = ""
			unless bindable.categories.nil?
				jsn = bindable.categories.to_s
				array = JSON.parse(jsn)
			   if array.length > 1 && array[1].length > 1
			   	cat =  "&nbsp;/&nbsp;"
			   end
			end
			{
				:content => cat
			}
		end

		binding(:category_three) do
			bindable.category_three_id
		end
		binding(:category_spacer_two) do
			log_debug("/app/lib/bindings.rb :: category_spacer_one :: ", bindable.categories_string.to_s)
			cat = ""
			unless bindable.categories.nil?
				jsn = bindable.categories.to_s
				array = JSON.parse(jsn)
			   if array.length > 2 && array[2].length > 1
			   	cat =  "&nbsp;/&nbsp;"
			   end
			end
			{
				:content => cat
			}
		end

		binding(:image_url) do
			bindable.image_url
		end

		binding(:image) do
			puts 'binding(:image) do'

			src = ""
			name = ""
			unless bindable.nil?
				unless bindable.email.nil?
					name = bindable.email

					unless bindable.image_url.nil? || bindable.image_url.length == 0
						pp 'bindable.image_url.nil? || bindable.image_url.length == 0'
						src = bindable.image_url
					else
						needle = bindable.email
						haystack = [
							'Abbie-Cataldo',
							'Adam-Whipple',
							'Alex-Moore',
							'Andrew-Hall',
							'Angie-Holt',
							'Ben-Jarrell',
							'Brad-Garland',
							'Candy-Ballenger',
							'Chris-Beaman',
							'Clay-Thomas',
							'Collier-Ward',
							'Dale-Gipson',
							'David-Cochran',
							'Doug-Martinson',
							'Drew-Chapman',
							'Elissa-Cain',
							'Eric-Gregorian',
							'Eric-John',
							'Everett-Brooks',
							'George-Kobler',
							'George-Smith',
							'Hall-Bryant',
							'Jacob-Birmingham',
							'Jeff-Hammock',
							'Jeff-Irons',
							'Jeremiah-Arsenault',
							'Joe-MacKen	zie',
							'Krista-Campbell',
							'Kyle-Newman',
							'Laurie-Heard',
							'Marty-Sellers',
							'Matt-Massaro',
							'Mital-Modi',
							'Paul-Finley',
							'Rich-Marsden',
							'Rob-Campbell',
							'Robb-Dempsey',
							'Samantha-Brinkley',
							'Scott-Cribbs',
							'Seth-Turner',
							'Stephen-Hall',
							'Tarra-Anzalone',
							'Vicki-Morris'
						]
						if haystack.include?(needle)
							pp 'haystack includes needle'
							src = "https://s3.amazonaws.com/openhsv.com/manual-uploads/" + name + ".jpg"
						else
							src = "/img/profile-backup.png"
						end
						pp 'ELSE bindable.image_url.nil? || bindable.image_url.length == 0'
					end
				else
					pp 'ELSE bindable.email.nil?'
				end
			else
				pp 'bindable NIL'
			end
			pp src
			{
				:src => src,
				:title =>  name,
				:alt => name
			}
		end

		binding(:image_unveil) do
			src = ""
			name = ""
			unless bindable.nil?
				unless bindable.email.nil?
					unless bindable.image_url.nil?
						src = bindable.image_url
					else
						src = "https://s3.amazonaws.com/openhsv.com/manual-uploads/" + bindable.auth0_id + ".jpg"
					end
				end
			end
			{

				:'data-src' => src,
				:title =>  name,
				:alt => name
			}
		end

		binding(:custom_url) do
			bindable.custom_url
		end

		binding(:admin) do
			{
				:checked => bindable[:admin]
			}
		end

		binding(:approved) do
			{
				:checked => bindable[:approved]
			}
		end

		binding(:is_elite) do
			{
				:checked => bindable[:is_elite]
			}
		end

		binding(:profile_link) do

			email = ""
			unless bindable.email.nil?
				email = bindable.email
			end
			{
				:href => "/people/" + bindable.custom_url,
				:content => email
			}
		end

		binding(:edit_profile_link) do
			{
				:href => "/people/" + bindable.custom_url.to_s + "/edit"
			}
		end

		binding(:edit_user_btn) do
			visible = "show"
			people = get_user_from_cookies()
			if people.nil? || people.admin.nil? || people.admin == false
				visible = "hide"
			end
			{
				class: lambda { |klass| klass << visible }
			}
		end

		binding(:edit_user_btn_href) do
			{
				:href => "/people/" + bindable.custom_url.to_s + "/edit"
			}
		end

		binding(:admin_fieldset) do
			visible = "show"
		  	people = get_user_from_cookies()
			if people.nil? || people.admin.nil? || people.admin == false
			 	visible = "hide"
			end
			{
				:class => visible
			}
		end

		binding(:container) do
			classes = "profile"
			unless bindable.categories.nil?
				jsn = bindable.categories.to_s
				array = JSON.parse(jsn)
				unless array[0].nil? || array[0].length == 0
					classes = classes + " " + get_css_classes_for_category(array[0])
				end

				unless array[1].nil? || array[1].length == 0
					classes = classes + " " + get_css_classes_for_category(array[1])
				end

				unless array[2].nil? || array[2].length == 0
					classes = classes + " " + get_css_classes_for_category(array[2])
				end
			end
			{
				:class => classes
			}
		end
		binding(:bio) do
			bindable.bio
		end

		binding(:events_link) do
			{
			:content => "Events",
			:href => '/people/' + bindable.custom_url.to_s + '/events'
			}
		end

		# schedule_event_link
    	# previous_link = {:class => 'previous-next-btns', :href => "/people"}

		binding(:schedule_event_link) do
			{
			:css => "btn btn-blue",
			:content => "Schedule Event",
			:href => '/people/' + bindable.custom_url.to_s + '/events/new'
			}
		end

		binding(:delete_user_link) do
			{
			:content => "Delete Account",
			:href => '/people/' + bindable.id.to_s + '/delete',
			:class => 'delete-btn'
			}
		end
    end
end
