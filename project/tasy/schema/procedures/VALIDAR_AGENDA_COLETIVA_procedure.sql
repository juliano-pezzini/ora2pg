-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_agenda_coletiva (nr_seq_pend_agenda_p bigint, ie_agrupado_p INOUT text) AS $body$
DECLARE


	nr_pend_age_w	bigint;
	nr_grupo_w		bigint;
	dt_prevista_w	timestamp;

	C01 CURSOR FOR
		SELECT nr_grupo_agendamento,
			coalesce(TRUNC(b.dt_prevista_agenda), coalesce(TRUNC(b.dt_real), TRUNC(b.dt_prevista)))
		FROM paciente_setor a,
			paciente_atendimento b
		WHERE a.nr_seq_paciente	= b.nr_seq_paciente
			AND a.ie_agendamento_multiplo = 'S'
			AND b.nr_seq_pend_agenda = nr_seq_pend_agenda_p;


BEGIN

	ie_agrupado_p := 'N';

	open C01;
	loop
	fetch C01 into
		nr_grupo_w,
		dt_prevista_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
			SELECT MAX(b.nr_seq_pend_agenda)
			INTO STRICT nr_pend_age_w
			FROM paciente_setor a,
				paciente_atendimento b
			WHERE a.nr_seq_paciente	= b.nr_seq_paciente
				AND a.ie_agendamento_multiplo = 'S'
				AND b.nr_seq_pend_agenda <> nr_seq_pend_agenda_p
				AND a.nr_grupo_agendamento = nr_grupo_w
				AND qt_obter_se_agendado(b.nr_seq_pend_agenda, coalesce(b.dt_prevista_agenda, b.dt_prevista)) = 'N'
				AND (TRUNC(b.dt_prevista_agenda) = dt_prevista_w
					OR TRUNC(b.dt_prevista) = dt_prevista_w);
			
			if (nr_pend_age_w IS NOT NULL AND nr_pend_age_w::text <> '') then
				ie_agrupado_p := 'S';
			end if;
		end;
	end loop;
	close C01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_agenda_coletiva (nr_seq_pend_agenda_p bigint, ie_agrupado_p INOUT text) FROM PUBLIC;

