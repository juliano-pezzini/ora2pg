-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_perda_contas_receber ( cd_estabelecimento_p bigint, nr_seq_cheque_p bigint, nr_titulo_p bigint, nr_seq_baixa_p bigint, vl_perda_p bigint, ie_tipo_perda_p text, nm_usuario_p text, nr_seq_motivo_perda_p bigint, dt_perda_p timestamp) AS $body$
DECLARE


nr_seq_perda_w		bigint;
cd_cgc_w		varchar(14);
cd_pessoa_fisica_w	varchar(10);
nr_seq_baixa_w		integer;
nr_seq_tipo_baixa_w	bigint;
nr_seq_grupo_prod_w	bigint;


BEGIN
if (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') then
	begin
	select	cd_cgc,
		cd_pessoa_fisica
	into STRICT	cd_cgc_w,
		cd_pessoa_fisica_w
	from	cheque_cr
	where	nr_seq_cheque = nr_seq_cheque_p;

	nr_seq_grupo_prod_w := OBTER_PROD_FINANC(nr_seq_cheque_p, 'CH', 'G');

	select	max(nr_sequencia)
	into STRICT	nr_seq_grupo_prod_w
	from	grupo_prod_financ
	where	nr_sequencia = nr_seq_grupo_prod_w;
	end;
elsif (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	begin
	select	cd_cgc,
		cd_pessoa_fisica
	into STRICT	cd_cgc_w,
		cd_pessoa_fisica_w
	from	titulo_receber
	where	nr_titulo = nr_titulo_p;

	nr_seq_grupo_prod_w := OBTER_PROD_FINANC(nr_titulo_p, 'TR', 'G');

	select	max(nr_sequencia)
	into STRICT	nr_seq_grupo_prod_w
	from	grupo_prod_financ
	where	nr_sequencia = nr_seq_grupo_prod_w;
	end;
end if;

select	nextval('perda_contas_receber_seq')
into STRICT	nr_seq_perda_w
;

insert into perda_contas_receber(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_estabelecimento,
	cd_pessoa_fisica,
	cd_cgc,
	nr_titulo,
	nr_seq_baixa,
	nr_seq_cheque,
	dt_perda,
	vl_perdas,
	vl_saldo,
	ie_tipo_perda,
	nr_seq_grupo_prod,
	nr_seq_motivo_perda)
values (	nr_seq_perda_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_estabelecimento_p,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_titulo_p,
	nr_seq_baixa_p,
	nr_seq_cheque_p,
	coalesce(dt_perda_p, clock_timestamp()),
	vl_perda_p,
	vl_perda_p,
	ie_tipo_perda_p,
	nr_seq_grupo_prod_w,
	nr_seq_motivo_perda_p );

if (ie_tipo_perda_p = 'I') then
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_baixa_w
	from	fin_tipo_baixa_perda
	where	ie_tipo_consistencia = '2'
	and	ie_situacao = 'A';

	if (coalesce(nr_seq_tipo_baixa_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(214619);
	end if;

	CALL fin_gerar_baixa_perda( nr_seq_perda_w, vl_perda_p, nr_seq_tipo_baixa_w, '1', null, coalesce(dt_perda_p, clock_timestamp()), nm_usuario_p);
	end;
end if;

CALL fin_atualiza_cobranca_perda(nr_seq_perda_w, 'BP', 'N', nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_perda_contas_receber ( cd_estabelecimento_p bigint, nr_seq_cheque_p bigint, nr_titulo_p bigint, nr_seq_baixa_p bigint, vl_perda_p bigint, ie_tipo_perda_p text, nm_usuario_p text, nr_seq_motivo_perda_p bigint, dt_perda_p timestamp) FROM PUBLIC;

