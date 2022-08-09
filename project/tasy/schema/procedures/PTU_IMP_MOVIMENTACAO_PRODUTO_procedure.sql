-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_movimentacao_produto ( ds_conteudo_p text, nm_usuario_p text) AS $body$
DECLARE



cd_unimed_ori_w			smallint;
cd_unimed_des_w			smallint;
nr_versao_trans_w		smallint;
ie_tipo_mov_w			varchar(1);
ie_tipo_produto_w		varchar(2);
dt_geracao_ww			varchar(10);
dt_geracao_w			timestamp;
dt_mov_ini_ww			varchar(10);
dt_mov_ini_w			timestamp;
dt_mov_final_ww			varchar(10);
dt_mov_final_w			timestamp;

cd_filial_w			smallint;
tp_pessoa_con_w			smallint;
cd_cgc_cpf302_w			bigint;
cd_insc_est_w			numeric(20);
nr_cep302_w			integer;
nr_ddd302_w			smallint;
nr_fone302_w			integer;
nr_fax_w			integer;
cd_empr_ori302_w		bigint;
ie_tipo_natureza_w		smallint;
cd_munic_w			integer;
nm_empr_compl_w			varchar(40);
nm_empr_abre_w			varchar(18);
ds_end_pri302_w			varchar(40);
ds_end_cpl_w			varchar(20);
ds_bairro302_w			varchar(30);
ds_cidade302_w			varchar(30);
cd_uf302_w			varchar(2);
dt_incl_uni302_w		timestamp;
dt_incl_uni302_ww		varchar(10);
dt_excl_uni_ww			varchar(10);
dt_excl_uni_w			timestamp;
nr_seq_produto_w		bigint;

cd_uni_w			smallint;
id_benef_w			bigint;
cd_familia_w			integer;
cd_cgc_cpf304_w			bigint;
cd_depe_w			smallint;
vl_mensalidade_w		bigint;
cd_uni_ant_w			smallint;
id_benef_ant_w			bigint;
id_benef_tit_w			bigint;
id_filho_w			smallint;
cd_empr_ori304_w		bigint;
cd_pais_w			smallint;
nm_benef_w			varchar(25);
cd_plano_des_w			varchar(6);
ie_sexo_w			varchar(1);
cd_rg_w				varchar(15);
cd_uf_rg_w			varchar(2);
cd_civil_w			varchar(1);
nm_compl_benef_w		varchar(120);
ie_tipo_acomodacao_w		varchar(2);
cd_ident_w			varchar(20);
ds_orgao_emissor_w		pessoa_fisica.ds_orgao_emissor_ci%type;
dt_nasc_ww			varchar(10);
dt_incl_uni304_ww		varchar(10);
dt_exclu_uni_ww			varchar(10);
dt_repasse_ww			varchar(10);
dt_base_carencia_ww		varchar(10);
dt_incl_plano_ww		varchar(10);
dt_incl_empr_uni_ww		varchar(10);
dt_nasc_w			timestamp;
dt_incl_uni304_w		timestamp;
dt_exclu_uni_w			timestamp;
dt_repasse_w			timestamp;
dt_base_carencia_w		timestamp;
dt_incl_plano_w			timestamp;
dt_incl_empr_uni_w		timestamp;
nr_seq_empresa_w		bigint;
ie_cooperativa_w		varchar(1);
cd_usuario_plano_w		ptu_mov_produto_benef.cd_usuario_plano%type;
cd_usuario_plano_ant_w		ptu_mov_produto_benef.cd_usuario_plano_ant%type;
cd_titular_plano_w		ptu_mov_produto_benef.cd_titular_plano%type;
cd_usuario_plano_benef_w 	ptu_mov_produto_benef.cd_usuario_plano_benef%type;
cd_plano_benef_ant_w 		ptu_mov_produto_benef.cd_plano_benef_ant%type;
cd_titular_benef_plano_w	ptu_mov_produto_benef.cd_titular_benef_plano%type;

nr_cep306_w			integer;
nr_ddd306_w			smallint;
nr_fone306_w			integer;
nr_ramal_w			integer;
ds_end_pri306_w			varchar(40);
ds_bairro306_w			varchar(30);
ds_cidade306_w			varchar(30);
cd_uf306_w			varchar(2);
nr_seq_benef_w			bigint;


BEGIN

if (substr(ds_conteudo_p,9,3) = '301') then

	select	CASE WHEN (substr(ds_conteudo_p,12,4))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,12,4))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,16,4))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,16,4))::numeric  END ,
		CASE WHEN substr(ds_conteudo_p,47,2)='0' THEN ''  ELSE substr(ds_conteudo_p,47,2) END
	into STRICT	cd_unimed_des_w,
		cd_unimed_ori_w,
		nr_versao_trans_w
	;

	ie_tipo_mov_w		:= substr(ds_conteudo_p,28,1);
	ie_tipo_produto_w	:= substr(ds_conteudo_p,45,2);

	dt_geracao_ww		:= substr(ds_conteudo_p,26,2)||substr(ds_conteudo_p,24,2)||substr(ds_conteudo_p,20,4);
	if (dt_geracao_ww <> '        ') then
		dt_geracao_w	:= to_date(dt_geracao_ww,'dd/mm/yyyy');
	end if;

	dt_mov_ini_ww	:= substr(ds_conteudo_p,35,2)||substr(ds_conteudo_p,33,2)||substr(ds_conteudo_p,29,4);

	if (dt_mov_ini_ww	<> '        ') then
		dt_mov_ini_w	:= to_date(dt_mov_ini_ww,'dd/mm/yyyy');
	end if;

	dt_mov_final_ww	:= substr(ds_conteudo_p,43,2)||substr(ds_conteudo_p,41,2)||substr(ds_conteudo_p,37,4);
	if (dt_mov_final_ww <> '        ') then
		dt_mov_final_w	:= to_date(dt_mov_final_ww,'dd/mm/yyyy');
	end if;

	insert into ptu_movimentacao_produto(nr_sequencia, cd_unimed_destino, cd_unimed_origem,
		dt_geracao, ie_tipo_mov, dt_mov_inicio,
		dt_mov_fim, ie_operacao, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_versao_transacao, ie_tipo_produto)
	values (nextval('ptu_movimentacao_produto_seq'), cd_unimed_des_w, cd_unimed_ori_w,
		dt_geracao_w, ie_tipo_mov_w, dt_mov_ini_w,
		dt_mov_final_w, 'R', clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		nr_versao_trans_w, ie_tipo_produto_w);
end if;

if (substr(ds_conteudo_p,9,3) = '302') then

	select	CASE WHEN (substr(ds_conteudo_p,16,3))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,16,3))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,77,1))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,77,1))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,93,20))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,93,20))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,203,8))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,203,8))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,243,4))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,243,4))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,247,8))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,247,8))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,255,8))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,255,8))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,289,1))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,289,1))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,290,7))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,290,7))::numeric  END
	into STRICT	cd_filial_w,
		tp_pessoa_con_w,
		cd_insc_est_w,
		nr_cep302_w,
		nr_ddd302_w,
		nr_fone302_w,
		nr_fax_w,
		ie_tipo_natureza_w,
		cd_munic_w
	;

	nm_empr_compl_w	:= substr(ds_conteudo_p,19,40);
	nm_empr_abre_w	:= substr(ds_conteudo_p,59,18);
	ds_end_pri302_w	:= substr(ds_conteudo_p,113,40);
	ds_end_cpl_w	:= substr(ds_conteudo_p,153,20);
	ds_bairro302_w	:= substr(ds_conteudo_p,173,20);
	ds_cidade302_w	:= substr(ds_conteudo_p,211,30);
	cd_uf302_w	:= substr(ds_conteudo_p,241,2);
	cd_empr_ori302_w := (substr(ds_conteudo_p,279,10))::numeric;

	dt_incl_uni302_ww	:= substr(ds_conteudo_p,269,2)||substr(ds_conteudo_p,267,2)||substr(ds_conteudo_p,263,4);
	if (dt_incl_uni302_ww <> '        ') then
		dt_incl_uni302_w	:= to_date(dt_incl_uni302_ww,'dd/mm/yyyy');
	end if;

	dt_excl_uni_ww	:= substr(ds_conteudo_p,277,2)||substr(ds_conteudo_p,275,2)||substr(ds_conteudo_p,271,4);
	if (dt_excl_uni_ww <> '        ') then
		dt_excl_uni_w	:= to_date(dt_excl_uni_ww,'dd/mm/yyyy');
	end if;

	if (tp_pessoa_con_w = '1') then
		cd_cgc_cpf302_w	:= substr(ds_conteudo_p,78,15);
	elsif (tp_pessoa_con_w = '2') then
		cd_cgc_cpf302_w	:= substr(substr(ds_conteudo_p,78,15),3,14);
	end if;

	select	max(nr_sequencia)
	into STRICT	nr_seq_produto_w
	from	ptu_movimentacao_produto;

	insert into ptu_mov_produto_empresa(nr_sequencia, ds_razao_social, nm_empr_abrev,
		ie_tipo_pessoa, cd_cgc_cpf, ds_endereco,
		cd_cep, cd_empresa_origem, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		cd_filial, nr_insc_estadual, ds_complemento,
		ds_bairro, nm_cidade, sg_uf,
		nr_ddd, nr_telefone, nr_fax,
		dt_inclusao, dt_exclusao, cd_municipio_ibge,
		nr_seq_mov_produto, nr_seq_contrato,ie_natureza_contratacao)
	values (nextval('ptu_mov_produto_empresa_seq'), nm_empr_compl_w, nm_empr_abre_w,
		tp_pessoa_con_w, cd_cgc_cpf302_w, ds_end_pri302_w,
		nr_cep302_w, cd_empr_ori302_w, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		cd_filial_w, cd_insc_est_w, ds_end_cpl_w,
		ds_bairro302_w, ds_cidade302_w, cd_uf302_w,
		nr_ddd302_w, nr_fone302_w, nr_fax_w,
		dt_incl_uni302_w, dt_excl_uni_w, cd_munic_w,
		nr_seq_produto_w, '',ie_tipo_natureza_w);

end if;

if (substr(ds_conteudo_p,9,3) = '304') then

	select	CASE WHEN (substr(ds_conteudo_p,12,4))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,12,4))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,19,13))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,19,13))::numeric  END ,
		(substr(ds_conteudo_p,36,6))::numeric ,
		(substr(ds_conteudo_p,82,15))::numeric ,
		CASE WHEN (substr(ds_conteudo_p,131,2))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,131,2))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,165,14))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,165,14))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,179,4))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,179,4))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,183,13))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,183,13))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,196,13))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,196,13))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,329,2))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,329,2))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,331,10))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,331,10))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,403,3))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,403,3))::numeric  END
	into STRICT	cd_uni_w,
		id_benef_w,
		cd_familia_w,
		cd_cgc_cpf304_w,
		cd_depe_w,
		vl_mensalidade_w,
		cd_uni_ant_w,
		id_benef_ant_w,
		id_benef_tit_w,
		id_filho_w,
		cd_empr_ori304_w,
		cd_pais_w
	;

	nm_benef_w		:= substr(ds_conteudo_p,42,25);
	cd_plano_des_w		:= substr(ds_conteudo_p,67,6);
	ie_sexo_w		:= substr(ds_conteudo_p,81,1);
	cd_rg_w			:= substr(ds_conteudo_p,97,15);
	cd_uf_rg_w		:= substr(ds_conteudo_p,112,2);
	cd_civil_w		:= substr(ds_conteudo_p,114,1);
	nm_compl_benef_w	:= substr(ds_conteudo_p,209,120);
	ie_tipo_acomodacao_w	:= substr(ds_conteudo_p,341,2);
	cd_ident_w		:= substr(ds_conteudo_p,343,20);
	ds_orgao_emissor_w	:= substr(ds_conteudo_p,373,30);

	dt_nasc_ww	:= substr(ds_conteudo_p,79,2)||substr(ds_conteudo_p,77,2)||substr(ds_conteudo_p,73,4);
	if (dt_nasc_ww <> '        ') then
		dt_nasc_w	:= to_date(dt_nasc_ww,'dd/mm/yyyy');
	end if;

	dt_incl_uni304_ww	:= substr(ds_conteudo_p,121,2)||substr(ds_conteudo_p,119,2)||substr(ds_conteudo_p,115,4);
	if (dt_incl_uni304_ww <> '        ') then
		dt_incl_uni304_w	:= to_date(dt_incl_uni304_ww,'dd/mm/yyyy');
	end if;

	dt_exclu_uni_ww	:= substr(ds_conteudo_p,129,2)||substr(ds_conteudo_p,127,2)||substr(ds_conteudo_p,123,4);
	if (dt_exclu_uni_ww <> '        ') then
		dt_exclu_uni_w	:= to_date(dt_exclu_uni_ww,'dd/mm/yyyy');
	end if;

	dt_repasse_ww	:= substr(ds_conteudo_p,139,2)||substr(ds_conteudo_p,137,2)||substr(ds_conteudo_p,133,4);
	if (dt_repasse_ww <> '        ') then
		dt_repasse_w	:= to_date(dt_repasse_ww,'dd/mm/yyyy');
	end if;

	dt_base_carencia_ww	:= substr(ds_conteudo_p,147,2)||substr(ds_conteudo_p,145,2)||substr(ds_conteudo_p,141,4);
	if (dt_base_carencia_ww <> '        ') then
		dt_base_carencia_w	:= to_date(dt_base_carencia_ww,'dd/mm/yyyy');
	end if;

	dt_incl_plano_ww	:= substr(ds_conteudo_p,155,2)||substr(ds_conteudo_p,153,2)||substr(ds_conteudo_p,149,4);
	if (dt_incl_plano_ww <> '        ') then
		dt_incl_plano_w	:= to_date(dt_incl_plano_ww,'dd/mm/yyyy');
	end if;

	dt_incl_empr_uni_ww	:= substr(ds_conteudo_p,163,2)||substr(ds_conteudo_p,161,2)||substr(ds_conteudo_p,157,4);
	if (dt_incl_empr_uni_ww <> '        ') then
		dt_incl_empr_uni_w	:= to_date(dt_incl_empr_uni_ww,'dd/mm/yyyy');
	end if;

	ie_cooperativa_w := pls_obter_se_cooperativa(wheb_usuario_pck.get_cd_estabelecimento);

	if (ie_cooperativa_w = 'S') then
		cd_usuario_plano_w := coalesce(id_benef_w,0000000000000);
		cd_usuario_plano_ant_w := id_benef_ant_w;
		cd_titular_plano_w := coalesce(id_benef_tit_w,0000000000000);
	else
		cd_usuario_plano_benef_w := coalesce(id_benef_w,000000000000000000000000000000);
		cd_plano_benef_ant_w := id_benef_ant_w;
		cd_titular_benef_plano_w := coalesce(id_benef_tit_w,000000000000000000000000000000);
	end if;

	select	max(nr_sequencia)
	into STRICT	nr_seq_empresa_w
	from	ptu_mov_produto_empresa;

	insert into ptu_mov_produto_benef(nr_sequencia, nr_seq_empresa, cd_unimed,
		cd_familia, nm_benef_abreviado,
		cd_plano_destino, dt_nascimento, ie_sexo,
		ie_estado_civil, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, dt_inclusao,
		cd_dependencia, dt_repasse, dt_base_carencia,
		dt_inclusao_plano_dest, dt_inclusao_empr_uni, cd_cgc_cpf,
		nr_rg, sg_uf_rg, dt_exclusao,
		cd_unimed_anterior, vl_mensalidade,
		ie_filho, nr_identidade, ds_orgao_emissor,
		cd_pais, nm_beneficiario,
		cd_empresa_origem, ie_tipo_acomodacao,
		cd_usuario_plano, cd_usuario_plano_ant, cd_titular_plano,
		cd_usuario_plano_benef, cd_plano_benef_ant, cd_titular_benef_plano)
	values (nextval('ptu_mov_produto_benef_seq'), nr_seq_empresa_w, coalesce(cd_uni_w,0),
		cd_familia_w, nm_benef_w,
		cd_plano_des_w, dt_nasc_w, ie_sexo_w,
		cd_civil_w, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, dt_incl_uni304_w,
		coalesce(cd_depe_w,00), dt_repasse_w, dt_base_carencia_w,
		dt_incl_plano_w, dt_incl_empr_uni_w, cd_cgc_cpf304_w,
		cd_rg_w, cd_uf_rg_w, dt_exclu_uni_w,
		cd_uni_ant_w, vl_mensalidade_w,
		id_filho_w, cd_ident_w, ds_orgao_emissor_w,
		cd_pais_w, nm_compl_benef_w,
		cd_empr_ori304_w, ie_tipo_acomodacao_w,
		cd_usuario_plano_w, cd_usuario_plano_ant_w, cd_titular_plano_w,
		cd_usuario_plano_benef_w, cd_plano_benef_ant_w, cd_titular_benef_plano_w);

end if;

if (substr(ds_conteudo_p,9,3) = '306') then

	select	CASE WHEN (substr(ds_conteudo_p,82,8))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,82,8))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,122,4))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,122,4))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,126,8))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,126,8))::numeric  END ,
		CASE WHEN (substr(ds_conteudo_p,134,8))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,134,8))::numeric  END
	into STRICT	nr_cep306_w,
		nr_ddd306_w,
		nr_fone306_w,
		nr_ramal_w
	;

	ds_end_pri306_w		:= substr(ds_conteudo_p,12,40);
	ds_bairro306_w		:= substr(ds_conteudo_p,52,30);
	ds_cidade306_w		:= substr(ds_conteudo_p,90,30);
	cd_uf306_w		:= substr(ds_conteudo_p,120,2);

	select	max(nr_sequencia)
	into STRICT	nr_seq_benef_w
	from	ptu_mov_produto_benef;

	insert into ptu_movimento_benef_compl(nr_sequencia, nr_seq_beneficiario, ds_endereco,
		cd_cep, nm_municipio, sg_uf,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, ds_bairro, nr_ddd,
		nr_fone, nr_ramal)
	values (nextval('ptu_movimento_benef_compl_seq'), nr_seq_benef_w, ds_end_pri306_w,
		nr_cep306_w, ds_cidade306_w, cd_uf306_w,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, ds_bairro306_w, nr_ddd306_w,
		nr_fone306_w, nr_ramal_w);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_movimentacao_produto ( ds_conteudo_p text, nm_usuario_p text) FROM PUBLIC;
