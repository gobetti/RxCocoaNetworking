# [0.2.1] - 2018-09-22
### Added
- Support to Swift 4.2 (still works with Swift 4.1)

# [0.2.0] - 2018-06-10
### Added
- `ProductionStub` enum, similar to `Stub` but not containing a `default` case

### Changed
- `TargetType` was split into 2 protocols, where `TargetType` is now a sub-protocol of `ProductionTargetType`
- `ProductionTargetType` does not require `sampleData` and uses `ProductionStub`

# [0.1.0] - 2018-06-03
### Added
- Support to "all" (?) HTTP methods (all methods included in HTTP/1.1 spec, section 4.3, plus PATCH)
- Support to specify HTTP body
- API example in the Tests target

### Changed
- `Task` is now a struct instead of an enum. The HTTP method, body and query parameters are defined in a Task.
- `method` is not a requirement for `TargetType` anymore (embedded in Task)
