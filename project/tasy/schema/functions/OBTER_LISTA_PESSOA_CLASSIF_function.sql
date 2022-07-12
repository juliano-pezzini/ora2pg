-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_pessoa_classif (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000) := '';
ds_classif_w		varchar(80);
ds_observacao_w		varchar(255);
ds_obs_cadastro_w varchar(255);

C01 CURSOR FOR
SELECT	a.ds_classificacao,
	a.ds_observacao ds_obs_cadastro,
	b.ds_observacao
from	classif_pessoa a,
	pessoa_classif b
where	a.nr_sequencia = b.nr_seq_classif
and  	a.ie_situacao = 'A'
and  	obter_se_mostra_alerta_classif(994, a.nr_sequencia) = 'S'
and  	coalesce(b.dt_final_vigencia,clock_timestamp() + interval '1 days') > clock_timestamp()
AND  	B.CD_PESSOA_FISICA = cd_pessoa_fisica_p
order by 	1 LIMIT 2;


BEGIN

open C01;
loop
fetch C01 into
	ds_classif_w,
  ds_obs_cadastro_w,
	ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

  ds_retorno_w := ds_retorno_w || ds_classif_w  || ',' ||  ds_obs_cadastro_w || ',' || ds_observacao_w || chr(13) || chr(10);

	end;
end loop;
close C01;

ds_retorno_w := substr(ds_retorno_w, 2, Length(ds_retorno_w) - 1);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_pessoa_classif (cd_pessoa_fisica_p text) FROM PUBLIC;

