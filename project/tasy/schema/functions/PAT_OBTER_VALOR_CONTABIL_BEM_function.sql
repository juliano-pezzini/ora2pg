-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_valor_contabil_bem ( nr_seq_bem_p bigint) RETURNS bigint AS $body$
DECLARE

dt_mes_ref_w		timestamp;
vl_contabil_w		double precision;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;


BEGIN

select 	a.cd_estabelecimento
into STRICT 	cd_estabelecimento_w
from 	pat_bem a
where 	a.nr_sequencia = nr_seq_bem_p;

select	max(dt_mes_ref)
into STRICT	dt_mes_ref_w
from	pat_mes_ref
where	(dt_calculo IS NOT NULL AND dt_calculo::text <> '')
and 	cd_estabelecimento = cd_estabelecimento_w
and	ie_situacao = 1;

select	coalesce(max(a.vl_contabil),0)
into STRICT	vl_contabil_w
from	pat_valor_bem a
where	a.nr_seq_bem = nr_seq_bem_p
and	trunc(a.dt_valor,'mm') = trunc(dt_mes_ref_w,'mm');

return vl_contabil_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_valor_contabil_bem ( nr_seq_bem_p bigint) FROM PUBLIC;

