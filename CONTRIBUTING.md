## Contribution Guidelines

- Do not add files with personal, private data.

- Initially, we try to stay close to the "Public ITS" distribution.

- A pull request should adress one, and only one, concern.  For
  example, adding a program or bug fix.

- Individual commits within a pull request should consist of atomic
  changes.  A single commit should neither be in a partial state, nor
  should it contain multiple unrelated changes that could be split
  into separate commits.

- Add or update documentation in the pull request.  That includes both
  README files in the repository, and files put into the ITS disk
  image.

- Do use the git history rewriting operations to modify pull request.

- Prefix temporary branch names with your username and `/`.

- When making a major change to a versioned ITS file, rename the file
  and increase the version number.  Do not keep the old version.  This
  way, it's easier to see the diff in the revision log.
