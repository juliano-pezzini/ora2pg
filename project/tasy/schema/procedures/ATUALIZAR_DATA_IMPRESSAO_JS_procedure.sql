-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_data_impressao_js ( nr_atendimento_p bigint) AS $body$
BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')then
	begin

	update 	prescr_procedimento a
	set   	a.dt_impressao   = clock_timestamp()
	where  	exists (	SELECT 	1
				from 	prescr_medica b
				where 	a.nr_prescricao = b.nr_prescricao
				and 	b.nr_atendimento = nr_atendimento_p);

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_data_impressao_js ( nr_atendimento_p bigint) FROM PUBLIC;
