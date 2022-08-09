-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_cabec_solic_quimio (nr_sequencia_autor_p bigint, nr_seq_anexo_p bigint, nm_usuario_p text, nr_seq_guia_nova_p INOUT bigint) AS $body$
DECLARE


cd_convenio_w			bigint;
cd_estabelecimento_w		bigint;
cd_ans_w			varchar(100);
ds_arquivo_logo_w		varchar(255);
ds_arquivo_logo_comp_w		varchar(255);
ie_gerar_tiss_w			varchar(10);
nr_seq_anexo_w			bigint;
nr_guia_operadora_w		varchar(20);
nr_guia_anexo_w			varchar(20);
nr_guia_principal_w		varchar(20);
cd_senha_w			varchar(20);
dt_autorizacao_w		timestamp;
cd_usuario_convenio_w		varchar(20);
nm_pessoa_fisica_w		varchar(255);
nm_contratado_w			varchar(255);
nr_telefone_contrat_w		varchar(11);
ds_email_contrat_w		varchar(60);
ds_justificativa_w		varchar(1000);
ds_especific_mat_w		varchar(500);
nr_seq_guia_w			bigint;
ds_versao_w			varchar(20);
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
qt_peso_w			real;
qt_altura_w			real;
qt_superficie_corporal_w	real;
qt_idade_w			smallint;
ie_sexo_w			varchar(3);
nr_ciclos_w			smallint;
nr_ciclo_atual_w		smallint;
nr_intervalo_ciclo_w		smallint;
nr_seq_solic_w			bigint;
ds_observacao_w			varchar(500);
dt_solicitacao_w		timestamp;
nr_dia_ciclo_atual_w	smallint;
nr_seq_paciente_setor_w	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_guia_operadora,
	nr_guia_anexo,
	nr_guia_principal,
	cd_senha,
	dt_autorizacao,
	cd_usuario_convenio,
	nm_pessoa_fisica,
	qt_peso,
	qt_altura,
	qt_superficie_corporal,
	qt_idade,
	ie_sexo,
	nm_contratado,
	nr_telefone_contrat,
	nr_ciclos,
	nr_ciclo_autal,
	nr_intervalo_ciclo,
	dt_solicitacao,
	ds_especific_mat,
	ds_observacao,
	ds_email_contrat
from	tiss_anexo_guia
where	nr_sequencia_autor	= nr_sequencia_autor_p
and	nr_sequencia		= nr_seq_anexo_p
and	ie_tiss_tipo_anexo	= 2; --Quimio
BEGIN

if (coalesce(nr_sequencia_autor_p,-1) > 0) then

	select	max(a.cd_convenio),
		max(a.cd_estabelecimento),
		max(c.cd_ans),
		max(b.ds_arquivo_logo_tiss),
		max(a.cd_pessoa_fisica),
		max(a.nr_atendimento),
		max(a.nr_seq_paciente_setor)
	into STRICT	cd_convenio_w,
		cd_estabelecimento_w,
		cd_ans_w,
		ds_arquivo_logo_w,
		cd_pessoa_fisica_w,
		nr_atendimento_w,
		nr_seq_paciente_setor_w
	from	autorizacao_convenio a,
		convenio b,
		pessoa_juridica c
	where	b.cd_convenio	= a.cd_convenio
	and	b.cd_cgc	= c.cd_cgc
	and	a.nr_sequencia	= nr_sequencia_autor_p;

	select	max(ds_arquivo_logo_comp),
		coalesce(max(ie_gerar_tiss), 'S')
	into STRICT	ds_arquivo_logo_comp_w,
		ie_gerar_tiss_w
	from	tiss_parametros_convenio
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	cd_convenio		= cd_convenio_w;

	select	max(ds_versao)
	into STRICT	ds_versao_w
	from	xml_projeto
	where	nr_sequencia	= tiss_obter_xml_projeto(cd_convenio_w, cd_estabelecimento_w, '21');

	open C01;
	loop
	fetch C01 into
		nr_seq_anexo_w,
		nr_guia_operadora_w,
		nr_guia_anexo_w,
		nr_guia_principal_w,
		cd_senha_w,
		dt_autorizacao_w,
		cd_usuario_convenio_w,
		nm_pessoa_fisica_w,
		qt_peso_w,
		qt_altura_w,
		qt_superficie_corporal_w,
		qt_idade_w,
		ie_sexo_w,
		nm_contratado_w,
		nr_telefone_contrat_w,
		nr_ciclos_w,
		nr_ciclo_atual_w,
		nr_intervalo_ciclo_w,
		dt_solicitacao_w,
		ds_especific_mat_w,
		ds_observacao_w,
		ds_email_contrat_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ds_observacao_w := replace(replace(ds_observacao_w,chr(10),' '),chr(13),' ' );

		select	count(*)
		into STRICT	nr_dia_ciclo_atual_w
		from	paciente_atendimento
		where	nr_seq_paciente = nr_seq_paciente_setor_w
		and	nr_ciclo	= nr_ciclo_atual_w;


		select	nextval('w_tiss_guia_seq')
		into STRICT	nr_seq_guia_w
		;

		insert into w_tiss_guia(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_autorizacao,
			nr_guia_prestador,
			ds_versao,
			cd_autorizacao_princ,
			cd_senha,
			dt_autorizacao,
			cd_ans,
			ds_justificativa,
			ds_especific_mat,
			ie_tiss_tipo_guia,
			nr_atendimento,
			dt_entrada,
			nr_ciclos,
			nr_ciclo_atual,
			nr_intervalo_ciclo,
			ds_observacao,
			nr_dia_ciclo_atual)
		values (nr_seq_guia_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_guia_operadora_w,
			nr_guia_anexo_w,
			ds_versao_w,
			nr_guia_principal_w,
			cd_senha_w,
			dt_autorizacao_w,
			cd_ans_w,
			ds_justificativa_w,
			ds_especific_mat_w,
			'10',
			nr_atendimento_w,
			dt_solicitacao_w,
			nr_ciclos_w,
			nr_ciclo_atual_w,
			nr_intervalo_ciclo_w,
			ds_observacao_w,
			nr_dia_ciclo_atual_w);

		insert	into w_tiss_beneficiario(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_guia,
			cd_pessoa_fisica,
			nm_pessoa_fisica,
			cd_usuario_convenio,
			qt_peso,
			qt_altura,
			qt_superficie_corporal,
			qt_idade,
			ie_sexo)
		values (nextval('w_tiss_beneficiario_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			cd_pessoa_fisica_w,
			nm_pessoa_fisica_w,
			cd_usuario_convenio_w,
			qt_peso_w,
			qt_altura_w,
			qt_superficie_corporal_w,
			qt_idade_w,
			ie_sexo_w);

		insert 	into w_tiss_contratado_solic(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			nm_contratado,
			nr_telefone_contrat,
			ds_email_contrat)
		values (nextval('w_tiss_contratado_solic_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			nm_contratado_w,
			nr_telefone_contrat_w,
			ds_email_contrat_w);

		select	nextval('w_tiss_solicitacao_seq')
		into STRICT	nr_seq_solic_w
		;

		insert	into w_tiss_solicitacao(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			dt_solicitacao,
			cd_estadiamento_tumor,
			cd_finalidade_tratamento,
			cd_ecog,
			ds_diag_histopatologico,
			ds_info_relevantes,
			cd_tipo_quimio,
			ds_plano_terapeutico,
			cd_cid,
			cd_cid2,
			ds_proc_cirurgia,
			dt_realizacao_cirurgia,
			cd_metastase,
			cd_nodulo,
			cd_tumor)
		SELECT	nr_seq_solic_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			max(dt_diagnostico),
			max(cd_estadiamento_tumor),
			max(cd_finalidade_tratamento),
			max(cd_ecog),
			max(ds_diag_histopatologico),
			max(ds_info_relevantes),
			max(cd_tipo_quimio),
			max(ds_plano_terapeutico),
			max(cd_cid),
			max(cd_cid_2),
			max(ds_proc_cirurgia),
			max(dt_realizacao_cirurgia),
			max(cd_metastase),
			max(cd_nodulo),
			max(cd_tumor)
		from	tiss_anexo_guia_diag
		where	nr_seq_guia	= nr_seq_anexo_p;

		end;
	end loop;
	close C01;

end if;

nr_seq_guia_nova_p	:= nr_seq_guia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_cabec_solic_quimio (nr_sequencia_autor_p bigint, nr_seq_anexo_p bigint, nm_usuario_p text, nr_seq_guia_nova_p INOUT bigint) FROM PUBLIC;
