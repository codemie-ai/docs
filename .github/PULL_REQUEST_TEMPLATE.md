<!--
PR Title MUST follow Conventional Commits format (enforced by CI):
  docs(scope): description       - Documentation changes
  feat(scope): description       - New features/sections
  fix(scope): description        - Bug fixes, typos, broken links
  chore(scope): description      - Build, deps, config changes

Examples:
  docs(aws): add prerequisites section
  docs(gcp): update architecture diagrams
  fix(deployment): correct kubectl commands
  chore(deps): update docusaurus to 3.9.2
-->

## Summary

<!-- Brief description of what this PR accomplishes -->

## Changes

<!-- List key changes (3-5 bullet points max):
- Added X section to Y guide
- Updated Z documentation with A, B, C
- Fixed broken links in D
-->

## Testing

- [ ] Tested locally with `npm start`
- [ ] All pages render correctly
- [ ] Images display properly
- [ ] Internal links work
- [ ] Sidebar navigation works

## Quality Checks

- [ ] `npm run check` passes (typecheck + lint + commitlint)
- [ ] No MDX compilation errors
- [ ] No raw angle brackets (`<text>` must be `` `<text>` ``)
- [ ] Sidebar references document IDs (not filenames)
- [ ] Images stored locally next to content (not in `static/img/`)
- [ ] Commit messages follow Conventional Commits
- [ ] No secrets or credentials in documentation

## Additional Notes

<!-- Optional: screenshots, migration notes, breaking changes, etc. -->
