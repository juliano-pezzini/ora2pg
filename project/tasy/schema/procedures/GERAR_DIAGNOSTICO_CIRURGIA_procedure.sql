-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_diagnostico_cirurgia ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_w		bigint;
cd_doenca_cid_w			varchar(10);
cd_medico_exec_w		varchar(10);				
 

BEGIN 
 
select 	max(a.cd_doenca_cid), 
	max(c.nr_atendimento), 
	max(b.cd_medico_exec) 
into STRICT	cd_doenca_cid_w, 
	nr_atendimento_w, 
	cd_medico_exec_w 
from  procedimento a, 
	prescr_procedimento b, 
	prescr_medica c 
where	a.cd_procedimento = b.cd_procedimento 
and	a.ie_origem_proced = b.ie_origem_proced 
and	b.nr_prescricao = c.nr_prescricao 
and	b.nr_prescricao = nr_prescricao_p 
and	b.nr_sequencia = nr_sequencia_p;
 
if (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> '') and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
	CALL Gerar_diagnostico_Atend(nr_atendimento_w,cd_doenca_cid_w,cd_medico_exec_w,nm_usuario_p,2,'P');
end if;	
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_diagnostico_cirurgia ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

