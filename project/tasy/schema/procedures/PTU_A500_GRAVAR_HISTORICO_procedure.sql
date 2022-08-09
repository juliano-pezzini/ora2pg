-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_a500_gravar_historico ( ie_tipo_historico_p bigint, ds_historico_p text, nr_seq_lote_p bigint, nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into ptu_a500_historico(nr_sequencia, ie_tipo_historico, cd_estabelecimento,
	ds_historico, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_lote,
	nr_seq_fatura,dt_historico)
values (nextval('ptu_a500_historico_seq'), ie_tipo_historico_p, cd_estabelecimento_p,
	ds_historico_p, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, nr_seq_lote_p,
	nr_seq_fatura_p,clock_timestamp());

CALL ptu_atualizar_status_fat_envio(nr_seq_fatura_p, 3, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_a500_gravar_historico ( ie_tipo_historico_p bigint, ds_historico_p text, nr_seq_lote_p bigint, nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
