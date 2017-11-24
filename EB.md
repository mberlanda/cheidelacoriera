# Instructions to Deploy on Elastic Beanstalk

### Install and configure EB

```
$ pip install --upgrade pip
$ pip install awsebcli --upgrade --user
```

Add a Programmatic access User in [IAM](https://console.aws.amazon.com/iam/home)

Configure EB-CLI

```
$ eb init

Select a default region
(default is 3): 5
You have not yet set up your credentials or your credentials are incorrect
You must provide your credentials.
(aws-access-id):
(aws-secret-key):

Select an application to use
2) [ Create new Application ]
(default is 2): 2

Enter Application Name
(default is ""): RubyTest
Application RubyTest has been created.

It appears you are using Ruby. Is this correct?
(Y/n): y

Select a platform version.
1) Ruby 2.4 (Puma)
(default is 1): 1

Do you wish to continue with CodeCommit? (y/N) (default is n): n
Do you want to set up SSH for your instances?
(Y/n): y

Select a keypair.
(default is 1): 1
```

Create an Environment

```
$ eb create
Enter Environment Name
(default is RubyTest-dev):
Enter DNS CNAME prefix
(default is RubyTest-dev):

Select a load balancer type
1) classic
2) application
3) network
(default is 1):
```

### Resources

- [medium.com](https://medium.com/@benhansen/setting-up-sidekiq-redis-on-aws-elastic-beanstalk-with-elasticache-2efeb32935fe)
