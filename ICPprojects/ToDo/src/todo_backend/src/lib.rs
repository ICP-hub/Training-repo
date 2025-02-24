use ic_cdk::query;
use ic_cdk_macros::*;
use std::cell::RefCell;
use serde::{Deserialize, Serialize};
use candid::CandidType;

#[derive(Clone, Debug, Default, Deserialize, Serialize, CandidType)] // Add CandidType here
struct Todo {
    id: u64,
    task: String,
    completed: bool,
}

thread_local! {
    static TODOS: RefCell<Vec<Todo>> = RefCell::new(Vec::new());
}

#[update]
fn add_task(task: String) -> u64 {
    TODOS.with(|todos| {
        let mut list = todos.borrow_mut();
        let id = list.len() as u64 + 1;
        list.push(Todo {
            id,
            task,
            completed: false,
        });
        id
    })
}

#[update]
fn complete_task(id: u64) -> bool {
    TODOS.with(|todos| {
        let mut list = todos.borrow_mut();
        if let Some(todo) = list.iter_mut().find(|t| t.id == id) {
            todo.completed = true;
            true
        } else {
            false
        }
    })
}

#[update]
fn remove_task(id: u64) -> bool {
    TODOS.with(|todos| {
        let mut list = todos.borrow_mut();
        let len_before = list.len();
        list.retain(|t| t.id != id);
        list.len() < len_before
    })
}

#[query]
fn get_tasks() -> Vec<Todo> {
    TODOS.with(|todos| todos.borrow().clone())
}
