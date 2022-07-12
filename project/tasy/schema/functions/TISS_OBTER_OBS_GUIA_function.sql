-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_obs_guia (cd_estabelecimento_p bigint, nr_interno_conta_p bigint, nr_seq_guia_p bigint, ie_tiss_tipo_guia_p text) RETURNS varchar AS $body$
DECLARE


/*Retorna o resultado da funtion informada no cadastro de convênio/tiss
	Esta function do cadastro de convênio deve ter como parâmetro apenas o nr_interno_conta
	Os demais tratamentos são realizados diretamente na funtion do cadastro de convênio.*/
ds_retorno_w		varchar(255) := null;
cd_convenio_w		bigint;
ds_parametro_w		varchar(2000);
ds_comando_w		varchar(2000);
ds_function_w		varchar(255);
vl_atributo_w		varchar(4000);


BEGIN

select 	max(cd_convenio_parametro)
into STRICT	cd_convenio_w
from 	conta_paciente
where	nr_interno_conta	= nr_interno_conta_p;

if (ie_tiss_tipo_guia_p = '4') then
	select	upper(max(DS_FUNCTION_OBS_SPSADT))
	into STRICT 	ds_function_w
	from 	tiss_parametros_convenio
	where	cd_estabelecimento 	= cd_estabelecimento_p
	and 	cd_convenio		= cd_convenio_w;
elsif (ie_tiss_tipo_guia_p = '3') then
	select	upper(max(DS_FUNCTION_OBS_CONSULTA))
	into STRICT 	ds_function_w
	from 	tiss_parametros_convenio
	where	cd_estabelecimento 	= cd_estabelecimento_p
	and 	cd_convenio		= cd_convenio_w;
end if;

if (ds_function_w IS NOT NULL AND ds_function_w::text <> '') then

	ds_comando_w		:= 'select  '||ds_function_w||'(:nr_interno_conta,:nr_seq_guia) from dual';

	ds_parametro_w		:= 'nr_interno_conta='||nr_interno_conta_p||';'||
				   'nr_seq_guia='||nr_seq_guia_p;

	vl_atributo_w := obter_valor_dinamico_char_bv(ds_comando_w, ds_parametro_w, vl_atributo_w);

end if;

return vl_atributo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_obs_guia (cd_estabelecimento_p bigint, nr_interno_conta_p bigint, nr_seq_guia_p bigint, ie_tiss_tipo_guia_p text) FROM PUBLIC;

