# finish-worktree

1. Discard all uncommitted changes in the feature branch.
2. Rebase feature branch onto main; fix conflicts.
3. Delete worktree. If for some reason you cannot, just `rm -rf` the worktree directory.
4. Navigate to `main` worktree.
5. _Fast-forward_ `main` to the feature branch. **If you cannot fast-forward, STOP and repeat the process from step 2.**
6. Delete feature branch
