-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_glosa_guia (nr_seq_ret_item_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	double precision;
vl_glosa_w	double precision;


BEGIN

select	sum(a.vl_glosa)
into STRICT	vl_glosa_w
from	motivo_glosa b,
	convenio_retorno_glosa a
where	a.nr_seq_ret_item	= nr_seq_ret_item_p
and	a.cd_motivo_glosa	= b.cd_motivo_glosa
and	((coalesce(a.ie_acao_glosa,b.ie_acao_glosa)	= 'R') or (coalesce(coalesce(a.ie_acao_glosa,b.ie_acao_glosa)::text, '') = ''));

if (ie_opcao_p	= 'G') then
	vl_retorno_w	:= vl_glosa_w;
end if;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_glosa_guia (nr_seq_ret_item_p bigint, ie_opcao_p text) FROM PUBLIC;
