-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_pendencia_req (cd_local_estoque_p bigint, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		double precision := 0;
qt_pend_req_consumo_w	double precision;

qt_pend_req_transf_saida_w	double precision;
qt_pend_req_transf_entrada_w	double precision;



BEGIN

select	coalesce(sum(c.qt_estoque),0)
into STRICT	qt_pend_req_consumo_w
from	material a ,
	operacao_estoque o ,
	requisicao_material b,
	item_requisicao_material c,
	sup_motivo_baixa_req e
where	b.nr_requisicao		= c.nr_requisicao
and	a.cd_material		= c.cd_material
and	b.cd_operacao_estoque	= o.cd_operacao_estoque
and	c.cd_motivo_baixa	= e.nr_sequencia
and	e.cd_motivo_baixa	= 0
and	o.ie_tipo_requisicao	= '1'
and	a.cd_material		= cd_material_p
and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

if (cd_local_estoque_p > 0) then

	select	coalesce(sum(c.qt_estoque),0)
	into STRICT	qt_pend_req_transf_saida_w
	from	material a ,
		operacao_estoque o ,
		requisicao_material b,
		item_requisicao_material c,
		sup_motivo_baixa_req e
	where	b.nr_requisicao		= c.nr_requisicao
	and	a.cd_material		= c.cd_material
	and	b.cd_operacao_estoque	= o.cd_operacao_estoque
	and	c.cd_motivo_baixa	= e.nr_sequencia
	and	e.cd_motivo_baixa	= 0
	and	o.ie_tipo_requisicao	= '2'
	and	a.cd_material		= cd_material_p
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	b.cd_local_estoque	= cd_local_estoque_p
	and	o.ie_entrada_saida	= 'S';

	if (qt_pend_req_transf_saida_w > 0) then
		qt_pend_req_consumo_w := qt_pend_req_consumo_w + qt_pend_req_transf_saida_w;
	end if;


	select	coalesce(sum(c.qt_estoque),0)
	into STRICT	qt_pend_req_transf_entrada_w
	from	material a ,
		operacao_estoque o ,
		requisicao_material b,
		item_requisicao_material c,
		sup_motivo_baixa_req e
	where	b.nr_requisicao		= c.nr_requisicao
	and	a.cd_material		= c.cd_material
	and	b.cd_operacao_estoque	= o.cd_operacao_estoque
	and	c.cd_motivo_baixa	= e.nr_sequencia
	and	e.cd_motivo_baixa	= 0
	and	o.ie_tipo_requisicao	= '2'
	and	a.cd_material		= cd_material_p
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and	b.cd_local_estoque	= cd_local_estoque_p
	and	o.ie_entrada_saida	= 'E';

	if (qt_pend_req_transf_entrada_w > 0) then
		qt_pend_req_consumo_w := qt_pend_req_consumo_w - qt_pend_req_transf_entrada_w;
	end if;

end if;

qt_retorno_w := qt_pend_req_consumo_w;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_pendencia_req (cd_local_estoque_p bigint, cd_material_p bigint) FROM PUBLIC;

