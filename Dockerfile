FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app


COPY requirements.txt /app/

RUN apt-get update && apt-get install -y gcc libpq-dev python3-dev && \
    pip install --upgrade pip && pip install -r requirements.txt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /app/

RUN python manage.py collectstatic --noinput

EXPOSE 8000

# Start the application with Gunicorn and Daphne for Channels
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]
