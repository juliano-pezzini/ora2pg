-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_tit_rec_cobranca (nr_titulo_p bigint, cd_estabelecimento_p bigint, nr_seq_historico_p text, nm_usuario_p text) AS $body$
DECLARE


vl_saldo_titulo_w		double precision;
nr_seq_cobranca_w	bigint;


BEGIN

select	sum(vl_saldo_titulo)
into STRICT	vl_saldo_titulo_w
from	titulo_receber
where	nr_titulo	= nr_titulo_p;


select	nextval('cobranca_seq')
into STRICT	nr_seq_cobranca_w
;


insert into COBRANCA(cd_estabelecimento,
	dt_atualizacao,
	dt_atualizacao_nrec,
	dt_inclusao,
	dt_previsao_cobranca,
	ie_status,
	nm_usuario,
	nm_usuario_nrec,
	nr_sequencia,
	nr_titulo,
	vl_acobrar,
	vl_original)
values (cd_estabelecimento_p,
	clock_timestamp(),
	clock_timestamp(),
	clock_timestamp(),
	clock_timestamp(),
	'P',
	nm_usuario_p,
	nm_usuario_p,
	nr_seq_cobranca_w,
	nr_titulo_p,
	vl_saldo_titulo_w,
	vl_saldo_titulo_w);

if (somente_numero(nr_seq_historico_p) <> 0) then

	insert into COBRANCA_HISTORICO(DT_ATUALIZACAO,
		DT_ATUALIZACAO_NREC,
		DT_HISTORICO,
		NM_USUARIO,
		NM_USUARIO_NREC,
		NR_SEQ_COBRANCA,
		NR_SEQ_HISTORICO,
		NR_SEQUENCIA)
	values (clock_timestamp(),
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_cobranca_w,
		somente_numero(nr_seq_historico_p),
		nextval('cobranca_historico_seq'));

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_tit_rec_cobranca (nr_titulo_p bigint, cd_estabelecimento_p bigint, nr_seq_historico_p text, nm_usuario_p text) FROM PUBLIC;
