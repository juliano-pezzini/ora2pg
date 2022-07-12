-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_desc_classif_paciente (cd_pessoa_fisica_p bigint) RETURNS varchar AS $body$
DECLARE


ds_classificacao_w	varchar(100);
ds_retorno_w		varchar(1000);
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;

c01 CURSOR FOR
SELECT	distinct b.DS_CLASSIFICACAO
from	PESSOA_CLASSIF a,
	classif_pessoa b
where	b.nr_sequencia = a.nr_seq_classif
and	a.cd_pessoa_fisica = cd_pessoa_fisica_w
and          b.ie_exibe_ocupacao_quimio = 'S';


BEGIN

cd_pessoa_fisica_w := to_char(cd_pessoa_fisica_p);

if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
	open c01;
	loop
	fetch c01 into ds_classificacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				ds_retorno_w 	:= ds_retorno_w || ' / ' || ds_classificacao_w;
			else
				ds_retorno_w 	:= ds_classificacao_w;
			end if;
		end;
	end loop;
	close c01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_desc_classif_paciente (cd_pessoa_fisica_p bigint) FROM PUBLIC;

