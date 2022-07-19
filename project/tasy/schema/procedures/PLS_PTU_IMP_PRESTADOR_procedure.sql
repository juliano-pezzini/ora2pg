-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ptu_imp_prestador ( ds_conteudo_p text, nm_usuario_p text) AS $body$
DECLARE

/*401*/

nr_seq_movimento_w		bigint;
cd_unimed_destino_w		smallint;
cd_unimed_origem_w		smallint;
dt_geracao_w			timestamp;
nr_versao_transacao_w		smallint;

/*402*/

ie_rce_w			varchar(1);
cd_especialidade_w		smallint;
cd_prestador_w			bigint;
nr_seq_prestador_ptu_w		bigint;
ie_tipo_prestador_w		varchar(2);
nr_seq_prestador_w		bigint;
cd_cgc_cpf_w			varchar(14);
nm_prestador_w			varchar(40);
ie_tipo_vinculo_w		smallint;
dt_inclusao_w			timestamp;
ie_tipo_classif_estab_w		varchar(1);
ie_categoria_dif_w		varchar(1);
ie_acidente_trabalho_w		varchar(1);
ie_urgencia_emerg_w		varchar(1);
dt_inicio_servico_w		timestamp;
dt_inicio_contrato_w		timestamp;
nr_registro_ans_w		integer;
nm_diretor_tecnico_w		varchar(40);
nr_insc_estadual_w		numeric(20);
nr_crm_w			integer;
uf_crm_w			varchar(2);
nm_fantasia_w			varchar(40);
dt_exclusao_w			timestamp;
ie_tipo_contratualizacao_w	varchar(1);
ie_tabela_propria_w		varchar(1);
ie_perfil_assistencial_w	smallint;
ie_tipo_produto_w		smallint;
nr_seq_conselho_w		bigint;
nr_cons_diretor_tecnico_w	varchar(15);
ie_tipo_rede_min_w		smallint;
sg_uf_cons_diretor_tecnico_w	varchar(2);
ie_tipo_disponibilidade_w	smallint;
ie_guia_medico_w		varchar(1);

/*403*/

nr_seq_endereco_w		bigint;
ie_tipo_endereco_w		smallint;
ds_endereco_w			varchar(40);
cd_municipio_ibge_w		varchar(6);
cd_cep_w			integer;
nr_telefone_w			bigint;
cd_cnes_w			varchar(7);
cd_cgc_cpf_ww			varchar(14);
nr_endereco_w			varchar(6);
ds_complemento_w		varchar(15);
ds_bairro_w			varchar(30);
nr_ddd_w			smallint;
nr_telefone_dois_w		bigint;
nr_fax_w			bigint;
ds_email_w			varchar(40);
ds_endereco_web_w		varchar(50);
nr_leitos_totais_w		integer;
nr_leitos_contrat_w		integer;
nr_leitos_psiquiatria_w		integer;
nr_uti_adulto_w			integer;
nr_uti_neonatal_w		integer;
nr_uti_pediatria_w		integer;

/*404*/

cd_grupo_servico_w		smallint;

/*505*/

cd_rede_w			varchar(5);
nm_rede_w			varchar(40);



BEGIN

if (substr(ds_conteudo_p,9,3) = '401') then
	cd_unimed_destino_w	:= (substr(ds_conteudo_p,12,4))::numeric;
	cd_unimed_origem_w	:= (substr(ds_conteudo_p,16,4))::numeric;
	dt_geracao_w		:= to_date(substr(ds_conteudo_p,26,2)||substr(ds_conteudo_p,24,2)||substr(ds_conteudo_p,20,4),'dd/mm/yyyy');
	nr_versao_transacao_w	:= (substr(ds_conteudo_p,28,2))::numeric;

	select	nextval('ptu_movimento_prestador_seq')
	into STRICT	nr_seq_movimento_w
	;

	insert into ptu_movimento_prestador(nr_sequencia, cd_unimed_destino, cd_unimed_origem,
		dt_geracao, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nr_versao_transacao)
	values (nr_seq_movimento_w, cd_unimed_destino_w, cd_unimed_origem_w,
		dt_geracao_w, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, nr_versao_transacao_w);
end if;

if (substr(ds_conteudo_p,9,3) = '402') then
	ie_tipo_prestador_w		:= substr(ds_conteudo_p,12,2);
	nr_seq_prestador_w		:= (substr(ds_conteudo_p,14,8))::numeric;
	cd_cgc_cpf_w			:= substr(ds_conteudo_p,23,14);
	nm_prestador_w			:= substr(ds_conteudo_p,67,40);
	ie_tipo_vinculo_w		:= (substr(ds_conteudo_p,147,1))::numeric;
	dt_inclusao_w			:= to_date(substr(ds_conteudo_p,174,2)||substr(ds_conteudo_p,172,2)||substr(ds_conteudo_p,168,4),'dd/mm/yyyy');
	ie_tipo_classif_estab_w		:= substr(ds_conteudo_p,185,1);
	ie_categoria_dif_w		:= substr(ds_conteudo_p,186,1);
	ie_acidente_trabalho_w		:= substr(ds_conteudo_p,187,1);
	ie_urgencia_emerg_w		:= substr(ds_conteudo_p,189,1);
	dt_inicio_servico_w		:= to_date(substr(ds_conteudo_p,203,2)||substr(ds_conteudo_p,201,2)||substr(ds_conteudo_p,197,4),'dd/mm/yyyy');
	dt_inicio_contrato_w		:= to_date(substr(ds_conteudo_p,211,2)||substr(ds_conteudo_p,209,2)||substr(ds_conteudo_p,205,4),'dd/mm/yyyy');
	nr_registro_ans_w		:= (substr(ds_conteudo_p,213,6))::numeric;
	nm_diretor_tecnico_w		:= substr(ds_conteudo_p,219,40);
	nr_insc_estadual_w		:= (substr(ds_conteudo_p,37,20))::numeric;
	nr_crm_w			:= (substr(ds_conteudo_p,57,8))::numeric;
	uf_crm_w			:= substr(ds_conteudo_p,65,2);
	nm_fantasia_w			:= substr(ds_conteudo_p,107,40);
	dt_exclusao_w			:= to_date(substr(ds_conteudo_p,202,2)||substr(ds_conteudo_p,199,2)||substr(ds_conteudo_p,176,4),'dd/mm/yyyy');
	ie_tipo_contratualizacao_w	:= substr(ds_conteudo_p,184,1);
	ie_tabela_propria_w		:= substr(ds_conteudo_p,268,1);
	ie_perfil_assistencial_w	:= (substr(ds_conteudo_p,269,2))::numeric;
	ie_tipo_produto_w		:= (substr(ds_conteudo_p,271,1))::numeric;
	ie_tipo_disponibilidade_w	:= (substr(ds_conteudo_p,267,1))::numeric;
	ie_guia_medico_w		:= substr(ds_conteudo_p,272,1);
	nr_seq_conselho_w		:= null;
	nr_cons_diretor_tecnico_w	:= null;
	sg_uf_cons_diretor_tecnico_w	:= null;
	ie_tipo_rede_min_w		:= null;

	select	max(nr_sequencia)
	into STRICT	nr_seq_movimento_w
	from	ptu_movimento_prestador;

	select	nextval('ptu_prestador_seq')
	into STRICT	nr_seq_prestador_ptu_w
	;

	insert into ptu_prestador(nr_sequencia, nr_seq_movimento, ie_tipo_prestador,
		nr_seq_prestador, cd_cgc_cpf, nm_prestador,
		ie_tipo_vinculo, dt_inclusao, ie_tipo_classif_estab,
		ie_categoria_dif, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, ie_acidente_trabalho,
		ie_urgencia_emerg, dt_inicio_servico, dt_inicio_contrato,
		nr_registro_ans, nm_diretor_tecnico, nr_insc_estadual,
		nr_crm, uf_crm, nm_fantasia,
		dt_exclusao, ie_tipo_contratualizacao, ie_tabela_propria,
		ie_perfil_assistencial, ie_tipo_produto, nr_seq_conselho,
		nr_cons_diretor_tecnico, sg_uf_cons_diretor_tecnico, ie_tipo_rede_min,
		ie_tipo_disponibilidade, ie_guia_medico)
	values (nr_seq_prestador_ptu_w, nr_seq_movimento_w, ie_tipo_prestador_w,
		nr_seq_prestador_w, cd_cgc_cpf_w, nm_prestador_w,
		ie_tipo_vinculo_w, dt_inclusao_w, ie_tipo_classif_estab_w,
		ie_categoria_dif_w, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, ie_acidente_trabalho_w,
		ie_urgencia_emerg_w, dt_inicio_servico_w, dt_inicio_contrato_w,
		nr_registro_ans_w, nm_diretor_tecnico_w, nr_insc_estadual_w,
		nr_crm_w, uf_crm_w, nm_fantasia_w,
		dt_exclusao_w, ie_tipo_contratualizacao_w, ie_tabela_propria_w,
		ie_perfil_assistencial_w, ie_tipo_produto_w, nr_seq_conselho_w,
		nr_cons_diretor_tecnico_w, sg_uf_cons_diretor_tecnico_w, ie_tipo_rede_min_w,
		ie_tipo_disponibilidade_w, ie_guia_medico_w);

	cd_especialidade_w	:= (substr(ds_conteudo_p,148,4))::numeric;
	ie_rce_w		:= substr(ds_conteudo_p,190,1);
	cd_prestador_w		:= (substr(ds_conteudo_p,14,8))::numeric;

	if (cd_especialidade_w	<> 0) then
		insert into ptu_prestador_espec(nr_sequencia, nr_seq_prestador, cd_especialidade,
			ie_rce, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ie_principal,
			nr_seq_apres)
		values (nextval('ptu_prestador_espec_seq'), nr_seq_prestador_ptu_w, cd_especialidade_w,
			ie_rce_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, 'N',
			cd_especialidade_w);

	end if;
	cd_especialidade_w	:= (substr(ds_conteudo_p,152,4))::numeric;
	ie_rce_w		:= substr(ds_conteudo_p,191,1);

	if (cd_especialidade_w	<> 0) then
		insert into ptu_prestador_espec(nr_sequencia, nr_seq_prestador, cd_especialidade,
			ie_rce, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ie_principal,
			nr_seq_apres)
		values (nextval('ptu_prestador_espec_seq'), nr_seq_prestador_ptu_w, cd_especialidade_w,
			ie_rce_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, 'N',
			cd_especialidade_w);
	end if;

	cd_especialidade_w	:= (substr(ds_conteudo_p,156,4))::numeric;
	ie_rce_w		:= substr(ds_conteudo_p,192,1);

	if (cd_especialidade_w	<> 0) then
		insert into ptu_prestador_espec(nr_sequencia, nr_seq_prestador, cd_especialidade,
			ie_rce, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ie_principal,
			nr_seq_apres)
		values (nextval('ptu_prestador_espec_seq'), nr_seq_prestador_ptu_w, cd_especialidade_w,
			ie_rce_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, 'N',
			cd_especialidade_w);
	end if;

	cd_especialidade_w	:= (substr(ds_conteudo_p,160,4))::numeric;
	ie_rce_w		:= substr(ds_conteudo_p,193,1);

	if (cd_especialidade_w	<> 0) then
		insert into ptu_prestador_espec(nr_sequencia, nr_seq_prestador, cd_especialidade,
			ie_rce, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ie_principal,
			nr_seq_apres)
		values (nextval('ptu_prestador_espec_seq'), nr_seq_prestador_ptu_w, cd_especialidade_w,
			ie_rce_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, 'N',
			cd_especialidade_w);
	end if;

	cd_especialidade_w	:= (substr(ds_conteudo_p,164,4))::numeric;
	ie_rce_w		:= substr(ds_conteudo_p,194,1);

	if (cd_especialidade_w	<> 0) then
		insert into ptu_prestador_espec(nr_sequencia, nr_seq_prestador, cd_especialidade,
			ie_rce, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ie_principal,
			nr_seq_apres)
		values (nextval('ptu_prestador_espec_seq'), nr_seq_prestador_ptu_w, cd_especialidade_w,
			ie_rce_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, 'N',
			cd_especialidade_w);
	end if;

end if;

if (substr(ds_conteudo_p,9,3) = '403') then
	ie_tipo_endereco_w	:= (substr(ds_conteudo_p,12,1))::numeric;
	ds_endereco_w		:= substr(ds_conteudo_p,13,40);
	cd_municipio_ibge_w	:= (substr(ds_conteudo_p,104,7))::numeric;
	cd_cep_w		:= (substr(ds_conteudo_p,111,8))::numeric;
	nr_telefone_w		:= (substr(ds_conteudo_p,123,12))::numeric;
	cd_cnes_w		:= substr(ds_conteudo_p,249,7);
	cd_cgc_cpf_ww		:= substr(ds_conteudo_p,293,14);
	nr_endereco_w		:= substr(ds_conteudo_p,53,6);
	ds_complemento_w	:= substr(ds_conteudo_p,59,15);
	ds_bairro_w		:= substr(ds_conteudo_p,74,30);
	nr_ddd_w		:= (substr(ds_conteudo_p,119,4))::numeric;
	nr_telefone_dois_w	:= (substr(ds_conteudo_p,135,12))::numeric;
	nr_fax_w		:= (substr(ds_conteudo_p,147,12))::numeric;
	ds_email_w		:= substr(ds_conteudo_p,159,40);
	ds_endereco_web_w	:= substr(ds_conteudo_p,199,50);
	nr_leitos_totais_w	:= (substr(ds_conteudo_p,256,6))::numeric;
	nr_leitos_contrat_w	:= (substr(ds_conteudo_p,262,6))::numeric;
	nr_leitos_psiquiatria_w	:= (substr(ds_conteudo_p,268,6))::numeric;
	nr_uti_adulto_w		:= (substr(ds_conteudo_p,274,6))::numeric;
	nr_uti_neonatal_w	:= (substr(ds_conteudo_p,280,6))::numeric;
	nr_uti_pediatria_w	:= (substr(ds_conteudo_p,286,6))::numeric;

	select	max(nr_sequencia)
	into STRICT	nr_seq_prestador_ptu_w
	from	ptu_prestador;

	select	nextval('ptu_prestador_endereco_seq')
	into STRICT	nr_seq_endereco_w
	;

	insert into ptu_prestador_endereco(nr_sequencia, nr_seq_prestador, ie_tipo_endereco,
		ds_endereco, cd_municipio_ibge, cd_cep,
		nr_telefone, cd_cnes, cd_cgc_cpf,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, nr_endereco, ds_complemento,
		ds_bairro, nr_ddd, nr_telefone_dois,
		nr_fax, ds_email, ds_endereco_web,
		nr_leitos_totais, nr_leitos_contrat, nr_leitos_psiquiatria,
		nr_uti_adulto, nr_uti_neonatal, nr_uti_pediatria)
	values (nr_seq_endereco_w , nr_seq_prestador_ptu_w, ie_tipo_endereco_w,
		ds_endereco_w, cd_municipio_ibge_w, cd_cep_w,
		nr_telefone_w, cd_cnes_w, cd_cgc_cpf_ww,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, nr_endereco_w, ds_complemento_w,
		ds_bairro_w, nr_ddd_w, nr_telefone_dois_w,
		nr_fax_w, ds_email_w, ds_endereco_web_w,
		nr_leitos_totais_w, nr_leitos_contrat_w, nr_leitos_psiquiatria_w,
		nr_uti_adulto_w, nr_uti_neonatal_w, nr_uti_pediatria_w);

end if;

if (substr(ds_conteudo_p,9,3) = '404') then

	cd_grupo_servico_w		:= substr(ds_conteudo_p,12,3);

	select	max(nr_sequencia)
	into STRICT	nr_seq_endereco_w
	from	ptu_prestador_endereco;

	insert into ptu_prestador_grupo_serv(nr_sequencia, nr_seq_endereco, cd_grupo_servico,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (nextval('ptu_prestador_grupo_serv_seq'), nr_seq_endereco_w, cd_grupo_servico_w,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p);
end if;

if (substr(ds_conteudo_p,9,3) = '405') then
	cd_rede_w	:= substr(ds_conteudo_p,12,5);
	nm_rede_w	:= substr(ds_conteudo_p,17,40);

	select	max(nr_sequencia)
	into STRICT	nr_seq_prestador_ptu_w
	from	ptu_prestador;

	insert into ptu_prestador_rede_ref(nr_sequencia, nr_seq_prestador, cd_rede,
		nm_rede, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec)
	values (nextval('ptu_prestador_rede_ref_seq'), nr_seq_prestador_ptu_w, cd_rede_w,
		nm_rede_w, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p);

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ptu_imp_prestador ( ds_conteudo_p text, nm_usuario_p text) FROM PUBLIC;

