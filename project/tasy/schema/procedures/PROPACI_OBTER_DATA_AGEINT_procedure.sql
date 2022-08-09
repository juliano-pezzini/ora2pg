-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function propaci_obter_data_ageint as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE propaci_obter_data_ageint (nr_prescricao_p bigint, nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_conta_p timestamp, dt_agenda_integrada_p INOUT timestamp) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'SELECT * FROM propaci_obter_data_ageint_atx ( ' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(cd_procedimento_p) || ',' || quote_nullable(ie_origem_proced_p) || ',' || quote_nullable(dt_conta_p) || ',' || quote_nullable(dt_agenda_integrada_p) || ' )';
	SELECT v_ret INTO dt_agenda_integrada_p FROM dblink(v_conn_str, v_query) AS p (v_ret timestamp);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE propaci_obter_data_ageint_atx (nr_prescricao_p bigint, nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_conta_p timestamp, dt_agenda_integrada_p INOUT timestamp) AS $body$
DECLARE


dt_agenda_integrada_w	timestamp;
BEGIN

begin
select  coalesce(coalesce(b.dt_transferencia, a.dt_inicio_agendamento), dt_conta_p)
into STRICT	dt_agenda_integrada_w
from    prescr_medica 		e,
	prescr_procedimento 	d,
	agenda_paciente 	c,
        agenda_integrada_item 	b,
        agenda_integrada 	a
where   a.nr_sequencia = b.nr_seq_agenda_int
and     c.nr_sequencia = b.nr_seq_agenda_exame
and     d.nr_seq_agenda = c.nr_sequencia
and     d.nr_prescricao = e.nr_prescricao
and 	e.nr_atendimento = nr_atendimento_p
and 	d.cd_procedimento = cd_procedimento_p
and 	d.ie_origem_proced = ie_origem_proced_p;
exception
    	when others then
      	begin
		select  coalesce(coalesce(b.dt_transferencia, a.dt_inicio_agendamento), dt_conta_p)
		into STRICT	dt_agenda_integrada_w
		from    prescr_medica 		e,
			prescr_procedimento 	d,
			agenda_consulta 	c,
		        agenda_integrada_item 	b,
		        agenda_integrada 	a
		where   a.nr_sequencia 			= b.nr_seq_agenda_int
		and     c.nr_sequencia 			= b.nr_seq_agenda_cons
		and     d.nr_seq_agenda_cons	= c.nr_sequencia
		and     d.nr_prescricao 		= e.nr_prescricao
		and 	e.nr_atendimento 		= nr_atendimento_p
		and 	d.cd_procedimento 		= cd_procedimento_p
		and 	d.ie_origem_proced 		= ie_origem_proced_p;
		exception
    	when others then
			dt_agenda_integrada_w:= dt_conta_p;
		end;
end;

dt_agenda_integrada_p:= dt_agenda_integrada_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE propaci_obter_data_ageint (nr_prescricao_p bigint, nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_conta_p timestamp, dt_agenda_integrada_p INOUT timestamp) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE propaci_obter_data_ageint_atx (nr_prescricao_p bigint, nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_conta_p timestamp, dt_agenda_integrada_p INOUT timestamp) FROM PUBLIC;
