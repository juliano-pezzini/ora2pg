-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_diops_pck.pls_gravar_consistencia ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, nr_seq_inconsistencia_p bigint) AS $body$
DECLARE


	ds_acao_usuario_w		diops_periodo_inconsist.ds_acao_usuario%type;
	ds_detalhe_w			varchar(4000);
	ds_detalhe_curto_w		varchar(255);

	
BEGIN
	PERFORM set_config('pls_consistir_diops_pck.nm_usuario_w', coalesce(Obter_Usuario_Ativo,'Tasy'), false);
	
	PERFORM set_config('pls_consistir_diops_pck.nr_seq_movimento_w', coalesce(current_setting('pls_consistir_diops_pck.nr_seq_movimento_w')::bigint,0) + 1, false);

	select	max(ds_acao_usuario)
	into STRICT	ds_acao_usuario_w
	from	diops_inconsistencia
	where	nr_sequencia = nr_seq_inconsistencia_p;

	if (nr_seq_inconsistencia_p = 47) then
		-- Saves the following inconsistency: 'O campo #@CAMPO#@ do quadro #@QUADRO#@ esta sem valor informado.'
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820638,'CAMPO=' || current_setting('pls_consistir_diops_pck.ds_campo_macro_w')::varchar(255) || ';' || 'QUADRO=' || current_setting('pls_consistir_diops_pck.ds_quadro_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 48) then
		-- Saves the following inconsistency: 'O campo #@CAMPO#@ do quadro #@QUADRO#@ possui caracteres especiais.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820662,'CAMPO=' || current_setting('pls_consistir_diops_pck.ds_campo_macro_w')::varchar(255) || ';' || 'QUADRO=' || current_setting('pls_consistir_diops_pck.ds_quadro_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 49) then
		-- Saves the following inconsistency: 'A conta contabil #@CONTA#@ nao esta parametrizada para integrar o DIOPS.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820663,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 50) then
		-- Saves the following inconsistency: 'O saldo inicial/final da conta #@CONTA#@ no balancete do DIOPS esta diferente do valor apresentado no balancete na funcao Contabilidade.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820664,'SALDO=' || current_setting('pls_consistir_diops_pck.ds_tipo_saldo_macro_w')::varchar(255) || ';' ||'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 51) then
		-- Saves the following inconsistency: 'O saldo inicial da conta #@CONTA#@ esta diferente do saldo final dessa conta no DIOPS anterior.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820665,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 52) then
		-- Saves the following inconsistency: 'O saldo da conta #@CONTA#@ nao confere com a soma do saldo de suas contas contabeis filhas.';	
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820666,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 53) then
		-- Saves the following inconsistency: 'O valor do saldo final da conta contabil #@CONTA#@ esta diferente da soma entre o valor do saldo inicial e o saldo final.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820668,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 55) then
		-- Saves the following inconsistency:  'O saldo final da conta contabil #@CONTA#@ nao pode ser positivo/negativo (de acordo com o tipo)';	
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820670,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 56) then
		-- Saves the following inconsistency:  'A conta contabil #@CONTA#@ nao possui abertura por ato cooperado no setimo digito da classificacao';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820672,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type ||';'|| 'POSSUI_ATO=' || current_setting('pls_consistir_diops_pck.ds_possui_ato_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 57) then
		-- Saves the following inconsistency:  'A diferenca entre o saldo final do Ativo e do Passivo nao coincide com a diferenca entre o saldo final da Receita e da Despesa.';	
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820673);
	elsif (nr_seq_inconsistencia_p = 58) then
		-- Saves the following inconsistency:  'A conta contabil #@CONTA#@ nao possui conta superior.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820674,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 59) then
		-- Saves the following inconsistency: 'A conta #@CONTASUPERIOR#@, indicada como conta superior da conta contabil #@CONTA#@, nao possui 9 digitos.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820675,'CONTASUPERIOR=' || current_setting('pls_consistir_diops_pck.cd_conta_superior_macro_w')::conta_contabil.cd_conta_contabil%type || ';' || 'CONTA=' || current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 60) then
		-- Saves the following inconsistency: 'A conta contabil #@CONTA#@ pertence ao grupo 7 e, portanto, nao pode possuir saldo.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820677,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 61) then
		-- Saves the following inconsistency: 'O valor informado nos campos #@CAMPO_ATE#@ e #@CAMPO_POS#@ esta diferente do saldo final da PEL no balancete do DIOPS.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820679,'CAMPO_ATE='||current_setting('pls_consistir_diops_pck.nm_campo_ate_macro_w')::varchar(255)||';'||'CAMPO_POS='||current_setting('pls_consistir_diops_pck.nm_campo_pos_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 62) then
		-- Saves the following inconsistency: 'A soma das atividades operacionais, financiamento e investimento esta divergente do valor de movimento das contas contabeis 1.2.1.1 e 1.2.1.3 no balancete do DIOPS.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820680);
	elsif (nr_seq_inconsistencia_p = 63) then
		-- Saves the following inconsistency: 'A conta medica #@CONTA_MEDICA#@ nao possui grupo ANS informado no item #@ITEM_PROC_MAT#@';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820639,'CONTA_MEDICA=' || current_setting('pls_consistir_diops_pck.nr_conta_medica_macro_w')::bigint || ';' || 'ITEM_PROC_MAT=' || current_setting('pls_consistir_diops_pck.nr_item_proc_mat_macro_w')::bigint);
	elsif (nr_seq_inconsistencia_p = 64) then
		-- Saves the following inconsistency: 'O item #@TIPO_ITEM#@ do quadro de cobertura assistencial esta com valor diferente do valor contabil.';	
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820667,'TIPO_ITEM=' || current_setting('pls_consistir_diops_pck.ds_tipo_item_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 65) then
		-- Saves the following inconsistency: 'O total dos ativos investimento esta diferente do saldo final das contas contabeis 1.2.2.1 e 1.3.1.1 no balancete do DIOPS.';	
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820669);
	elsif (nr_seq_inconsistencia_p = 66) then
		-- Saves the following inconsistency: 'Ha valores informados no ativo imobiliario, no entanto, o saldo final da conta contabil 1.3.3.1 no balancete do DIOPS esta zero.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820676);
	elsif (nr_seq_inconsistencia_p = 67) then
		-- Saves the following inconsistency: 'O valor total do intercambio eventual a receber mais o intercambio a faturar esta diferente do saldo final da conta #@CONTA#@ no balancete do DIOPS.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820678);
	elsif (nr_seq_inconsistencia_p = 68) then
		-- Saves the following inconsistency: 'O valor total do intercambio eventual a pagar esta diferente do saldo final da conta #@CONTA#@ no balancete do DIOPS.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820681);
	elsif (nr_seq_inconsistencia_p = 69) then
		-- Saves the following inconsistency: 'O valor informado no quadro #@QUADRO#@ para a operadora #@OPERADORA#@ esta diferente do saldo da conta contabil #@CONTA#@.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820682,'QUADRO=' || current_setting('pls_consistir_diops_pck.ds_quadro_macro_w')::varchar(255) || ';' || 'OPERADORA=' || current_setting('pls_consistir_diops_pck.ds_operadora_macro_w')::varchar(255) || ';' || 'CONTA=' || current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 70) then
		-- Saves the following inconsistency: 'A operadora #@OPERADORA#@ nao possui numero do registro ANS informada em seu cadastro.';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820683);
	elsif (nr_seq_inconsistencia_p = 71) then	
		-- Saves the following inconsistency: 'O valor apresentado no quadro Idade dos Saldos para a conta contabil #@CONTA#@ esta diferente do valor apresentado no quadro de Intercambio Eventual para a operadora #@OPERADORA#@.';	
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto(820684,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type||';'||'OPERADORA='||current_setting('pls_consistir_diops_pck.ds_operadora_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 72) then
		-- Saves the following inconsistency: 'O somatorio dos valores informados para #@CAMPO#@ nas contas do #@ATIVO_PASSIVO#@ esta diferente dos saldos das contas contabeis #@CONTAS#@.';	
		 ds_detalhe_w		:= substr(wheb_mensagem_pck.get_texto(820685,'CAMPO='||current_setting('pls_consistir_diops_pck.ds_campo_macro_w')::varchar(255)||';'||'ATIVO_PASSIVO='||current_setting('pls_consistir_diops_pck.ds_ativo_passivo_macro_w')::varchar(255)||';'||'CONTAS='||current_setting('pls_consistir_diops_pck.nr_contas_macro_w')::varchar(4000)),1,4000);
	elsif (nr_seq_inconsistencia_p = 73) then
		-- Saves the following inconsistency: 'O total dos novos avisados informados no periodo #@N#@ esta diferente do saldo das contas contabeis #@CONTAS#@.';
		 ds_detalhe_w		:= substr(wheb_mensagem_pck.get_texto(840758,'N='||current_setting('pls_consistir_diops_pck.ds_periodo_w')::varchar(60)||';'||'CONTAS='||current_setting('pls_consistir_diops_pck.nr_contas_macro_w')::varchar(4000)),1,4000);
	elsif (nr_seq_inconsistencia_p = 74) then
		-- Saves the following inconsistency: 'O total de glosas informadas no periodo #@N#@ esta diferente do saldo das contas contabeis #@CONTAS#@.';	
		 ds_detalhe_w		:= substr(wheb_mensagem_pck.get_texto( 841053  ,'N='||current_setting('pls_consistir_diops_pck.ds_periodo_w')::varchar(60)||';'||'CONTAS='||current_setting('pls_consistir_diops_pck.nr_contas_macro_w')::varchar(4000)), 1, 4000);
	elsif (nr_seq_inconsistencia_p = 75) then
		-- Saves the following inconsistency: 'O total de coparticipacoes informadas no periodo #@N#@ esta diferente do saldo das contas contabeis de coparticipacao e de outras recuperacoes';
		 ds_detalhe_w		:= wheb_mensagem_pck.get_texto( 820688 ,'N='||current_setting('pls_consistir_diops_pck.ds_periodo_w')::varchar(60));
	elsif (nr_seq_inconsistencia_p = 76) then	
		-- Saves the following inconsistency: 'O valor informado para #@ITEM#@ esta diferente do saldo das contas contabeis #@CONTA#@.';
		ds_detalhe_w		:= substr(wheb_mensagem_pck.get_texto(820689,'ITEM='||current_setting('pls_consistir_diops_pck.ds_item_w')::varchar(90)||';'||'CONTA='||current_setting('pls_consistir_diops_pck.nr_contas_macro_w')::varchar(4000)), 1, 4000);
	elsif (nr_seq_inconsistencia_p = 78) then
		-- Saves the following inconsistency: 'Os titulos a pagar #@DS_TITULOS#@ estao sem conta contabil na classificacao'
		ds_detalhe_w		:= wheb_mensagem_pck.get_texto( 840785 ,'DS_TITULOS='|| current_setting('pls_consistir_diops_pck.ds_titulos_w')::varchar(500));
	elsif (nr_seq_inconsistencia_p = 80) then
		-- Saves the following inconsistency: 'Os titulos a receber #@DS_TITULOS#@ estao sem conta contabil na classificacao'
		ds_detalhe_w		:= wheb_mensagem_pck.get_texto( 820687 ,'DS_TITULOS='|| current_setting('pls_consistir_diops_pck.ds_titulos_w')::varchar(500));
	elsif (nr_seq_inconsistencia_p = 87) then
		-- Saves the following inconsistency:O somatorio dos valores informados para os campos da Idade de saldos nas contas do #@ATIVO_PASSIVO#@, estao diferentes dos saldos das contas contabeis do DIOPS.
		ds_detalhe_w		:= wheb_mensagem_pck.get_texto(841239,'ATIVO_PASSIVO='||current_setting('pls_consistir_diops_pck.ds_ativo_passivo_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 89) then
		-- Saves the following inconsistency:A conta #@CONTA#@ esta com a superior igual a sua propria classificacao.
		ds_detalhe_w		:= wheb_mensagem_pck.get_texto(886218,'CONTA='||current_setting('pls_consistir_diops_pck.cd_conta_macro_w')::conta_contabil.cd_conta_contabil%type);
	elsif (nr_seq_inconsistencia_p = 104) then
		-- Saves the following inconsistency: O somatorio dos valores para o campo #@CAMPO#@ das Contraprestacoes Pecuniarias esta diferente da soma dos valores informados na Idade de saldos.
		ds_detalhe_w 		:= wheb_mensagem_pck.get_texto(932139, 'CAMPO='||current_setting('pls_consistir_diops_pck.ds_campo_macro_w')::varchar(255));
	elsif (nr_seq_inconsistencia_p = 105) then
		-- Saves the following inconsistency:O somatorio dos valores para o #@ITEM#@ da Corresponsabilidade Cedida esta diferente dos saldos das contas contabeis #@CONTA#@.
		ds_detalhe_w		:= substr(wheb_mensagem_pck.get_texto(932141, 'ITENS='||current_setting('pls_consistir_diops_pck.ds_item_w')::varchar(90)||';'||'CONTA='||current_setting('pls_consistir_diops_pck.nr_contas_macro_w')::varchar(4000)), 1, 4000);
	elsif (nr_seq_inconsistencia_p = 115) then
		-- Saves the following inconsistency: 'O total de PEONA informada no periodo #@N#@ esta diferente do saldo das contas contabeis #@CONTAS#@.';
		 ds_detalhe_w		:= substr(wheb_mensagem_pck.get_texto(1113521,'N='||current_setting('pls_consistir_diops_pck.ds_periodo_w')::varchar(60)||';'||'CONTAS='||current_setting('pls_consistir_diops_pck.nr_contas_macro_w')::varchar(4000)),1,4000);
	end if;

	if (length(ds_detalhe_w) > 251) then
		ds_detalhe_curto_w := substr(ds_detalhe_w, 1, 252) || '...';
	else
		ds_detalhe_curto_w := substr(ds_detalhe_w, 1, 255);
	end if;

	insert into diops_periodo_inconsist(	nr_seq_periodo,
						nr_sequencia,
						cd_estabelecimento,
						nr_seq_inconsistencia,
						dt_atualizacao,
						nm_usuario,
						ds_acao_usuario,
						ds_detalhe,
						ds_acao_detalhe,
						cd_pessoa_fisica,
						nr_seq_movimento,
						nr_quadro)
				values (	nr_seq_periodo_p,
						current_setting('pls_consistir_diops_pck.nr_seq_movimento_w')::bigint,
						cd_estabelecimento_p,
						nr_seq_inconsistencia_p,
						clock_timestamp(),
						current_setting('pls_consistir_diops_pck.nm_usuario_w')::varchar(15),
						ds_acao_usuario_w,
						ds_detalhe_curto_w,
						ds_detalhe_w,
						null,
						current_setting('pls_consistir_diops_pck.nr_seq_movimento_w')::bigint,
						current_setting('pls_consistir_diops_pck.nr_quadro_w')::bigint);

	commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_diops_pck.pls_gravar_consistencia ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, nr_seq_inconsistencia_p bigint) FROM PUBLIC;