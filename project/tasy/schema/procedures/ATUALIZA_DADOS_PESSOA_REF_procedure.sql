-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dados_pessoa_ref ( cd_pessoa_fisica_p text, cd_pessoa_ref_p text, ie_tipo_complemento_p bigint, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	cd_cep,
		cd_empresa_refer,
		cd_municipio_ibge,
		cd_profissao,
		cd_tipo_logradouro,
		cd_zona_procedencia,
		ds_bairro,
		ds_complemento,
		ds_email,
		ds_endereco,
		ds_fax,
		ds_fone_adic,
		ds_fonetica,
		ds_horario_trabalho,
		ds_municipio,
		ds_observacao,
		ds_setor_trabalho,
		ds_website,
		ie_nf_correio,
		ie_obriga_email,
		nm_contato,
		nm_contato_pesquisa,
		nr_cpf,
		nr_ddd_fax,
		nr_ddd_telefone,
		nr_ddi_fax,
		nr_ddi_telefone,
		nr_endereco,
		nr_identidade,
		nr_matricula_trabalho,
		nr_ramal,
		nr_seq_ident_cnes,
		nr_seq_pais,
		nr_seq_parentesco,
		nr_telefone,
		qt_dependente,
		sg_estado,
		nr_sequencia
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_ref_p
	and	ie_tipo_complemento = 1;

c01_w	c01%rowtype;


BEGIN


open C01;
	loop
	fetch C01 into
		C01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update 	compl_pessoa_fisica
				set 	cd_cep				= C01_w.cd_cep,
					cd_empresa_refer			= C01_w.cd_empresa_refer,
					cd_municipio_ibge			= C01_w.cd_municipio_ibge,
					cd_profissao			= C01_w.cd_profissao,
					cd_tipo_logradouro			= C01_w.cd_tipo_logradouro,
					cd_zona_procedencia		= C01_w.cd_zona_procedencia,
					ds_bairro				= C01_w.ds_bairro,
					ds_complemento			= C01_w.ds_complemento,
					ds_email				= C01_w.ds_email,
					ds_endereco			= C01_w.ds_endereco,
					ds_fax				= C01_w.ds_fax,
					ds_fone_adic			= C01_w.ds_fone_adic,
					ds_fonetica			= C01_w.ds_fonetica,
					ds_horario_trabalho			= C01_w.ds_horario_trabalho,
					ds_municipio			= C01_w.ds_municipio,
					ds_observacao			= C01_w.ds_observacao,
					ds_setor_trabalho			= C01_w.ds_setor_trabalho,
					ds_website			= C01_w.ds_website,
					ie_nf_correio			= C01_w.ie_nf_correio,
					ie_obriga_email			= C01_w.ie_obriga_email,
					nm_contato			= C01_w.nm_contato,
					nm_contato_pesquisa		= C01_w.nm_contato_pesquisa,
					nr_cpf				= C01_w.nr_cpf,
					nr_ddd_fax			= C01_w.nr_ddd_fax,
					nr_ddd_telefone			= C01_w.nr_ddd_telefone,
					nr_ddi_fax			= C01_w.nr_ddi_fax,
					nr_ddi_telefone			= C01_w.nr_ddi_telefone,
					nr_endereco			= C01_w.nr_endereco,
					nr_identidade			= C01_w.nr_identidade,
					nr_matricula_trabalho		= C01_w.nr_matricula_trabalho,
					nr_ramal				= C01_w.nr_ramal,
					nr_seq_ident_cnes			= C01_w.nr_seq_ident_cnes,
					nr_seq_pais			= C01_w.nr_seq_pais,
					nr_seq_parentesco			= C01_w.nr_seq_parentesco,
					nr_telefone			= C01_w.nr_telefone,
					qt_dependente			= C01_w.qt_dependente,
					sg_estado			= C01_w.sg_estado,
					dt_atualizacao			= clock_timestamp(),
					dt_atualizacao_nrec		= clock_timestamp(),
					nm_usuario			= nm_usuario_p,
					nm_usuario_nrec			= nm_usuario_p
		where	cd_pessoa_fisica 	= cd_pessoa_fisica_p
		and	ie_tipo_complemento	= ie_tipo_complemento_p;
		end;
	end loop;
	close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dados_pessoa_ref ( cd_pessoa_fisica_p text, cd_pessoa_ref_p text, ie_tipo_complemento_p bigint, nm_usuario_p text) FROM PUBLIC;
