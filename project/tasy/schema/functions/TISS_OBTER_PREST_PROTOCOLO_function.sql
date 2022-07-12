-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_prest_protocolo (cd_estabelecimento_p bigint, cd_setor_protocolo_p bigint, ie_tipo_protocolo_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w		bigint;
cd_setor_protocolo_w		bigint;
ie_tipo_protocolo_w		bigint;
cd_prestador_protocolo_w	varchar(255);

c01 CURSOR FOR
SELECT	cd_prestador_convenio
from	tiss_regra_cod_prestador
where	cd_estabelecimento					= cd_estabelecimento_p
and	cd_convenio						= cd_convenio_p
and	coalesce(cd_setor_protocolo, coalesce(cd_setor_protocolo_p, 0))	= coalesce(cd_setor_protocolo_p, 0)
and	coalesce(ie_tipo_protocolo, coalesce(ie_tipo_protocolo_p, 0))	= coalesce(ie_tipo_protocolo_p, 0)
and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp() - interval '9999 days') and coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days');


BEGIN

open c01;
loop
fetch c01 into
	cd_prestador_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

return cd_prestador_protocolo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_prest_protocolo (cd_estabelecimento_p bigint, cd_setor_protocolo_p bigint, ie_tipo_protocolo_p bigint, cd_convenio_p bigint) FROM PUBLIC;

