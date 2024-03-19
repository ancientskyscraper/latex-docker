# Latex-Docker

This is a Docker file that will install Latex.

## Usage

```bash
$ docker build -t latex .
$ docker run -v `pwd`:/tmp latex pdflatex sample.tex
```


## See also

[An amazing tutorial that Josh Finnie wrote about using LaTeX with a Docker container](https://www.joshfinnie.com/blog/latex-through-docker/).
