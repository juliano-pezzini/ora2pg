-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_etapa_superior_classif ( cd_classificacao_p text) RETURNS varchar AS $body$
DECLARE


k			integer;
i			integer;
j			integer;
ds_superior_w		varchar(255);



BEGIN
--identifica quantos niveis tem esta classificacao
i	:= 1;
for k in 1..length(cd_classificacao_p) LOOP
	if (substr(cd_classificacao_p, k, 1) = '.') then
		i	:= i + 1;
	end if;
end loop;


--monta a classificacao com 1 nivel a menos
j	:= 0;
for k in 1..length(cd_classificacao_p) LOOP
	begin
	if (substr(cd_classificacao_p, k, 1) = '.') then
		j	:= j + 1;
	end if;
	if (j = i - 1) and (coalesce(ds_superior_w::text, '') = '') then
		ds_superior_w	:= substr(cd_classificacao_p, 1, k - 1);
	end if;

	end;
end loop;

return ds_superior_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_etapa_superior_classif ( cd_classificacao_p text) FROM PUBLIC;

