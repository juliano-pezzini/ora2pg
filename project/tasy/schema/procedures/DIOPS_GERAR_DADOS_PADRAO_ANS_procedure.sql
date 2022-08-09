-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diops_gerar_dados_padrao_ans ( nr_seq_periodo_p bigint, ie_tipo_tabela_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* IE_TIPO_TABELA_P
	1 - Fluxo de caixa (DIOPS_FIN_FLUXO_CAIXA)
	2 - Idade saldo (DIOPS_FIN_IDADESALDO_PAS e DIOPS_FIN_IDADESALDO_ATI)
*/
ds_conta_w			varchar(255);
ds_desc_conta_w			varchar(255);
ie_tipo_atividade_w		varchar(1);
ie_tipo_vencimento_w		varchar(5);
cd_solvencia_w			varchar(20);
ds_solvencia_w			varchar(255);
ie_tipo_solvencia_w		varchar(1);
ie_acao_conta_w			varchar(2);
nr_seq_operadora_w		pls_outorgante.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	ds_conta,
		ds_desc_conta,
		ie_tipo_atividade,
		coalesce(ie_acao_conta,'SO')
	from	diops_trans_conta
	where	ie_tipo_conta		= 'F'
	and	ie_tipo_atividade in ('O','I','F')
	and	cd_estabelecimento	= cd_estabelecimento_p;

C02 CURSOR FOR
	SELECT	vl_dominio
	from	valor_dominio
	where	cd_dominio = 2183
	order by vl_dominio;

C03 CURSOR FOR
	SELECT	ds_conta,
		ds_desc_conta
	from	diops_trans_conta
	where	ie_tipo_conta		= 'LP'
	and	cd_estabelecimento	= cd_estabelecimento_p;

C04 CURSOR FOR
	SELECT	cd_solvencia,
		ds_solvencia,
		ie_tipo_solvencia
	from	diops_conta_ans_solvencia;


BEGIN
select	max(nr_sequencia)
into STRICT	nr_seq_operadora_w
from	pls_outorgante
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_tipo_tabela_p	= 1) then
	open C01;
	loop
	fetch C01 into
		ds_conta_w,
		ds_desc_conta_w,
		ie_tipo_atividade_w,
		ie_acao_conta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		insert into diops_fin_fluxo_caixa(nr_sequencia, cd_estabelecimento, nr_seq_periodo,
			ds_conta, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, vl_fluxo,
			ie_tipo_atividade, ds_descricao_conta, ie_acao_conta,
			nr_seq_operadora, nr_seq_apresentacao)
		values (	nextval('diops_fin_fluxo_caixa_seq'), cd_estabelecimento_p, nr_seq_periodo_p,
			ds_conta_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, 0,
			ie_tipo_atividade_w, ds_desc_conta_w, ie_acao_conta_w,
			nr_seq_operadora_w, 100);
		end;
	end loop;
	close C01;
end if;

if (ie_tipo_tabela_p	= 2) then
	open C02;
	loop
	fetch C02 into
		ie_tipo_vencimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		insert into diops_fin_idadesaldo_pas(nr_sequencia, cd_estabelecimento, nr_seq_periodo,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, ie_tipo_vencimento, vl_evento_liquidar,
			vl_debito_operadora, vl_comercializacao, vl_debito_oper)
		values (	nextval('diops_fin_idadesaldo_pas_seq'), cd_estabelecimento_p, nr_seq_periodo_p,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, ie_tipo_vencimento_w, 0,
			0, 0, 0);

		insert into diops_fin_idadesaldo_ati(nr_sequencia, cd_estabelecimento, nr_seq_periodo,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, ie_tipo_vencimento, vl_individual,
			vl_coletivo_pre, vl_coletivo_pos, vl_taxa_adm,
			vl_credito_operadoras, vl_outros_creditos)
		values (	nextval('diops_fin_idadesaldo_ati_seq'), cd_estabelecimento_p, nr_seq_periodo_p,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, ie_tipo_vencimento_w, 0,
			0, 0, 0,
			0, 0);
		end;
	end loop;
	close C02;
end if;

if (ie_tipo_tabela_p	= 3) then
	open C03;
	loop
	fetch C03 into
		ds_conta_w,
		ds_desc_conta_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		insert into diops_fin_lucro_prej(nr_sequencia, cd_estabelecimento, nr_seq_periodo,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, ds_conta, vl_saldo_final,
			ds_descricao_conta)
		values (	nextval('diops_fin_lucro_prej_seq'), cd_estabelecimento_p, nr_seq_periodo_p,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, ds_conta_w, 0,
			ds_desc_conta_w);
		end;
	end loop;
	close C03;
end if;

if (ie_tipo_tabela_p	= 4) then

	open C04;
	loop
	fetch C04 into
		cd_solvencia_w,
		ds_solvencia_w,
		ie_tipo_solvencia_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		insert into diops_fin_solvencia(nr_sequencia,
			cd_estabelecimento,
			nr_seq_periodo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_solvencia,
			ds_solvencia,
			vl_saldo,
			ie_tipo_solvencia,
			nr_seq_operadora)
		values (	nextval('diops_fin_solvencia_seq'),
			cd_estabelecimento_p,
			nr_seq_periodo_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_solvencia_w,
			ds_solvencia_w,
			0,
			ie_tipo_solvencia_w,
			nr_seq_operadora_w);
		end;
	end loop;
	close C04;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_gerar_dados_padrao_ans ( nr_seq_periodo_p bigint, ie_tipo_tabela_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
