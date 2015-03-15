---
layout: post
title: Set Up a Staging Environment for Your Rails App on Heroku
excerpt: "Setting up a staging environment on Heroku requires a couple of special steps that I’ve decided to keep here in the same place."
type: long
---

This morning I had occasion to set up a staging environment on the first Rails project I’ve run on Heroku for a client in a little while and rediscovered a few of the little Heroku-specific things you need to do to make this work. I decided to write something up to help me remember in the future.

### Why Staging?

If you’re running a small web application on Heroku, it may feel like overkill to set up a separate staging environment when it’s just you or a small team making changes. However, even with the simplest applications, the smallest difference between development and production environments can cause things to blow up. Setting up a staging environment, and taking advantage of it, will save you eventually.

If you’re working on an application for client, the staging environment provides the perfect way to show your work in progress and receive feedback without having to arrange demonstrations in the production environment.

### What is a Staging Environment?

Your goal for your staging environment is to blend the benefits of your development and production environments. Like your development environment, no one needs to see this code until you’re ready for them to and you’re free to experiment and to leave your unfinished business lying around. However, unlike your development environment, your staging environment should be running on a server configured exactly as your production server is. This balance lets you try new ideas in a production-like environment without spreading your mess to your actual production environment.

### Getting Set Up on Heroku

I’m going to assume you already have things well-configured to get your project deployed to a public production enviornment on Heroku.

First, set up a new app on Heroku and set it up with all of the same add-ons you have running your production app.[^gocheap] Go to the Settings view to find your Git URL. It should follow the format `git@heroku.com:your-staging-app-name.git`. While your application’s directory on your development machine, add this repo as a remote called `staging-heroku`:

{% highlight bash %}
git remote add staging-heroku git@heroku.com:your-staging-app-name.git
{% endhighlight %}

If you haven’t already created a `staging` branch on your local Git repo, make sure to do that and merge over your active `development` branch (or whatever other branch you want to see in your staging environment):

{% highlight bash %}
git checkout -b staging
git merge development
{% endhighlight %}

Here’s a special case when dealing with Heroku. Its Git-based deployment approach assumes that the `master` branch is the branch that will be deployed. When we’re using a Heroku application as a staging environment, we’ll almost certainly be pushing a branch named something other than `master` (`staging` if you’re following these instructions, of course), so we’ll need to make a slight variation to our usual `git push` command:

{% highlight bash %}
git push staging-heroku staging:master
{% endhighlight %}

In the above command we’re pushing from our local `staging` branch to the `master` branch on the remote named `staging-heroku`. If we’ve done everything correctly, we should see the usual Heroku deployment output, but on our Heroku staging app rather than the usual production app.

You’ll need to run your migrations against the database you’ve set up on the staging app: 

{% highlight bash %}
heroku run rake db:migrate --app your-staging-app-name
{% endhighlight %}

You may have your own way to seed data on the new staging environment, but a quick and easy way to get data into your staging app is to copy it over from the production environment. You can repeat this process from time-to-time if you’d like to keep your data in the two environments relatively closely tied. First, add the pgbackups add-on to both your production and staging apps if you haven’t already:

{% highlight bash %}
heroku addons:add pgbackups --app your-staging-app-name
heroku addons:add pgbackups --app your-production-app-name
{% endhighlight %}

Then, create a new backup of the data on your production app and copy that backup to your staging app. You’ll want to verify what level of database you’re using on the Settings page of your staging app. For this example, I’m using the free Blue tier:

{% highlight bash %}
heroku pgbackups:capture --expire --app your-production-app-name
heroku pgbackups:restore HEROKU_POSTGRESQL_BLUE --app your-staging-app-name `heroku pgbackups:url --app your-production-app-name`
{% endhighlight %}

Finally, you’ll want to set up environment variables on your new Heroku staging app so that you can use settings specific to the staging environment when necessary:

{% highlight bash %}
heroku config:add RACK_ENV=staging RAILS_ENV=staging --app your-staging-app-name
{% endhighlight %}

Now you can add a new environment configuration file for the staging environment to your Rails app at `/config/environments/staging.rb`. Just as in `development.rb` or `production.rb`, you’ll add staging-specific settings here. As an example, we can set up basic HTTP authentication to keep casual passers-by away from seeing our in-progress work at staging. We can use our new staging configuration file to save the username and password.[^password] Then we’ll put a simple `authenticate` method in our application controller along with a `before_filter` to call that method when we’re running in the staging environment.

{% highlight ruby %}
# /config/environments/staging.rb
config.user_id = "staging_user"
config.password = "staging_password"
{% endhighlight %}

{% highlight ruby %}
# /app/controllers/application_controller.rb

if Rails.env == "staging"
  before_filter :authenticate
end

def authenticate
  authenticate_or_request_with_http_basic do |username, password|
    username == Rails.configuration.user_id && password == Rails.configuration.password 
  end
end
{% endhighlight %}




[^gocheap]: I know I said that your staging environment should be configured precisely as the production server is, but unless absolutely necessary, I actually tend to cheap out when configuring the staging app on Heroku. Unless I’m planning on specifically testing elements that would require running at scale, I stick with the free add-ons. Heroku makes it easy to ramp these services up and down as needed.

[^password]: This approach is convenient, but it’s not the most secure. In this case, I’m envisioning a small client project where I’m not sharing the code on an open repository. In cases where you anticipate sharing your code without wanting to share the passwords, using environment variables on Heroku for these settings would be more secure. 