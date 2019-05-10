---
title: Haskell - The Good, the Bad, The Ugly
description: A short summary of Holmusk's experience with Haskell so far
tags: haskell
---

# Haskell - The Good, the Bad, The Ugly

Holmusk is a digital healthcare startup based in Singapore with a focus on mental health and chronic conditions.

Approximately a year ago, we chose to begin the process of migrating our backend into Haskell. As of March 2019, Holmusk is now powered fully by Haskell and this post is a summary of our experiences so far.

> These are all anecdotal, based just on our experience in this process. Generalise it with a pinch of salt.

This post assumes that you have some idea of what Haskell is and why someone might use it for their personal projects. This is a summation of our experiences when trying to use it as a startup.


## The Good

### Hiring

> You can put together a stronger technical team faster with Haskell

Hiring Haskell developers can be a breeze because of its status as an outsider language. Anyone who knows Haskell can already be assumed to be technically curious and potentially the type of people you want in your company. There is also a stronger culture of remote work in the Haskell community so if you are open to remote work, the number of options available to you are large.

The signal-to-noise ratio when hiring for Haskell developers is very high because not a lot of developers will apply to begin with, and most that do are people who you would be happy to have on your team.

### Library Quality

> The quality of Haskell libraries, especially in the web domain, is amazing

The library quality of Haskell is excellent. It has some battle-tested libraries which have well documented behaviours. Because of the flexibility of the type system, the libraries in Haskell tend to be much more modular. For example, the database pooling library that is used for your postgresql connections can also be used for your redis connections, or as a way to limit the number of concurrent API calls that your worker makes. This degree of flexibility means that you can safely modify the behaviour of existing libraries and have predictable results.

### Ability to pivot

> A modest test suite + the compiler gives you the ability to refactor pretty much any part of your application without fear

Start-ups are primarily economic experiments and don’t necessarily place the concerns of its developers first. We all want to write great software that is elegant, has high test coverage and goes through many rounds of code reviews before it gets committed. In early stages of a product, this may not always be possible as there will be time pressure from external clients, and an understanding that what we build today might be thrown out tomorrow due to scope changes or a pivot.

Haskell helps us maintain software quality in such scenarios, by forcing the implicit assumptions that we make in our head to be explicitly spelled out. The presence of property testing libraries means that we can codify our assumptions about the program and have it do the hard work of verifying if what we wrote aligns to our assumptions.

This also means that code for a feature that we wrote many months ago and haven’t touched since can be expected to continue to work and be worked on at some point in the future.

### Cost efficiency

> If you need to scale, Haskell’s runtime efficiency can save you a substantial amount of money, especially at the beginning when you are the most resource constrained.

The Haskell backend that replaced our old backend was significantly more efficient. It allowed us to run fewer servers to support the same workload. The cost savings from a smaller AWS bill can make a difference if your startup is in the phase where every dollar counts.

Here is a chart of our AWS expenditure as we switched to a Haskell backend:

<img src="/images/blogposts/2019-03-29-why-haskell/aws-costs.png" class="img-fluid" alt="AWS costs graph">

## The Bad

### Lack of conventions

> There are very few well-trodden paths in Haskell, expect to make lots of decisions about your stack.

Apart from things like [`Yesod`](https://www.yesodweb.com/), there aren’t really many framework style Haskell projects that come with best practices on how to structure your application or guides on how to do common tasks like handling file uploads, user authentication, database management etc.

Working on Haskell projects feels very much like working with [`react`](https://reactjs.org/) projects in that you have to bring in external libraries piecemeal for most of the features you want and the libraries aren’t necessarily designed with the assumption that they will be used together in that particular combination.

Conventions also codify some hard-learned lessons, in their absence most of those lessons have to be re-learned by your team.

### Lack of libraries

> While the quality of libraries is excellent, the quantity can be rather limiting. Don’t expect the equivalent of [passportjs](http://www.passportjs.org/) or [vanity](http://vanity.labnotes.org/).

The best Haskell libraries tend to be rather low-level, providing the building blocks rather than solving one cohesive problem by themselves.

For instance, you won’t find any ‘batteries included’ libraries for user authentication which support OAuth integration, work with most major providers, have a password reset functionality, etc. If you are coming from other technologies like Rails, where creating admin interfaces is a simple one day job with [`activeadmin`](https://activeadmin.info/), you would be surprised at how cumbersome and repetitive some of the common tasks can get.  

### First-class developer experience

> Expect Haskell to get only community support or delayed support in most places.

When AWS releases interesting new tools like Lambda, expect to not be able to play around with them through Haskell right away. You will be a second-class citizen in most developer products.

This translates to either missed opportunities or just extra time spent trying to setup common tools like CI systems which are designed to work well with popular languages but have trouble adjusting to Haskell projects (I’m looking at you CircleCI).

## The Ugly

### Breaking changes in libraries

> You can expect libraries to have breaking changes that have ripple effects throughout your project.

Most Haskell projects don’t really have a concept of backwards compatibility. They regularly release breaking changes because they tend to be either hobby projects or projects that simply have ambitious technical goals which don’t necessarily align with your company’s goals of having stable interfaces.

Upgrading to a new compiler version almost always ends up becoming a blocking task that requires many tangential changes or reviewing changelogs carefully of all the libraries that you depend on to make sure that there aren’t any behaviour changes.

### The bait of type safety

> Type-safety can be an alluring thing that you eventually end up spending too much time and effort to achieve. Typing everything has diminishing returns.

Having experienced the bliss of GHC being your programming assistant, it can be extremely tempting to rely on evermore fancy type system features to make more illegal states unrepresentable.

Soon, you find yourself encoding entire chunks of your business logic into the type system while a simple run-time check might have sufficed. Just because Haskell allows you to express something in the type system doesn’t mean that it is always a good idea to do so.

These endeavours increase the on-boarding difficulty of new developers into your project, can drastically increase your compile times and just make code plain unreadable sometimes.

## Conclusions

If you have people in your team who already know Haskell and are itching to put it into production use, starting an incremental inclusion of it in your stack might be well worth the try. This gives you a chance to evaluate the pains of the language vs the rewards. Some of the positive outcomes of type-safety do require a certain critical mass of your product to be written in haskell/haskell-like languages to kick in so this is something to be aware of.

If you have a greenfield project, some very specific requirements around performance, correctness and future malleability of the code in the face of massive code changes, Haskell provides a best in-class experience that can be worth the downsides.

If you already have people know Haskell or are very interested to learn Haskell, give it a chance and at least 3-4 months. I think that the effort will be well worth the payoff, it certainly was for us.
