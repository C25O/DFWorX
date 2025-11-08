-- Seed data for development

-- Insert test users (passwords are hashed 'password123')
-- Note: In production, use proper password hashing
INSERT INTO users (email, name, password_hash, is_verified) VALUES
    ('test@example.com', 'Test User', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYqFjZ0u0Cu', true),
    ('admin@example.com', 'Admin User', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYqFjZ0u0Cu', true)
ON CONFLICT (email) DO NOTHING;
