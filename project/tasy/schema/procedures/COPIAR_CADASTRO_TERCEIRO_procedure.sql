-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_cadastro_terceiro ( nr_seq_terceiro_p bigint, cd_estab_dest_p bigint) AS $body$
DECLARE


nr_seq_terceiro_new_w			terceiro.nr_sequencia%type;
nr_seq_terc_regra_esp_new_w		terceiro_regra_esp.nr_sequencia%type;
nr_seq_terc_regra_esp_old_w		terceiro_regra_esp.nr_sequencia%type;
nr_seq_terc_reg_esp_item_new_w	terceiro_regra_esp_item.nr_sequencia%type;
nr_seq_terc_reg_esp_item_old_w	terceiro_regra_esp_item.nr_sequencia%type;
nr_sequencia_old_w				bigint;
cd_pessoa_fisica_old_w			terceiro_pessoa_fisica.cd_pessoa_fisica%type;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	terceiro_regra_esp
	where	nr_seq_terceiro = nr_seq_terceiro_p
	and		cd_estabelecimento = obter_estabelecimento_ativo;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	terceiro_regra_esp_item
	where	nr_seq_terc_regra = nr_seq_terc_regra_esp_old_w;

c03 CURSOR FOR
	SELECT	nr_sequencia
	from	terc_regra_esp_base
	where	nr_seq_regra_item = nr_seq_terc_reg_esp_item_old_w
	and		nr_seq_regra_esp = nr_seq_terc_regra_esp_old_w;

c04 CURSOR FOR
	SELECT  nr_sequencia
	from	terceiro_pessoa_consulta
	where	nr_seq_terceiro = nr_seq_terceiro_p;

c05 CURSOR FOR
	SELECT	cd_pessoa_fisica
	from	terceiro_pessoa_fisica
	where	nr_seq_terceiro = nr_seq_terceiro_p;

c06 CURSOR FOR
	SELECT	nr_sequencia
	from	terceiro_pf_conv
	where	nr_seq_terceiro = nr_seq_terceiro_p;

c07 CURSOR FOR
	SELECT	nr_sequencia
	from	terceiro_relatorio
	where	nr_seq_terceiro = nr_seq_terceiro_p;

c08 CURSOR FOR
	SELECT	nr_sequencia
	from	terceiro_repasse
	where	nr_seq_terceiro = nr_seq_terceiro_p;

c09 CURSOR FOR
	SELECT	nr_sequencia
	from	terceiro_regra_pontuacao
	where	nr_seq_terceiro = nr_seq_terceiro_p;


BEGIN

update terceiro t
   set t.dt_fim_vigencia = clock_timestamp()
 where (coalesce(t.dt_fim_vigencia::text, '') = '' or dt_fim_vigencia > clock_timestamp())
   and t.cd_estabelecimento = cd_estab_dest_p
   and exists (SELECT 1
                 from terceiro a
                where a.nr_sequencia = nr_seq_terceiro_p
                  and (coalesce(a.cd_cgc::text, '') = '' or a.cd_cgc = t.cd_cgc) 
                  and (coalesce(a.cd_pessoa_fisica::text, '') = '' or a.cd_pessoa_fisica = t.cd_pessoa_fisica)
              );
	
select	nextval('terceiro_seq')
into STRICT	nr_seq_terceiro_new_w
;

insert into terceiro(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		cd_cgc,
		cd_pessoa_fisica,
		cd_convenio,
		cd_categoria,
		ie_situacao,
		cd_conta_contabil,
		ie_forma_pagto,
		cd_estabelecimento,
		cd_conta_financ,
		ie_utilizacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_centro_custo,
		ds_observacao,
		ie_gerar_tit_rec,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		cd_externo,
		cd_conta_financ_cre,
		nr_seq_trans_fin_baixa,
		ds_email,
		nr_seq_trans_fin_baixa_cr,
		cd_barras,
		nr_seq_trans_fin_tit,
		vl_max_operacao,
		ie_gerar_oper,
		vl_piso_repasse,
		cd_condicao_pagamento,
		ds_procedure,
		ds_texto_email,
		cd_conta_contabil_cr,
		nr_seq_trans_item_rep,
		nr_seq_tipo_rep,
		ie_gerar_conta_rep_pf)
SELECT	nr_seq_terceiro_new_w,
		clock_timestamp(),
		obter_usuario_ativo,
		cd_cgc,
		cd_pessoa_fisica,
		cd_convenio,
		cd_categoria,
		ie_situacao,
		cd_conta_contabil,
		ie_forma_pagto,
		cd_estab_dest_p,
		cd_conta_financ,
		ie_utilizacao,
		clock_timestamp(),
		obter_usuario_ativo,
		cd_centro_custo,
		ds_observacao,
		ie_gerar_tit_rec,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		cd_externo,
		cd_conta_financ_cre,
		nr_seq_trans_fin_baixa,
		ds_email,
		nr_seq_trans_fin_baixa_cr,
		cd_barras,
		nr_seq_trans_fin_tit,
		vl_max_operacao,
		ie_gerar_oper,
		vl_piso_repasse,
		cd_condicao_pagamento,
		ds_procedure,
		ds_texto_email,
		cd_conta_contabil_cr,
		nr_seq_trans_item_rep,
		nr_seq_tipo_rep,
		ie_gerar_conta_rep_pf
from	terceiro
where	nr_sequencia = nr_seq_terceiro_p
and		cd_estabelecimento = obter_estabelecimento_ativo;

open c01;
loop
	fetch c01 into
		nr_seq_terc_regra_esp_old_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	select	nextval('terceiro_regra_esp_seq')
	into STRICT	nr_seq_terc_regra_esp_new_w
	;

	insert into terceiro_regra_esp(
			nr_sequencia,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_terceiro,
			ie_situacao,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			ds_regra,
			cd_regra_repasse,
			ie_condicao_valor,
			vl_condicao,
			nr_seq_regra_ant,
			ds_regra_abrev,
			ie_totalizador,
			ie_valor_final,
			nr_seq_apresentacao,
			ie_regra_base_valor)
	SELECT	nr_seq_terc_regra_esp_new_w,
			cd_estab_dest_p,
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			nr_seq_terceiro_new_w,
			ie_situacao,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			ds_regra,
			cd_regra_repasse,
			ie_condicao_valor,
			vl_condicao,
			nr_seq_regra_ant,
			ds_regra_abrev,
			ie_totalizador,
			ie_valor_final,
			nr_seq_apresentacao,
			ie_regra_base_valor
	from	terceiro_regra_esp
	where	nr_sequencia = nr_seq_terc_regra_esp_old_w;

	open c02;
	loop
		fetch c02 into
			nr_seq_terc_reg_esp_item_old_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

		select	nextval('terceiro_regra_esp_item_seq')
		into STRICT	nr_seq_terc_reg_esp_item_new_w
		;

		insert into	terceiro_regra_esp_item(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_terc_regra,
				nr_seq_tipo_valor,
				vl_item,
				nr_seq_terc_regra_ant,
				tx_item,
				cd_centro_custo,
				cd_material,
				nr_adiant_pago,
				ie_forma_calculo)
		SELECT	nr_seq_terc_reg_esp_item_new_w,
				clock_timestamp(),
				obter_usuario_ativo,
				clock_timestamp(),
				obter_usuario_ativo,
				nr_seq_terc_regra_esp_new_w,
				nr_seq_tipo_valor,
				vl_item,
				nr_seq_terc_regra_ant,
				tx_item,
				cd_centro_custo,
				cd_material,
				nr_adiant_pago,
				ie_forma_calculo
		from	terceiro_regra_esp_item
		where	nr_sequencia = nr_seq_terc_reg_esp_item_old_w;

		open c03;
		loop
			fetch c03 into
				nr_sequencia_old_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */

			insert into terc_regra_esp_base(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_regra_item,
					nr_seq_regra_esp,
					tx_regra_base)
			SELECT	nextval('terc_regra_esp_base_seq'),
					clock_timestamp(),
					obter_usuario_ativo,
					clock_timestamp(),
					obter_usuario_ativo,
					nr_seq_terc_reg_esp_item_new_w,
					nr_seq_terc_regra_esp_new_w,
					tx_regra_base
			from	terc_regra_esp_base
			where	nr_sequencia = nr_sequencia_old_w;
		end loop;
		close c03;
	end loop;
	close c02;
end loop;
close c01;

open c04;
loop
	fetch c04 into
		nr_sequencia_old_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */

	insert into terceiro_pessoa_consulta(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_terceiro,
			cd_pessoa_fisica,
			cd_perfil)
	SELECT	nextval('terceiro_pessoa_consulta_seq'),
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			nr_seq_terceiro_new_w,
			cd_pessoa_fisica,
			cd_perfil
	from	terceiro_pessoa_consulta
	where	nr_sequencia = nr_sequencia_old_w;
end loop;
close c04;

open c05;
loop
	fetch c05 into
		cd_pessoa_fisica_old_w;
	EXIT WHEN NOT FOUND; /* apply on c05 */

	insert into terceiro_pessoa_fisica(
			nr_seq_terceiro,
			cd_pessoa_fisica,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_observacao,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			ie_resp_terceiro,
			cd_barras,
			ie_repasse,
			ie_receb_prot_onco)
	SELECT	nr_seq_terceiro_new_w,
			cd_pessoa_fisica,
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			ds_observacao,
			dt_inicio_vigencia,
			dt_fim_vigencia,
			ie_resp_terceiro,
			cd_barras,
			ie_repasse,
			ie_receb_prot_onco
	from	terceiro_pessoa_fisica
	where	nr_seq_terceiro = nr_seq_terceiro_p
	and		cd_pessoa_fisica = cd_pessoa_fisica_old_w;
end loop;
close c05;

open c06;
loop
	fetch c06 into
		nr_sequencia_old_w;
	EXIT WHEN NOT FOUND; /* apply on c06 */

	insert into terceiro_pf_conv(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_terceiro,
			cd_pessoa_fisica,
			cd_convenio)
	SELECT	nextval('terceiro_pf_conv_seq'),
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			nr_seq_terceiro_new_w,
			cd_pessoa_fisica,
			cd_convenio
	from	terceiro_pf_conv
	where	nr_sequencia = nr_sequencia_old_w;
end loop;
close c06;

open c07;
loop
	fetch c07 into
		nr_sequencia_old_w;
	EXIT WHEN NOT FOUND; /* apply on c07 */

	insert into terceiro_relatorio(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_terceiro,
			cd_relatorio,
			ds_medicos,
			cd_conta_contabil,
			ds_servico,
			nm_gestor,
			ds_cargo_gestor,
			ie_relatorio_repasse,
			ds_arquivo_relatorio)
	SELECT	nextval('terceiro_relatorio_seq'),
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			nr_seq_terceiro_new_w,
			cd_relatorio,
			ds_medicos,
			cd_conta_contabil,
			ds_servico,
			nm_gestor,
			ds_cargo_gestor,
			ie_relatorio_repasse,
			ds_arquivo_relatorio
	from	terceiro_relatorio
	where	nr_sequencia = nr_sequencia_old_w;
end loop;
close c07;

open c08;
loop
	fetch c08 into
		nr_sequencia_old_w;
	EXIT WHEN NOT FOUND; /* apply on c08 */

	insert into terceiro_repasse(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_terceiro,
			nr_seq_terc_destino,
			tx_repasse,
			ie_situacao,
			nr_seq_trans_financ,
			vl_repasse,
			ie_prioridade,
			ie_saldo,
			ie_valor,
			ie_tipo_convenio)
	SELECT	nextval('terceiro_repasse_seq'),
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			nr_seq_terceiro_new_w,
			nr_seq_terc_destino,
			tx_repasse,
			ie_situacao,
			nr_seq_trans_financ,
			vl_repasse,
			ie_prioridade,
			ie_saldo,
			ie_valor,
			ie_tipo_convenio
	from	terceiro_repasse
	where	nr_sequencia = nr_sequencia_old_w;
end loop;
close c08;

open c09;
loop
	fetch c09 into
		nr_sequencia_old_w;
	EXIT WHEN NOT FOUND; /* apply on c09 */

	insert into terceiro_regra_pontuacao(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_terceiro,
			nr_seq_regra_rep_pont)
	SELECT	nextval('terceiro_regra_pontuacao_seq'),
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			nr_seq_terceiro_new_w,
			nr_seq_regra_rep_pont
	from	terceiro_regra_pontuacao
	where	nr_sequencia = nr_sequencia_old_w;
end loop;
close c09;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_cadastro_terceiro ( nr_seq_terceiro_p bigint, cd_estab_dest_p bigint) FROM PUBLIC;

