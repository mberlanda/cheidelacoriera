FROM ruby:2.5.1

ENV RAILS_ENV "production"
ENV RACK_ENV "production"
ENV RAILS_SERVE_STATIC_FILES "enabled"
ENV CHEIDELACORIERA_DIR "/home/app/cheidelacoriera"

ENV GEM_NOKOGIRI_DEPS "build-essential patch ruby-dev zlib1g-dev liblzma-dev"
ENV YARN_DEPS "apt-transport-https ca-certificates"
ENV POSTGRESQL_DEPS "libpq-dev gcc g++ make"

# Add PostgreSQL repository
# RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

RUN apt update -qq > /dev/null && \
    apt-get install -y -qq --no-install-recommends \
    curl unzip netcat sudo \
    libjemalloc-dev \
    $POSTGRESQL_DEPS \
    $GEM_NOKOGIRI_DEPS \
    $YARN_DEPS \
    nginx \
    cron > /dev/null && \
    apt-get clean

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

RUN apt-get update && apt-get install -y -qq nodejs yarn

RUN useradd --create-home app && \
    echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so.1
ENV WORKDIR /home/app/cheidelacoriera
WORKDIR "$WORKDIR"

COPY ./app ${WORKDIR}/app
COPY ./bin ${WORKDIR}/bin
COPY ./ci ${WORKDIR}/ci
COPY ./config ${WORKDIR}/config
COPY ./data ${WORKDIR}/data
COPY ./db ${WORKDIR}/db
COPY ./lib ${WORKDIR}/lib
COPY ./public ${WORKDIR}/public
COPY ./spec ${WORKDIR}/spec
COPY ./stack ${WORKDIR}/stack
COPY ./vendor ${WORKDIR}/vendor

COPY .babelrc .haml-lint.yml .postcssrc.yml \
     .rspec .rubocop.yml .ruby-version .yarnclean \
     Gemfile Gemfile.lock Rakefile config.ru package.json \
     yarn.lock ${WORKDIR}/

RUN chown -R app:app .
USER app

EXPOSE 3000

RUN gem install bundler -v "$(tail -n 1 Gemfile.lock | tr -d '[:blank:]')"
RUN bundle install --no-cache --jobs 4 --deployment --without development test || bundle check

ENV SECRET_KEY_BASE $(bundle exec rake secret)

ENTRYPOINT ["./stack/docker/entrypoint.sh"]
CMD ["./stack/docker/start.sh"]
