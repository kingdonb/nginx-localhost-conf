### Nginx Localhost SSL conf

This HOWTO repo spawned from a [tweet thread](https://twitter.com/diybyo/status/1277705913386713088) about how to use Webpacker and Rails with SSL in local dev mode. The inspiration for this approach is based on a simple idea: if your Rails app won't be serving TLS in production (eg. if TLS is terminated by a load balancer or traffic shaping appliance that sits in front of the app), then the Rails app ought not be made responsible either, for terminating TLS in development mode!

The provided nginx configuration demonstrates a basic application of the Reverse Proxy mode, serving traffic on http://localhost and https://localhost, (your browser will probably choose the HTTPS path by default, in 2020) - then ultimately forwards the packets to an HTTP server on localhost port 3000, (the port that Rails Server listens on by default.)

Instructions:

* review [nginx.conf](nginx.conf) - some strings may need to be changed here
* review the article at [domysee](https://www.domysee.com/blogposts/reverse-proxy-nginx-docker-compose) where this config was derived from, for further insight into how this config is meant to be used
* (the configuration that I have used does not exercise all the features)
* `cd ssl/`
* review the configuration I have written in `localhost.csr.cnf` and `v3.ext`, and replace example values with your own preferred names.
* `./createRootCA.sh` - this will by default require you to assign a passphrase of at least 4 characters, that you will need to remember until the next script has run successfully
* Answer the prompts with any values or no values
* `./createselfsignedcertificate.sh` - this will require the CA passphrase you assigned earlier

At this point, four new files have been created:

* `.srl`
* `localhost.crt`
* `localhost.csr`
* `localhost.key`

... and two which I have added to the `.gitignore` so they will not be shared accidentally:

* `rootCA.key`
* `rootCA.pem`

If your user accepts the "Ignore Certificate Issues" warning from their browser, or if you can ensure their certificate chain (or if OS trust is configured) permitting trusting of certificates signed by `rootCA.pem`, then you will be able to use `localhost.crt` and `localhost.key` inside of nginx.conf to perform SSL termination for your app.

More attention paid to the caching section of the configuration is desirable. In this example I have disabled all caching and pass every request through to the Rails app, (so you may have to reconfigure Rails to serve static assets.) See `serve_static_files` or `serve_static_assets` in the [Rails Guide](https://guides.rubyonrails.org/v4.2/configuring.html#rails-general-configuration) - this configuration is especially undesirable for production, unless nginx caching has also been configured. (For a local dev, it is probably fine, as the browser will most likely be able to take care of the caching after a few tries.)

## UPDATE

Since I mostly took this nginx config example from somewhere else, and it uses or mentions a lot of features that I admitted that I am not using, I have added the localhost config that I am actually using for my single-app SSL setup in the directory [nginx/](nginx/). There are two files instead of one, you can put [nginx/localhost.conf](nginx/localhost.conf) into a `servers/` subdirectory of `/etc/nginx` and it is referred to from [nginx/nginx.conf](nginx/nginx.conf), which is placed directly into `/etc/nginx`.

You might be able to use it without modification instead. If you are on MacOS, `brew install nginx` and those files go into `/usr/local/etc/nginx/` where they are picked up by `brew services`. (Try `sudo brew services start nginx`). Good luck, and mash that Issues button or submit fixes as a PR if something doesn't look right or immediately work for you!
