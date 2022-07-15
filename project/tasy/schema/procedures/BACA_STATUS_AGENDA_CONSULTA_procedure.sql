-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_status_agenda_consulta ( dt_inicial_p timestamp, dt_final_p timestamp) AS $body$
BEGIN
 
update	agenda_consulta 
set	ie_status_agenda = 'E' 
where	nr_sequencia in (	SELECT	nr_sequencia 
			from	agenda_consulta 
			where	dt_agenda between dt_inicial_p and fim_dia(dt_final_p) 
			and	(nr_atendimento IS NOT NULL AND nr_atendimento::text <> '') 
			and	obter_se_atendimento_alta(nr_atendimento) = 'S' 
			and	ie_status_agenda not in ('E','C','B','F','I','L','LF','II'));
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_status_agenda_consulta ( dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

