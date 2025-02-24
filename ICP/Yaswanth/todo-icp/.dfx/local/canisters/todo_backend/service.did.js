export const idlFactory = ({ IDL }) => {
  const Task = IDL.Record({
    'id' : IDL.Nat64,
    'title' : IDL.Text,
    'is_completed' : IDL.Bool,
  });
  const Result = IDL.Variant({ 'ok' : Task, 'err' : IDL.Text });
  return IDL.Service({
    'toggle_is_completed' : IDL.Func([IDL.Nat64], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
