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
    - uses: actions/checkout@v2
    - uses: actions/setup-java@v1
      with:
        java-version: '11'
    - name: SonarCloud Scan
      uses: jinguji/sonarcloud-gradle-github-action@v2
      with:
        sonar-token: ${{ secrets.SONAR_TOKEN }}
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Supported event types

- `pull_request`
- `push`
- `workflow_dispatch`

### Environment variable

- `GITHUB_TOKEN` - (Optional) Required only for **`push`** events.

### Input parameters

- `sonar-token` – **Required** this is the token used to authenticate access to SonarCloud. You can generate a token on your [Security page in SonarCloud](https://sonarcloud.io/account/security/). You can set the `SONAR_TOKEN` environment variable in the "Secrets" settings page of your repository.
- `sonar-host-url` - (Optional) SonarCloud endpoint. (default: `https://sonarcloud.io`)
- `sonar-organization` - (Optional) SonarCloud organization key. (default: <*github organization name*>)
- `sonar-project-key` - (Optional) The key generated when setting up the project on SonarCloud. (default: <*github organization name*>_<*repository-name*>)
- `gradle-cli-opts` - (Optional) Gradle command line options. (default: blank)
  - e.g.

    ```yaml
    with:
      sonar-token: ${{ secrets.SONAR_TOKEN }}
      gradle-cli-opts: "--info"
    ```

  - See the [Command-Line Interface](https://docs.gradle.org/current/userguide/command_line_interface.html)
- `gradle-before-tasks` - (Optional) Space spreaded task names to be executed before `sonarcube` task. (default: blank)
- `gradle-after-tasks` - (Optional) Space spreaded task names to be executed after `sonarcube` task. (default: blank)
