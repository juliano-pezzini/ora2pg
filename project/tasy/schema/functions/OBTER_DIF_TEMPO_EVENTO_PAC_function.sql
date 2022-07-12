-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dif_tempo_evento_pac ( nr_cirurgia_p bigint, nr_seq_evento_ini_p text, nr_seq_evento_fim_p text) RETURNS bigint AS $body$
DECLARE



dt_evento_ini_w			timestamp;
dt_evento_fim_w 		timestamp;
qt_min_retorno_w		double precision;


BEGIN

select	max(dt_registro)
into STRICT	dt_evento_ini_w
from	evento_cirurgia_paciente
where	nr_cirurgia = nr_cirurgia_p
and	nr_seq_evento = nr_seq_evento_ini_p
and	coalesce(ie_situacao,'A') = 'A'
order by 1;

select	max(dt_registro)
into STRICT	dt_evento_fim_w
from	evento_cirurgia_paciente
where	nr_cirurgia = nr_cirurgia_p
and	nr_seq_evento = nr_seq_evento_fim_p
and	coalesce(ie_situacao,'A') = 'A'
order by 1;

if (dt_evento_ini_w IS NOT NULL AND dt_evento_ini_w::text <> '') and (dt_evento_fim_w IS NOT NULL AND dt_evento_fim_w::text <> '') then
	select (dt_evento_fim_w - dt_evento_ini_w) * 1440
	into STRICT	qt_min_retorno_w
	;
end if;

return coalesce(qt_min_retorno_w,0);

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dif_tempo_evento_pac ( nr_cirurgia_p bigint, nr_seq_evento_ini_p text, nr_seq_evento_fim_p text) FROM PUBLIC;

