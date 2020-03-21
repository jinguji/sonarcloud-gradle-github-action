# Scan your code with SonarCloud and Gradle

Integrate SonarCloud code analysis and Gradle to GitHub Actions

## Requirements

- Have an account on SonarCloud.
- The repository to analyze is set up on SonarCloud.

## Usage

```yaml
on: push
name: Main Workflow
jobs:
  sonarCloudTrigger:
    name: SonarCloud Trigger
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: SonarCloud Scan
      uses: jinguji/sonarcloud-gradle-github-action@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

### Supported event types

- `push`
- `pull_request`

### Secrets

- `SONAR_TOKEN` – **Required** this is the token used to authenticate access to SonarCloud. You can generate a token on your [Security page in SonarCloud](https://sonarcloud.io/account/security/). You can set the `SONAR_TOKEN` environment variable in the "Secrets" settings page of your repository.
- `GITHUB_TOKEN` - (Optional) Required only for **`push`** events.

### Other Variables

- `SONAR_HOST_URL` - (Optional) SonarCloud endpoint. (default: `https://sonarcloud.io`)
- `SONAR_ORGANIZATION` - (Optional) SonarCloud organization key. (default: <*github organization name*>)
- `SONAR_PROJECT_KEY` - (Optional) The key generated when setting up the project on SonarCloud. (default: <*github organization name*>_<*repository-name*>)
- `GRADLE_CLI_OPTS` - (Optional) Gradle command line options. (default: blank)
  - e.g.

    ```yaml
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      GRADLE_CLI_OPTS: "--info -x test"
    ```

  - See the [Command-Line Interface](https://docs.gradle.org/current/userguide/command_line_interface.html)
- `GRADLE_BEFORE_TASK` - (Optional) Task name to be executed before `sonarcube` task. (default: blank)
- `GRADLE_AFTER_TASK` - (Optional) Task name to be executed after `sonarcube` task. (default: blank)
