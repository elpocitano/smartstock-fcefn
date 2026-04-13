// src/shared/supabaseClient.js
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const supabaseUrl = window.SUPABASE_URL
const supabaseAnonKey = window.SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
    console.error('❌ Supabase credentials not found. Check config.js')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)