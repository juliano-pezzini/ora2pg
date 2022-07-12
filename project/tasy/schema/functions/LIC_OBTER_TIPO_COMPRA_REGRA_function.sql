-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_tipo_compra_regra ( cd_conta_contabil_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_tipo_compra_w			bigint;


BEGIN

select	coalesce(max(a.nr_seq_tipo_compra),0)
into STRICT	nr_seq_tipo_compra_w
from	reg_lic_conta_valor a
where (trunc(a.dt_inicio_vigencia,'dd') <= trunc(clock_timestamp(),'dd') and trunc(a.dt_fim_vigencia,'dd') >= trunc(clock_timestamp(),'dd'))
and	a.ie_situacao = 'A'
and	a.cd_conta_contabil	= cd_conta_contabil_p
and	a.cd_estabelecimento	= cd_estabelecimento_p;

return	nr_seq_tipo_compra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_tipo_compra_regra ( cd_conta_contabil_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

