-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_regra_pagto_prod (nr_seq_regra_p pls_periodo_pagamento.nr_sequencia%type, ie_opcao_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_regra_duplic_p INOUT pls_periodo_pagamento.nr_sequencia%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Duplicar as regras da função OPS - Pagamento de Produção Médica
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/BEGIN
if (nr_seq_regra_p IS NOT NULL AND nr_seq_regra_p::text <> '') then

	if (ie_opcao_p = 'PR') then

		select	nextval('pls_periodo_pagamento_seq')
		into STRICT	nr_seq_regra_duplic_p
		;

		-- copia o período
		insert into pls_periodo_pagamento(
			nr_sequencia, ie_situacao, cd_estabelecimento,
			ds_periodo, ie_tipo_pagamento, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			ie_complementar, ie_recurso_proprio, ie_retencao_trib,
			ie_tributo_mes, ie_tipo_periodo, nr_fluxo_pgto,
			cd_condicao_pagamento, dt_dia_mes_inicial_ref, dt_dia_mes_final_ref
		) SELECT
			nr_seq_regra_duplic_p, ie_situacao, cd_estabelecimento,
			substr('Cópia - '||ds_periodo,1,255), ie_tipo_pagamento, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			ie_complementar, ie_recurso_proprio, ie_retencao_trib,
			ie_tributo_mes, ie_tipo_periodo, nr_fluxo_pgto,
			cd_condicao_pagamento, dt_dia_mes_inicial_ref, dt_dia_mes_final_ref
		from	pls_periodo_pagamento
		where	nr_sequencia = nr_seq_regra_p;

		-- copia todas as regras que existem para o período
		insert into pls_evento_regra(
			nr_sequencia, nr_seq_evento, nr_seq_periodo,
			ie_situacao, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_prestador,
			ie_tipo_guia, vl_fixo, tx_valor,
			nr_seq_ordem, dt_inicio_vigencia, dt_fim_vigencia,
			qt_mes_deslocamento, nr_seq_tipo_prestador, nr_seq_classif_prestador,
			ie_conta_intercambio, nr_seq_contrato, nr_seq_plano,
			nr_seq_grupo_contrato, ie_incide_periodo, qt_mes_desloc_final,
			nr_seq_tipo_prest_prot, ie_apresentacao_prot, ie_origem_conta,
			cd_condicao_pagamento, ie_tipo_evento, ie_tipo_pessoa_prest
		) SELECT
			nextval('pls_evento_regra_seq'), nr_seq_evento, nr_seq_regra_duplic_p,
			ie_situacao, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, nr_seq_prestador,
			ie_tipo_guia, vl_fixo, tx_valor,
			nr_seq_ordem, dt_inicio_vigencia, dt_fim_vigencia,
			qt_mes_deslocamento, nr_seq_tipo_prestador, nr_seq_classif_prestador,
			ie_conta_intercambio, nr_seq_contrato, nr_seq_plano,
			nr_seq_grupo_contrato, ie_incide_periodo, qt_mes_desloc_final,
			nr_seq_tipo_prest_prot, ie_apresentacao_prot, ie_origem_conta,
			cd_condicao_pagamento, ie_tipo_evento, ie_tipo_pessoa_prest
		from	pls_evento_regra
		where	nr_seq_periodo = nr_seq_regra_p;

		-- copia todas as regra de exceção
		insert into pls_evento_regra_ex(
			nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
			nm_usuario, nm_usuario_nrec, nr_seq_periodo,
			nr_seq_prestador, nr_seq_prestador_atend
		) SELECT
			nextval('pls_evento_regra_ex_seq'), clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, nr_seq_regra_duplic_p,
			nr_seq_prestador, nr_seq_prestador_atend
		from	pls_evento_regra_ex
		where	nr_seq_periodo = nr_seq_regra_p;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_regra_pagto_prod (nr_seq_regra_p pls_periodo_pagamento.nr_sequencia%type, ie_opcao_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_regra_duplic_p INOUT pls_periodo_pagamento.nr_sequencia%type) FROM PUBLIC;
