#!/bin/sh

IMAGE_NAME=fsouza/docker-ssl-proxy

pick_tag() {
	tag=latest
	if [ "${GITHUB_REF##refs/tags/}" != "${GITHUB_REF}" ]; then
		tag=${GITHUB_REF##refs/tags/}
	fi
	echo "$tag"
}

additional_tags() {
	original_tag=$1
	if echo "$original_tag" | grep -q '^v\d\+\.\d\+\.\d\+$'; then
		filtered=${original_tag#v}
		tags="${filtered} ${filtered%.*} ${filtered%%.*}"

		for tag in $tags; do
			docker tag "${IMAGE_NAME}:${original_tag} ${IMAGE_NAME}:${tag}"
		done
	fi
}

tag=$(pick_tag)
docker build -t "${IMAGE_NAME}:${tag}" .
additional_tags "${tag}"

if [[ ${GITHUB_EVENT_NAME} == "push" || ${GITHUB_EVENT_NAME} == "create" ]]; then
	docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
	docker push --all-tags ${IMAGE_NAME}

	docker system prune -af

	# sanity check
	docker run "${IMAGE_NAME}:${tag}" -h
fi
