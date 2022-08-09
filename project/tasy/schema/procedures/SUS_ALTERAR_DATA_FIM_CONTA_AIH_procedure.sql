-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_alterar_data_fim_conta_aih ( nr_aih_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE

						 
nr_interno_conta_w		bigint;						
dt_inicial_w		timestamp;
dt_final_w		timestamp;
nr_atendimento_w		bigint;


BEGIN 
 
begin 
select	nr_interno_conta, 
	dt_inicial, 
	dt_final, 
	nr_atendimento 
into STRICT	nr_interno_conta_w, 
	dt_inicial_w, 
	dt_final_w, 
	nr_atendimento_w 
from	sus_aih_unif 
where	nr_aih		= nr_aih_p 
and	nr_sequencia 	= nr_sequencia_p;
exception 
when others then 
	nr_interno_conta_w	:= 0;
end;
 
if (ie_opcao_p = 'S') and (coalesce(nr_interno_conta_w,0) > 0) and (dt_final_w IS NOT NULL AND dt_final_w::text <> '') then 
	begin 
	 
	update	conta_paciente 
	set	dt_periodo_final	= to_date((to_char(dt_final_w,'dd/mm/yyyy')|| ' 23:59:59'),'dd/mm/yyyy hh24:mi:ss'), 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao 	= clock_timestamp() 
	where	nr_interno_conta 	= nr_interno_conta_w;	
	 
	commit;
		 
	end;
elsif (ie_opcao_p = 'A') and (coalesce(nr_interno_conta_w,0) > 0) and (dt_inicial_w IS NOT NULL AND dt_inicial_w::text <> '') and (dt_final_w IS NOT NULL AND dt_final_w::text <> '') then 
	begin 
	 
	update	conta_paciente 
	set	dt_periodo_inicial	= to_date((to_char(dt_inicial_w,'dd/mm/yyyy')|| ' 00:00:01'),'dd/mm/yyyy hh24:mi:ss'), 
		dt_periodo_final	= to_date((to_char(dt_final_w,'dd/mm/yyyy')|| ' 23:59:59'),'dd/mm/yyyy hh24:mi:ss'), 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao 	= clock_timestamp() 
	where	nr_interno_conta 	= nr_interno_conta_w;
	 
	end;	
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_alterar_data_fim_conta_aih ( nr_aih_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;
