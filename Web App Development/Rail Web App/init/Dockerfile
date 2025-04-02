# pull official base image
FROM python:3.10.6-alpine

# set work directory
WORKDIR /init

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# copy project
COPY . .

# install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# run python files
CMD python3 init_db.py
