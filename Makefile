# eg: make dev-push VM=y9ba
dev-push:
	rsync -rtv --exclude .stackato-pkg --exclude .git \
	 . stackato@${TARGET}:/s/code/fence/fence/vendor/cache/em-docker-client-*/
