1. read models for entitycomponents, spplications, systems, components, events, commands, subscribers, families
1. execute command locks the entitycomponent, process manager unlocks it on timeout
1. call command handler from event handler, then store emitted events in aggregate
1. call event handlers, update entitycomponent read model (consistent)
1. errors from handlers disable the component, component configuration update enables the component

Notes:
- :already_seen_event
- strong consistency