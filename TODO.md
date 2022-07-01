1. Stub aggregate and process manager for entitycomponents
1. read models for entitycomponents, spplications, systems, components, events, commands, subscribers, families
1. execute command locks the entitycomponent, process manager unlocks it (timeout?)
1. call command handler from event handler, call command to store emitted events in aggregate
1. call event handlers, update entitycomponent read model (consistent)
1. errors from handlers disable the component
1. component configuration update enables the component
