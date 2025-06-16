//! A flexible password generator module for PassTool Rust Core
//!
//! Provides a function to generate random passwords with configurable length, character sets,
//! and minimum counts for digits and symbols, using a cryptographically secure RNG.

use rand::{rngs::OsRng, seq::SliceRandom};

// Predefined symbol set
#[flutter_rust_bridge::frb(sync)] 
pub const SYMBOLS: &[char] = &[
    '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', ';',
    ':', ',', '.', '<', '>', '/', '?', '|',
];

/// Generates a random password using OS-provided secure randomness.
///
/// # Arguments
///
/// * `length` - Desired total length of the password.
/// * `include_lower` - Include lowercase letters (`a-z`).
/// * `include_upper` - Include uppercase letters (`A-Z`).
/// * `include_digits` - Include digits (`0-9`).
/// * `include_symbols` - Include symbols (`!@#$%^&*()-_=+[]{};:,.<>/?|`).
/// * `min_digits` - Minimum number of numeric digits (`0-9`) to include (only if `include_digits`).
/// * `min_symbols` - Minimum number of symbols to include (only if `include_symbols`).
///
/// # Panics
///
/// Panics if no character sets are selected or if sums of minimums exceed `length`.
#[flutter_rust_bridge::frb(sync)] 
pub fn generate_password(
    length: usize,
    include_lower: bool,
    include_upper: bool,
    include_digits: bool,
    include_symbols: bool,
    min_digits: usize,
    min_symbols: usize,
) -> String {
    // Validate character sets
    if !(include_lower || include_upper || include_digits || include_symbols) {
        panic!("At least one character set must be included");
    }
    // Validate minimums
    let total_min =
        if include_digits { min_digits } else { 0 } + if include_symbols { min_symbols } else { 0 };

    if total_min > length {
        panic!("Sum of min_digits and min_symbols cannot exceed length");
    }

    let mut rng = OsRng; // CSPRNG from the operating system
    let mut password: Vec<char> = Vec::with_capacity(length);
    let mut charset: Vec<char> = Vec::new();

    // Add required counts
    if include_digits {
        
        let digits: Vec<char> = ('0'..='9').collect();
        for _ in 0..min_digits {
            password.push(*digits.choose(&mut rng).unwrap());
        }

        charset.extend(digits);

        if min_digits == 0 {
            password.push(*charset.last().unwrap());
        }
    }
    
    if include_symbols {
        
        for _ in 0..min_symbols {
            password.push(*SYMBOLS.choose(&mut rng).unwrap());
        }

        charset.extend(SYMBOLS.iter());

        if min_symbols == 0 {
            password.push(*charset.last().unwrap());
        }
    }
    
    if include_lower {
        charset.extend(('a'..='z').collect::<Vec<char>>());
        password.push(*charset.last().unwrap());
    }

    if include_upper {
        charset.extend(('A'..='Z').collect::<Vec<char>>());
        password.push(*charset.last().unwrap());
    }

    // Fill the rest
    for _ in password.len()..length {
        password.push(*charset.choose(&mut rng).unwrap());
    }
    
    // Shuffle
    password.shuffle(&mut rng);
    password.into_iter().collect()
}
