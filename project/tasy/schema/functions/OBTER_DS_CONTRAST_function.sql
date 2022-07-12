-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_contrast (nr_atendimento_P bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(4000);
ds_contrast_w varchar(250);

C01 CURSOR FOR
SELECT c.DS_CONTRAST ds from type_of_contrast c,paciente_alergia a
where c.ie_situacao = 'A' and c.nr_seq_allergen= a.NR_SEQ_TIPO and a.nr_atendimento = nr_atendimento_P
and  (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.dt_inativacao::text, '') = ''
;



BEGIN

open c01;
loop
fetch c01 into
		ds_contrast_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w := ds_contrast_w;
	else
		ds_retorno_w := ds_retorno_w || ', ' || ds_contrast_w;

	end if;
	end;
end loop;
close c01;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_contrast (nr_atendimento_P bigint) FROM PUBLIC;

