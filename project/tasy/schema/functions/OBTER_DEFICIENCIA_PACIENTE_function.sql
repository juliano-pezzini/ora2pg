-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_deficiencia_paciente (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_deficiencia_w	varchar(254);
ds_retorno_w		varchar(4000);

C01 CURSOR FOR
	SELECT  b.ds_deficiencia
	FROM  	pf_tipo_deficiencia a,
		tipo_deficiencia b
	WHERE  	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and  	b.nr_sequencia = a.nr_seq_tipo_def
	and  	coalesce(a.IE_SITUACAO,'A') = 'A';



BEGIN

open c01;
loop
fetch c01 into
		ds_deficiencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w := ds_deficiencia_w;
	else
		ds_retorno_w := ds_retorno_w || ', ' || ds_deficiencia_w;
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
-- REVOKE ALL ON FUNCTION obter_deficiencia_paciente (cd_pessoa_fisica_p text) FROM PUBLIC;

