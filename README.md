# Shindig

![](.//screenshots.png)

I wrote a series of articles that detail various aspects of building this application.

- [Shindig: An event discovery app built with Meteor.js, React.js, and Neo4j](https://medium.com/@chetcorcos/shindig-an-event-discovery-app-built-with-meteor-js-react-js-and-neo4j-602afb483ae6#.l4vunmdsq)
- [Shindig: Integrating Neo4j with Meteor](https://medium.com/@chetcorcos/shindig-integrating-neo4j-with-meteor-17b0fce644d#.d6na8a4h6)
- [Shindig: Reactive Meteor Publish/Subscribe with Any Database](https://medium.com/@chetcorcos/shindig-reactive-meteor-publish-subscribe-with-any-database-feb09105c343)
- [Shindig: Subscription Caching and Latency Compensation](https://medium.com/@chetcorcos/shindig-subscription-caching-and-latency-compensation-d2e01e708f31)
- [Shindig: React.js + Coffeescript](https://medium.com/@chetcorcos/shindig-react-js-coffeescript-c79d01197203)
- [Shindig: React Component Instances](https://medium.com/@chetcorcos/shindig-react-component-instances-e8b68bf398f4)
- [Shindig: React Tab View Controller](https://medium.com/@chetcorcos/shindig-react-tab-view-controller-48af935a5cd9)
- [Shindig: React Proxy Component](https://medium.com/@chetcorcos/shindig-react-proxy-component-bb368510aad4)
- [Shindig: React Nav View Controller](https://medium.com/@chetcorcos/shindig-react-nav-view-controller-414328034e6a)
- [Shindig: React Transitions with Stylus](https://medium.com/@chetcorcos/shindig-react-transitions-with-stylus-fab08e40818e)
- [Shindig: React Data Component](https://medium.com/@chetcorcos/shindig-react-data-component-aa0d2c82059e)
- [Shindig: Patterns and Best Practices](https://medium.com/@chetcorcos/shindig-patterns-and-best-practices-3baffa406a75)
- [Shindig: Deployment and DevOps](https://medium.com/@chetcorcos/shindig-deployment-and-devops-a06db26aa833)


## Development

This application was built with Meteor v1.2, MongoDb, and Neo4j.


### Installation

- install meteor

```sh
curl https://install.meteor.com/ | sh
```

- install neo4j

```sh
brew install neo4j
```

- configure neo4j

As outlined [here](https://github.com/ccorcos/meteor-neo4j), I have a script that will instantiate neo4j in your local .meteor/local folder that we'll use.

```sh
curl -O https://raw.githubusercontent.com/ccorcos/meteor-neo4j/master/m4j
chmod +x m4j
```

You'll want to put this script somewhere in your path so you can run it. You'll also need to export a variable in your `.bashrc`:

```sh
export NEO4J_PATH=/usr/local/Cellar/neo4j/2.1.7
```

Now to start and stop neo4j from within your meteor project:

```sh
m4j start
m4j stop
```

- install `ttab`

ttab is a simple Terminal utility to open up new tabs. You'll need to be using Mac Terminal to use this and the helper scripts.

```sh
npm install -g ttab
```

### Running

To run this app locally, you'll need to grab some Facebook API keys and add them to `settings.dev.json`.

To start everything up, simply run:

```sh
cd shindig-app/
./dev
```
