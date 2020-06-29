### Nginx Localhost SSL conf

Instructions:

* review [nginx.conf](nginx.conf)
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

More attention paid to the caching section of the configuration is desirable. In this example I have disabled all caching and pass every request through to the Rails app, (so you may have to reconfigure Rails to serve static assets. See `serve_static_files` or `serve_static_assets` in the [Rails Guide](https://guides.rubyonrails.org/v4.2/configuring.html#rails-general-configuration) - this configuration is especially undesirable for production, unless nginx caching has also been configured. (For a local dev, it is probably fine, as the browser will most likely be able to take care of the caching after a few tries.)
