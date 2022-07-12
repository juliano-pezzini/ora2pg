-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_obter_vl_compra_conv ( cd_pessoa_fisica_p text, nr_seq_convenio_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;


BEGIN

select	sum(vl_total)
into STRICT	vl_retorno_w
from	far_pedido
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	nr_seq_contrato_conv = nr_seq_convenio_p
and	trunc(dt_fechamento,'mm') = trunc(dt_referencia_p,'mm')
and	(dt_fechamento IS NOT NULL AND dt_fechamento::text <> '')
and	coalesce(dt_cancelamento::text, '') = '';

return	coalesce(vl_retorno_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_obter_vl_compra_conv ( cd_pessoa_fisica_p text, nr_seq_convenio_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

