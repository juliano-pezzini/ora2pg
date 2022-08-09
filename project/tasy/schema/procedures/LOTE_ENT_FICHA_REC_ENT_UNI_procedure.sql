-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_ficha_rec_ent_uni ( nr_seq_ficha_p bigint, ds_lista_exames_p text, nm_usuario_p text, nr_atendimento_p bigint, cd_estabelecimento_p bigint ) AS $body$
DECLARE



nr_seq_lote_sec_w		bigint;
nr_lote_w				bigint;
nr_seq_instituicao_w	bigint;
nr_seq_novo_lote_w		bigint;
nr_seq_nova_ficha_w		bigint;
nr_seq_exame_w			bigint;
cd_material_exame_w		varchar(20);
cd_pessoa_fisica_w		varchar(10);
nr_seq_reconvocado_w	bigint;
cd_pessoa_fisica_resp_w	varchar(10);
nr_prescricao_w			bigint;
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%type;
nr_seq_forma_laudo_w	lote_ent_inst_geracao.nr_seq_forma_laudo%type;
qt_rec_w				bigint;


C01 CURSOR FOR
	SELECT	nr_seq_exame,
			cd_material_exame
	from	lote_ent_sec_ficha_exam
	where	nr_seq_ficha = nr_seq_ficha_p
	and		obter_se_contido(nr_sequencia,ds_lista_exames_p) = 'S';


BEGIN

if (nr_seq_ficha_p IS NOT NULL AND nr_seq_ficha_p::text <> '') and (ds_lista_exames_p IS NOT NULL AND ds_lista_exames_p::text <> '') then

	--Insere o Lote
	select	max(a.nr_seq_lote_sec),
			max(a.cd_pessoa_fisica),
			max(c.cd_medico_resp),
			max(c.cd_setor_atendimento),
			max(c.nr_seq_forma_laudo)
	into STRICT	nr_seq_lote_sec_w,
			cd_pessoa_fisica_w,
			cd_pessoa_fisica_resp_w,
			cd_setor_atendimento_w,
			nr_seq_forma_laudo_w
	from	lote_ent_sec_ficha a,
			lote_ent_secretaria b,
			lote_ent_inst_geracao c
	where	a.nr_sequencia = nr_seq_ficha_p
	and		b.nr_sequencia = a.nr_seq_lote_sec
	and		c.nr_seq_instituicao = b.nr_seq_instituicao;

	select	max(NR_LOTE),
			max(NR_SEQ_INSTITUICAO)
	into STRICT	nr_lote_w,
			nr_seq_instituicao_w
	from	lote_ent_secretaria
	where	nr_sequencia = nr_seq_lote_sec_w;


	select	nextval('lote_ent_secretaria_seq')
	into STRICT	nr_seq_novo_lote_w
	;

	select	nextval('lote_ent_sec_ficha_seq')
	into STRICT	nr_seq_nova_ficha_w
	;

	--Insere a prescrição
	select	nextval('prescr_medica_seq')
	into STRICT	nr_prescricao_w
	;

	insert into prescr_medica(
		nr_prescricao,
		cd_pessoa_fisica,
		dt_prescricao,
		dt_atualizacao,
		nm_usuario,
		nr_atendimento,
		nr_seq_ficha_lote,
		nr_seq_lote_entrada,
		cd_estabelecimento,
		cd_medico,
		cd_setor_entrega,
		nr_seq_forma_laudo
	) values (
		nr_prescricao_w,
		cd_pessoa_fisica_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nr_atendimento_p,
		nr_seq_nova_ficha_w,
		nr_seq_novo_lote_w,
		cd_estabelecimento_p,
		cd_pessoa_fisica_resp_w,
		cd_setor_atendimento_w,
		nr_seq_forma_laudo_w
	);

	insert into lote_ent_secretaria(
		nr_sequencia,
		nr_lote,
		nr_seq_instituicao,
		ie_tipo_ficha,
		dt_recebimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_lote_anterior
	) values (
		nr_seq_novo_lote_w,
		nr_lote_w,
		nr_seq_instituicao_w,
		'R',
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_lote_w
	);

	--Insere a ficha
	insert into lote_ent_sec_ficha(
		nr_sequencia,
		cd_pessoa_fisica,
		nr_seq_lote_sec,
		dt_atualizacao,
		nm_usuario,
		ie_ficha_adicional,
		cd_material_exame,
		cd_entidade_f,
		cd_lote_f,
		cd_prontuario_f,
		nm_rn_f,
		cd_dnv_f,
		dt_coleta_ficha_f,
		ie_periodo_col_f,
		dt_nascimento_f,
		ie_periodo_nasc_f,
		qt_peso_f,
		ie_sexo_f,
		ie_cor_pf_f,
		ie_npp_f,
		ie_premat_s_f,
		nr_idade_gest_f,
		ie_transfusao_f,
		dt_transf_f,
		ie_gemelar_f,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_prontuario_ex,
		cd_usuario_conv_ext,
		nr_ficha_ext,
		ds_observacao,
		ie_susp_am_inad,
		cd_barras,
		nr_cartao_nac_sus,
		cd_exame_f,
		ie_prematuro_f,
		dt_coleta_f,
		ie_tipo_teste_f,
		ds_repeticao_exame_f,
		cd_entrada_f,
		cd_exame_ficha_f,
		ie_premat_n_f,
		ie_transf_s_f,
		ie_transf_n_f,
		ie_tipo_ficha,
		ie_status_ficha,
		nr_seq_mot_inadeq,
		ds_motivo_inadeq,
		cd_medico_resp
		)
	SELECT	nr_seq_nova_ficha_w,
		cd_pessoa_fisica,
		nr_seq_novo_lote_w,
		clock_timestamp(),
		nm_usuario_p,
		ie_ficha_adicional,
		cd_material_exame,
		cd_entidade_f,
		cd_lote_f,
		cd_prontuario_f,
		nm_rn_f,
		cd_dnv_f,
		coalesce(dt_coleta_ficha_f,clock_timestamp()),
		ie_periodo_col_f,
		dt_nascimento_f,
		ie_periodo_nasc_f,
		qt_peso_f,
		ie_sexo_f,
		ie_cor_pf_f,
		ie_npp_f,
		ie_premat_s_f,
		nr_idade_gest_f,
		ie_transfusao_f,
		dt_transf_f,
		ie_gemelar_f,
		clock_timestamp(),
		nm_usuario_p,
		nr_prontuario_ex,
		cd_usuario_conv_ext,
		nr_ficha_ext,
		ds_observacao,
		ie_susp_am_inad,
		cd_barras,
		nr_cartao_nac_sus,
		cd_exame_f,
		ie_prematuro_f,
		dt_coleta_f,
		ie_tipo_teste_f,
		ds_repeticao_exame_f,
		cd_entrada_f,
		cd_exame_ficha_f,
		ie_premat_n_f,
		ie_transf_s_f,
		ie_transf_n_f,
		ie_tipo_ficha,
		ie_status_ficha,
		nr_seq_mot_inadeq,
		ds_motivo_inadeq,
		cd_medico_resp
	from	lote_ent_sec_ficha
	where	nr_sequencia  = nr_seq_ficha_p;

	--Insere as informações do lote
	select 	coalesce(nr_sequencia,0)
	into STRICT	nr_seq_reconvocado_w
	from	lote_ent_reconvocado
	where	nr_seq_ficha_lote = nr_seq_ficha_p;

	if (coalesce(nr_seq_reconvocado_w,0) = 0) then

		select	nextval('lote_ent_reconvocado_seq')
		into STRICT	nr_seq_reconvocado_w
		;

		insert into lote_ent_reconvocado(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			nr_seq_lote_sec,
			nr_seq_ficha_lote,
			dt_atualizacao_nrec,
			nm_usuario_nrec
		) values (
			nr_seq_reconvocado_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			nr_seq_novo_lote_w,
			nr_seq_nova_ficha_w,
			clock_timestamp(),
			nm_usuario_p
		);

	end if;

	--Insere os exames
	open C01;
	loop
	fetch C01 into
		nr_seq_exame_w,
		cd_material_exame_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		insert into lote_ent_sec_ficha_exam(
			nr_sequencia,
			nr_seq_exame,
			dt_atualizacao,
			nm_usuario,
			cd_material_exame,
			nr_seq_ficha,
			dt_atualizacao_nrec,
			nm_usuario_nrec
		) values (
			nextval('lote_ent_sec_ficha_exam_seq'),
			nr_seq_exame_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_exame_w,
			nr_seq_nova_ficha_w,
			clock_timestamp(),
			nm_usuario_p
		);

		insert	into LOTE_ENT_RECONVOCADO_ITEM(
			NR_SEQUENCIA,
			NR_SEQ_EXAME,
			DT_ATUALIZACAO,
			NM_USUARIO,
			CD_MATERIAL_EXAME,
			NR_SEQ_RECONVOCADO,
			DT_ATUALIZACAO_NREC,
			NM_USUARIO_NREC,
			IE_TIPO_BUSCA
		) values (
			nextval('lote_ent_reconvocado_item_seq'),
			nr_seq_exame_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_exame_w,
			nr_seq_reconvocado_w,
			clock_timestamp(),
			nm_usuario_p,
			'A'
		);

		end;
	end loop;
	close C01;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_ficha_rec_ent_uni ( nr_seq_ficha_p bigint, ds_lista_exames_p text, nm_usuario_p text, nr_atendimento_p bigint, cd_estabelecimento_p bigint ) FROM PUBLIC;
