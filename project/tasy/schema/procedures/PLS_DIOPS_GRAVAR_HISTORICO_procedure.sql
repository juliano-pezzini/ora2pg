-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_diops_gravar_historico ( nr_seq_periodo_p integer, ie_tipo_historico_p integer, ds_observacao_p text, ds_parametro_p text, nm_usuario_p text) AS $body$
BEGIN

insert into diops_historico(nr_sequencia, nr_seq_periodo, ie_tipo_historico,
	dt_historico, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, ds_observacao)
values (nextval('diops_historico_seq'), nr_seq_periodo_p, ie_tipo_historico_p,
	clock_timestamp(), clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, ds_observacao_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_diops_gravar_historico ( nr_seq_periodo_p integer, ie_tipo_historico_p integer, ds_observacao_p text, ds_parametro_p text, nm_usuario_p text) FROM PUBLIC;

