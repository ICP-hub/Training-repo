use std::io;

#[derive(Debug)]
struct Task {
    description: String,
    priority: u8,
    completed: bool,
}

impl Task {
    fn new(description: String, priority: u8) -> Self {
        Self {
            description,
            priority,
            completed: false,
        }
    }
}

fn main() {
    let mut task_list: Vec<Task> = Vec::new();

    loop {
        println!("\nPlease enter your choice:");
        println!("1. Add task");
        println!("2. Remove task");
        println!("3. View all tasks");
        println!("4. View completed tasks");
        println!("5. View pending tasks");
        println!("6. Mark task as complete");
        println!("7. Change task priority");
        println!("8. Exit");

        let mut choice = String::new();
        io::stdin().read_line(&mut choice).expect("Invalid input");

        let choice: i32 = match choice.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Invalid input. Please enter a number between 1-8.");
                continue;
            }
        };

        match choice {
            1 => add_task(&mut task_list),
            2 => remove_task(&mut task_list),
            3 => view_task(&task_list),
            4 => view_completed_task(&task_list),
            5 => view_pending_task(&task_list),
            6 => mark_complete(&mut task_list),
            7 => change_priority(&mut task_list),
            8 => {
                println!("Exiting....");
                break;
            }
            _ => println!("Wrong Input: Try Again"),
        }
    }
}

fn add_task(task_list: &mut Vec<Task>) {
    let mut description = String::new();
    println!("Enter task description:");
    io::stdin().read_line(&mut description).expect("Invalid input");
    let description = description.trim().to_string();

    let mut priority = String::new();
    println!("Enter task priority (1-5):");
    io::stdin().read_line(&mut priority).expect("Invalid input");
    let priority: u8 = match priority.trim().parse() {
        Ok(num) if (1..=5).contains(&num) => num,
        _ => {
            println!("Invalid priority. Must be between 1 and 5.");
            return;
        }
    };

    if !description.is_empty() {
        task_list.push(Task::new(description, priority));
        println!("Task added successfully!");
    } else {
        println!("Task description cannot be empty.");
    }
}

fn remove_task(task_list: &mut Vec<Task>) {
    if task_list.is_empty() {
        println!("No tasks found.");
        return;
    }
    
    view_task(task_list);
    println!("Enter the task number to remove:");
    let mut task_number = String::new();
    io::stdin().read_line(&mut task_number).expect("Invalid input");
    
    match task_number.trim().parse::<usize>() {
        Ok(num) if num > 0 && num <= task_list.len() => {
            task_list.remove(num - 1);
            println!("Task removed successfully!");
        }
        _ => println!("Invalid task number.")
    }
}

fn view_task(task_list: &Vec<Task>) {
    if task_list.is_empty() {
        println!("No tasks found.");
        return;
    }
    println!("\nTask List:");
    for (i, task) in task_list.iter().enumerate() {
        println!("{}. [{}] Priority: {} - {}", i + 1, if task.completed { "✓" } else { " " }, task.priority, task.description);
    }
}

fn view_completed_task(task_list: &Vec<Task>) {
    println!("\nCompleted Tasks:");
    for task in task_list.iter().filter(|t| t.completed) {
        println!("- Priority: {} | {}", task.priority, task.description);
    }
}

fn view_pending_task(task_list: &Vec<Task>) {
    println!("\nPending Tasks:");
    for task in task_list.iter().filter(|t| !t.completed) {
        println!("- Priority: {} | {}", task.priority, task.description);
    }
}

fn mark_complete(task_list: &mut Vec<Task>) {
    if task_list.is_empty() {
        println!("No tasks found.");
        return;
    }
    
    view_task(task_list);
    println!("Enter the task number to mark as completed:");
    let mut task_number = String::new();
    io::stdin().read_line(&mut task_number).expect("Invalid input");
    
    match task_number.trim().parse::<usize>() {
        Ok(num) if num > 0 && num <= task_list.len() => {
            task_list[num - 1].completed = true;
            println!("Task marked as completed!");
        }
        _ => println!("Invalid task number.")
    }
}

fn change_priority(task_list: &mut Vec<Task>) {
    if task_list.is_empty() {
        println!("No tasks found.");
        return;
    }
    
    view_task(task_list);
    println!("Enter the task number to change priority:");
    let mut task_number = String::new();
    io::stdin().read_line(&mut task_number).expect("Invalid input");
    
    match task_number.trim().parse::<usize>() {
        Ok(num) if num > 0 && num <= task_list.len() => {
            println!("Enter new priority (1-5):");
            let mut new_priority = String::new();
            io::stdin().read_line(&mut new_priority).expect("Invalid input");
            
            match new_priority.trim().parse::<u8>() {
                Ok(p) if (1..=5).contains(&p) => {
                    task_list[num - 1].priority = p;
                    println!("Priority updated successfully!");
                }
                _ => println!("Invalid priority. Must be between 1 and 5.")
            }
        }
        _ => println!("Invalid task number.")
    }
}
