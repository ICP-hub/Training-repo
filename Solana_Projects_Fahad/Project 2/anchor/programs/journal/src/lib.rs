us anchor_lang::prelude::*;

declare_id!("1111111111111111111");

#[program]
pub fn journal{
    use super::*;

    pub fn create_entry(ctx: Context<CreateEntry>, title:String, message:String) -> Result(()) {
        let mut journal = &mut ctx.accounts.journalEntry;
        journal.owner = &ctx.accounts.owner.key()
        journal.title = title;
        journal.message = message;

        Ok(())
    }
    pub fn update_entry(ctx: Context<UpdateEntry>, title:String, message:String) -> Result(()) {
        let mut journal = &mut ctx.accounts.journalEntry;
        journal.title = title;
        journal.message = message;

        Ok(())
    }
    pub fn delete_entry(ctx: Context<DeleteEntry>, title:String) -> Result(()) {
        msg!("Entry Deleted.")
        Ok(())
    }
}

#[account]
#[derive(InitSpace)]
pub struct Journal_entry{
    pub owner: Pubkey,

    #[max_len(50)]
    pub title: String,

    #[max_len(300)]
    pub message: String
}

#[derive(Accounts)]
#[instruction(title:String)]
pub struct CreateEntry<'info>{
    #[account(mut)]
    pub owner = Signer<'info>,

    #[account(
        mut,
        init,
        space= 8+ Journal_entry::INIT_SPACE(),
        payer = owner,
        seeds = [title.as_bytes(), owner.key().as_ref()],
        bump
    )]
    pub journalEntry = Account<'info, Journal_entry>,

    pub system_program = Program<'info, System>
}

#[derive(Accounts)]
#[instruction(title:String)]
pub struct UpdateEntry<'info>{
    #[account(mut)]
    pub owner = Signer<'info>,

    #[account(
        mut,
        realloc = 8 + Journal_entry::INIT_SPACE(),
        realloc::payer = owner,
        realloc::zero = true,
        seeds = [title.as_bytes(), owner.key().as_ref()],
        bump
    )]
    pub journalEntry = Account<'info, Journal_entry>,

    pub system_program = Program<'info, System>
}

#[derive(Accounts)]
#[instruction(title:String)]
pub struct DeleteEntry<'info>{
    #[account(mut)]
    pub owner = Signer<'info>,

    #[account(
        mut,
        close = owner,
        seeds = [title.as_bytes(), owner.key().as_ref()],
        bump
    )]
    pub journalEntry = Account<'info, Journal_entry>,

    pub system_program = Program<'info, System>
}