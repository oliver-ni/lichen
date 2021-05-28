# Lichen: Code Similarity Checker (APCS Final Project)

Lichen aims to be an automatic system for determining the similarity of programs. It primarily aims to assist computer science teachers combat plagiarism and cheating by cross-checking code sources from individual students, but may have other applications as well, such as in search engines or autograding code.

Related projects include Stanford's [MOSS](http://moss.stanford.edu/) but I wanted to try making one on my own.


## Overall Design

Lichen is split into two parts: an API backend accessible through HTTP, and and a frontend. The rationale for separating the project this way is to allow it to be more extensible. Users won't just be limited to one client that may or may not serve their needs; if they need something, they can easily build something on top of the API. In fact, most use cases (especially automated ones) would want to use the API. The official client is provided for demo purposes and as a sample.


## Elixir Backend

The backend will be in charge of all the code crunching with a callable API that takes in two or more code samples and returns the result of the similarity checking. It does all the heavy lifting so the client only has to call the backend and display the results. I have decided to implement the backend in [Elixir](https://elixir-lang.org/). Why, you ask? Well, I like Elixir 👍

The algorithm in use is document fingerprinting. Each code sample will first be preprocessed based on the language, removing keywords and turning variable names into generic names, and then that preprocessed code is split into n-grams, and each n-gram is hashed into a series of fingerprints. Then, an algorithm called Winnowing, described in the wonderful research paper [Winnowing: Local Algorithms for Document Fingerprinting](https://theory.stanford.edu/~aiken/publications/papers/sigmod03.pdf) (which this project is highly based on) is used to select some of them to keep and match on. This generates a method that can detect partial matches and is resistant to simple changes like reordering or renaming, while also staying efficient.

In the future, the backend will also store intermediate results of the algorithm, such as the sequence of tokens, into a database such as MongoDB to quickly find matches. This will also allow Lichen to build up a large database of fingerprints over time, potentially being able to alert teachers of unknown plagiarism.


## Java Client

The sample frontend will be implemented in Java because the project requires me to do so. (I would have much preferred to make a web frontend with React.) I will use JvvaFX to render a basic UI with textboxes for the user to paste code into / select files to load code from, a button to submit the code to the API, and another box to display the results. The results will be highlighted in the code boxes. This should be relatively minimal as there is not much logic here; only the UI which connects to the API.

The code for this portion will be fairly simple, so I can't come up with the list of data structures I'm going to use here at the moment. There's a good chance that I'm going to need to use one of them, but I can't think of where I would use them in the Java portion off the top of my head. However, I will be using equivalent data structures in the backend.


## Class Diagram

[![Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/oliver-ni/lichen/master/diagram.iuml)](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/oliver-ni/lichen/master/diagram.iuml)

This is a basic outline of how Lichen will be laid out. Since I'm using Elixir, which is not an object-oriented language, in the backend, I would be using concepts analogous to the classes and interfaces presented in the diagram, such as modules, structs, and behaviors.


## Structural Design Table

I'm not too sure what to put here. Although the project is complex, there really aren't that many structures to use. If I run across more, I'll update this table.


### Java

| Data         | Structure                                  |
| ------------ | ------------------------------------------ |
| Code Samples | `ArrayList<String>`                        |
| Matches      | `ArrayList<ArrayList<ArrayList<Integer>>>` |


### Elixir

| Data                     | Structure                              |
| ------------------------ | -------------------------------------- |
| Language Configs         | `%{String.t() => Lichen.Language.t()}` |
| Code Sample              | `String.t()`                           |
| Preprocessed Code Sample | `[{String.t(), integer()}]`            |
| Fingerprints             | `MapSet.t(integer)`                    |
| Matches                  | `[[{integer(), integer()}]]`           |


