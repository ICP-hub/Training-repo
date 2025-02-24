import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type Result = { 'ok' : Task } |
  { 'err' : string };
export interface Task {
  'id' : bigint,
  'title' : string,
  'is_completed' : boolean,
}
export interface _SERVICE {
  'toggle_is_completed' : ActorMethod<[bigint], Result>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
