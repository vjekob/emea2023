# Directions EMEA 2023 Demos

This repository contains the demos I delivered during my Directions EMEA 2023 session titled *"Mythbusting Code Coverage (while writing better code)"*.

## How to use this

You are now at the tip of the `master` branch where the latest state of all code is. Don't start here 😉

There are two demos, with three steps each. Each is tagged with a tag explaining roughly what the demo is about.

You can checkout into each of those tags directly to see the demo at that stage.

* `01-monolith-uncovered`: Here we have a starting example of a simple monolithic code containing all in the same place, just lke most of AL out there. There are also some tests that cover this code partially.
* `02-monolith-covered`: Now we have the same functional code, just with a lot more test code that makes sure 100% of paths and logic of the function code is covered. These tests are relatively slow, they require a lot of setup, they are pretty fragile because any change in business logic could easily break any of them, or even all of them.
* `03-decoupled`: Now we are talking. This is how the code should have been in the first place. We can now cover all of it with only three tests. They are unit tests, require no database access, have no fixtures, and execute fast, like tests should.
* `04-tightly-coupled-base-app`: This is why you are here. Here we have a copy of `codeunit 1405 "Purch. Inv. Header - Edit"` from the base app, and then a test for it. I chose this codeunit for my example in the event because is small and simple enough for me to be able to explain all I did to it in the course of a short session demo, but still a good representation of how we write our functional code. Nobody could complain that the code in this code is offensive or bad and probably most of AL developers would just say there is not much to improve and there is no better way to test it. Yet, the code is another monolith, all is mish-mashed together, the data, the dependencies, the logic, and it can be vastly improved, and so can the test. The existing test tests all the paths through this code, covers 100% of it, but it requires a lot of setup, and runs relatively slow (200ms was the fastest run I could get from it, usually it was around 400ms).
* `05-refactored-no-breaking-changes`: Here, I refactor the code to turn the monolith into a nice decoupled piece of testable code. The test is the same to prove that you can refactor existing code, decouple it and write it properly, without making a breaking change to existing code. All existing code that depends on this codeunit can keep calling it and using it exactly as it did before, nothing was broken, all stll runs and does all the same things.
* `06-testing-in-isolation`: This is the final stage, the one you have right now in front of you while reading this readme file. This stage drops the old inefficient integration test and replaces it with four unit tests. Those unit tests all test individual components of the code in isolation of all its dependencies and are examples of true unit tests. No fixtures are required, no database reads or writes happen during execution of those test, and yet all business logic is correctly validated. The tests take almost no time as they all run in time unmeasurable for BC test runners (under 0.5 ms). If you get any time reported by test framework, that's purely the overhead of running the test suite.

That's what you have here. The details of how I did the transition from step 4 to 6 will be explained in detail on my blog pretty soon.
