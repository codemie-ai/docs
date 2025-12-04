/**
 * Commitlint configuration for documentation repository
 * @see https://commitlint.js.org/reference/configuration.html
 */

module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Custom rules for documentation repository
    'type-enum': [
      2,
      'always',
      [
        'docs', // Documentation changes
        'feat', // New features/sections
        'fix', // Corrections/fixes
        'style', // Formatting, whitespace changes
        'refactor', // Restructuring without changing functionality
        'chore', // Maintenance tasks (dependencies, config, etc.)
        'revert', // Revert previous commits
      ],
    ],
    // Allow these scopes for better organization
    'scope-enum': [
      2,
      'always',
      [
        'aws', // AWS deployment guide
        'gcp', // GCP deployment guide
        'user-guide', // User guide sections
        'deployment', // General deployment docs
        'getting-started', // Getting started guide
        'config', // Configuration files
        'deps', // Dependencies
      ],
    ],
    // Make scope optional but recommended
    'scope-empty': [1, 'never'],
    // Enforce subject case (lowercase start)
    'subject-case': [2, 'always', 'lower-case'],
    // Subject max length
    'subject-max-length': [2, 'always', 100],
    // Body max line length
    'body-max-line-length': [2, 'always', 300],
    // Footer max line length
    'footer-max-line-length': [2, 'always', 300],
  },
};
