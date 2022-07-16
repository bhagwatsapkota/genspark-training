
FROM python:3.7

WORKDIR /app

RUN pip3 install -r flask redis

copy . .

CMD ["python", "./sample-app.py"]

EXPOSE 80
