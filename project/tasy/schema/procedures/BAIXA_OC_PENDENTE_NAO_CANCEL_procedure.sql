-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_oc_pendente_nao_cancel () AS $body$
BEGIN
 
update	ordem_compra 
set	dt_baixa = clock_timestamp() 
where	nr_ordem_compra in ( 
	SELECT	distinct b.nr_ordem_compra 
	from 	ordem_compra b, 
		ordem_compra_item_entrega a 
	where 	a.nr_ordem_compra = b.nr_ordem_compra 
	and	((coalesce(qt_prevista_entrega,0) > coalesce(qt_real_entrega,0)) and coalesce(a.dt_baixa::text, '') = '') /*que não tenham sido entregues totalmente ou que tenha sido baixado com dif OCxNF*/
 
	and	a.dt_prevista_entrega < (clock_timestamp() - coalesce(obter_dados_parametro_compras(b.cd_estabelecimento,'17'),180)) /*que ja deveriam ter sido entregues a 180 dias atraz*/
 
	and	coalesce(a.dt_real_entrega::text, '') = '' /*que não tenham a data real de entrega*/
 
	and	coalesce(b.dt_baixa::text, '') = '' /*que ainda não foram baixadas*/
 
	and	coalesce(a.dt_cancelamento::text, '') = '');
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_oc_pendente_nao_cancel () FROM PUBLIC;

