FROM python:3.6-slim

ENV CAKE_SERVICE_VERSION 0.3.2
RUN pip install --no-cache cake-service==$CAKE_SERVICE_VERSION

CMD ["cake", "serve"]
