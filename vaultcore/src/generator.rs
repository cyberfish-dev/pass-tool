//! A flexible password generator module for PassTool Rust Core
//!
//! Provides a function to generate random passwords with configurable length, character sets,
//! and minimum counts for digits and symbols, using a cryptographically secure RNG.

use rand::{seq::SliceRandom, rngs::OsRng};

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
///
/// # Examples
///
/// ```rust
/// use pass_tool_core::password_generator::generate_password;
///
/// let pwd = generate_password(16, true, true, true, true, 4, 2);
/// assert_eq!(pwd.len(), 16);
/// ```
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
    let total_min = if include_digits { min_digits } else { 0 } + if include_symbols { min_symbols } else { 0 };
    if total_min > length {
        panic!("Sum of min_digits and min_symbols cannot exceed length");
    }

    // Predefined symbol set
    const SYMBOLS: &[char] = &[
        '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+',
        '[', ']', '{', '}', ';', ':', ',', '.', '<', '>', '/', '?', '|'
    ];

    let mut rng = OsRng;  // CSPRNG from the operating system
    let mut password: Vec<char> = Vec::with_capacity(length);
    let mut charset: Vec<char> = Vec::new();

    // Add required counts
    if include_digits {
        let digits: Vec<char> = ('0'..='9').collect();
        for _ in 0..min_digits {
            password.push(*digits.choose(&mut rng).unwrap());
        }
        charset.extend(digits);
    }
    if include_symbols {
        for _ in 0..min_symbols {
            password.push(*SYMBOLS.choose(&mut rng).unwrap());
        }
        charset.extend(SYMBOLS.iter());
    }
    if include_lower {
        charset.extend(('a'..='z').collect::<Vec<char>>());
    }
    if include_upper {
        charset.extend(('A'..='Z').collect::<Vec<char>>());
    }

    // Fill the rest
    for _ in password.len()..length {
        password.push(*charset.choose(&mut rng).unwrap());
    }
    // Shuffle
    password.shuffle(&mut rng);
    password.into_iter().collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_all_sets() {
        let pwd = generate_password(12, true, true, true, true, 3, 2);
        assert_eq!(pwd.len(), 12);
        assert!(pwd.chars().any(|c| c.is_ascii_lowercase()));
        assert!(pwd.chars().any(|c| c.is_ascii_uppercase()));
        assert!(pwd.chars().filter(|c| c.is_ascii_digit()).count() >= 3);
        assert!(pwd.chars().filter(|c| SYMBOLS.contains(&c)).count() >= 2);
    }

    #[test]
    fn test_only_lower() {
        let pwd = generate_password(8, true, false, false, false, 0, 0);
        assert_eq!(pwd.len(), 8);
        assert!(pwd.chars().all(|c| c.is_ascii_lowercase()));
    }

    #[test]
    #[should_panic(expected = "At least one character set must be included")]
    fn test_no_sets() {
        generate_password(8, false, false, false, false, 0, 0);
    }

    #[test]
    #[should_panic(expected = "Sum of min_digits and min_symbols cannot exceed length")]
    fn test_minimums_exceed() {
        generate_password(4, true, false, true, true, 3, 2);
    }
}
