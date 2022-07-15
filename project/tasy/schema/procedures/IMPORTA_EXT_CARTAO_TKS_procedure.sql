-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importa_ext_cartao_tks ( nr_seq_extrato_p bigint, nm_usuario_p text, ds_arquivo_p text) AS $body$
DECLARE


/*Desenvolvido cfme layout enviado na OS 2119249 -
	CONCILIACAO  FINANCEIRA
	Arquivo de Conciliacao
		 TKS
*/
nr_seq_extrato_arq_w		extrato_cartao_cr_arq.nr_sequencia%type;
cd_estabelecimento_w		extrato_cartao_cr.cd_estabelecimento%type;
nr_seq_grupo_w				extrato_cartao_cr.nr_seq_grupo%type;
nr_seq_conta_banco_w		banco_estabelecimento.nr_sequencia%type;
nr_seq_extrato_res_w		extrato_cartao_cr_res.nr_sequencia%type;
nr_ultimo_nsu_w				varchar(12);
nr_seq_bandeira_w			bandeira_cartao_cr.nr_sequencia%type;

nr_nsu_host_movto_w			varchar(12);
dt_transacao_w				timestamp;
ie_credito_debito_w			varchar(1);
vl_bruto_w					double precision;
vl_despesa_w				double precision;
vl_liquido_w				double precision;
nr_cartao_w					varchar(19);
nr_parcela_w				smallint;
qtd_parcela_w				smallint;
nr_nsu_host_parcela_w		varchar(12);
vl_bruto_parcela_w			double precision;
vl_despesa_parcela_w		double precision;
vl_liquido_parcela_w		double precision;
cd_banco_w					varchar(3);
cd_agencia_w				varchar(6);
cd_conta_w					varchar(11);
nr_autorizacao_w			varchar(12);
cd_bandeira_w				varchar(3);
cd_produto_w				varchar(3);
dt_pagto_w					timestamp;


C01 CURSOR FOR
	SELECT	substr(ds_conteudo,18,12) nr_nsu_host_movto,
			to_date(substr(ds_conteudo,36,2)||substr(ds_conteudo,34,2)||substr(ds_conteudo,30,4),'dd/mm/yyyy') dt_transacao,
			substr(ds_conteudo,53,1) ie_credito_debito,
			substr(ds_conteudo,55,11)/100 vl_bruto,
			substr(ds_conteudo,66,11)/100 vl_despesa,
			substr(ds_conteudo,77,11)/100 vl_liquido,
			substr(ds_conteudo,88,19) nr_cartao,
			substr(ds_conteudo,107,2) nr_parcela,
			substr(ds_conteudo,109,2) qtd_parcelas,
			substr(ds_conteudo,111,12) nr_nsu_host_parcela,
			substr(ds_conteudo,123,11)/100 vl_bruto_parcela,
			substr(ds_conteudo,134,11)/100 vl_despesa_parcela,
			substr(ds_conteudo,145,11)/100 vl_liquido_parcela,
			substr(ds_conteudo,156,3) cd_banco,
			substr(ds_conteudo,159,6) cd_agencia,
			substr(ds_conteudo,165,11) cd_conta,
			substr(ds_conteudo,176,12) nr_autorizacao,
			substr(ds_conteudo,188,3) cd_bandeira,
			substr(ds_conteudo,191,3) cd_produto,
			to_date(substr(ds_conteudo,51,2)||substr(ds_conteudo,49,2)||substr(ds_conteudo,45,4),'dd/mm/yyyy') dt_pagto
	from	w_extrato_cartao_cr
	where	nr_seq_extrato = nr_seq_extrato_p
	and		substr(ds_conteudo,1,2) = 'CV'
	order by	nr_nsu_host_parcela,
				nr_parcela;


BEGIN

/*Criar  Registro do arquivo que esta sendo importado - Financeiro pois no extrato podem ter Debito e Credito*/

select 	nextval('extrato_cartao_cr_arq_seq')
into STRICT	nr_seq_extrato_arq_w
;

insert into EXTRATO_CARTAO_CR_ARQ(	nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									nr_seq_extrato,
									ie_tipo_arquivo,
									ds_arquivo)
						values (	nr_seq_extrato_arq_w,
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									nr_seq_extrato_p,
									'F',
									ds_arquivo_p);

if (nr_seq_extrato_p IS NOT NULL AND nr_seq_extrato_p::text <> '') then

	select	max(cd_estabelecimento),
			max(nr_seq_grupo)
	into STRICT	cd_estabelecimento_w,
			nr_seq_grupo_w
	from	extrato_cartao_cr
	where	nr_sequencia	= nr_seq_extrato_p;

	open C01;
	loop
	fetch C01 into
		nr_nsu_host_movto_w,
		dt_transacao_w,
		ie_credito_debito_w,
		vl_bruto_w,
		vl_despesa_w,
		vl_liquido_w,
		nr_cartao_w,
		nr_parcela_w,
		qtd_parcela_w,
		nr_nsu_host_parcela_w,
		vl_bruto_parcela_w,
		vl_despesa_parcela_w,
		vl_liquido_parcela_w,
		cd_banco_w,
		cd_agencia_w,
		cd_conta_w,
		nr_autorizacao_w,
		cd_bandeira_w,
		cd_produto_w,
		dt_pagto_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (coalesce(nr_nsu_host_movto_w,'') <> coalesce(nr_ultimo_nsu_w,'-9999')) then

			/*Buscar conta no Tasy de acordo com retorno no arquivo*/

			select	max(nr_sequencia)
			into STRICT	nr_seq_conta_banco_w
			from	banco_estabelecimento_v
			where	somente_numero(cd_banco)					= somente_numero(cd_banco_w)
			and		somente_numero(cd_agencia_bancaria)			= somente_numero(cd_agencia_w)
			and		somente_numero(cd_conta)					= somente_numero(cd_conta_w);

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_bandeira_w
			from	bandeira_cartao_cr a
			where	exists ( SELECT	1
							from	produto_bandeira_cartao_cr x
							where	x.nr_seq_bandeira	= a.nr_sequencia
							and		x.cd_produto		= cd_produto_w)
			and	a.cd_bandeira	= cd_bandeira_w
			and	(a.cd_bandeira IS NOT NULL AND a.cd_bandeira::text <> '');

			if (coalesce(nr_seq_bandeira_w::text, '') = '') then

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_bandeira_w
				from	bandeira_cartao_cr a
				where	a.cd_bandeira	= cd_bandeira_w
				and		(a.cd_bandeira IS NOT NULL AND a.cd_bandeira::text <> '');

			end if;

			select	nextval('extrato_cartao_cr_res_seq')
			into STRICT	nr_seq_extrato_res_w
			;

			insert into extrato_cartao_cr_res( nr_sequencia,
												dt_atualizacao_nrec,
												nm_usuario_nrec,
												dt_atualizacao,
												nm_usuario,
												nr_seq_extrato,
												nr_resumo,
												nr_seq_conta_banco,
												qt_cv_aceito,
												qt_cv_rejeitado,
												vl_bruto,
												vl_comissao,
												vl_rejeitado,
												vl_liquido,
												dt_prev_pagto,
												nr_seq_extrato_arq,
												nr_seq_bandeira)
									values ( nr_seq_extrato_res_w,
												clock_timestamp(),
												nm_usuario_p,
												clock_timestamp(),
												nm_usuario_p,
												nr_seq_extrato_p,
												nr_nsu_host_movto_w,
												nr_seq_conta_banco_w,
												1,--t_cv_aceito_w, Botei fixo um CV pq nao vem no layout essa informacao, esse layout eh bem diferente dos outros que ja atuamos, pois n tem reumos dos movimentos.
												0,--qt_cv_rejeitado_w,
												CASE WHEN nr_nsu_host_parcela_w='000000000000' THEN vl_bruto_w  ELSE vl_bruto_parcela_w END ,--vl_bruto_w,
												0,--vl_comissao_w,
												0,--vl_rejeitado_w,
												CASE WHEN nr_nsu_host_parcela_w='000000000000' THEN vl_liquido_w  ELSE vl_liquido_parcela_w END , --vl_liquido
												dt_transacao_w,
												nr_seq_extrato_arq_w,
												nr_seq_bandeira_w);

			nr_ultimo_nsu_w := 	nr_nsu_host_movto_w;

		else

			update 	extrato_cartao_cr_res
			set		vl_bruto 			= coalesce(vl_bruto,0) + coalesce(vl_bruto_parcela_w,0),
					qt_cv_aceito		= coalesce(qt_cv_aceito,0) + 1,
					vl_liquido			= vl_liquido + coalesce(vl_liquido_parcela_w,0)
			where	nr_sequencia		= nr_seq_extrato_res_w
			and		nr_seq_extrato_arq	= nr_seq_extrato_arq_w;

		end if;

		insert into extrato_cartao_cr_movto(	 nr_sequencia,
												 dt_atualizacao,
												 nm_usuario,
												 dt_atualizacao_nrec,
												 nm_usuario_nrec,
												 nr_seq_extrato,
												 nr_seq_extrato_res,
												 vl_parcela,
												 dt_parcela,
												 qt_parcelas,
												 nr_cartao,
												 nr_autorizacao,
												 ds_comprovante,
												 ds_rejeicao,
												 dt_compra,
												 nr_parcela,
												 nr_seq_extrato_parcela,
												 ie_pagto_indevido,
												 vl_liquido,
												 nr_seq_extrato_arq,
												 nr_resumo,
												 nr_seq_extrato_parc_cred,
												 vl_saldo_concil_fin,
												 vl_saldo_concil_cred,
												 vl_aconciliar,
												 nr_seq_origem,
												 nr_seq_parcela,
												 nr_documento,
												 vl_ajuste,
												 vl_ajuste_desp)
										values (nextval('extrato_cartao_cr_movto_seq'),
												 clock_timestamp(),
												 nm_usuario_p,
												 clock_timestamp(),
												 nm_usuario_p,
												 nr_seq_extrato_p,
												 nr_seq_extrato_res_w, --nr_seq_resumo, -----
												 CASE WHEN nr_nsu_host_parcela_w='000000000000' THEN vl_bruto_w  ELSE vl_bruto_parcela_w END ,
												 dt_transacao_w,
												 qtd_parcela_w,
												 nr_cartao_w,
												 nr_autorizacao_w,
												 null,
												 null, -- ds_rejeicao
												 dt_pagto_w, --dt_compra
												 (substr(nr_parcela_w,1,2))::numeric ,
												 null, --nr_seq_extrato_parcela,
												 'N', --ie_pagto_indevido
												 CASE WHEN nr_nsu_host_parcela_w='000000000000' THEN vl_liquido_w  ELSE vl_liquido_parcela_w END , --vl_liquido
												 nr_seq_extrato_arq_w,
												 nr_nsu_host_movto_w,
												 null, --nr_seq_extrato_parc_cred
												 CASE WHEN nr_nsu_host_parcela_w='000000000000' THEN vl_liquido_w  ELSE vl_liquido_parcela_w END ,
												 null, --vl_saldo_concil_cred
												 null, --vl_aconciliar
												 null, --nr_seq_origem
												 null, --nr_seq_parcela,
												 null, --nr_documento
												 null, --vl_ajuste
												 null); --vl_ajuste_desp
		end;
	end loop;
	close C01;

end if;

update	extrato_cartao_cr
set	 	dt_importacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_extrato_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importa_ext_cartao_tks ( nr_seq_extrato_p bigint, nm_usuario_p text, ds_arquivo_p text) FROM PUBLIC;

