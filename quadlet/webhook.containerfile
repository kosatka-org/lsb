FROM ruby:4.0.2

RUN apt update
RUN apt install -y webhook

CMD ["webhook", "-hooks", "/app/hooks.json", "-hotreload"]

