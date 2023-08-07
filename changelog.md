# Changelog
All notable changes to `iac-tf-az-cloudtrain-modules` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - YYYY-MM-DD
### Added
### Changed
### Fixed

## [1.2.0] - 2023-08-07
### Added
- added new variables to define subnets for system pools and user pools to module container/ask/cluster
### Changed
- module network/vnet4aks returns specific subnet IDs now to simplify further usage of subnets
- improved documentation of module network/vnet
- improved overall documentation
- simplified usage of module container/aks/cluster by introducing optional values to node pool templates

## [1.0.0] - 2023-07-25
### Added
- added proper module versioning through git tags
- added build pipeline on AWS CodeBuild
### Changed
- improved documentation in README.md
