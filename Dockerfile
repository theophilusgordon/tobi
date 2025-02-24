
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt /app/

RUN apt-get update && apt-get install -y gcc libpq-dev python3-dev && \
    pip install --upgrade pip && pip install -r requirements.txt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*  && mkdir -p /app/staticfiles

COPY . /app/

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]