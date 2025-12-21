# Changelog

All notable changes to the LibreNMS Helm Chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 

### Changed
- 

### Deprecated
- 

### Removed
- 

### Fixed
- 

### Security
- 

## [7.1.0] - 2024-12-21

### Changed
- **LibreNMS version**: Updated to v25.12.0
- Updated resource indentation in template files
- Improved schema references and validation

### Added
- Added security context support for SNMP scanner pods
- Added support for custom pull policies
- Enhanced CI test coverage with additional test defaults

### Fixed
- Fixed typos in values, README, and schema files
- Fixed resource indentation issues in templates

## [7.0.1] - 2024-12-15

### Fixed
- Minor bug fixes and improvements

## [7.0.0] - 2024-12-10

### Changed
- **BREAKING**: Updated APP_KEY handling with native LibreNMS generation
- **LibreNMS version**: Updated to v25.11.0 (via dependency updates)

### Added
- Native LibreNMS APP_KEY generation support
- Persistent storage configuration for frontend APP_KEY persistence

### Fixed
- Fixed JSON format errors in configuration
- Adjusted schema for optional appKey configuration

### Upgrade Notes
- If you were previously using a custom APP_KEY, review the new native generation approach
- Persistent storage is now available for APP_KEY to maintain consistency across pod restarts

## [6.1.0] - 2024-12-05

### Added
- Added security context support for SNMP scanner containers
- Enhanced security configuration options

### Changed
- Improved default security context settings for SNMP scanner

## [6.0.1] - 2024-12-01

### Added
- Enhanced test values for improved CI coverage
- Persistent storage configuration for frontend APP_KEY

### Fixed
- Fixed indentation for extra environment variables in librenms-cron.yml

## [6.0.0] - 2024-11-25

### Changed
- **BREAKING**: Updated Redis dependency to v24
- Migrated from bitnami to bitnami-legacy Redis images where applicable

### Added
- Added nodeSelector support for SNMP scanner pods
- Added values.schema.json for comprehensive configuration validation
- Added support for extraEnvFrom sources in LibreNMS components

### Fixed
- Fixed extra environment variables handling in LibreNMS components
- Updated init container image tag format in values.yaml
- Improved spacing and formatting in templates

### Upgrade Notes
- Review Redis configuration changes if using external Redis
- The Redis chart major version update may require configuration adjustments

## [5.2.0] - 2024-11-10

### Changed
- **LibreNMS version**: Updated to v25.11.0

### Added
- Automated LibreNMS version updates via renovate

## [5.1.1] - 2024-11-05

### Changed
- Reorganized values.yaml for better clarity and structure

### Improved
- Updated README.md with better documentation

## [5.1.0] - 2024-11-01

### Added
- Added support for nodeSelector in frontend, poller, and rrdcached configurations
- Added support for extraVolumes and extraVolumeMounts in frontend, poller, and rrdcached

### Improved
- Enhanced flexibility for custom volume configurations
- Better pod scheduling control with nodeSelector

## [5.0.13] - 2024-10-20

### Changed
- Minor maintenance updates and dependency updates

### Fixed
- Various bug fixes and stability improvements

## Older Releases

Releases prior to 5.0.13 represent the early development phase of this Helm chart. Key features implemented in earlier versions include:

- Initial chart structure and LibreNMS deployment
- MySQL and Redis dependencies integration
- Poller StatefulSet implementation
- RRDcached deployment with persistent storage
- Ingress configuration support
- ConfigMap and Secret management
- Cron job scheduling for maintenance tasks
- Basic Horizontal Pod Autoscaling support
- Initial CI/CD pipeline setup

For detailed information about releases prior to 5.0.13, please refer to the git commit history.

---

## Release Version Format

- **Chart Version** (e.g., 7.1.0): The version of this Helm chart following SemVer
- **AppVersion** (e.g., v25.12.0): The version of LibreNMS application being deployed

### Version Bump Guidelines

- **Major version**: Breaking changes, major dependency updates, or significant architectural changes
- **Minor version**: New features, non-breaking enhancements, or minor dependency updates
- **Patch version**: Bug fixes, documentation updates, or minor tweaks

[Unreleased]: https://github.com/librenms/helm-charts/compare/librenms-7.1.0...HEAD
[7.1.0]: https://github.com/librenms/helm-charts/compare/librenms-7.0.1...librenms-7.1.0
[7.0.1]: https://github.com/librenms/helm-charts/compare/librenms-7.0.0...librenms-7.0.1
[7.0.0]: https://github.com/librenms/helm-charts/compare/librenms-6.1.0...librenms-7.0.0
[6.1.0]: https://github.com/librenms/helm-charts/compare/librenms-6.0.1...librenms-6.1.0
[6.0.1]: https://github.com/librenms/helm-charts/compare/librenms-6.0.0...librenms-6.0.1
[6.0.0]: https://github.com/librenms/helm-charts/compare/librenms-5.2.0...librenms-6.0.0
[5.2.0]: https://github.com/librenms/helm-charts/compare/librenms-5.1.1...librenms-5.2.0
[5.1.1]: https://github.com/librenms/helm-charts/compare/librenms-5.1.0...librenms-5.1.1
[5.1.0]: https://github.com/librenms/helm-charts/compare/librenms-5.0.13...librenms-5.1.0
[5.0.13]: https://github.com/librenms/helm-charts/releases/tag/librenms-5.0.13
