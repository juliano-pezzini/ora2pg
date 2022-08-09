-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_avaliacoes (cd_funcao_p bigint, ie_com_atendimento_p text, ie_com_prescricao_p text, ie_checkup_p text, qt_dias_p bigint) AS $body$
DECLARE

				 
nr_sequencia_w	bigint;
nm_usuario_w	varchar(15);				
				 
				 
c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		nm_usuario 
	from	med_avaliacao_paciente 
	where 	coalesce(dt_liberacao::text, '') = '' 
	and	((cd_funcao_p = '0') or (nr_seq_tipo_avaliacao in (	SELECT	t.nr_sequencia 
									from	med_tipo_avaliacao t 
									where	t.cd_funcao	= cd_funcao_p))) 
	and	((ie_com_atendimento_p = 'A')  or (ie_com_atendimento_p = 'S' AND nr_atendimento IS NOT NULL AND nr_atendimento::text <> '') 
						or ((ie_com_atendimento_p = 'N') and (coalesce(nr_atendimento::text, '') = ''))) 
	and	((ie_com_prescricao_p = 'A')  or (ie_com_prescricao_p = 'S' AND nr_prescricao IS NOT NULL AND nr_prescricao::text <> '') 
						or ((ie_com_prescricao_p = 'N') and (coalesce(nr_prescricao::text, '') = ''))) 
	and	((ie_checkup_p = 'A')  	or (ie_checkup_p 	 = 'S' AND nr_seq_checkup IS NOT NULL AND nr_seq_checkup::text <> '') 
						or ((ie_checkup_p 	 = 'N') and (coalesce(nr_seq_checkup::text, '') = ''))) 
	and	dt_avaliacao <= (clock_timestamp() - qt_dias_p);
				
/* 
 ie_com_atendimento,  
 ie_com_prescricao,   
 ie_com_checkup:  	S -> Sim 
        	N -> Não 
			A -> Ambos 
*/
 
 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w, 
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL liberar_avaliacao(nr_sequencia_w,nm_usuario_w);
	end;
end loop;
close C01;
 
/* 
Update	med_avaliacao_paciente 
set 	dt_liberacao 	= sysdate 
where 	dt_liberacao is null 
and	((cd_funcao_p = '0') or (nr_seq_tipo_avaliacao in (	select	t.nr_sequencia 
								from	med_tipo_avaliacao t 
								where	t.cd_funcao	= cd_funcao_p))) 
and	((ie_com_atendimento_p = 'A')  or ((ie_com_atendimento_p = 'S') and (nr_atendimento is not null)) 
					or ((ie_com_atendimento_p = 'N') and (nr_atendimento is null))) 
and	((ie_com_prescricao_p = 'A')  or ((ie_com_prescricao_p = 'S') and (nr_prescricao is not null)) 
					or ((ie_com_prescricao_p = 'N') and (nr_prescricao is null))) 
and	((ie_checkup_p = 'A')  	or ((ie_checkup_p 	 = 'S') and (nr_seq_checkup is not null)) 
					or ((ie_checkup_p 	 = 'N') and (nr_seq_checkup is null))) 
and	dt_avaliacao <= (sysdate - qt_dias_p); 
*/
 
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_avaliacoes (cd_funcao_p bigint, ie_com_atendimento_p text, ie_com_prescricao_p text, ie_checkup_p text, qt_dias_p bigint) FROM PUBLIC;
