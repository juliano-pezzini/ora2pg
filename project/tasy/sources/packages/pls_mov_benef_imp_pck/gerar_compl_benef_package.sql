-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mov_benef_imp_pck.gerar_compl_benef ( nr_seq_mov_segurado_p pls_mov_benef_segurado.nr_sequencia%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

nr_sequencia_compl_w	compl_pessoa_fisica.nr_sequencia%type;

cd_cep_w		compl_pessoa_fisica.cd_cep%type;
cd_municipio_ibge_w	compl_pessoa_fisica.cd_municipio_ibge%type;
cd_tipo_logradouro_w	compl_pessoa_fisica.cd_tipo_logradouro%type;
ds_bairro_w		compl_pessoa_fisica.ds_bairro%type;
ds_complemento_w	compl_pessoa_fisica.ds_complemento%type;
ds_email_w		compl_pessoa_fisica.ds_email%type;
ds_endereco_w		compl_pessoa_fisica.ds_endereco%type;
nr_ddd_telefone_w	compl_pessoa_fisica.nr_ddd_telefone%type;
nr_ddi_telefone_w	compl_pessoa_fisica.nr_ddi_telefone%type;
nr_endereco_w		compl_pessoa_fisica.nr_endereco%type;
nr_telefone_w		compl_pessoa_fisica.nr_telefone%type;
sg_estado_w		compl_pessoa_fisica.sg_estado%type;

nr_seq_solic_w		tasy_solic_alteracao.nr_sequencia%type;


C01 CURSOR FOR
	SELECT	a.*,
		(SELECT	count(1)
		from	compl_pessoa_fisica x
		where	x.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	x.ie_tipo_complemento = a.ie_tipo_complemento) qt_registro_compl
	from	pls_mov_benef_seg_compl a,
		pls_mov_benef_segurado	b
	where	b.nr_sequencia	= a.nr_seq_mov_segurado
	and	b.nr_sequencia	= nr_seq_mov_segurado_p;
BEGIN

for r_c01_w in C01 loop
	begin

	if (r_c01_w.qt_registro_compl = 0) then
		select	coalesce(max(nr_sequencia),0)+1
		into STRICT	nr_sequencia_compl_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		
		insert	into	compl_pessoa_fisica(	cd_pessoa_fisica, nr_sequencia, ie_tipo_complemento, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, cd_cep, cd_tipo_logradouro,
				ds_endereco, nr_endereco, ds_complemento, ds_bairro,
				sg_estado, cd_municipio_ibge, ds_email, nr_ddi_telefone,
				nr_ddd_telefone, nr_telefone )
			values (	cd_pessoa_fisica_p, nr_sequencia_compl_w, r_c01_w.ie_tipo_complemento ,clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, r_c01_w.cd_cep, r_c01_w.cd_tipo_logradouro,
				r_c01_w.ds_endereco, r_c01_w.nr_endereco, r_c01_w.ds_complemento, r_c01_w.ds_bairro,
				r_c01_w.sg_estado, r_c01_w.cd_municipio_ibge, r_c01_w.ds_email, r_c01_w.nr_ddi_telefone,
				r_c01_w.nr_ddd_telefone, r_c01_w.nr_telefone );
	else
		select	cd_cep,
			cd_municipio_ibge,
			cd_tipo_logradouro,
			ds_bairro,
			ds_complemento,
			ds_email,
			ds_endereco,       
			nr_ddd_telefone,
			nr_ddi_telefone,        
			nr_endereco,
			nr_telefone,
			sg_estado
		into STRICT	cd_cep_w,
			cd_municipio_ibge_w,
			cd_tipo_logradouro_w,
			ds_bairro_w,
			ds_complemento_w,
			ds_email_w,
			ds_endereco_w,       
			nr_ddd_telefone_w,
			nr_ddi_telefone_w,        
			nr_endereco_w,
			nr_telefone_w,
			sg_estado_w	
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	ie_tipo_complemento = r_c01_w.ie_tipo_complemento;

		if (coalesce(r_c01_w.cd_cep,cd_cep_w) <> cd_cep_w) then
			pls_gravar_solic_alteracao(cd_cep_w, r_c01_w.cd_cep, 'CD_CEP','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.cd_municipio_ibge,cd_municipio_ibge_w) <> cd_municipio_ibge_w) then
			pls_gravar_solic_alteracao(cd_municipio_ibge_w, r_c01_w.cd_municipio_ibge,'CD_MUNICIPIO_IBGE','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.cd_tipo_logradouro,cd_tipo_logradouro_w) <> cd_tipo_logradouro_w) then
			pls_gravar_solic_alteracao(cd_tipo_logradouro_w, r_c01_w.cd_tipo_logradouro, 'CD_TIPO_LOGRADOURO','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.ds_bairro,ds_bairro_w) <> ds_bairro_w) then
			pls_gravar_solic_alteracao(ds_bairro_w, r_c01_w.ds_bairro, 'DS_BAIRRO','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.ds_complemento,ds_complemento_w) <> ds_complemento_w) then
			pls_gravar_solic_alteracao(ds_complemento_w, r_c01_w.ds_complemento,'DS_COMPLEMENTO','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.ds_email,ds_email_w) <> ds_email_w) then
			pls_gravar_solic_alteracao(ds_email_w, r_c01_w.ds_email,'DS_EMAIL','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.ds_endereco,ds_endereco_w) <> ds_endereco_w) then
			pls_gravar_solic_alteracao(ds_endereco_w, r_c01_w.ds_endereco,'DS_ENDERECO','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.nr_ddd_telefone,nr_ddd_telefone_w) <> nr_ddd_telefone_w) then
			pls_gravar_solic_alteracao(nr_ddd_telefone_w, r_c01_w.nr_ddd_telefone, 'NR_DDD_TELEFONE','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);	
		end if;
		if (coalesce(r_c01_w.nr_ddi_telefone,nr_ddi_telefone_w) <> nr_ddi_telefone_w) then
			pls_gravar_solic_alteracao(nr_ddi_telefone_w, r_c01_w.nr_ddi_telefone, 'NR_DDI_TELEFONE','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.nr_endereco,nr_endereco_w) <> nr_endereco_w) then
			pls_gravar_solic_alteracao(nr_endereco_w, r_c01_w.nr_endereco, 'NR_ENDERECO','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.nr_telefone,nr_telefone_w) <> nr_telefone_w) then
			pls_gravar_solic_alteracao(nr_telefone_w, r_c01_w.nr_telefone, 'NR_TELEFONE','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;
		if (coalesce(r_c01_w.sg_estado,sg_estado_w) <> sg_estado_w) then
			pls_gravar_solic_alteracao(sg_estado_w, r_c01_w.sg_estado, 'SG_ESTADO','COMPL_PESSOA_FISICA',cd_pessoa_fisica_p,nm_usuario_p,null,
							    null,null,r_c01_w.ie_tipo_complemento,cd_estabelecimento_p,1286,nr_seq_solic_w);
		end if;		
	end if;
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_imp_pck.gerar_compl_benef ( nr_seq_mov_segurado_p pls_mov_benef_segurado.nr_sequencia%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;