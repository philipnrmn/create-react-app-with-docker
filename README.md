# create-react-app-with-docker

A sensible create-react-app configuration using docker and make.


## Getting started

Run create-react-app in docker:
```bash
make env
```

This will create the app directory, in which you will find a familiar node project structure. 

Next, run the development server:
```bash
make run
```

Add a dependency (like 'npm install lodash --save'):
```bash
PACKAGE=lodash make add
```

Delete the node_modules directory and reinstall everything in package.json:
```bash
make clean
make deps
```

Build an optimised version of your app for distribution:
```bash
make dist
```


## What's actually happening?

The `node` and `npm` binaries are now running inside [the official node alpine docker][0] container, but nothing else 
has changed. Your app directory is mounted into the docker container at `/home/node/app`. Anything else on your machine 
is not accessible; for example if your code accesses `/tmp`, it will access `/tmp` inside the container, not `/tmp` on
your machine. 

Changing code on your machine will change the code running inside the container, so hot reloading will continue to
work. Your code isn't being added to the image. This also means you can continue to use familiar commands like `npm
install` interchangeably with make commands like `make add`. 


## Why should I use this?

Normally when you want to run create-react-app, you need node.js and npm installed on your machine. If you regularly
work with node, you will likely have multiple versions of both node.js and npm installed for different projects, and
will use a utility like [nvm][1] to switch between them. You probably also have a few npm packages installed globally
instead of into your node_modules directory.

This works well for an individual developer, or a dedicated frontend team. It causes friction when you distribute a
UI as a component of a larger project, or when you're trying to maintain a continuous integration environment. It's 
common for the frontend build to be fragile and to require lengthy documentation.

By running those tools inside a docker container, we create a lightweight, version-controllable, replicable environment
which can be run on any machine that supports [docker][2]. 

Instead of having to maintain a list of node versions which other developers must install and keep updated, you can 
now simply update the node version by bumping the tag in your Makefile to a [different image][3].


## Using a custom docker image

There are cases where you will want to use a custom docker image. You can do this by renaming the included template
Dockerfile.tpl to Dockerfile. 

Then if, for example, you would like [imagemagick][4] to be available in your container, you could add this line:
```
RUN apk add imagemagick
```

Then build your custom docker image, giving it the tag of your choice (we're giving this image the name 'gallery' and
the version '0.1'):
```bash
docker build . --tag gallery:0.1
```

Lastly, update the image and version variables at the top of the Makefile to use your newly built docker image:
```
IMG=gallery
V=0.1
```

That's it, you're done! Commit your new Dockerfile and the changes you made to your Makefile, and you're good to go. 
If you want to share your image with other people (or your CI environment) you can [push it up to dockerhub][5] or the
private registry of your choice. 


## Ejecting Docker

Tried it, hated it? No problem. Delete everything in this directory except the app directory. Delete the npm_modules
directory and run `npm install` to tidy up. Now you're back where you started with no more docker in your life


## Pitfalls

It's tempting to `COPY` your entire app directory into the container via the Dockerfile. Don't do this unless you're 
sure you want to do this! It will mean rebuilding the image and restarting the container every time you change your
code. And remember, anything you add to the container can be see by anybody who can access that image - pushing a
custom image to public dockerhub will publish anything you have copied into it. 

In the interests of minimal footprint, the default node image image is based on a minimal linux distribution called
[Alpine][6]. Alpine builds binaries differently from most other linux distributions, and this may cause issues for you. 
You can switch to a Debian-based image by changing the version variable in the Makefile to `10.16.0-buster`.

Some npm modules act differently on different operating systems. If you install one of these via `npm install` instead
of `make add`, you may notice that `make run` encounters errors. Don't panic! Just run `make clean && make deps` and
npm will install the correct packages.

Docker is a great way to run your production code, but that's beyond the scope of create-react-app-with-docker. You
should run `make dist` and host the build directory just as you normally would. 


## Something missing? Have a question?

Open a PR or an issue!


[0]: https://hub.docker.com/layers/node/library/node/10.16.0-alpine/images/sha256-f59303fb3248e5d992586c76cc83e1d3700f641cbcd7c0067bc7ad5bb2e5b489?context=explore
[1]: https://github.com/nvm-sh/nvm
[2]: https://www.docker.com/
[3]: https://hub.docker.com/_/node
[4]: https://imagemagick.org/
[5]: https://docs.docker.com/engine/reference/commandline/push/
[6]: https://alpinelinux.org/
