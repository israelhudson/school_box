class SupabaseConfig {
  // Configuração Local
  static const String localUrl = 'http://127.0.0.1:54321';
  static const String localAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';
  static const String localServiceRoleKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU';

  // Configuração Remota - ColegioPequenosPassosDB
  static const String remoteUrl = 'https://oguadbjnpxhedcsvfvtd.supabase.co';
  static const String remoteAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ndWFkYmpucHhoZWRjc3ZmdnRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1NTA5ODEsImV4cCI6MjA2NzEyNjk4MX0.A_ArBctt7khsh4KEbK54RtuWyILyqREZm94NlSOYVAw';
  static const String remoteServiceRoleKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ndWFkYmpucHhoZWRjc3ZmdnRkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MTU1MDk4MSwiZXhwIjoyMDY3MTI2OTgxfQ.d00kFL7MAb-TDJLTq_SnslLej1_BudV-E-PIcXDTpq0';

  // Configuração ativa - AGORA USANDO REMOTO! 🚀
  static const bool useLocal = false; // ← Mudado para usar remoto

  // Getters para usar a configuração ativa
  static String get url => useLocal ? localUrl : remoteUrl;
  static String get anonKey => useLocal ? localAnonKey : remoteAnonKey;
  static String get serviceRoleKey =>
      useLocal ? localServiceRoleKey : remoteServiceRoleKey;
}
