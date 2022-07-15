-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_receb_tit_caixa (cd_estabelecimento_p bigint, nr_seq_saldo_caixa_p bigint, nr_titulo_p bigint, nm_usuario_p text, nr_seq_caixa_receb_p INOUT bigint, vl_especie_p bigint default 0) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
nr_sequencia_w			bigint;
nr_seq_trans_rec_w		bigint;
cd_tipo_recebimento_w		bigint;
vl_saldo_titulo_w		double precision;
nr_seq_rec_aberto_w		bigint;
/* Projeto Multimoeda - Variáveis */

qnt_moeda_titulo_w		bigint;
ie_moeda_estrang_w		varchar(1);
vl_especie_estrang_w		double precision;
vl_complemento_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_w			integer;
cd_moeda_empresa_w		integer;
dt_cotacao_w			timestamp;
ie_cotacao_caixa_w		varchar(1);
ie_caixa_estrang_w		varchar(1);
vl_adto_estrang_w		double precision;
qnt_receb_estrang_w		bigint;


BEGIN

nr_seq_caixa_receb_p := 0;

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_saldo_caixa_p IS NOT NULL AND nr_seq_saldo_caixa_p::text <> '') then

	select	cd_pessoa_fisica,
		cd_cgc,
		vl_saldo_titulo,
		cd_moeda
	into STRICT	cd_pessoa_fisica_w,
		cd_cgc_w,
		vl_saldo_titulo_w,
		cd_moeda_w
	from	titulo_receber
	where	nr_titulo = nr_titulo_p;

	/* Consistências */

	select	obter_moeda_padrao_empresa(cd_estabelecimento_p,'E')
	into STRICT	cd_moeda_empresa_w
	;

	select	max(nr_sequencia)
	into STRICT	nr_seq_rec_aberto_w
	from	caixa_receb a
	where	nr_seq_saldo_caixa	= nr_seq_saldo_caixa_p
	and	coalesce(a.dt_fechamento::text, '') = '';

	if (nr_seq_rec_aberto_w IS NOT NULL AND nr_seq_rec_aberto_w::text <> '') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(193612);
	end if;

	select	max(nr_seq_trans_tit_caixa)
	into STRICT	nr_seq_trans_rec_w
	from	parametro_contas_receber
	where	cd_estabelecimento	= cd_estabelecimento_p;

	if (coalesce(nr_seq_trans_rec_w::text, '') = '') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(443643);
	end if;

	select	max(cd_tipo_recebimento)
	into STRICT	cd_tipo_recebimento_w
	from	transacao_financeira
	where	nr_sequencia = nr_seq_trans_rec_w;

	/* Projeto Multimoeda - Busca a data do saldo para buscar a cotação */

	select	max(dt_saldo),
		max(obter_se_caixa_estrang(nr_seq_caixa))
	into STRICT	dt_cotacao_w,
		ie_caixa_estrang_w
	from	caixa_saldo_diario
	where	nr_sequencia = nr_seq_saldo_caixa_p;
	-- Verifica se os títulos selecionados estão em moeda não liberada para o caixa
	select	count(*)
	into STRICT	qnt_moeda_titulo_w
	from 	titulo_receber a
	where	a.nr_titulo = nr_titulo_p
	and	a.cd_moeda not in (SELECT	b.cd_moeda
				from	caixa_saldo_estrang b
				where	b.nr_seq_caixa_saldo = nr_seq_saldo_caixa_p
				
union

				SELECT	obter_moeda_padrao_empresa(a.cd_estabelecimento,'E')
				);

	if (coalesce(qnt_moeda_titulo_w,0) > 0) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(443670);
	end if;

	-- Verifica se tem cotação cadastrada para as moedas do caixa
	if (coalesce(ie_caixa_estrang_w,'N') = 'S') then
		select	max(verifica_cotacao_moeda_caixa(nr_seq_caixa,dt_saldo))
		into STRICT	ie_cotacao_caixa_w
		from	caixa_saldo_diario
		where	nr_sequencia = nr_seq_saldo_caixa_p;
		if (coalesce(ie_cotacao_caixa_w,'N') = 'N') then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(443457);
		end if;
	end if;

	/* Fim consistências */

	begin

		select	nextval('caixa_receb_seq')
		into STRICT	nr_sequencia_w
		;

		insert into caixa_receb(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_fisica,
			cd_cgc,
			nr_seq_saldo_caixa,
			nr_seq_trans_financ,
			cd_tipo_receb_caixa,
			dt_recebimento,
			vl_especie)
		values (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			cd_cgc_w,
			nr_seq_saldo_caixa_p,
			nr_seq_trans_rec_w,
			cd_tipo_recebimento_w,
			clock_timestamp(),
			vl_especie_p);
		nr_seq_caixa_receb_p := nr_sequencia_w;
	exception when others then
		nr_seq_caixa_receb_p := 0;
	end;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_receb_tit_caixa (cd_estabelecimento_p bigint, nr_seq_saldo_caixa_p bigint, nr_titulo_p bigint, nm_usuario_p text, nr_seq_caixa_receb_p INOUT bigint, vl_especie_p bigint default 0) FROM PUBLIC;

