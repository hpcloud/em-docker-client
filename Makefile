# eg: make dev-push VM=y9ba
dev-push:
	rsync -rtv --exclude .stackato-pkg --exclude .git \
	 . stackato@${TARGET}:/opt/rubies/current/lib/ruby/gems/*/bundler/gems/em-docker-client-*/
