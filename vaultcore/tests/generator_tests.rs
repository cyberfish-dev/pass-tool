use pass_tool_core::generator::{generate_password, SYMBOLS};

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
