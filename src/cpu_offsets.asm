%define Cpu_struct_m_offset 0
%define Cpu_struct_v_offset (Cpu_struct_m_offset + 4096)
%define Cpu_struct_i_offset (Cpu_struct_v_offset + 16)
%define Cpu_struct_dt_offset (Cpu_struct_i_offset + 2)
%define Cpu_struct_st_offset (Cpu_struct_dt_offset + 1)
%define Cpu_struct_pc_offset (Cpu_struct_st_offset + 1)
%define Cpu_struct_sp_offset (Cpu_struct_pc_offset + 2)
%define Cpu_struct_s_offset (Cpu_struct_sp_offset + 1)
%define Cpu_struct_screen_offset (Cpu_struct_s_offset + 32)
%define Cpu_struct_keys_offset (Cpu_struct_screen_offset + 2048)
%define Cpu_struct_pause_offset (Cpu_struct_keys_offset + 16)


%define pc_counter_start (0x200)
%define Cpu_struct_pc_counter_start_offset (Cpu_struct_m_offset + pc_counter_start)

%define Cpu_struct_v_f_flags (Cpu_struct_v_offset + 0xF)