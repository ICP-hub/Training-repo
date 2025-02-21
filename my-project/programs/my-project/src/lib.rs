use anchor_lang::prelude::*;

declare_id!("DZBWQ7EYa2g4FMXbLuX5rcqDoGitRWWXgjzNokcCUEtj");

#[program]
pub mod my_project {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
