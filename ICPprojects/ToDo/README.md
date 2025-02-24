# Simple Todo List Canister

This project implements a simple todo list as an Internet Computer canister using Rust.  It allows users to add, complete, and remove tasks.

## Functionality

The canister provides the following functionalities:

* **`add_task(task: String) -> u64`**: Adds a new task to the list.  Returns the unique ID of the newly added task.
* **`complete_task(id: u64) -> bool`**: Marks a task as completed. Returns `true` if the task was found and updated, `false` otherwise.
* **`remove_task(id: u64) -> bool`**: Removes a task from the list. Returns `true` if the task was found and removed, `false` otherwise.
* **`get_tasks() -> Vec<Todo>`**: Retrieves all tasks in the list.

## Data Structure

The `Todo` struct represents a single task:

```rust
#[derive(Clone, Debug, Default, Deserialize, Serialize, CandidType)]
struct Todo {
    id: u64,
    task: String,
    completed: bool,
}