-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_desf_assumir_medic_infect (nr_atendimento_p text, nm_usuario_p text) AS $body$
DECLARE

										 
cd_medico_w varchar(20);										
 

BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
 
select substr(max(b.DS_VALOR_OLD),1,250) cd_medic_infect 
into STRICT cd_medico_w 
from tasy_log_alt_campo b 
where 1 = 1 
and b.NM_ATRIBUTO = 'CD_MEDICO_INFECT' 
and b.nr_seq_log_alteracao = (SELECT max(nr_sequencia) 
						  	 from tasy_log_alteracao a 
							 where 1 = 1 
							 and a.nm_tabela = 'ATENDIMENTO_PACIENTE' 							 
							 and a.ds_chave_simples = nr_atendimento_p);
							 
CALL HD_ASSUMIR_MEDIC_INFECT(nr_atendimento_p,cd_medico_w,nm_usuario_p);
							 
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_desf_assumir_medic_infect (nr_atendimento_p text, nm_usuario_p text) FROM PUBLIC;
