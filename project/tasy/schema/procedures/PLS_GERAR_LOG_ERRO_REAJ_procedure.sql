-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_log_erro_reaj ( nr_seq_rejauste_p bigint, nr_seq_segurado_p bigint, ds_erro_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_reaj_log_w	bigint;


BEGIN

select	nextval('pls_lote_reajuste_log_seq')
into STRICT	nr_seq_reaj_log_w
;

insert into	pls_lote_reajuste_log(	nr_sequencia, nr_seq_lote_reaj, cd_estabelecimento,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, nr_seq_segurado, ds_erro)
	values (	nr_seq_reaj_log_w, nr_seq_rejauste_p, cd_estabelecimento_p,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, nr_seq_segurado_p, ds_erro_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_log_erro_reaj ( nr_seq_rejauste_p bigint, nr_seq_segurado_p bigint, ds_erro_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

