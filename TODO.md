1. read model tests
1. Move validation to commands
1. primary keys, names/ids
1. top-level API `Ecstatic.application("demo").configure(config)`, `Ecstatic.application("demo").commands()`
1. query types (not the projection types), "update" events (can remove uniqueness constraints?)
1. execute command locks the entitycomponent, process manager unlocks it on timeout
1. call command handler from event handler, then store emitted events in aggregate
1. call event handlers, update entitycomponent read model (consistent)
1. errors from handlers disable the component, component configuration update enables the component

Notes:
- :already_seen_event
- strong consistency
