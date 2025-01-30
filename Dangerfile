# Dangerfile
message("✅ Danger is running successfully!")

# Example check: Warn if PR has no description
warn("Please add a description to this PR.") if github.pr_body.length < 5

# Example check: Fail build if PR modifies more than 500 lines
fail("This PR is too big! Try breaking it into smaller changes.") if git.lines_of_code > 500
