# Lichen Development Log

## May 7, 2021

* Started research on project
  * Looked into document fingerprinting
  * Found [Winnowing: Local Algorithms for Document Fingerprinting](https://theory.stanford.edu/~aiken/publications/papers/sigmod03.pdf) research paper
* Drafted functional specifications & class diagram
  * I am very proud of my wonderful diagram!

## May 16, 2021

* Began development of Elixir backend
  * Starting with the algorithm itself (not HTTP stuff)
* Created language configuration for preprocessing
  * Figured out what I needed to know for the algorithm
  * Keywords, special characters, comment syntax, etc.

## May 21, 2021

* Implemented preprocessing algorithm
  * Had to tweak language-specific configuration a bit
  * Modified my original specs—would preprocess into regular string so the fingerprinter is more universal
  * Would remove noise like whitespace and comments, rename non-keyword identifiers, etc.

## May 22, 2021

* Implemented fingerprinting algorithm
  * Had to tweak preprocessing a bit
  * Helped a lot by the research paper I mentioned at the beginning, as well as [OCaMOSS](https://github.com/RobYang1024/OCaMOSS)
  * Added documentation all around the backend

## May 23, 2021

* Put it all together: take in two strings of source code, preprocess them, fingerprint them, and compare the fingerprints to extract a similarity score
* Started working on the API portion
  * Separated from the actual alg, so the algorithm part can be included and used without the API
  * Used [Plug](https://hexdocs.pm/plug/readme.html) to create a single HTTP endpoint, parse JSON body of POST requests, and return results
* Created deployment configs (Dockerfile, Kubernetes manifest, etc.) and deployed to https://lichen.oliver.ni/

## May 24, 2021

* Partially reimplemented much of the preprocessing/fingerprinting algorithms
  * I realized that I needed to be able to trace the fingerprints back to the positions in the code
  * Required a lot of changes and rewrote most of the code, using some clever tricks
  * However, wasn't that difficult as a lot of it remained very similar (even if they weren't exactly the same)
* Fixed various bugs and refactored code throughout the project

## May 27, 2021

* Began and completed the Java client
  * Learned how to use Maven to manage Java dependencies and projects. I've actually used it before, but that was many years ago.
  * Learned how to use JavaFX and FXML to make user interfaces
    * Was originally going to use Swing, but I wanted to learn something new. JavaFX turned out to be pretty good, and given my history of web development, I liked being able to declaratively write UIs with FXML.
      * However, in hindsight, I was already tight on time and it might have been significantly less time-consuming to just use Swing, which I was already familiar with
  * Figured out that my backend was only programmed to return the start position of each match, and not the end position, so I couldn't highlight code yet
    * Had to update the backend again to return both the start position of the match and the end position, so I could highlight matching code on the UI. Required rewriting some of the code
  * Spent around 1 hour being immensely frustrated with `java.net.http.HttpClient`. It kept randomly closing the connection when querying the API, and nothing else I tried (Python `requests`, Insomnia, Postman, `curl`), did the same thing. Eventually I figured out that it only happened when the URI was `localhost`. If I got some random domain and made a DNS record to `127.0.0.1` it would work fine, but not `localhost`. Really weird issue. I ended up moving it to the production deployment at https://lichen.oliver.ni/ anyway, was just testing before.
* Finished documenting all the code in the project, both in the backend and in the Java client, and generating all the HTML (I had done much of it, but there was some missing here and there)
* Updated the functional specifications and the diagram to reflect how things were actually implemented (last time I touched it, I hadn't even started yet)
* Figured out I was supposed to have a development log, so wrote it based on my commit history
* Definitely my biggest day by far. According to [WakaTime](https://wakatime.com/), I spent 8 hours and 40 minutes actively programming today. I honestly thought I was going to finish earlier, but I got caught up with AP exams and homework earlier in the week, so I didn't get around to it until today.
