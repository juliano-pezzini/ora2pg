-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_iva (nr_sequencia_nf_p bigint, ie_opcao bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w             double precision := 0;
vl_total_sem_imp         double precision;


BEGIN

select 	coalesce(sum(((a.qt_item_nf * a.vl_unitario_item_nf) - a.vl_desconto)),0)
into STRICT 	vl_retorno_w
from    nota_fiscal_item a,
	nota_fiscal_item_trib b
where   a.nr_sequencia = nr_sequencia_nf_p
and     a.nr_sequencia = b.nr_sequencia
and 	a.nr_item_nf = b.nr_item_nf
and 	b.tx_tributo = 16;

select 	vl_total_nota - obter_vl_total_trib_nota(nr_sequencia, 'IVA')
into STRICT 	vl_total_sem_imp
from 	nota_fiscal
where 	nr_sequencia = nr_sequencia_nf_p;

if (ie_opcao = 0) then
    vl_retorno_w :=  vl_total_sem_imp - vl_retorno_w;
    return vl_retorno_w;
end if;

if (ie_opcao = 16) then
    return vl_retorno_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_iva (nr_sequencia_nf_p bigint, ie_opcao bigint) FROM PUBLIC;
