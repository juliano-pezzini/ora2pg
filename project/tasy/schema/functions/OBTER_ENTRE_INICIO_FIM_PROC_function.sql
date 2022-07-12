-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_entre_inicio_fim_proc ( nr_cirurgia_p bigint, ie_inicio_proc_p bigint, ie_fim_proc_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	bigint:= 0;
dt_inicio_w	timestamp;
dt_fim_w		timestamp;


BEGIN

if (ie_inicio_proc_p > 0) and (ie_fim_proc_p > 0) then

	select	max(a.dt_registro)
	into STRICT	dt_inicio_w
	from	evento_cirurgia b,
		evento_cirurgia_paciente a
	where	a.nr_seq_evento = b.nr_sequencia
	and	b.ie_etapa_cirurgia = campo_numerico(ie_inicio_proc_p)
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	a.nr_cirurgia = nr_cirurgia_p;

	select	max(a.dt_registro)
	into STRICT	dt_fim_w
	from	evento_cirurgia b,
		evento_cirurgia_paciente a
	where	a.nr_seq_evento = b.nr_sequencia
	and	b.ie_etapa_cirurgia = campo_numerico(ie_fim_proc_p)
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	a.nr_cirurgia = nr_cirurgia_p;

	if (dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') and (dt_fim_w IS NOT NULL AND dt_fim_w::text <> '') then
		qt_retorno_w := Obter_Minutos_Espera(dt_inicio_w, dt_fim_w);
	end if;

end if;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_entre_inicio_fim_proc ( nr_cirurgia_p bigint, ie_inicio_proc_p bigint, ie_fim_proc_p bigint) FROM PUBLIC;
