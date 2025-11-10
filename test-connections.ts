/**
 * Quick test script to verify all backend connections
 * Run with: npx tsx test-connections.ts
 */

import { config } from 'dotenv';
import { resolve } from 'path';
import { createClient as createSupabaseClient } from '@supabase/supabase-js';

// Load environment variables from multiple sources
config({ path: resolve(process.cwd(), 'apps/web/.env.local') });
config({ path: resolve(process.cwd(), 'services/auth-service/.env') });

async function testSupabase() {
  console.log('🧪 Testing Supabase connection...');

  try {
    // Use service role key to bypass RLS for connection testing
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.SUPABASE_URL;
    const serviceKey = process.env.SUPABASE_KEY; // Service role key from auth-service/.env

    if (!supabaseUrl || !serviceKey) {
      console.log('❌ Supabase credentials not found');
      return false;
    }

    const supabase = createSupabaseClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false }
    });

    // Test connection by querying organizations table
    const { data, error } = await supabase
      .from('organizations')
      .select('count')
      .limit(1);

    if (error) {
      console.log('❌ Supabase connection failed:', error.message);
      return false;
    }

    console.log('✅ Supabase connection successful!');
    console.log('   Database tables are accessible');
    return true;
  } catch (err: any) {
    console.log('❌ Supabase connection error:', err.message);
    return false;
  }
}

async function testConvex() {
  console.log('\n🧪 Testing Convex connection...');

  try {
    // Check if Convex dev server is running
    const response = await fetch('http://127.0.0.1:3210/api/health');

    if (response.ok) {
      console.log('✅ Convex dev server is running!');
      console.log('   URL: http://127.0.0.1:3210');
      return true;
    } else {
      console.log('❌ Convex dev server returned error:', response.status);
      return false;
    }
  } catch (err: any) {
    console.log('❌ Convex dev server not reachable');
    console.log('   Make sure "npx convex dev" is running');
    return false;
  }
}

async function main() {
  console.log('🚀 DFWorX Backend Connection Tests\n');
  console.log('=' .repeat(50));

  const supabaseOk = await testSupabase();
  const convexOk = await testConvex();

  console.log('\n' + '='.repeat(50));
  console.log('\n📊 Test Results:');
  console.log(`   Supabase: ${supabaseOk ? '✅ Connected' : '❌ Failed'}`);
  console.log(`   Convex:   ${convexOk ? '✅ Connected' : '❌ Failed'}`);

  if (supabaseOk && convexOk) {
    console.log('\n🎉 All backend services are connected and ready!');
    console.log('\n✨ You can now start development:');
    console.log('   1. Keep "npx convex dev" running');
    console.log('   2. Run "pnpm dev" to start Next.js');
    console.log('   3. Visit http://localhost:3000');
    process.exit(0);
  } else {
    console.log('\n⚠️  Some services are not connected');
    console.log('\n🔧 Troubleshooting:');
    if (!supabaseOk) {
      console.log('   - Check .env.local has correct Supabase credentials');
      console.log('   - Verify migrations ran successfully: supabase migration list');
    }
    if (!convexOk) {
      console.log('   - Start Convex dev server: npx convex dev');
      console.log('   - Check port 3210 is not in use');
    }
    process.exit(1);
  }
}

main();
