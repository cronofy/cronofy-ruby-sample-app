# Cronofy Ruby Sample Application

## Prerequisites

### A Git Tool

We would recommend downloading and using the Git Bash tool, which you can find [here](https://git-scm.com/downloads).

### A cloned version of this repository

For help in cloning this repository please see [this](https://help.github.com/articles/cloning-a-repository/) article.

### A Ruby on Rails environment

We recommend using [RailsInstaller](http://railsinstaller.org/en) to set up Ruby on Rails on your machine.

## Set-up

### Create a Cronofy application

To use the Cronofy Ruby Sample App you need to create a Cronofy application. To do this, [create a free developer account](https://app.cronofy.com/sign_up/developer), click "Create New App" in the left-hand navigation and create an application.

Once you've created your application you will need to set the `CRONOFY_CLIENT_ID` and `CRONOFY_CLIENT_SECRET` in the application's `config/local_env.yml` file.

### Deploying the Sample App

Open a terminal window and navigate it to your cloned repository. Once there run `bundle install && rails server`, this will set up your project and run your application at `http://localhost:3000`.

### Setting up a Remote URL

In order to test [Push Notification](https://www.cronofy.com/developers/api/#push-notifications) callbacks and Enterprise Connect user authentications your application will need to be reachable by the internet.

To do this we would recommend using [ngrok](https://ngrok.com/) to create a URL that is accessible by the Cronofy API.

Once you have ngrok installed you can initialise it for your application by using the following line in your terminal:

`ngrok http -host-header=localhost localhost:3000`

Your terminal will then display a URL in the format `http://[unique identifier].ngrok.io`. You will need to set the `DOMAIN` variable in the application's `config/local_env.yml` in order to test these remote features.

## Example `config/local_env.yml` file

Your complete `config/local_env.yml` file should look similar to this:

```
CRONOFY_CLIENT_ID: [cronofy client id]
CRONOFY_CLIENT_SECRET: [cronofy client secret]
   
DOMAIN: http://[ngrok identifier].ngrok.io
```
