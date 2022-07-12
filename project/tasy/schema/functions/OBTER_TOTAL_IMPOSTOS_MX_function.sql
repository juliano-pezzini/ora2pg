-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_impostos_mx (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


vl_tributo_w  varchar(15);


BEGIN

if (ie_opcao_p = 'T') then

select	subst_virgula_ponto_adic_zero(campo_mascara_casas(coalesce(sum(vl_tributo),0),2))
into STRICT    vl_tributo_w
from	nota_fiscal_item_trib
where	nr_sequencia = nr_sequencia_p
and     upper(obter_tipo_tributo(cd_tributo)) <> 'IVAR'
and     upper(obter_tipo_tributo(cd_tributo)) <> 'ISRR';

end if;


if (ie_opcao_p = 'R') then

select  subst_virgula_ponto_adic_zero(campo_mascara_casas(coalesce(sum(vl_tributo),0),2))
into STRICT    vl_tributo_w
from	nota_fiscal_item_trib
where	nr_sequencia = nr_sequencia_p
and     ((upper(obter_tipo_tributo(cd_tributo)) = 'IVAR')
or (upper(obter_tipo_tributo(cd_tributo)) = 'ISRR'));

end if;

return	vl_tributo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_impostos_mx (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
