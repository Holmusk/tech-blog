---
title: <undecided>
author: Rohan
github: RohanGautam
description: Explore the use of rust in FoodDX, and go over key architectural decisions
tags: rust
---

# Introduction to the product FoodDX

## Product intro

[FoodDX](https://www.fooddx.com/) is a service which helps people get insights on how to improve their diet with the help from our proprietary AI technology and personalized feedback from our nutrition experts. In it's current stage, it helps score images of food taken through an app, and gives it a score from 1-5, and also provides personalized tips for the food.

It's a big project with a lot of components - the AI models, the app, and the backend infrastructure which handles it all. We'll be taking a look at the backend in this article.

## Lifecycle of an image

Before we dive into the infrastructure, it would help to take a look at what an image goes through once it enters our system.

- The image is assigned a UUID.
- The image is uploaded to a `s3` bucket.
- The image is then downloaded, preprocessed, run through our models, and a food tip is generated for the image.
- The food tip, inference results and the image hash form the final response.

## Stack decisions: Rust and haskell

Haskell is used for the client facing API, and it's for other ad-hoc tasks such as reading/writing to a database among others.

Rust is used for image preprocessing, model inference and sending the results back. Sending of results was done differently in the two approaches outlined below. Rust was chosen for it's high efficiency, small executable footprint, and absence of a garbage collector. It also had strong type system, speed & relatively actively maintained Tensorflow (client) library.

# Introduction and pitfalls of the existing architecture

![](/images/v2-arch-diagram.png)
The internal organization of the rust service in this architecture is outlined above.
There were 3 main parts, all running concurrently on 3 separate tokio runtimes - namely polling sqs, preprocessing and inferring from the images, and cleanup tasks.

The external processes related to this architecture are outlined below.
![](/images/v2-external-arch-diagram.png)

The main gripe we had was in the `S3` to `SQS` upload event notification. In our experiments, it was [very slow](https://github.com/Holmusk/aws_benchmarks/tree/master/s3_event_to_sqs), and we aim for the service to have a very low latency, with the goal being that every image that comes into the system should be scored/rated in under 1 second. Because of the way the system was designed, this meant that we'd need a pretty big makeover on the rust side, and some tweaks on the haskell side. This is also mentioned in the [AWS docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/NotificationHowTo.html), where they point that `Typically, event notifications are delivered in seconds but can sometimes take a minute or longer`.

# The new architecture

Like mentioned before, the main reason for redesigning the architecture was to avoid the `S3` to `SQS` upload event notification as speed was of high importance. In the process, we found out that we actually simplified it, by removing unnecessary moving parts.

Internally, the rust service now also has a webserver. The client facing API proxies the requests it receives to the rust webservers via a load balancer. In this version, we completely eliminate the use of SQS.

## Rust webserver internals

![](/images/v3-arch-diagram.png)

We use a [`warp`](https://github.com/seanmonstar/warp) for the webserver in rust.

Because we have multiple tokio runtimes, the messages are passed between them using a bounded channel. We also have an extra batching step, which converts a bunch of independent requests into a batch. The batching step is important as the model inference is efficient for an image batch as compared to a single image. Also, with a batch, we can parallelize the image download and preprocessing steps for extra speed gains.

Finally, because each request handler needs a result for it's own image, the handler initially creates a [oneshot](https://tokio-rs.github.io/tokio/doc/tokio/sync/oneshot/index.html) for receiving it's results and this is passed along as metadata for the image. Once the image is inferred to in a batch, the data is sent back to the image's corresponding request handler so the results can be returned.

As mentioned, we have completely avoided the use of SQS in this architecture. The external architecture around the rust service now looks like this:
![](/images/v3-external-arch-diagram.png)

### Types of channels used

### Monitoring health

#### to panic or not to panic

#### webserver errors

#### Tracking metrics

# Future possibilities

## Tighter integration via Rust's FFI
