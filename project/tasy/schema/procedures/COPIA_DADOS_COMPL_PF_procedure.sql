-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_dados_compl_pf ( cd_pessoa_fisica_p text, ie_tipo_compl_origem_p bigint, ie_tipo_compl_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE

				
nr_sequencia_w	bigint;				

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
        		nr_ddd_fone_adic,
		nr_ddi_fax,
		nr_ddi_telefone,
		nr_ddi_fone_adic,
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
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_tipo_complemento = ie_tipo_compl_origem_p;
	
c01_w	c01%rowtype;


BEGIN

open C01;
	loop
	fetch C01 into	
		C01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		
		
		delete from	compl_pessoa_fisica
		where	cd_pessoa_fisica 	= cd_pessoa_fisica_p
		and	ie_tipo_complemento	= ie_tipo_compl_destino_p;
		
		CALL gravar_log_exclusao('COMPL_PESSOA_FISICA',nm_usuario_p,substr('CD_PESSOA_FISICA=' || cd_pessoa_fisica_p ||
					', IE_TIPO_COMPLEMENTO=' || ie_tipo_compl_destino_p || ' - COPIA_DADOS_COMPL_PF',1,255),'N');

		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT 	nr_sequencia_w
		from 	compl_pessoa_fisica
		where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
		
		
		
		insert into 	compl_pessoa_fisica(	cd_cep				,
					cd_empresa_refer		,
					cd_municipio_ibge		,    
					cd_profissao			,
					cd_tipo_logradouro		,
					cd_zona_procedencia		,
					ds_bairro			,
					ds_complemento			,
					ds_email			,
					ds_endereco			,
					ds_fax				,
					ds_fone_adic			,
					ds_fonetica			,
					ds_horario_trabalho		,
					ds_municipio			,
					ds_observacao			,
					ds_setor_trabalho		,
					ds_website			,
					ie_nf_correio			,
					ie_obriga_email			,
					nm_contato			,
					nm_contato_pesquisa		,
					nr_cpf				,
					nr_ddd_fax			,
					nr_ddd_telefone			,
                   				 nr_ddd_fone_adic        		,
					nr_ddi_fax			,
					nr_ddi_telefone			,
                    				nr_ddi_fone_adic      		 ,
					nr_endereco			,
					nr_identidade			,
					nr_matricula_trabalho		,
					nr_ramal			,
					nr_seq_ident_cnes		,
					nr_seq_pais			,
					nr_seq_parentesco		,
					nr_telefone			,
					qt_dependente			,
					sg_estado			,
					dt_atualizacao			,
					dt_atualizacao_nrec		,
					nm_usuario			,
					nm_usuario_nrec			,
					cd_pessoa_fisica		,
					ie_tipo_complemento		,
					nr_sequencia)
		values (C01_w.cd_cep,                           
		                 C01_w.cd_empresa_refer,         
		                 C01_w.cd_municipio_ibge,        
		                 C01_w.cd_profissao,         
		                 C01_w.cd_tipo_logradouro,
		                 C01_w.cd_zona_procedencia,
		                 C01_w.ds_bairro,
		                 C01_w.ds_complemento,
		                 C01_w.ds_email,
		                 C01_w.ds_endereco,
		                 C01_w.ds_fax,
		                 C01_w.ds_fone_adic,
		                 C01_w.ds_fonetica,
		                 C01_w.ds_horario_trabalho,
		                 C01_w.ds_municipio,
		                 C01_w.ds_observacao,
		                 C01_w.ds_setor_trabalho,
		                 C01_w.ds_website,
		                 C01_w.ie_nf_correio,
		                 C01_w.ie_obriga_email,	
		                 C01_w.nm_contato,
		                 C01_w.nm_contato_pesquisa,
		                 C01_w.nr_cpf,
		                 C01_w.nr_ddd_fax,
		                 C01_w.nr_ddd_telefone,
                         		C01_w.nr_ddd_fone_adic,
		                 C01_w.nr_ddi_fax,
		                 C01_w.nr_ddi_telefone,
                         		C01_w.nr_ddi_fone_adic,
		                 C01_w.nr_endereco,
		                 C01_w.nr_identidade,
		                 C01_w.nr_matricula_trabalho,
		                 C01_w.nr_ramal,
		                 C01_w.nr_seq_ident_cnes,
		                 C01_w.nr_seq_pais,
		                 C01_w.nr_seq_parentesco,
		                 C01_w.nr_telefone,
		                 C01_w.qt_dependente,
		                 C01_w.sg_estado,
		                clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				cd_pessoa_fisica_p,
				ie_tipo_compl_destino_p,
				nr_sequencia_w);
		end;
	end loop;
	close C01;
	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_dados_compl_pf ( cd_pessoa_fisica_p text, ie_tipo_compl_origem_p bigint, ie_tipo_compl_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
