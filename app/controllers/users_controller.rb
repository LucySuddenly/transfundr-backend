class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create, :show, :rankings]

    def create
        user = User.new(user_params)
        if user.trans 
            user.femme = true
        end
        user.save
        if user.valid?
            profile_body = Base64.decode64(params["profile_image_file"].split(',')[1])
            profile_content = params["profile_image_file"].split(":")[1].split(";").flatten[0]
            profile_obj = S3_BUCKET.object((0...8).map { (65 + rand(26)).chr }.join + params["profile_image_file_name"])
            profile_obj.put(body: profile_body, acl: 'public-read', content_type: profile_content, content_encoding: 'base64')
            
            cover_body = Base64.decode64(params["cover_image_file"].split(',')[1])
            cover_content = params["cover_image_file"].split(":")[1].split(";").flatten[0]
            cover_obj = S3_BUCKET.object((0...8).map { (65 + rand(26)).chr }.join + params["cover_image_file_name"])
            cover_obj.put(body: cover_body, acl: 'public-read', content_type: cover_content, content_encoding: 'base64')

            profile = Profile.new(venmo: params["venmo"], cash: params["cash"], zelle: params["zelle"], paypal: params["paypal"], bio: params["bio"], profile_img: profile_obj.public_url, cover_img: cover_obj.public_url )
            profile.user_id = user.id
            profile.save
            token = encode_token(user_id: user.id)
            render json: {user: UserSerializer.new(user), jwt: token}, status: :created
        else
            render json: { error: user.errors.full_messages[0] }, status: :not_acceptable
        end
    end

    def show 
        user = User.find(params[:id])
        #prepare beacons
        beacons = user.beacons.map do |beacon|
            total = 0
            beacon.donations.each do |donation|
                if donation.confirmed 
                    total += donation.amount
                end
            end
            {beacon: beacon, total: total}
        end
        #prepare points
        points = 0
        user.donations.each do |donation|
            if donation.confirmed
                points += donation.points
            end
        end
        new_user = user.to_json(:include => [:profile, {:donations => {:include => {:beacon => {:include => {:user => {:include => :profile}}}}}}])
        new_user = JSON.parse(new_user)
        render json: {user: new_user, beacons: beacons, points: points}
    end

    def rankings 
        #prepare top ten
        users = User.all 
        donators = []
        users.each do |user|
            points = 0
            user.donations.map do |donation|
                if donation.confirmed
                    points += donation.points
                end
            end
            new_user = UserSerializer.new(user)
            if points > 0
                donators << {user: new_user, points: points}
            end
        end
        users = donators.sort_by do |user|
            user[:points]
        end.reverse
        top_ten_users =  users[0..9]
        #prepare Biggest Donations
        biggest_donation_today = Donation.first
        biggest_donation_week = Donation.first
        biggest_donation_month = Donation.first
        biggest_donation_year = Donation.first
        Donation.all.each do |donation|
            if donation.confirmed 
                if Time.now.to_i - donation.created_at.to_time.to_i < 86400
                    if donation.amount > biggest_donation_today.amount
                        biggest_donation_today = donation
                    end
                end
                if Time.now.to_i - donation.created_at.to_time.to_i < 604800
                    if donation.amount > biggest_donation_week.amount
                        biggest_donation_week = donation
                    end
                end
                if Time.now.to_i - donation.created_at.to_time.to_i < 2592000
                    if donation.amount > biggest_donation_month.amount
                        biggest_donation_month = donation
                    end
                end
                if Time.now.to_i - donation.created_at.to_time.to_i < 31536000
                    if donation.amount > biggest_donation_year.amount
                        biggest_donation_year = donation
                    end
                end
            end
        end
        biggest_donation_today = biggest_donation_today.to_json(:include => {:user =>{:include => :profile}})
        biggest_donation_week = biggest_donation_week.to_json(:include => {:user =>{:include => :profile}})
        biggest_donation_month = biggest_donation_month.to_json(:include => {:user =>{:include => :profile}})
        biggest_donation_year = biggest_donation_year.to_json(:include => {:user =>{:include => :profile}})
        biggest_donation_today = JSON.parse(biggest_donation_today)
        biggest_donation_week = JSON.parse(biggest_donation_week)
        biggest_donation_month = JSON.parse(biggest_donation_month)
        biggest_donation_year = JSON.parse(biggest_donation_year)
        
        render json: {topTen: top_ten_users, biggestToday: biggest_donation_today, biggestWeek: biggest_donation_week, biggestMonth: biggest_donation_month, biggestYear: biggest_donation_year}
    end


    private

    def user_params
        params.permit(:username, :email, :password, :trans, :femme, :nonwhite)
    end
end
