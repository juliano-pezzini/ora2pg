-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_alertas_anestesia ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_return_w			varchar(4000) := null;
ie_first_value		varchar(1) := 1;

c01 CURSOR FOR
SELECT 		CASE WHEN 	a.ie_tipo_alerta=0 THEN (select substr(max(b.ds_alerta),1,100) from alerta_anestesia b where b.nr_sequencia = a.nr_seq_alerta)  ELSE (select substr(max(c.ds_diagnostico),1,100) from apa_diagnostico c where c.nr_sequencia = a.nr_seq_diag) END  ds_alerta
from 		ALERTA_ANESTESIA_APAE a
where 		coalesce(a.ie_situacao, 'A') = 'A'
and 		((coalesce(a.dt_fim_alerta::text, '') = '') or (clock_timestamp() between coalesce(a.dt_alerta,clock_timestamp() - interval '1 days') and a.dt_fim_alerta))
and 		coalesce(a.dt_inativacao::text, '') = ''
and 		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and 		a.cd_pessoa_fisica = cd_pessoa_fisica_p
order by 	ds_alerta asc;

BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	for r_c01 in c01 loop
		if (r_c01.ds_alerta IS NOT NULL AND r_c01.ds_alerta::text <> '') then
			if (ie_first_value = 1) then
				ds_return_w := ds_return_w || r_c01.ds_alerta;
				ie_first_value := 0;
			else
				ds_return_w := ds_return_w || ',' || r_c01.ds_alerta;
			end if;
		end if;
	end loop;
end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_alertas_anestesia ( cd_pessoa_fisica_p text) FROM PUBLIC;
