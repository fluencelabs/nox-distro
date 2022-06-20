FROM python:2-alpine as BUILD
RUN apk add gcc musl-dev libffi-dev rust cargo make openssl-dev
COPY ./requirements.txt ./requirements.txt
RUN pip install --user -r requirements.txt

FROM python:2-alpine
RUN apk --no-cache add openssh-client
COPY --from=BUILD /root/.local /root/.local
COPY . /deploy
ENV PATH=/root/.local/bin:$PATH
WORKDIR /deploy
ENTRYPOINT ["/deploy/entrypoint.sh"]
CMD ["--list"] # execute `fab --list` by default
