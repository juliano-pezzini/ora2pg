-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_sus_municipio ( cd_municipio_ibge_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*IE_OPCAO_P:
NC - Sequencia da coordenadoria
DC - Descrição da coordenadoria
CB - Código do municipio Bacen
*/
ds_retorno_w			varchar(255);
cd_medico_autorizador_w		varchar(10);
cd_municipio_sinpas_w		varchar(5);
cd_municipio_tom_w		bigint;
cd_orgao_emissor_w		varchar(10);
cd_orgao_emissor_sihd_w		varchar(10);
cd_siafi_w			varchar(80);
ds_abreviacao_w			varchar(15);
ds_municipio_w			varchar(100);
ds_unidade_federacao_w		varchar(2);
ie_importacao_sus_w		varchar(1);
nr_localidade_w			integer;
nr_seq_coordenadoria_w		bigint;
cd_municipio_bacen_w		sus_municipio.cd_municipio_bacen%type;


BEGIN

begin
select	cd_medico_autorizador,
	cd_municipio_sinpas,
	cd_municipio_tom,
	cd_orgao_emissor,
	cd_orgao_emissor_sihd,
	cd_siafi,
	ds_abreviacao,
	ds_municipio,
	ds_unidade_federacao,
	ie_importacao_sus,
	nr_localidade,
	nr_seq_coordenadoria,
	cd_municipio_bacen
into STRICT	cd_medico_autorizador_w,
	cd_municipio_sinpas_w,
	cd_municipio_tom_w,
	cd_orgao_emissor_w,
	cd_orgao_emissor_sihd_w,
	cd_siafi_w,
	ds_abreviacao_w,
	ds_municipio_w,
	ds_unidade_federacao_w,
	ie_importacao_sus_w,
	nr_localidade_w,
	nr_seq_coordenadoria_w,
	cd_municipio_bacen_w
from	sus_municipio
where	cd_municipio_ibge = cd_municipio_ibge_p;
exception
when others then
	ds_retorno_w := '';
end;

if (ie_opcao_p = 'NC') then
	ds_retorno_w := nr_seq_coordenadoria_w;
elsif (ie_opcao_p = 'DC') then
	ds_retorno_w := substr(sus_obter_desc_coordenad(nr_seq_coordenadoria_w),1,255);
elsif (ie_opcao_p = 'CB') then
	ds_retorno_w := substr(cd_municipio_bacen_w,1,255);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_sus_municipio ( cd_municipio_ibge_p text, ie_opcao_p text) FROM PUBLIC;
