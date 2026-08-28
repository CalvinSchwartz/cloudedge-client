FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

COPY cloudedge.py /app/cloudedge.py

ENTRYPOINT ["python", "/app/cloudedge.py"]
CMD ["--help"]
