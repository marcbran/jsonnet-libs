default:
    @just --list

[no-cd]
jsonnet-test:
    #!/usr/bin/env bash
    exit_code=0
    while IFS=$'\t' read -r name actual expected; do
      if [ "${actual}" != "${expected}" ]; then
        echo "${name} failed!"
        echo "${expected} was expected"
        echo "${actual} was the actual value"
        echo ""
        exit_code=1
      fi
    done < <(jsonnet ./tests.jsonnet | jq -r 'map([.name, (.actual | tostring), (.expected | tostring)]) | .[] | @tsv')

    if [ "${exit_code}" -eq 0 ]; then
      echo "All tests passed!"
    else
      echo "Some tests failed!"
    fi
    exit "${exit_code}"

[no-cd]
jsonnet-release artifact:
    #!/usr/bin/env bash
    rm -rf release
    git clone git@github.com:marcbran/jsonnet.git release
    pushd release
    git checkout {{artifact}} || git checkout -b {{artifact}}
    git pull
    mkdir -p {{artifact}}
    cp ../main.libsonnet {{artifact}}/main.libsonnet
    git add -A
    git commit -m "release {{artifact}}"
    git push --set-upstream origin {{artifact}}
    popd
    rm -rf release

[no-cd]
grafana-it:
    #!/usr/bin/env bash
    echo "Running integration tests..."
    pushd it

    echo "Starting Docker Compose..."
    docker-compose up -d

    echo "Installing jsonnet dependencies..."
    jb install

    echo "Waiting for Grafana to start..."
    while ! curl -s -o /dev/null http://localhost:3000/metrics; do
      sleep 1
    done

    code="$(jsonnet -J vendor ./main.jsonnet |
      curl -o /dev/null -s -w "%{http_code}\n" -X POST \
        -H "Content-Type: application/json" \
        http://localhost:3000/api/dashboards/db \
        --data-binary @- |
      tail -n 1)"

    exit_code=1
    if [ "${code}" == "200" ]; then
      exit_code=0
    fi

    docker-compose down

    if [ "${exit_code}" -eq 0 ]; then
      echo "All tests passed!"
    else
      echo "Some tests failed!"
    fi
    exit "${exit_code}"
