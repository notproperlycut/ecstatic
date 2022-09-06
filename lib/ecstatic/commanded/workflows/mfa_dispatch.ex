defmodule Ecstatic.Commanded.Workflows.MfaDispatch do
  def dispatch([module | [function | _args]], entity_component, payload) do
    state = entity_component && entity_component.value
    apply(String.to_atom(module), String.to_atom(function), [state, payload])
  end
end
