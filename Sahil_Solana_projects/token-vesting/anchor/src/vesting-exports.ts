import { AnchorProvider, Program } from '@coral-xyz/anchor';
import { Cluster, PublicKey } from '@solana/web3.js';
import VestingIDL from '../target/idl/vesting.json';
import type { Vesting } from '../target/types/vesting';

export { Vesting, VestingIDL };

export const VESTING_PROGRAM_ID = new PublicKey(VestingIDL.address);

export function getVestingProgram(provider: AnchorProvider) {
  return new Program(VestingIDL as Vesting, provider);
}

export function getVestingProgramId(cluster: Cluster) {
  switch (cluster) {
    case 'devnet':
    case 'testnet':
      return new PublicKey('2vKg76rA1Ho27YD4uuc2Z2FCwRTySxdyHup1JjsXS6dp');
    case 'mainnet-beta':
    default:
      return VESTING_PROGRAM_ID;
  }
}
