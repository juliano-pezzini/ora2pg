-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_oc_trans_estoque ( nr_ordem_compra_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(2);
qt_existe_aguardo_w			integer;
qt_existe_pendente_w			integer;
qt_existe_parcial_w			integer;
qt_existe_w                             integer;



BEGIN


select  count(*) --aguardando AG - É quando ainda não existe nota fiscal  ativa
into STRICT	qt_existe_aguardo_w
from 	ordem_compra_item b,
	ordem_compra a
where 	a.nr_ordem_compra = b.nr_ordem_compra
and   	a.cd_estab_transf = cd_estabelecimento_p
and   	a.nr_ordem_compra = nr_ordem_compra_p
and   	a.ie_tipo_ordem   = 'T'
and	a.nr_ordem_compra not in (
	SELECT	x.nr_ordem_compra
	from	nota_fiscal y,
		nota_fiscal_item x
	where	x.nr_sequencia 		= y.nr_sequencia
	and	y.cd_estabelecimento 	= cd_estabelecimento_p
	and	x.nr_ordem_compra	= a.nr_ordem_compra
	and	y.ie_situacao = 1);

select  count(*)  --pendente PE
into STRICT	qt_existe_pendente_w
from 	ordem_compra_item b,
 	ordem_compra a
where  	a.nr_ordem_compra = b.nr_ordem_compra
and   	a.ie_tipo_ordem   ='T'
and   	a.cd_estab_transf = cd_estabelecimento_p
and   	a.nr_ordem_compra = nr_ordem_compra_p
and	obter_status_item_transf(a.nr_ordem_compra, b.nr_item_oci) = wheb_mensagem_pck.get_texto(309385) -- status = Pendente
and   	obter_qt_oci_trans_nota(a.nr_ordem_compra, b.nr_item_oci,'S') >= 0
and 	obter_qt_oci_trans_nota(a.nr_ordem_compra, b.nr_item_oci,'S') <> b.qt_material;

select  count(*)  --Atendido Parcial PA
into STRICT	qt_existe_parcial_w
from 	ordem_compra_item b,
 	ordem_compra a
where  	a.nr_ordem_compra = b.nr_ordem_compra
and   	a.ie_tipo_ordem   ='T'
and   	a.cd_estab_transf = cd_estabelecimento_p
and   	a.nr_ordem_compra = nr_ordem_compra_p
and	obter_status_item_transf(a.nr_ordem_compra, b.nr_item_oci) <> wheb_mensagem_pck.get_texto(309385) -- status <> Pendente
and   	obter_qt_oci_trans_nota(a.nr_ordem_compra, b.nr_item_oci,'S') >= 0
and 	obter_qt_oci_trans_nota(a.nr_ordem_compra, b.nr_item_oci,'S') <> b.qt_material;

select 	count(*)
into STRICT   	qt_existe_w
from (SELECT *
	 from    solic_compra_item
where  	 nr_ordem_compra_orig = nr_ordem_compra_p) alias1;

if (qt_existe_w > 0) then
	ds_retorno_w := 'GE';

elsif (qt_existe_aguardo_w > 0) then
	ds_retorno_w := 'AG'; --Aguardando AG
elsif (qt_existe_pendente_w > 0) and (qt_existe_aguardo_w = 0) then
	ds_retorno_w := 'PE'; --pendente PE
elsif (qt_existe_parcial_w > 0) then
	ds_retorno_w := 'AP'; --Atendido Parcial AP
elsif (qt_existe_pendente_w = 0) and (qt_existe_aguardo_w = 0) then
	ds_retorno_w := 'AT'; --atendido AT
end if;

return ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_oc_trans_estoque ( nr_ordem_compra_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
