-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_data_contratual (nr_seq_segurado_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_contrato_w		timestamp;
qt_intervalo_w		bigint;
dt_contrato_atual_w	timestamp;
dt_contrato_atual_ww	timestamp;
dt_retorno_w		timestamp;


BEGIN

begin
	select	b.dt_contrato,
		b.qt_intervalo
	into STRICT	dt_contrato_w,
		qt_intervalo_w
	from	pls_contrato	b,
		pls_segurado	a
	where	a.nr_sequencia		= nr_seq_segurado_p
	and	a.nr_seq_contrato	= b.nr_sequencia;
exception
when others then
	dt_contrato_w := clock_timestamp();
	qt_intervalo_w := null;
end;

if (coalesce(qt_intervalo_w,0)	> 0) then
	dt_contrato_atual_ww := dt_contrato_w;
	while(dt_contrato_atual_ww	< clock_timestamp()) loop
		dt_contrato_atual_ww := add_months(dt_contrato_w,qt_intervalo_w);
		if (dt_contrato_atual_ww	< clock_timestamp()) then
			dt_contrato_w  := dt_contrato_atual_ww;
		end if;
	end loop;
end if;

dt_retorno_w := dt_contrato_w;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_data_contratual (nr_seq_segurado_p bigint) FROM PUBLIC;
