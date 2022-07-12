-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atualiza_juros_receb (cd_convenio_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_vl_conv_rec_adic_w	varchar(10);

c01 CURSOR FOR
SELECT	ie_vl_conv_rec_adic
from	convenio_regra_juros_receb
where	cd_convenio	= cd_convenio_p
and	dt_referencia_p between coalesce(dt_inicio_vigencia,dt_referencia_p - 1) and coalesce(dt_fim_vigencia,dt_referencia_p + 1)
order by coalesce(dt_inicio_vigencia,to_date('01/01/1900','dd/mm/yyyy'));


BEGIN

ie_vl_conv_rec_adic_w	:= null; -- tem que retornar null se não tem regra
open C01;
loop
fetch C01 into
	ie_vl_conv_rec_adic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ie_vl_conv_rec_adic_w	:= ie_vl_conv_rec_adic_w;
end loop;
close C01;

return	ie_vl_conv_rec_adic_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atualiza_juros_receb (cd_convenio_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

