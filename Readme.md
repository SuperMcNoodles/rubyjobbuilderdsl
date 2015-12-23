# Introduction

The rubyjobbuilderdsl project lets you treat the configuration of your jenkins server jobs as software in its own right.
You can store the configuration of your jenkins server in git so you can restore it anytime you like.

In our experience continuous integration projects consists of the following kinds of things:

* software build
* software test
* software deploy

If you have well structured code the following will happen:

1. all of the software build jobs will follow the same templates
2. all of the software test jobs will be the same but specify a different group of tests
3. all of the software deploys will be the same but specify a different target

Rubyjobbuilderdsl will help you with this as you can specify each job type once.

You can then use ruby to help you generate all the different jenkins jobs you need.
We have done this using arrays or hashes that contain all the items we wish to build, test and deploy.
By iterating over the arrays we can create all the jenkins jobs we require.

At Wonga we used this to create many 100's if not 1000's of jobs in numerous jenkins servers and it gave us a level of control we never had before.

# How does Rubyjobbuilderdsl work?

if you look at any job in jenkins and add /config.xml to the url you will see the raw xml that defines the job.

rubyjobbuilderdsl works with models and xml generators to generate this xml.

If you post this xml to the jenkins api it lets you create and modify the jobs giving you control over your jobs.

Each jenkins feature/addin has a section in this xml.
rubyjobbuilderdsl has a model for each addin that we have used so far (more can be added as and when required)
The xmlgenerator step converts the model to the xml.
The xml from all of the models are combined together and then posted to the jenkins api to create the jenkins jobs.

NOTE: if you want to add new features/add ins to rubyjobbuilderdsl you will need to extend it and tests to prove that it still works.

# Index of rubyjobbuilderdsl functionality

* [Common features](docs/common.md)
* [flow based build jobs](docs/flow.md)
* [freestyle build jobs](docs/freestyle.md)
* [gerrit based build jobs](docs/gerrit.md)
* [git based build jobs](docs/git.md)
* [multi jobs - a job type that lets you link many jobs together](docs/multi.md)
* [postbuild functionality](docs/postbuild.md)
* [jenkins views](docs/view.md)

# Is there a simple example to get me started?

* [Overview](docs/overview.md)

# References

* http://ci.openstack.org/jenkins-job-builder/
* https://github.com/jenkinsci/jenkins.rb
* https://github.com/jenkinsci/job-dsl-plugin/wiki/Job-DSL-Commands
