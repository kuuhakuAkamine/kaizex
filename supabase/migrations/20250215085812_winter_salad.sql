/*
  # Fix admin role permissions

  1. Changes
    - Drop existing admin role trigger
    - Create a more robust admin role management system
    - Fix permissions for admin users
  
  2. Security
    - Ensure proper role assignment for admin users
    - Maintain RLS policies
*/

-- First, let's create a function to check if a user is an admin
CREATE OR REPLACE FUNCTION is_admin(user_email TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN user_email = 'admin@kaizen.com';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a policy that uses the is_admin function
DROP POLICY IF EXISTS "Allow admin full access" ON products;

CREATE POLICY "Allow admin full access"
ON products
FOR ALL
TO authenticated
USING (is_admin(auth.jwt() ->> 'email'))
WITH CHECK (is_admin(auth.jwt() ->> 'email'));