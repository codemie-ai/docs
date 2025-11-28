---
id: angular-upgrade-assistant
sidebar_position: 5
title: Angular Upgrade Assistant
description: Specialized assistant for Angular application upgrades
---

# Angular Upgrade Assistant

Specialized assistant for Angular application upgrades.

## Features

- Version compatibility analysis
- Migration path planning
- Code transformation suggestions
- Dependency updates
- Breaking change identification

## Use Cases

### Angular version upgrades

Upgrade Angular applications to newer versions:

- Analyze current version
- Plan migration path
- Identify breaking changes
- Generate migration scripts

### Migration to modern Angular features

- Convert to standalone components
- Adopt signals and modern APIs
- Update routing patterns
- Modernize dependency injection

### Breaking change identification

- Detect deprecated APIs
- Find incompatible patterns
- Suggest alternatives

### Best practices application

- Recommend Angular best practices
- Improve code structure
- Optimize performance

## Prerequisites

- Angular application source code
- Git repository access
- Understanding of target Angular version

## Configuration

### Target Version

Specify target Angular version:

```yaml
angular_upgrade:
  target_version: '17.0.0'
  current_version: '14.2.0'
```

### Migration Options

Configure migration preferences:

```yaml
angular_upgrade:
  options:
    standalone_components: true
    signals: true
    strict_mode: true
```

## Using the Assistant

### Analysis Phase

1. Connect Angular project
2. Run compatibility analysis
3. Review breaking changes
4. Generate migration plan

### Migration Phase

1. Follow suggested migration steps
2. Apply code transformations
3. Update dependencies
4. Test changes

### Validation Phase

1. Run tests
2. Verify functionality
3. Review performance
4. Document changes

## Next Steps

- Return to [Extensions Overview](./)
- Configure other extensions
