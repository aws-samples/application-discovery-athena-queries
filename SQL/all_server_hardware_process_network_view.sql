select  B.account_number
        ,A.agent_id
        ,A.server_id
        ,C.host_name
        ,C.cpu_type
        ,B.CPUs
        ,B.COREs
        ,B.LOGICAL_PROCESSORs
        ,B.DISK_SIZE_GB
        ,B.RAM_SIZE_MB
        ,C.os_name
        ,C.os_version
        ,D.process_id
        ,D.process_name
        ,D.process_cmd_line
        ,D.process_path
        ,E.source_ip
        ,E.source_port
        ,E.destination_ip
        ,E.destination_port
        ,E.transport_protocol
from    (
            SELECT  distinct agent_id
                    ,server_id
            FROM    "id_mapping_agent"
        ) A
        inner join (
            SELECT  distinct account_number
                    ,agent_id
                    ,total_num_cpus as CPUs
                    ,total_num_cores as COREs
                    ,total_num_logical_processors as LOGICAL_PROCESSORs
                    ,total_disk_size_in_gb as DISK_SIZE_GB
                    ,total_ram_in_mb as RAM_SIZE_MB
            FROM    "sys_performance_agent"
        ) B on
        A.agent_id = B.agent_id
        inner join (
            SELECT  distinct account_number
                    ,agent_id
                    ,os_name
                    ,os_version
                    ,cpu_type
                    ,host_name
            FROM    "os_info_agent"
        ) C on
        B.account_number = C.account_number
        and B.agent_id = C.agent_id
        inner join (
            SELECT  distinct account_number
                    ,agent_id
                    ,agent_assigned_process_id as process_id
                    ,name as process_name
                    ,cmd_line as process_cmd_line
                    ,path as process_path
            FROM    "processes_agent"
            --WHERE   is_system=false        
        ) D on
        C.account_number = D.account_number
        and C.agent_id = D.agent_id
        left join (
            SELECT  distinct account_number
                    ,agent_id
                    ,agent_assigned_process_id as process_id
                    ,source_ip
                    ,source_port
                    ,destination_ip
                    ,destination_port
                    ,transport_protocol
            FROM    "inbound_connection_agent"
        ) E on
        D.account_number = E.account_number
        and D.agent_id = E.agent_id
        and D.process_id = E.process_id
        left join (
            SELECT  distinct account_number
                    ,agent_id
                    ,agent_assigned_process_id as process_id
                    ,source_ip
                    ,source_port
                    ,destination_ip
                    ,destination_port
                    ,transport_protocol
            FROM "outbound_connection_agent"
        ) F on
        D.account_number = F.account_number
        and D.agent_id = F.agent_id
        and D.process_id = F.process_id
