-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_glosa ( nr_seq_ret_item_p bigint, ie_acao_glosa_p text) RETURNS bigint AS $body$
DECLARE


/* OPÇÔES
	'A' = Glosa Aceita
	'R' = Reapresentação
*/
vl_glosa_w	double precision	:= 0;


BEGIN

select	coalesce(sum(a.vl_glosa),0)
into STRICT	vl_glosa_w
from	motivo_glosa b,
	convenio_retorno_glosa a
where	a.cd_motivo_glosa	= b.cd_motivo_glosa
and	a.nr_seq_ret_item	= nr_seq_ret_item_p
and	coalesce(a.ie_acao_glosa,b.ie_acao_glosa) = ie_acao_glosa_p;

return vl_glosa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_glosa ( nr_seq_ret_item_p bigint, ie_acao_glosa_p text) FROM PUBLIC;
