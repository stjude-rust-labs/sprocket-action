# Release Process

After a new Sprocket release, perform the following steps:

1. Update the Sprocket version in the `Dockerfile`.
2. Commit and push to `main`.
3. Create and push a new tag: `git tag vX.Y.Z && git push origin vX.Y.Z`.
4. Create a GitHub release for the tag with a body referencing the
   [Sprocket releases](https://github.com/stjude-rust-labs/sprocket/releases).
