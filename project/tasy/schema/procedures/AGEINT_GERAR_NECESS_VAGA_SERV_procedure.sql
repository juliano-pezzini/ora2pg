-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_necess_vaga_serv ( nr_seq_ageint_p bigint, ie_tipo_agendamento_p INOUT text, nr_seq_agenda_p INOUT bigint) AS $body$
DECLARE

			
nr_seq_agenda_w		agenda_consulta.nr_sequencia%type;	
ie_tipo_agendamento_w	varchar(15);


C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.ie_tipo_agendamento
	FROM	agenda_integrada_item a,
		agenda_paciente b
	WHERE	a.nr_seq_agenda_exame	= b.nr_sequencia
	AND	a.nr_seq_agenda_int	= nr_seq_ageint_p
	AND	b.ie_status_agenda	<> 'C'
	AND	coalesce(a.ie_necessita_internacao, 'N')	= 'S'
	ORDER BY b.hr_inicio DESC;
	
	
C02 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.ie_tipo_agendamento
	FROM	agenda_integrada_item a,
		agenda_consulta b,
		agenda c
	WHERE	a.nr_seq_agenda_cons	= b.nr_sequencia
	AND	b.cd_agenda 		= c.cd_agenda
	AND	a.nr_seq_agenda_int	= nr_seq_ageint_p
	AND	b.ie_status_agenda	<> 'C'
	AND	c.cd_tipo_agenda 	= 5
	AND	coalesce(a.ie_necessita_internacao, 'N')	= 'S'
	ORDER BY b.dt_agenda DESC;
	


BEGIN

open C01;
		loop
		fetch C01 into	
			nr_seq_agenda_w,
			ie_tipo_agendamento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			nr_seq_agenda_w := nr_seq_agenda_w;
			ie_tipo_agendamento_w := ie_tipo_agendamento_w;
			end;
		end loop;
		close C01;
	

if (coalesce(nr_seq_agenda_w::text, '') = '') then

open C02;
		loop
		fetch C02 into	
			nr_seq_agenda_w,
			ie_tipo_agendamento_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			nr_seq_agenda_w := nr_seq_agenda_w;
			ie_tipo_agendamento_w := ie_tipo_agendamento_w;
			end;
		end loop;
		close C02;
		
end if;

nr_seq_agenda_p := nr_seq_agenda_w;
ie_tipo_agendamento_p := ie_tipo_agendamento_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_necess_vaga_serv ( nr_seq_ageint_p bigint, ie_tipo_agendamento_p INOUT text, nr_seq_agenda_p INOUT bigint) FROM PUBLIC;

