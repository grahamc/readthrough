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

### Automatically on ALL your vagrant boxes:

Place this in `~/.vagrant.d/Vagrantfile`:

```ruby
Vagrant.configure(2) do |config|
  config.vm.provision "shell",
    privileged: false,
    inline: File.read(File.expand_path('~/.vagrant.d/gemcache'))
end
```

    This will automatically run the gemcache provisioner in all your vagrant
    boxes on `vagrant provision`. This provisioner will be "merged" with your
    per-project provisioner.

and place this in `~/vagrant.d/gemcache`:

```bash
#!/bin/bash

set -e
set -x
cd /home/vagrant
touch Gemfile
export GEM_MIRROR=`echo "$SSH_CLIENT" | cut -d' ' -f1`

function test_up()
{
  # -t -> attempts
  # -T -> timeout
  # -S -> Server response (headers)
  # --spider -> spider?
  # Somehow these arguments come together to execute a HEAD request.
  wget -t 1 -T 1 -S --spider http://$GEM_MIRROR:9000 2> /dev/null;
}

hash bundle 2> /dev/null || exit 0

bundle config --delete mirror.http://rubygems.org
bundle config --delete mirror.https://rubygems.org

test_up || exit 0

bundle config mirror.http://rubygems.org "http://$GEM_MIRROR:9000"
bundle config mirror.https://rubygems.org "http://$GEM_MIRROR:9000"
```

    This will detect if your gem mirror is running or not. If it is, it will
    ensure the configuration is in place. If it is not, it will ensure to remove
    any mirror configs in place, saving you from a broken provisioning.

# Then ...

Run `bundle install`, it'll go through the cache.

[source]: https://github.com/rubygems/rubygems.org-configs/tree/master/mirror
