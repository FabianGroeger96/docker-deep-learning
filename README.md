# docker-deep-learning

A Docker Image for Deep Learning with Python 3

## Start the container

```bash
docker run -it --name python-deep-learning -v $(PWD):/home/notebooks -p 8888:8888 -d --rm python-deep-learning
```

## Open Jupyter Notebook

Open this link [localhost:8888](http://localhost:8888/) in your browser and start working on your notebook.

## Stop the container

```bash
docker stop python-deep-learning
```