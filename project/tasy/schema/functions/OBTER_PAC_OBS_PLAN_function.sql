-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pac_obs_plan (nr_seq_versao_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w			varchar(2000)	:= '';
ds_alergias_w			varchar(255);
qt_peso_w			double precision;
qt_altura_w			double precision;
qt_creatinina_w			double precision;
ds_sexo_w			varchar(10);
ds_outras_condicoes_w		varchar(255);
nr_linhas_w			smallint := 0;


BEGIN

select 	substr(replace(ds_alergias,'|',', '),1,70),
	qt_peso,
	qt_altura,
	qt_creatinina,
	CASE WHEN obter_sexo_pf(cd_pessoa_fisica,'C')='F' THEN 'w' WHEN obter_sexo_pf(cd_pessoa_fisica,'C')='M' THEN 'm' WHEN obter_sexo_pf(cd_pessoa_fisica,'C')='D' THEN  'd'  ELSE 'unbestimmt' END ,
	substr(ds_outras_condicoes,1,70)
into STRICT 	ds_alergias_w,
        qt_peso_w,
        qt_altura_w,
        qt_creatinina_w,
        ds_sexo_w,
        ds_outras_condicoes_w
from    plano_versao
where   nr_sequencia = nr_seq_versao_p;

if (ds_alergias_w IS NOT NULL AND ds_alergias_w::text <> '')then
	ds_retorno_w := ds_retorno_w || 'Allerg./Unv.: ' || ds_alergias_w;
	nr_linhas_w := trunc(length(ds_retorno_w) / 20);
end if;

if (qt_peso_w IS NOT NULL AND qt_peso_w::text <> '')then
	ds_retorno_w := ds_retorno_w || chr(13)||chr(10) ||'Gew.: ' || qt_peso_w || ' Kg ';
end if;

if (qt_altura_w IS NOT NULL AND qt_altura_w::text <> '')then
	if (nr_linhas_w < 3)then
		ds_retorno_w := ds_retorno_w || obter_desc_expressao(299037) || qt_altura_w || ' cm ';
		nr_linhas_w := nr_linhas_w + 1;
	else
		nr_linhas_w := nr_linhas_w + 1;
	end if;
end if;

if (qt_creatinina_w IS NOT NULL AND qt_creatinina_w::text <> '')then
	if (nr_linhas_w < 3)then
		ds_retorno_w := ds_retorno_w || chr(13)||chr(10) || 'Krea.: ' ||qt_creatinina_w || ' mg/dl';
		nr_linhas_w := nr_linhas_w + 1;
	else
		nr_linhas_w := nr_linhas_w + 1;
	end if;
end if;

if (ds_sexo_w IS NOT NULL AND ds_sexo_w::text <> '')then
	if (nr_linhas_w < 3)then
		ds_retorno_w := ds_retorno_w || chr(13)||chr(10) ||'Geschl.: ' || ds_sexo_w;
		nr_linhas_w := nr_linhas_w + 1;
	else
		nr_linhas_w := nr_linhas_w + 1;
	end if;
end if;

if (ds_outras_condicoes_w IS NOT NULL AND ds_outras_condicoes_w::text <> '')then
	if (nr_linhas_w < 3)then
		ds_retorno_w := ds_retorno_w || chr(13)||chr(10) ||ds_outras_condicoes_w;
		nr_linhas_w := nr_linhas_w + 1;
	else
		nr_linhas_w := nr_linhas_w + 1;
	end if;
end if;

if (nr_linhas_w > 3)then
	if (length(ds_retorno_w) > 75) then
		ds_retorno_w := substr(ds_retorno_w,1,70)||'...';
	else
		ds_retorno_w := ds_retorno_w || '...';
	end if;
elsif (length(ds_retorno_w) > 75)then
	ds_retorno_w := substr(ds_retorno_w,1,70)||'...';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pac_obs_plan (nr_seq_versao_p bigint) FROM PUBLIC;
