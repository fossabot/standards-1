#!/usr/bin/env sh

readonly STANDARDS="v1 draft"
readonly CNAME_ADDRESS="standards.lifeengine.io"
readonly WORKDIR="/src"
readonly TEMP_FOLDER="/tmp/html"
readonly ARTIFACTS_ROOT="/artifacts"
readonly THEME="darkly"

set -exu

cd "${WORKDIR}"

python githubify.py "${STANDARDS}"

for version in $STANDARDS; do
  ontology="${WORKDIR}/${version}/Ontology/dli.jsonld"
  artifacts="${ARTIFACTS_ROOT}/${version}"
  out_folder="$TEMP_FOLDER/$version"

  mkdir -p "${artifacts}"

  if [ -f "$ontology" ]; then
    mkdir -p "${out_folder}"
    ontospy gendocs "${ontology}" -o "${out_folder}" --title "Digital Living" --theme="${THEME}" --type 2
  fi

  # Copy over the ontologies and contexts to GH pages
  cp -R "${WORKDIR}/${version}/Context" "${artifacts}/" || true
  cp -R "${WORKDIR}/${version}/Vocabulary" "${artifacts}/" || true
  cp -R "${WORKDIR}/${version}/ClassDefinitions" "${artifacts}/" || true
  cp -R "${WORKDIR}/${version}/DataProducts" "${artifacts}/" || true
done

# Copy the HTML to the artifacts folder.
cp -R "${TEMP_FOLDER}"/* "${ARTIFACTS_ROOT}"/
echo "${CNAME_ADDRESS}" > "${ARTIFACTS_ROOT}"/CNAME

# POSIX compliant heredoc
redirect=""
nl='
'
while IFS="$nl" read -r line; do
    redirect="$redirect$line$nl"
done <<\END
plugins:
  - jekyll-redirect-from
END

echo "$redirect" > "${ARTIFACTS_ROOT}"/_config.yml
