use ic_cdk::storage;
use candid::CandidType;
use serde::{Deserialize, Serialize};
use std::cell::RefCell;

// Define the Todo struct with CandidType
#[derive(Clone, Debug, CandidType, Deserialize, Serialize)]
struct Todo {
    id: u64,
    title: String,
    completed: bool,
}

// Create storage for the to-do list
thread_local! {
    static TODOS: RefCell<Vec<Todo>> = RefCell::new(Vec::new());
}

// Function to add a to-do (Returns the new To-Do)
#[ic_cdk::update]
fn add_todo(title: String) -> Todo {  // ✅ Now returns the new Todo
    let new_todo = Todo {
        id: ic_cdk::api::time(), // Using timestamp as a unique ID
        title,
        completed: false,
    };

    TODOS.with(|todos| {
        todos.borrow_mut().push(new_todo.clone());
    });

    ic_cdk::println!("Added new To-Do: {:?}", new_todo);

    new_todo  // ✅ Return the created To-Do
}

// Function to get all to-dos
#[ic_cdk::query]
fn get_todos() -> Vec<Todo> {
    TODOS.with(|todos| todos.borrow().clone())
}

// Function to update a to-do's completion status
#[ic_cdk::update]
fn complete_todo(id: u64) -> Option<Todo> {  // ✅ Return the updated To-Do
    TODOS.with(|todos| {
        let mut todos = todos.borrow_mut();
        if let Some(todo) = todos.iter_mut().find(|t| t.id == id) {
            todo.completed = true;
            ic_cdk::println!("Marked To-Do {} as completed!", id);
            return Some(todo.clone());  // ✅ Return updated To-Do
        }
        None  // If not found, return None
    })
}

// Function to delete a to-do
#[ic_cdk::update]
fn delete_todo(id: u64) -> bool {  // ✅ Returns true if deleted, false if not found
    TODOS.with(|todos| {
        let mut todos = todos.borrow_mut();
        let len_before = todos.len();
        todos.retain(|todo| todo.id != id);
        let deleted = len_before != todos.len();
        ic_cdk::println!("Deleted To-Do {}: {}", id, deleted);
        deleted
    })
}

// Function to toggle completion status of a to-do
#[ic_cdk::update]
fn toggle_todo(id: u64) -> Option<Todo> {  // ✅ Returns updated To-Do
    TODOS.with(|todos| {
        let mut todos = todos.borrow_mut();
        if let Some(todo) = todos.iter_mut().find(|t| t.id == id) {
            todo.completed = !todo.completed;
            ic_cdk::println!("Toggled To-Do {}: {:?}", id, todo);
            return Some(todo.clone());  // ✅ Return updated To-Do
        }
        None  // If not found, return None
    })
}
