# Cache your Gems

This is a very simple rubygems cache. It is a read-through, and uses nearly
identical configs to what [rubygems itself uses][source].

## From your local machine

Implementing it is easy as pie, run `vagrant up`, and then set bundler to use
your local cache:

```
bundle config mirror.http://rubygems.org http://localhost:9000
bundle config mirror.https://rubygems.org http://localhost:9000
```

## From within another Vagrant box

Or, if you're using it in another vagrant box, put this in a provisioning script:

```
GEM_MIRROR=`echo "$SSH_CLIENT" | cut -d' ' -f1`

bundle config mirror.http://rubygems.org "http://$GEM_MIRROR:9000"
bundle config mirror.https://rubygems.org "http://$GEM_MIRROR:9000"
```

# Then ...

Run `bundle install`, it'll go through the cache.

[source]: https://github.com/rubygems/rubygems.org-configs/tree/master/mirror
