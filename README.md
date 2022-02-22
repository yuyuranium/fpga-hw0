# vlsi-hw0
Homework 0 of VLSI design

## Getting started

### To clone the Repo

We may need an ssh key, see [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

```shell
git clone git@github.com:yuyuranium/vlsi-hw0.git
```

### Checkout our own branches first

By doing so, we can maintain our own works and minimize the possibilities of conflicts. (Conflicts are annoying XD)

- PE + Analyzer

  ```shell
  git checkout pe-analyzer
  ```

- Controller

  ```shell
  git checkout controller
  ```

- Top

  ```shell
  git checkout top
  ```

### Push our works

- Make sure changes are on our own branch

- First add all changed files

  ```shell
  git add .
  ```

- Then commit the changes

  ```shell
  git commit -m "Commit messages"
  ```

- Finally push to GitHub

  - PE + Analyzer

    ```shell
    git push origin pe-analyzer
    ```

  - Controller

    ```shell
    git push origin controller
    ```

  - Top

    ```shell
    git push origin top
    ```

### The main branch

Once our works are ready, the branch of ours (`pe-analyzer`, `controller` and `top`) will be merged into `main` branch.

- To follow up the main branch after merging

  ```shell
  # In our own branch, execute:
  git pull origin main
  ```

A good practice is that we should avoid pushing our work directly to the `main` branch.
