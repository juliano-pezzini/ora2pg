-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_receita_pac_js ( nr_atendimento_p bigint, nr_prescricao_p bigint) AS $body$
DECLARE

 
nr_sequencia_w	med_receita.nr_sequencia%type;

C01 CURSOR FOR 
SELECT nr_sequencia 
from 	med_receita 
where 	nr_atendimento_hosp = nr_atendimento_p 
and	nr_prescricao       = nr_prescricao_p 
and	coalesce(dt_liberacao::text, '') = '' 
order by 1;


BEGIN 
 
if (coalesce(nr_atendimento_p,0) > 0) and (coalesce(nr_prescricao_p,0) > 0) then 
	open C01;
	loop 
	fetch C01 into 
	nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	  CALL liberar_receita_pac(nr_sequencia_w);
	end;
	end loop;
	close C01;
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_receita_pac_js ( nr_atendimento_p bigint, nr_prescricao_p bigint) FROM PUBLIC;
