-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprovacao_pre_cadastro (nm_usuario_p text, nr_seq_processo_p bigint, ie_tipo_processo_p text, ie_tipo_acao_p text) AS $body$
DECLARE

				

dt_liberacao_w						processo_pre_cadastro.dt_liberacao%type;
dt_atualizacao_nrec_w			processo_pre_cadastro.dt_atualizacao_nrec%type;
cd_cgc_w								pessoa_juridica_precad.cd_cgc%type;
nr_cpf_w								pessoa_fisica.nr_cpf%type;
dt_liberacao_p_fisica_w			pessoa_fisica_precad.dt_liberacao%type;
dt_liberacao_p_juridica_w		pessoa_juridica_precad.dt_liberacao%type;
dt_liberacao_material_w			material_precad.dt_liberacao%type;
ds_motivo_w						processo_precad_hist.ds_historico%type;
material_seq_w					material.cd_material%type;
nr_seq_doc_w					pessoa_juridica_doc.nr_sequencia%type;

c01 CURSOR FOR
	SELECT a.*, b.cd_cgc
	from pessoa_juridica_doc_precad a, pessoa_juridica_precad b
	where a.nr_seq_pes_jur_precad = b.nr_sequencia
	and b.nr_seq_processo = nr_seq_processo_p;
c01_w	c01%rowtype;

c02 CURSOR FOR
	SELECT *
	from pj_doc_anexo_precad
	where nr_seq_doc = c01_w.nr_sequencia;
c02_w	c02%rowtype;

c03 CURSOR FOR
	SELECT a.*, b.cd_cgc
	from pessoa_jurid_cont_precad a, pessoa_juridica_precad b
	where a.nr_seq_pes_jur_precad = b.nr_sequencia
	and b.nr_seq_processo = nr_seq_processo_p;
c03_w	c03%rowtype;

c04 CURSOR FOR
	SELECT a.*
	from pes_jur_conta_estab_precad a, pessoa_jurid_cont_precad b
	where a.cd_banco = c03_w.cd_banco
	and a.cd_agencia_bancaria = c03_w.cd_agencia_bancaria
	and a.nr_conta = c03_w.nr_conta
	and a.nr_seq_pes_conta_precad = b.nr_sequencia;
c04_w	c04%rowtype;
				

BEGIN
	
if (ie_tipo_acao_p = 'APROVADO')then

	select max(dt_liberacao)
	into STRICT dt_liberacao_w
	from processo_pre_cadastro
	where nr_sequencia = nr_seq_processo_p;

	select max(dt_atualizacao_nrec)
	into STRICT dt_atualizacao_nrec_w
	from processo_pre_cadastro
	where nr_sequencia = nr_seq_processo_p;

	select max(dt_liberacao)
	into STRICT dt_liberacao_p_fisica_w
	from pessoa_fisica_precad
	where nr_seq_processo = nr_seq_processo_p;
	
	select max(dt_liberacao)
	into STRICT dt_liberacao_p_juridica_w
	from pessoa_juridica_precad
	where nr_seq_processo = nr_seq_processo_p;
	
	select max(dt_liberacao)
	into STRICT dt_liberacao_material_w
	from material_precad
	where nr_seq_processo = nr_seq_processo_p;
	
	select max(b.cd_cgc)
	into STRICT 	cd_cgc_w
	from 	pessoa_juridica_precad a,
			pessoa_juridica b
	where a.nr_seq_processo = nr_seq_processo_p
	and 	b.cd_cgc = a.cd_cgc;
			
	select max(b.nr_cpf)
	into STRICT 	nr_cpf_w
	from 	pessoa_fisica_precad a,
			pessoa_fisica b
	where a.nr_seq_processo = nr_seq_processo_p
	and 	a.nr_cpf = b.nr_cpf;
	
	if (nr_cpf_w IS NOT NULL AND nr_cpf_w::text <> '') or (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '')then
		
		ds_motivo_w := 'Fornecedor ja possui cadastro';
		
		insert into processo_precad_hist(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										dt_liberacao,
										nm_usuario_lib,
										nr_seq_processo,
										ds_historico
										) values (
										nextval('processo_precad_hist_seq'),
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										dt_liberacao_w,
										nm_usuario_p,
										nr_seq_processo_p,
										ds_motivo_w);
		
	end if;
	
	if (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') and (dt_atualizacao_nrec_w IS NOT NULL AND dt_atualizacao_nrec_w::text <> '') and (dt_liberacao_p_fisica_w IS NOT NULL AND dt_liberacao_p_fisica_w::text <> '') or (dt_liberacao_p_juridica_w IS NOT NULL AND dt_liberacao_p_juridica_w::text <> '') or (dt_liberacao_material_w IS NOT NULL AND dt_liberacao_material_w::text <> '') then
	
		if (ie_tipo_processo_p = 'FPJ') and (coalesce(cd_cgc_w::text, '') = '')then
	
				insert into pessoa_juridica(cd_cgc,
												ds_razao_social,
												nm_fantasia,
												cd_tipo_pessoa,
												cd_cep,
												ds_endereco,
												ds_municipio,
												sg_estado,
												ie_prod_fabric,
												ie_situacao,
												nm_usuario,
												nr_endereco,
												nr_fax,
												ds_complemento,
												cd_uf_ibge,
												ds_email_nfe,
												ds_bairro,
												ds_email,
												nr_telefone,
												ds_observacao_compl,
												nr_seq_pais,
												nr_inscricao_estadual,
												nr_inscricao_municipal,
												ds_site_internet,
												ds_orgao_reg_resp_tecnico,
												nr_autor_func,
												nr_autor_receb_resid,
												nr_autor_transp_resid,
												nr_alvara_sanitario,
												dt_validade_autor_func,
												dt_validade_alvara_sanit,
												nr_seq_tipo_logradouro,
												nm_usuario_revisao,
												ds_nome_abrev,
												ds_resp_tecnico,
												nm_pessoa_contato,
												ds_observacao,
												ds_orientacao_cobranca,
												nr_ramal_contato,
												dt_atualizacao,
												dt_atualizacao_nrec,
												nm_usuario_nrec)
				SELECT cd_cgc,
												ds_razao_social,
												nm_fantasia,
												cd_tipo_pessoa,
												cd_cep,
												ds_endereco,
												ds_municipio,
												sg_estado,
												ie_prod_fabric,
												'a',
												nm_usuario_p,
												nr_endereco,
												nr_fax,
												ds_complemento,
												cd_uf_ibge,
												ds_email_nfe,
												ds_bairro,
												ds_email,
												nr_telefone,
												ds_observacao_compl,
												nr_seq_pais,
												nr_inscricao_estadual,
												nr_inscricao_municipal,
												ds_site_internet,
												ds_orgao_reg_resp_tecnico,
												nr_autor_func,
												nr_autor_receb_resid,
												nr_autor_transp_resid,
												nr_alvara_sanitario,
												dt_validade_autor_func,
												dt_validade_alvara_sanit,
												nr_seq_tipo_logradouro,
												nm_usuario_revisao,
												ds_nome_abrev,
												ds_resp_tecnico,
												nm_pessoa_contato,
												ds_observacao,
												ds_orientacao_cobranca,
												nr_ramal_contato,
												clock_timestamp(),
												clock_timestamp(),
												nm_usuario_p
				from pessoa_juridica_precad
				where nr_seq_processo = nr_seq_processo_p;
		
			open c01;
			loop
			fetch c01 into
				c01_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				
					select nextval('pessoa_juridica_doc_seq')
					into STRICT   nr_seq_doc_w
					;

					insert into pessoa_juridica_doc( nr_sequencia,
													  dt_atualizacao,
													  nm_usuario,
													  dt_atualizacao_nrec,
													  nm_usuario_nrec,
													  cd_cgc,
													  dt_revisao,
													  nr_seq_tipo_docto,
													  cd_pessoa_responsavel,
													  qt_tempo_validade,
													  ie_comunic_resp_documento,
													  ie_comunic_comprador,
													  qt_dias_aviso_vencto,
													  cd_setor_responsavel,
													  ie_consiste_cotacao,
													  ie_comunic_todos_comprador,
													  ie_comunic_setor,
													  dt_emissao,
													  ds_observacao,
													  nr_registro,
													  cd_pessoa_documento,
													  ie_data_indeterminada,
													  ie_comunic_regra_envio,
													  ds_pf_responsavel,
													  cd_estabelecimento)
											 values ( nr_seq_doc_w,
													  clock_timestamp(),
													  nm_usuario_p,
													  clock_timestamp(),
													  nm_usuario_p,
													  c01_w.cd_cgc,
													  c01_w.dt_revisao,
													  c01_w.nr_seq_tipo_docto,
													  c01_w.cd_pessoa_responsavel,
													  c01_w.qt_tempo_validade,
													  c01_w.ie_comunic_resp_documento,
													  c01_w.ie_comunic_comprador,
													  c01_w.qt_dias_aviso_vencto,
													  c01_w.cd_setor_responsavel,
													  c01_w.ie_consiste_cotacao,
													  c01_w.ie_comunic_todos_comprador,
													  c01_w.ie_comunic_setor,
													  c01_w.dt_emissao,
													  c01_w.ds_observacao,
													  c01_w.nr_registro,
													  c01_w.cd_pessoa_documento,
													  c01_w.ie_data_indeterminada,
													  c01_w.ie_comunic_regra_envio,
													  c01_w.ds_pf_responsavel,
													  c01_w.cd_estabelecimento);							
																					
						open c02;
						loop
						fetch c02 into
							c02_w;
						EXIT WHEN NOT FOUND; /* apply on c02 */
							begin
							
								insert into pessoa_juridica_doc_anexo( nr_sequencia,
																	   dt_atualizacao,
																	   nm_usuario,
																	   dt_atualizacao_nrec,
																	   nm_usuario_nrec,
																	   ds_arquivo,
																	   ds_titulo,
																	   nr_seq_doc,
																	   nr_seq_tipo_anexo)
															  values ( nextval('pessoa_juridica_doc_anexo_seq'),
																	   clock_timestamp(),
																	   nm_usuario_p,
																	   clock_timestamp(),
																	   nm_usuario_p,
																	   c02_w.ds_arquivo,
																	   c02_w.ds_titulo,
																	   nr_seq_doc_w,
																	   c02_w.nr_seq_tipo_anexo);																	   					
						
							end;		
						end loop;
						close c02;	
					
				end;			
			end loop;
			close c01;
			
			open c03;
			loop
			fetch c03 into
				c03_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
			
					insert into pessoa_juridica_conta(nr_sequencia,
														cd_cgc,
														cd_banco,
														cd_agencia_bancaria,
														nr_conta,
														dt_atualizacao,
														nm_usuario,
														ie_situacao,
														nr_digito_conta,
														cd_camara_compensacao,
														ie_digito_agencia,
														ds_observacao,
														ie_conta_pagamento,
														ie_prestador_pls,
														cd_codigo_identificacao,
														ie_tipo_conta,
														ie_propriedade_conta,
														ie_conta_repasse,
														cd_cnpj_agencia,
														nr_cbu,
														ds_alias,
														cd_bic,
														cd_iban,
														ds_chave_pix)
												values (nextval('pessoa_juridica_conta_seq'),
														c03_w.cd_cgc,
														c03_w.cd_banco,
														c03_w.cd_agencia_bancaria,
														c03_w.nr_conta,
														clock_timestamp(),
														nm_usuario_p,
														c03_w.ie_situacao,
														c03_w.nr_digito_conta,
														c03_w.cd_camara_compensacao,
														c03_w.ie_digito_agencia,
														c03_w.ds_observacao,
														c03_w.ie_conta_pagamento,
														c03_w.ie_prestador_pls,
														c03_w.cd_codigo_identificacao,
														c03_w.ie_tipo_conta,
														c03_w.ie_propriedade_conta,
														c03_w.ie_conta_repasse,
														c03_w.cd_cnpj_agencia,
														c03_w.nr_cbu,
														c03_w.ds_alias,
														c03_w.cd_bic,
														c03_w.cd_iban,
														c03_w.ds_chave_pix);	
					
					open c04;
					loop
					fetch c04 into
						c04_w;
					EXIT WHEN NOT FOUND; /* apply on c04 */
						begin

							insert into pessoa_jur_conta_estab(nr_sequencia,
																dt_atualizacao,
																nm_usuario,
																cd_cgc,
																cd_banco,
																cd_agencia_bancaria,
																nr_conta,
																cd_estabelecimento)
														values (nextval('pessoa_jur_conta_estab_seq'),
																clock_timestamp(),
																nm_usuario_p,
																c03_w.cd_cgc,
																c03_w.cd_banco,
																c03_w.cd_agencia_bancaria,
																c03_w.nr_conta,
																c04_w.cd_estabelecimento);
						end;									
					end loop;
					close c04;
			
				end;
			end loop;
			close c03;
	
		end if;
	
		if (ie_tipo_processo_p = 'FPF')and (coalesce(nr_cpf_w::text, '') = '')then
		
				insert into pessoa_fisica(nm_pessoa_fisica,
													dt_nascimento,
													nr_identidade,
													ie_fornecedor,
													nr_cpf,
													cd_tipo_pj,
													nm_usuario,
													ie_tipo_pessoa,
													ie_sexo,
													ie_estado_civil,
													cd_nacionalidade,
													ie_grau_instrucao,
													ds_orgao_emissor_ci,
													nr_telefone_celular,
													cd_municipio_ibge,
													cd_medico,
													cd_empresa,
													nr_passaporte,
													nm_abreviado,
													ds_apelido,
													ds_observacao,
													cd_pessoa_fisica,
													dt_atualizacao_nrec,
													nm_usuario_nrec,
													dt_atualizacao
													)
				SELECT nm_pessoa_fisica,
													dt_nascimento,
													nr_identidade,
													ie_fornecedor,
													nr_cpf,
													cd_tipo_pj,
													nm_usuario_p,
													ie_tipo_pessoa,
													ie_sexo,
													ie_estado_civil,
													cd_nacionalidade,
													ie_grau_instrucao,
													ds_orgao_emissor_ci,
													nr_telefone_celular,
													cd_municipio_ibge,
													cd_medico,
													cd_empresa,
													nr_passaporte,
													nm_abreviado,
													ds_apelido,
													ds_observacao,
													nextval('pessoa_fisica_seq'),
													clock_timestamp(),
													nm_usuario_p,
													clock_timestamp()
				from pessoa_fisica_precad
				where nr_seq_processo = nr_seq_processo_p;
		end if;
		
		if (ie_tipo_processo_p = 'MAT') then
		
			select	nextval('material_seq')
			into STRICT	material_seq_w
			;		
		
			insert into material(ds_material,
													ds_reduzida,
													cd_classe_material,
													cd_unidade_medida_compra,
													cd_unidade_medida_estoque ,
													ie_material_estoque,
													ie_receita ,
													ie_cobra_paciente ,
													ie_baixa_inteira ,
													qt_minimo_multiplo_solic,
													qt_conv_compra_estoque,
													ie_tipo_material ,
													qt_conv_estoque_consumo,
													cd_material_estoque,
													ie_controle_medico,
													ie_bomba_infusao ,
													ie_diluicao ,
													ie_solucao,
													ie_mistura ,
													ie_gravar_obs_prescr ,
													ie_inf_ultima_compra,
													cd_material,
													dt_cadastramento,
													dt_atualizacao,
													ie_baixa_estoq_pac,
													ie_umidade_controlada,
													ie_abrigo_luz,
													cd_unidade_medida_consumo,
													nm_usuario,
													cd_fabricante,
													cd_unidade_medida_solic,
													dt_validade_reg_anvisa,
													ie_consignado,
													ie_curva_abc,
													ie_obrig_via_aplicacao,
													ie_padronizado,
													ie_preco_compra,
													ie_prescricao,
													ie_via_aplicacao,
													nr_certificado_aprovacao,
													nr_registro_anvisa,
													nr_seq_fabric,
													nr_seq_familia,
													qt_max_prescricao,
													nr_seq_grupo_rec,
													qt_prioridade_coml,
													cd_classif_fiscal,
													cd_sistema_ant,
													ie_disponivel_mercado,
													qt_peso_kg,
													qt_dias_validade,
													qt_horas_util_pac,
													qt_dia_terapeutico,
													qt_dia_profilatico,
													ds_mensagem,
													ie_situacao,
													dt_atualizacao_nrec,
													nm_usuario_nrec)
				SELECT ds_material,
													ds_reduzida,
													cd_classe_material,
													cd_unidade_medida_compra,
													cd_unidade_medida_estoque ,
													ie_material_estoque,
													ie_receita ,
													ie_cobra_paciente ,
													ie_baixa_inteira ,
													qt_minimo_multiplo_solic,
													qt_conv_compra_estoque,
													ie_tipo_material ,
													qt_conv_estoque_consumo,
													material_seq_w,
													ie_controle_medico,
													ie_bomba_infusao ,
													ie_diluicao ,
													ie_solucao,
													ie_mistura ,
													ie_gravar_obs_prescr ,
													ie_inf_ultima_compra ,
													material_seq_w,
													dt_cadastramento,
													dt_atualizacao,
													ie_baixa_estoq_pac,
													ie_umidade_controlada,
													ie_abrigo_luz,
													cd_unidade_medida_consumo,
													nm_usuario_p,
													cd_fabricante,
													cd_unidade_medida_solic,
													dt_validade_reg_anvisa,
													ie_consignado,
													ie_curva_abc,
													ie_obrig_via_aplicacao,
													ie_padronizado,
													ie_preco_compra,
													ie_prescricao,
													ie_via_aplicacao,
													nr_certificado_aprovacao,
													nr_registro_anvisa,
													nr_seq_fabric,
													nr_seq_familia,
													qt_max_prescricao,
													nr_seq_grupo_rec,
													qt_prioridade_coml,
													cd_classif_fiscal,
													cd_sistema_ant,
													ie_disponivel_mercado,
													qt_peso_kg,
													qt_dias_validade,
													qt_horas_util_pac,
													qt_dia_terapeutico,
													qt_dia_profilatico,
													ds_mensagem,
													ie_situacao,
													clock_timestamp(),
													nm_usuario_p													
				from material_precad
				where nr_seq_processo = nr_seq_processo_p;
		
		end if;
	
		update processo_pre_cadastro set
		nm_usuario_aprov = nm_usuario_p,
		dt_aprovacao = clock_timestamp() 
		where nr_sequencia = nr_seq_processo_p;
	
		insert into processo_precad_hist(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										dt_liberacao,
										nm_usuario_lib,
										nr_seq_processo,
										ds_historico
										) values (
										nextval('processo_precad_hist_seq'),
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										dt_liberacao_w,
										nm_usuario_p,
										nr_seq_processo_p,
										ie_tipo_acao_p);
	end if;
end if;

if (ie_tipo_acao_p = 'REPROVADO')then

	update processo_pre_cadastro set
	nm_usuario_reprov = nm_usuario_p,
	dt_reprovacao = clock_timestamp() 
	where nr_sequencia = nr_seq_processo_p;

	insert into processo_precad_hist(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										dt_liberacao,
										nm_usuario_lib,
										nr_seq_processo,
										ds_historico
										) values (
										nextval('processo_precad_hist_seq'),
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										dt_liberacao_w,
										nm_usuario_p,
										nr_seq_processo_p,
										ie_tipo_acao_p);

end if;

if (ie_tipo_acao_p = 'ESTORNAR REPROVACAO')then

	update processo_pre_cadastro set
	nm_usuario_reprov  = NULL,
	dt_reprovacao  = NULL 
	where nr_sequencia = nr_seq_processo_p;

	insert into processo_precad_hist(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										dt_liberacao,
										nm_usuario_lib,
										nr_seq_processo,
										ds_historico
										) values (
										nextval('processo_precad_hist_seq'),
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										dt_liberacao_w,
										nm_usuario_p,
										nr_seq_processo_p,
										ie_tipo_acao_p);	

end if;			
			
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprovacao_pre_cadastro (nm_usuario_p text, nr_seq_processo_p bigint, ie_tipo_processo_p text, ie_tipo_acao_p text) FROM PUBLIC;

