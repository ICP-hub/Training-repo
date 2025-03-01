import { AnchorProvider, Program } from '@coral-xyz/anchor';
import { Cluster, PublicKey } from '@solana/web3.js';
import CounterIDL from '../target/idl/counter.json';
import type { Counter } from '../target/types/counter';


export { Counter, CounterIDL };


export const COUNTER_PROGRAM_ID = new PublicKey(CounterIDL.address);


export function getCounterProgram(provider: AnchorProvider) {
  return new Program(CounterIDL as Counter, provider);
}

export function getCounterProgramId(cluster: Cluster) {
  switch (cluster) {
    case 'devnet':
    case 'testnet':
      return new PublicKey('CounNZdmsQmWh7uVngV9FXW2dZ6zAgbJyYsvBpqbykg');
    case 'mainnet-beta':
    default:
      return COUNTER_PROGRAM_ID;
  }
}
