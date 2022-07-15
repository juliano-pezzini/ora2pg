-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_movto_banco ( nr_seq_conta_p bigint, dt_referencia_p timestamp) AS $body$
DECLARE


nr_seq_banco_saldo_w			bigint;
ie_dia_fechado_w			varchar(1);
ie_abrir_saldo_w			varchar(1);
cd_estabelecimento_w			bigint;
ie_abrir_saldo_autom_w			varchar(1);
cout_w					bigint;


BEGIN

ie_abrir_saldo_w := Obter_Param_Usuario(814, 50, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_abrir_saldo_w);

if (coalesce(nr_seq_conta_p,0) > 0) then

	select	max(nr_sequencia)
	into STRICT	nr_seq_banco_saldo_w
	from	banco_saldo
	where	nr_seq_conta			= nr_seq_conta_p
	and	pkg_date_utils.start_of(dt_referencia, 'MONTH', 0) = pkg_date_utils.start_of(dt_referencia_p, 'MONTH', 0)
	and	(dt_fechamento IS NOT NULL AND dt_fechamento::text <> '');

	if (nr_seq_banco_saldo_w IS NOT NULL AND nr_seq_banco_saldo_w::text <> '') then
		/* O mês de referência da transação a ser lançada já tem saldo bancário fechado!
		Conta: nr_seq_conta_p
		Mês: to_char(dt_referencia_p,'dd/mm/yyyy')
		Seq saldo: nr_seq_banco_saldo_w */
		CALL wheb_mensagem_pck.exibir_mensagem_abort(262443,	'NR_SEQ_CONTA_P='||nr_seq_conta_p || ';' ||
								'DT_REFERENCIA_P=' || PKG_DATE_FORMATERS.TO_VARCHAR(dt_referencia_p, 'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO) || ';' ||
								'NR_SEQ_BANCO_SALDO_W=' || nr_seq_banco_saldo_w);
	end if;

	select	substr(obter_se_banco_fechado(nr_seq_conta_p,dt_referencia_p),1,1)
	into STRICT	ie_dia_fechado_w
	;

	if (coalesce(ie_dia_fechado_w,'N')	= 'S') then
		/* O dia dt_referencia_p já foi fechado no banco!
		Consulte o fechamento na pasta Fechamento banco do Controle Bancário.
		Parâmetro [72] */
		CALL wheb_mensagem_pck.exibir_mensagem_abort(231442,'DT_TRANSACAO='||dt_referencia_p);
	end if;

	cd_estabelecimento_w := obter_estabelecimento_ativo;

	if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then

		select	coalesce(max(a.ie_abrir_saldo),'S')
		into STRICT	ie_abrir_saldo_autom_w
		from	parametro_controle_banc a
		where	a.cd_estabelecimento = obter_estabelecimento_ativo;

	end if;

	select	max(nr_sequencia) -- Verifica se encontra saldo para o mes em questão para o banco da baixa
	into STRICT	nr_seq_banco_saldo_w
	from	banco_saldo
	where	nr_seq_conta			= nr_seq_conta_p
	and	pkg_date_utils.start_of(dt_referencia, 'MONTH', 0) = pkg_date_utils.start_of(dt_referencia_p, 'MONTH', 0);

	if (coalesce(nr_seq_banco_saldo_w::text, '') = '') and (coalesce(ie_abrir_saldo_autom_w,'S') = 'S') then -- Se não encontrar saldo aberto e o parametro estiver marcado para abrir novo saldo
		select	count(*) -- Verifica se existem saldos em aberto para a conta em questao
		into STRICT	cout_w
		from	banco_saldo
		where	coalesce(dt_fechamento::text, '') = ''
		and	nr_seq_conta = nr_seq_conta_p;

		if (cout_w > 0) and (coalesce(ie_abrir_saldo_w,'N') = 'N') then
			--R.aise_application_error(-20011,'Não existe saldo para o banco com mês de referência '|| dt_referencia_p || '. Verifique o campo "Abrir saldo bancário automaticamente", dos Parâmetros do Controle Bancário (SHIFT + F11 / Aplicação principal / Cadastros Gerais). É necessário também verificar o parâmetro [50] da função Controle Bancário.');
			CALL wheb_mensagem_pck.exibir_mensagem_abort(276496,'DT_REFERENCIA_P='||dt_referencia_p);
		end if;

	end if;

	/*Se nao tiver saldo aberto no mês da baixa e nao estiver parametrizado para abrir saldo automaticamente */

	if (coalesce(nr_seq_banco_saldo_w::text, '') = '') and (coalesce(ie_abrir_saldo_autom_w,'S') = 'N') then
		--R.aise_application_error(-20011,'Não existe saldo para o banco com mês de referência '|| dt_referencia_p || '. Verifique o campo "Abrir saldo bancário automaticamente", dos Parâmetros do Controle Bancário (SHIFT + F11 / Aplicação principal / Cadastros Gerais). É necessário também verificar o parâmetro [50] da função Controle Bancário.');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(276496,'DT_REFERENCIA_P='||dt_referencia_p);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_movto_banco ( nr_seq_conta_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

