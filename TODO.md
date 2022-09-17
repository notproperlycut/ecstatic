Aggregates:
validate updates
remove old state modules
fix tests

Projectors:
state+configuration from ecto/projectors

1. Move validation to commands
1. "update" events (can remove uniqueness constraints?)
1. config+state API
1. handle errors from invocations
1. read model tests
1. projectors robust against duplicate events
1. timeout (process manager?) unlocks the entitycomponent
1. errors from handlers disable the component, component configuration update enables the component
1. clients can wait on command invocation, clients can retry command invocation

Notes:
- require :already_seen_event ?
