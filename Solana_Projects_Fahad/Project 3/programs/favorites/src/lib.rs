use anchor_lang::prelude::*;

// This is your program's public key.
declare_id!("HeiUC5HtvaZKh1BfUu7hMTLm2XRX1qA99tLMr5TBFGuj");

#[program]
pub mod favs {
    use super::*;
    pub fn set_favs(ctx: Context<SetFavs>, age: u8, name: String, hobbies: Vec<String>) -> Result<()> {
        let user = &ctx.accounts.user;
        msg!("Hello everyone user: {}", user.key());
        ctx.accounts.favourites.set_inner(Favourites {
            age,
            name,
            hobbies,
        });
        Ok(())
    }
    pub fn change_age(ctx: Context<ChangeDetails>, age: u8) -> Result<()> {
        let user = &ctx.accounts.user;
        msg!("Hello everyone user: {} age changed", user.key());
        let favs = &mut ctx.accounts.favourites;
        favs.age = age;
        Ok(())
    }
    pub fn change_name(ctx: Context<ChangeDetails>, name: String) -> Result<()> {
        let user = &ctx.accounts.user;
        msg!("Hello everyone user: {} name changed", user.key());
        let favs = &mut ctx.accounts.favourites;
        favs.name = name;
        Ok(())
    }
    pub fn change_hobbies(ctx: Context<ChangeDetails>, hobbies: Vec<String>) -> Result<()> {
        let user = &ctx.accounts.user;
        msg!("Hello everyone user: {} hobbies changed", user.key());
        let favs = &mut ctx.accounts.favourites;
        favs.hobbies = hobbies;
        Ok(())
    }
}

#[account]
#[derive(InitSpace)]
pub struct Favourites {
    pub age: u8,
    #[max_len(50)]
    pub name: String,
    #[max_len(3, 50)]
    pub hobbies: Vec<String>,
}

#[derive(Accounts)]
pub struct SetFavs<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(
        init_if_needed,
        payer = user,
        space = 8 + Favourites::INIT_SPACE,
        seeds = [b"favourites", user.key().as_ref()],
        bump
    )]
    pub favourites: Account<'info, Favourites>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct ChangeDetails<'info> {
    #[account(mut)]
    pub user: Signer<'info>,
    #[account(
        mut,
        seeds = [b"favourites", user.key().as_ref()],
        bump
    )]
    pub favourites: Account<'info, Favourites>,
}
