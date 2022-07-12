-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_valor_fixo_criterio ( cd_sequencia_criterio_p bigint) RETURNS bigint AS $body$
DECLARE


vl_fixo_w					double precision;


BEGIN

if (cd_sequencia_criterio_p IS NOT NULL AND cd_sequencia_criterio_p::text <> '') then
	select	vl_fixo
	into STRICT	vl_fixo_w
	from	criterio_distr_orc
	where	cd_sequencia_criterio = cd_sequencia_criterio_p;

end if;

return vl_fixo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_valor_fixo_criterio ( cd_sequencia_criterio_p bigint) FROM PUBLIC;
