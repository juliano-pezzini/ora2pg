-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_obser_setor_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_observacoes_w	varchar(2000);
ds_obs_w	varchar(2000);

C01 CURSOR FOR
	SELECT	ds_observacao
	from	atend_paciente_unidade
	where	nr_atendimento = nr_atendimento_p
	and	(ds_observacao IS NOT NULL AND ds_observacao::text <> '');



BEGIN

open C01;
loop
fetch C01 into
	ds_obs_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(ds_observacoes_w::text, '') = '') then

		ds_observacoes_w := ds_obs_w;
	else
		ds_observacoes_w := substr(ds_observacoes_w || ' - ' || ds_obs_w,1,2000);
	end if;

	end;
end loop;
close C01;


return	ds_observacoes_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_obser_setor_atend (nr_atendimento_p bigint) FROM PUBLIC;

