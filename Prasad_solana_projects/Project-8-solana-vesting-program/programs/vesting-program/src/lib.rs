use anchor_lang::prelude::*;
use anchor_spl::token::{self, Token, TokenAccount, Mint, Transfer};

declare_id!("7MVhx3atLxcLYg3ydcenT7tSrx5w4SjzsGCKK4AdhbF1");

#[program]
mod vesting_program {
    use super::*;

    pub fn initialize_vesting(
        ctx: Context<InitializeVesting>,
        total_amount: u64,
        release_time: i64,
    ) -> Result<()> {
        let vesting = &mut ctx.accounts.vesting;
        vesting.beneficiary = ctx.accounts.beneficiary.key();
        vesting.total_amount = total_amount;
        vesting.released_amount = 0;
        vesting.release_time = release_time;
        Ok(())
    }

    pub fn claim_tokens(ctx: Context<ClaimTokens>) -> Result<()> {
        let vesting = &mut ctx.accounts.vesting;
        let current_time = Clock::get()?.unix_timestamp;

        require!(current_time >= vesting.release_time, CustomError::VestingNotMatured);

        let amount_to_transfer = vesting.total_amount - vesting.released_amount;
        let cpi_accounts = Transfer {
            from: ctx.accounts.vesting_account.to_account_info(),
            to: ctx.accounts.beneficiary_account.to_account_info(),
            authority: ctx.accounts.vesting.to_account_info(),
        };

        token::transfer(CpiContext::new(ctx.accounts.token_program.to_account_info(), cpi_accounts), amount_to_transfer)?;

        vesting.released_amount = vesting.total_amount;
        Ok(())
    }
}

#[account]
pub struct Vesting {
    pub beneficiary: Pubkey,
    pub total_amount: u64,
    pub released_amount: u64,
    pub release_time: i64,
}

#[derive(Accounts)]
pub struct InitializeVesting<'info> {
    #[account(init, payer = payer, space = 8 + 32 + 8 + 8 + 8)]
    pub vesting: Account<'info, Vesting>,
    pub beneficiary: Signer<'info>,
    pub token_program: Program<'info, Token>,
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct ClaimTokens<'info> {
    #[account(mut, has_one = beneficiary)]
    pub vesting: Account<'info, Vesting>,
    pub beneficiary: Signer<'info>,
    #[account(mut)]
    pub vesting_account: Account<'info, TokenAccount>,
    #[account(mut)]
    pub beneficiary_account: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
}

#[error_code]
pub enum CustomError {
    #[msg("Vesting period is not completed yet.")]
    VestingNotMatured,
}
