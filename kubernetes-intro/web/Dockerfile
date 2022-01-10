FROM python:3.7-alpine

RUN addgroup -S appgroup && adduser -S appuser --uid 1001 -G appgroup

USER appuser

WORKDIR /app

COPY app/* /app

EXPOSE 8000

CMD python -m http.server
