-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_cgc_prest_protocolo (cd_estabelecimento_p bigint, cd_setor_protocolo_p bigint, ie_tipo_protocolo_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_cgc_cabecalho_w	varchar(14);

c01 CURSOR FOR
SELECT	cd_cgc_cabecalho
from	tiss_regra_cod_prestador
where	cd_estabelecimento					= cd_estabelecimento_p
and	cd_convenio						= cd_convenio_p
and	coalesce(cd_prestador_convenio::text, '') = ''
and	coalesce(cd_procedencia, coalesce(cd_procedencia_p, 0))		= coalesce(cd_procedencia_p, 0)
and	coalesce(cd_setor_protocolo, coalesce(cd_setor_protocolo_p, 0))	= coalesce(cd_setor_protocolo_p, 0)
and	coalesce(ie_tipo_protocolo, coalesce(ie_tipo_protocolo_p, 0))	= coalesce(ie_tipo_protocolo_p, 0)
and	coalesce(cd_categoria, coalesce(cd_categoria_p,'X'))		= coalesce(cd_categoria_p,'X')
and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp() - interval '9999 days') and coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days')
order by coalesce(cd_setor_protocolo,0),
	coalesce(ie_tipo_protocolo,0),
	coalesce(cd_categoria,'X'),
	coalesce(cd_procedencia,0),
	dt_inicio_vigencia;


BEGIN

open c01;
loop
fetch c01 into
	cd_cgc_cabecalho_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

return cd_cgc_cabecalho_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_cgc_prest_protocolo (cd_estabelecimento_p bigint, cd_setor_protocolo_p bigint, ie_tipo_protocolo_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedencia_p bigint) FROM PUBLIC;

