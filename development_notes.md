## No API Call Branch
This is a branch to allow cc-checks to be ran during deployment of an official Chamleon Cloud image.  

## Dev Process (The method I use)
Environment I'm using: CentOS7 (stock ruby) with pry and pry-nav gems installed for breakpoints

1. make changes to Ruby files
2. run the testing_update_rpm.sh script

The testing_update_rpm.sh script is just a wrapper to remove the current version of g5k-checks, run scripts/jenkins/build_rpm.sh, and locally install it

The current no_api_formatter.rb is basically a clone of the api_formatter.rb because I can not get it to load:
```
[1] pry(#<G5kChecks::G5kChecks>)> c
/usr/share/rubygems/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- g5kchecks/rspec/core/formatter/no_api_formatter (LoadError)
        from /usr/share/rubygems/rubygems/core_ext/kernel_require.rb:55:in `require'
        from /usr/share/gems/gems/g5k-checks-0.7.5/lib/g5kchecks.rb:76:in `run'
        from /usr/share/gems/gems/g5k-checks-0.7.5/bin/g5k-checks:84:in `<top (required)>'
        from /usr/bin/cc-checks:23:in `load'
        from /usr/bin/cc-checks:23:in `<main>'
```
I've set up a breakpoint right before the call that loads no_api_formatter.rb.
```
From: /usr/share/gems/gems/g5k-checks-0.7.5/lib/g5kchecks.rb @ line 75 G5kChecks::G5kChecks#run:
    74:       elsif conf["mode"] == "no_api"
 => 75:         binding.pry
    76:         require 'g5kchecks/rspec/core/formatter/no_api_formatter'

```
Another is set if you want to see the working implementation with -m api.
## To invoke the changes being made:
```
sudo cc-checks -m no_api
```
