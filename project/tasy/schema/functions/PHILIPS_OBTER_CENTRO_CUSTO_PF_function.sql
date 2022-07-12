-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION philips_obter_centro_custo_pf (cd_pessoa_p text, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


cd_centro_custo_w	bigint;


BEGIN

select	max(cd_centro_custo)
into STRICT	cd_centro_custo_w
from	PF_CENTRO_CUSTO_HIST
where	cd_pessoa_fisica	= cd_pessoa_p
and	dt_referencia_p between coalesce(dt_entrada,dt_referencia_p) and coalesce(dt_saida,dt_referencia_p);

return cd_centro_custo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION philips_obter_centro_custo_pf (cd_pessoa_p text, dt_referencia_p timestamp) FROM PUBLIC;
