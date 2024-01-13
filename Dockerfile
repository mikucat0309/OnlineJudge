FROM python:3.11-alpine

ENV OJ_ENV production
WORKDIR /app

COPY ./deploy/ /app/deploy/
RUN <<EOS
set -ex
apk add --no-cache build-base supervisor jpeg-dev zlib-dev postgresql-dev freetype-dev
pip install --no-cache-dir -r /app/deploy/requirements.txt
apk del build-base --purge
EOS
COPY ./ ./
RUN chmod -R u=rwX,go=rX ./ && chmod +x ./deploy/entrypoint.sh

HEALTHCHECK --interval=5s --retries=3 CMD python3 /app/deploy/health_check.py
EXPOSE 8080
ENTRYPOINT /app/deploy/entrypoint.sh
