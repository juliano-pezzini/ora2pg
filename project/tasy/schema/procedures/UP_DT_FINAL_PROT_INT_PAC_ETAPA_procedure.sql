-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE up_dt_final_prot_int_pac_etapa (nr_seq_protocolo_p bigint) AS $body$
DECLARE


dt_inicial_real_w timestamp;
dt_final_real_w timestamp;
dt_real_w timestamp;
qt_etapas_incompletas_W bigint;


BEGIN
    select max(DT_REAL)
    into STRICT dt_inicial_real_w
    from PROTOCOLO_INT_PAC_EVENTO 
    where nr_seq_prt_int_pac_etapa = nr_seq_protocolo_p;

 select min(dt_final_real)
    into STRICT dt_final_real_w 
    from PROTOCOLO_INT_PAC_ETAPA 
    where nr_seq_protocolo_int_pac = nr_seq_protocolo_p;

       if (coalesce(dt_real_w::text, '') = '') then
        update PROTOCOLO_INT_PAC_ETAPA set dt_final_real = dt_real_w where nr_sequencia = nr_seq_protocolo_p;
        commit;
    end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE up_dt_final_prot_int_pac_etapa (nr_seq_protocolo_p bigint) FROM PUBLIC;

