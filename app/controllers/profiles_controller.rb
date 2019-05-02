class ProfilesController < ApplicationController
    skip_before_action :authorized, only: [:get_profile_by_user_id]

    def get_profile_by_user_id
        profile = Profile.find_by(user_id: params[:id])
        render json: profile
    end

    def show
        profile = Profile.find(params[:id])
        render json: profile
    end

    def update
        if params["profile_image_file"] && params["cover_image_file"]
            profile_body = Base64.decode64(params["profile_image_file"].split(',')[1])
            profile_content = params["profile_image_file"].split(":")[1].split(";").flatten[0]
            profile_obj = S3_BUCKET.object((0...8).map { (65 + rand(26)).chr }.join + params["profile_image_file_name"])
            profile_obj.put(body: profile_body, acl: 'public-read', content_type: profile_content, content_encoding: 'base64')
            
            cover_body = Base64.decode64(params["cover_image_file"].split(',')[1])
            cover_content = params["cover_image_file"].split(":")[1].split(";").flatten[0]
            cover_obj = S3_BUCKET.object((0...8).map { (65 + rand(26)).chr }.join + params["cover_image_file_name"])
            cover_obj.put(body: cover_body, acl: 'public-read', content_type: cover_content, content_encoding: 'base64')
        
            profile = Profile.find(params[:id])
            profile.update(venmo: params["venmo"], cash: params["cash"], zelle: params["zelle"], paypal: params["paypal"], bio: params["bio"], profile_img: profile_obj.public_url, cover_img: cover_obj.public_url )
            profile.save
            render json: profile
        elsif params["profile_image_file"]
            profile_body = Base64.decode64(params["profile_image_file"].split(',')[1])
            profile_content = params["profile_image_file"].split(":")[1].split(";").flatten[0]
            profile_obj = S3_BUCKET.object((0...8).map { (65 + rand(26)).chr }.join + params["profile_image_file_name"])
            profile_obj.put(body: profile_body, acl: 'public-read', content_type: profile_content, content_encoding: 'base64')
            
            profile = Profile.find(params[:id])
            profile.update(venmo: params["venmo"], cash: params["cash"], zelle: params["zelle"], paypal: params["paypal"], bio: params["bio"], profile_img: profile_obj.public_url)
            profile.save
            render json: profile
        elsif params["cover_image_file"]
            cover_body = Base64.decode64(params["cover_image_file"].split(',')[1])
            cover_content = params["cover_image_file"].split(":")[1].split(";").flatten[0]
            cover_obj = S3_BUCKET.object((0...8).map { (65 + rand(26)).chr }.join + params["cover_image_file_name"])
            cover_obj.put(body: cover_body, acl: 'public-read', content_type: cover_content, content_encoding: 'base64')

            profile = Profile.find(params[:id])
            profile.update(venmo: params["venmo"], cash: params["cash"], zelle: params["zelle"], paypal: params["paypal"], bio: params["bio"], cover_img: cover_obj.public_url )
            profile.save
            render json: profile
        else
            profile = Profile.find(params[:id])
            profile.update(profile_params)
            profile.save
            render json: profile
        end
    end
    
    private

    def profile_params
        params.permit(:bio, :cover_img, :profile_img, :venmo, :cash, :paypal, :zelle)
    end
end
