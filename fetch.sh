#!/bin/sh

set -e
set -x

function curl_sha_checksum_fetch {
  FILENAME="${1}"
  REPO_URL="${2}"
  SHA1="${3}"
  PREFIX="${4}"

  mkdir -p /home/minecraft/cache

  curl -LS -s -z /home/minecraft/cache/${SHA1}-${FILENAME} -o /home/minecraft/cache/${SHA1}-${FILENAME} --location ${REPO_URL}

  ln -s /home/minecraft/cache/${SHA1}-${FILENAME} /home/minecraft/cache/${FILENAME}

  shasum cache/${SHA1}-${FILENAME}

  echo "${SHA1}  cache/${SHA1}-${FILENAME}" | shasum -c || (shasum cache/${SHA1}-${FILENAME} && exit 1)
}

curl_sha_checksum_fetch \
  "minecraft-server-1.13.2.jar" \
  "https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar" \
  "3737db93722a9e39eeada7c27e7aca28b144ffa7"

curl_sha_checksum_fetch \
  "minecraft-client-1.13.2.jar" \
  "https://launcher.mojang.com/v1/objects/30bfe37a8db404db11c7edf02cb5165817afb4d9/client.jar" \
  "30bfe37a8db404db11c7edf02cb5165817afb4d9"

curl_sha_checksum_fetch \
  "minecraft-server-1.12.2.jar" \
  "https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar" \
  "886945bfb2b978778c3a0288fd7fab09d315b25f"

curl_sha_checksum_fetch \
  "minecraft-client-1.12.2.jar" \
  "https://launcher.mojang.com/v1/objects/0f275bc1547d01fa5f56ba34bdc87d981ee12daf/client.jar" \
  "0f275bc1547d01fa5f56ba34bdc87d981ee12daf"

curl_sha_checksum_fetch \
  "VirtualPlayers.jar" \
  "https://media.forgecdn.net/files/2763/496/VirtualPlayers.jar" \
  "4e43d777c7aba08882ff2f9ef24850f80e90804d"

curl_sha_checksum_fetch \
  "EssentialsX-2.17.1.25.jar" \
  "https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/Essentials/target/EssentialsX-2.17.1.25.jar" \
  "76d179b863c200db6d91279ebcc7b72241b71525"

curl_sha_checksum_fetch \
  "craftbukkit-server-1.12.2.jar" \
  "https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.12.2.jar" \
  "3aefd516366d91cc8d182bb8bdad46b8ba7d13c2"

curl_sha_checksum_fetch \
  "craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
  "https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
  "94cfd13aa142a404affc9ddc29ba0fe3c604323c"
