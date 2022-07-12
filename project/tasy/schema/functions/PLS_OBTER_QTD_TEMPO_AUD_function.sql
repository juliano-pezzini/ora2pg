-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qtd_tempo_aud ( nr_seq_grupo_p text, dt_inicio_p timestamp, dt_fim_p timestamp, ie_tipo_segurado_p text, ie_tipo_processo_p text, ie_status_p text) RETURNS varchar AS $body$
DECLARE


nr_tempo_total_w		varchar(99);
nr_hora_w			varchar(99);
nr_minuto_w			varchar(99);
nr_segundo_w			varchar(99);
nr_hora_sem_ponto_w		varchar(99);
nr_hora_num_w			bigint := 0;
nr_minuto_num_w			bigint := 0;
nr_segundo_num_w		bigint := 0;
qt_hora_total			bigint := 0;
qt_minuto_total			bigint := 0;
qt_segundo_total		bigint := 0;

C01 CURSOR FOR
	SELECT 	pls_obter_tempo_lib_auditor(a.nr_sequencia, a.nr_seq_auditoria) nr_horario
	from 	pls_auditoria_grupo a,
		pls_auditoria b
	where 	a.nr_seq_grupo = nr_seq_grupo_p
	and	b.nr_sequencia = a.nr_seq_auditoria
	and	coalesce(a.dt_liberacao::text, '') = ''
	and 	a.ie_status not in ('C', 'F')
	and	ie_status_p in (b.ie_status, 'X')
	and	ie_tipo_processo_p in (b.ie_tipo_processo, 'X')
	and (coalesce(ie_tipo_segurado_p::text, '') = '' or ie_tipo_segurado_p = pls_obter_dados_segurado(b.nr_seq_segurado, 'TP'))
	and	pkg_date_utils.start_of(trunc(b.dt_auditoria), 'DAY') between	pkg_date_utils.start_of(dt_inicio_p,'DAY') and pkg_date_utils.end_of(dt_fim_p, 'DAY');
vet_01	C01%rowtype;

BEGIN

open C01;
	loop
	fetch C01 into	
		vet_01;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			select 	coalesce(substr(vet_01.nr_horario, 1, instr(vet_01.nr_horario, ':', 1, 1) -1), 0) ds_hora,
				coalesce(substr(vet_01.nr_horario, instr(vet_01.nr_horario, ':', 1, 1) +1, instr(vet_01.nr_horario, ':', 1, 2) - instr(vet_01.nr_horario, ':', 1,1) -1), 0) ds_minuto,
				coalesce(substr(vet_01.nr_horario, instr(vet_01.nr_horario, ':', 1, 2) + 1, length(vet_01.nr_horario) - instr(vet_01.nr_horario, ':', 1,2)), 0) ds_segundos
			into STRICT	nr_hora_w,
				nr_minuto_w,
				nr_segundo_w
			;

			select 	REPLACE(nr_hora_w, '.', '')
			into STRICT	nr_hora_sem_ponto_w
			;

			if (coalesce(nr_hora_sem_ponto_w::text, '') = '') then
				nr_hora_num_w := (nr_hora_w)::numeric;
			else
				nr_hora_num_w := (nr_hora_sem_ponto_w)::numeric;
			end if;

			nr_minuto_num_w := (nr_minuto_w)::numeric;
			nr_segundo_num_w := (nr_segundo_w)::numeric;

			qt_hora_total := qt_hora_total + nr_hora_num_w;
			qt_minuto_total := qt_minuto_total + nr_minuto_num_w;
			qt_segundo_total := qt_segundo_total + nr_segundo_num_w;

		end;
	end loop;
close C01;

qt_minuto_total := qt_minuto_total + (qt_segundo_total / 60);
qt_segundo_total := MOD(qt_segundo_total, 60);
qt_hora_total := qt_hora_total + (qt_minuto_total / 60);
qt_minuto_total := MOD(qt_minuto_total, 60);

nr_tempo_total_w := to_char(qt_hora_total) || ':' || to_char(qt_minuto_total) || ':' || to_char(qt_segundo_total);

return nr_tempo_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qtd_tempo_aud ( nr_seq_grupo_p text, dt_inicio_p timestamp, dt_fim_p timestamp, ie_tipo_segurado_p text, ie_tipo_processo_p text, ie_status_p text) FROM PUBLIC;
