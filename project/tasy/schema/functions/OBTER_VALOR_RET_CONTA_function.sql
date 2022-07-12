-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_ret_conta ( nr_interno_conta_p bigint, ie_retorno_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	double precision	:= 0;
vl_pago_w	double precision	:= 0;
vl_glosado_w	double precision	:= 0;
vl_amenor_w	double precision	:= 0;
vl_adicional_w	double precision	:= 0;


BEGIN

select	sum(b.vl_pago),
	sum(b.vl_glosado),
	sum(b.vl_amenor),
	sum(b.vl_adicional)
into STRICT	vl_pago_w,
	vl_glosado_w,
	vl_amenor_w,
	vl_adicional_w
from	convenio_retorno_item b
where	b.nr_interno_conta	= nr_interno_conta_p;

if (ie_retorno_p	= 'P') then
	vl_retorno_w	:= vl_pago_w;
elsif (ie_retorno_p	= 'AM') then
	vl_retorno_w	:= vl_amenor_w;
elsif (ie_retorno_p	= 'AD') then
	vl_retorno_w	:= vl_adicional_w;
else
	vl_retorno_w	:= vl_glosado_w;
end if;

return	coalesce(vl_retorno_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_ret_conta ( nr_interno_conta_p bigint, ie_retorno_p text) FROM PUBLIC;
