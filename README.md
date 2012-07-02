SmartBox
========

GIT clone
---------

Replace `<user>` with your actual user.

    git clone https://github.com/FDVSolutions/smartbox

Development
-----------

To run the application, you'll need to:

* Install Ruby > 1.9. We recommend to use [RVM](http://beginrescueend.com/).
* Install Bundler: `gem install bundler`
* Install all the dependencies: `bundle install`

To run the local development server, just run:

    $ rackup

To build the static application:

    $ rake build

To clone outside fdv's lan you have to set this environment variable:
    
    $ export GIT_SSL_NO_VERIFY=true
    
Or, alternatively:

    $ git config http.sslVerify "false"
