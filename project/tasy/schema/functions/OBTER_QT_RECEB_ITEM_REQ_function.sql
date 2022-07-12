-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_receb_item_req (nr_requisicao_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_movimento_w			double precision;
cd_operacao_estoque_w  		smallint;
cd_operacao_estoque_ww 		smallint; -- É a operação de estoque correspondente
ie_entrada_saida_w 		varchar(1);


BEGIN

-- Pega a operação de estoque da requisição
select	a.cd_operacao_estoque
into STRICT	cd_operacao_estoque_w
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao = b.nr_requisicao
and	b.nr_requisicao = nr_requisicao_p
and	b.nr_sequencia  = nr_sequencia_p;

select	CASE WHEN ie_entrada_saida='S' THEN  cd_operacao_correspondente  ELSE cd_operacao_estoque END ,
	ie_entrada_saida
into STRICT	cd_operacao_estoque_ww,
	ie_entrada_saida_w
from	operacao_estoque
where	cd_operacao_estoque  = cd_operacao_estoque_w;

select	coalesce(sum(CASE WHEN cd_acao='1' THEN  qt_movimento WHEN cd_acao='2' THEN (qt_movimento * -1)  ELSE 0 END ),0)
into STRICT	qt_movimento_w
from	movimento_estoque
where	nr_documento = nr_requisicao_p
and	nr_sequencia_item_docto = nr_sequencia_p
and 	ie_origem_documento = 2
and	(dt_processo IS NOT NULL AND dt_processo::text <> '')
and	cd_operacao_estoque = cd_operacao_estoque_ww;

return	qt_movimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_receb_item_req (nr_requisicao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

