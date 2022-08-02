-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_dt_limite_util_contr ( nr_seq_contrato_p bigint, dt_data_alteracao_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_limite_util_ant_w		timestamp;


BEGIN
select	dt_limite_utilizacao
into STRICT	dt_limite_util_ant_w
from	pls_contrato
where	nr_sequencia		= nr_seq_contrato_p;

update	pls_contrato
set	dt_limite_utilizacao	= dt_data_alteracao_p,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_contrato_p;

insert	into	pls_contrato_historico(	nr_sequencia, cd_estabelecimento, nr_seq_contrato, dt_historico, ie_tipo_historico,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_historico)
values ( 	nextval('pls_contrato_historico_seq'), cd_estabelecimento_p, nr_seq_contrato_p, clock_timestamp(), '15',
		clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'De: ' || dt_limite_util_ant_w || '. Para: ' || dt_data_alteracao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_dt_limite_util_contr ( nr_seq_contrato_p bigint, dt_data_alteracao_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

