FROM python:3.7-alpine
COPY . /app
WORKDIR /app
RUN pip freeze > requirements.txt
CMD ["gunicorn", "-w 4", "main:app"]
