use anchor_lang::prelude::*;

declare_id!("4q3SyytkXxnKbzY2CnDauNUuYcsdeY3633ConNN5eTRL");

#[program]
pub mod solana_crud_app {
    use super::*;

    //  new note Creation
    pub fn create_note(ctx: Context<CreateNote>, content: String) -> Result<()> {
        let note = &mut ctx.accounts.note;
        note.author = *ctx.accounts.author.key;
        note.content = content;
        Ok(())
    }

    // existing note update
    pub fn update_note(ctx: Context<UpdateNote>, new_content: String) -> Result<()> {
        let note = &mut ctx.accounts.note;
        note.content = new_content;
        Ok(())
    }

    // Delete note
    pub fn delete_note(_ctx: Context<DeleteNote>) -> Result<()> {
        Ok(())
    }
}

#[derive(Accounts)]
pub struct CreateNote<'info> {
    #[account(init, payer = author, space = 8 + 32 + 280)]
    pub note: Account<'info, Note>,
    #[account(mut)]
    pub author: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct UpdateNote<'info> {
    #[account(mut, has_one = author)]
    pub note: Account<'info, Note>,
    pub author: Signer<'info>,
}

#[derive(Accounts)]
pub struct DeleteNote<'info> {
    #[account(mut, close = author, has_one = author)]
    pub note: Account<'info, Note>,
    pub author: Signer<'info>,
}

#[account]
pub struct Note {
    pub author: Pubkey,
    pub content: String,
}
