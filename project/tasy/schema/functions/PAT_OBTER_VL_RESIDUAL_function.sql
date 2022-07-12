-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_vl_residual (nr_seq_bem_p bigint, dt_mes_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_residual_w		pat_bem_regra_residual.vl_residual%type;


BEGIN
if (nr_seq_bem_p > 0) then
	begin
	select	vl_residual
	into STRICT	vl_residual_w
	from	pat_bem_regra_residual
	where	nr_seq_bem = nr_seq_bem_p
	and	trunc(dt_mes_referencia_p,'mm') between trunc(dt_inicio_vigencia,'mm') and fim_mes(coalesce(dt_fim_vigencia,dt_mes_referencia_p))  LIMIT 1;
	exception
	when others then
		vl_residual_w := 0;
	end;
end if;

return	vl_residual_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_vl_residual (nr_seq_bem_p bigint, dt_mes_referencia_p timestamp) FROM PUBLIC;

