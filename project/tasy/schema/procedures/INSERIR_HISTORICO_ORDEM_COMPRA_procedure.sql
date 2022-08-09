-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_historico_ordem_compra ( nr_ordem_compra_p bigint, ie_tipo_p text, ds_titulo_p text, ds_historico_p text, nm_usuario_p text) AS $body$
BEGIN

insert into ordem_compra_hist(
	nr_sequencia,
	nr_ordem_compra,
	dt_atualizacao,
	nm_usuario,
	dt_historico,
	ds_titulo,
	ds_historico,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_tipo,
	dt_liberacao)
values (	nextval('ordem_compra_hist_seq'),
	nr_ordem_compra_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	substr(ds_titulo_p,1,80),
	substr(ds_historico_p,1,4000),
	clock_timestamp(),
	nm_usuario_p,
	ie_tipo_p,
	clock_timestamp());

/*if (nvl(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if; retirado por Maicon dia 06/10/2009, porque da erro em algumas procedures, como no caso da OS 170928*/

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_historico_ordem_compra ( nr_ordem_compra_p bigint, ie_tipo_p text, ds_titulo_p text, ds_historico_p text, nm_usuario_p text) FROM PUBLIC;
