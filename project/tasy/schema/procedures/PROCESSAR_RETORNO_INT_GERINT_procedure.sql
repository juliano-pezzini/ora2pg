-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE processar_retorno_int_gerint (nr_sequencia_p bigint) AS $body$
DECLARE


ds_log_w 						intpd_fila_transmissao.ds_message_response%type;
nr_seq_evento_w					gerint_evento_integracao.nr_sequencia%type;
retorno_w 						philips_json;
retorno_lista_w					philips_json_list;

ie_status_http_w				intpd_fila_transmissao.ie_status_http%type;
nr_seq_solic_inter_w			gerint_evento_integracao.nr_seq_solic_inter%type;
ie_evento_w						intpd_fila_transmissao.ie_evento%type;
i 								bigint;

ds_cod_erro_w					varchar(100);

ds_situacao_ret_w		varchar(40);
ie_situacao_ret_w		varchar(1);
ie_existe_solic_w		varchar(1);
ds_mensagem_ret_w		varchar(255);

-- Cadastro de pessoa fisica
cd_pessoa_fisica_w			pessoa_fisica.cd_pessoa_fisica%type;
dt_nascimento_w 			pessoa_fisica.dt_nascimento%type;
nr_cpf_w 					varchar(15);
nr_cartao_sus_w 			pessoa_fisica.nr_cartao_nac_sus%type;
nm_pessoa_fisica_w 			varchar(255);
nm_mae_w					varchar(255);
ds_logradouro_w				varchar(255);	
nr_logradouro_w				varchar(255);
ds_complemento_w			varchar(255);	
ds_bairro_w					varchar(255);
nr_cep_w					compl_pessoa_fisica.cd_cep%type;
ds_municipio_residencia_w	varchar(255);
ds_municipio_nascimento_w	varchar(255);
ds_sexo_w					varchar(15);
nr_telefone_w				varchar(255);
ds_nacionalidade_w			varchar(60);
ds_raca_cor_w				varchar(14);
ds_estado_civil_w			varchar(20);
nr_cerih_w					varchar(12);
ds_tipo_leito_w				varchar(60);
cd_estabelecimento_w		gerint_evento_integracao.cd_estabelecimento%type;
nm_usuario_w				gerint_evento_integracao.nm_usuario%type;
ds_stack_w					varchar(2000);
ie_reg_transf_w				varchar(1);


BEGIN
	
	select	ds_message_response,
			nr_seq_documento,
			ie_status_http,
			ie_evento
	into STRICT	ds_log_w,
			nr_seq_evento_w,
			ie_status_http_w,
			ie_evento_w
	from	intpd_fila_transmissao
	where	nr_sequencia = nr_sequencia_p;	
	
	select 	max(nr_seq_solic_inter),
			max(cd_estabelecimento),
			max(nm_usuario)
	into STRICT	nr_seq_solic_inter_w,
			cd_estabelecimento_w,
			nm_usuario_w
	from	gerint_evento_integracao
	where	nr_sequencia = nr_seq_evento_w;

	ie_situacao_ret_w := null;
	ds_mensagem_ret_w := null;
	begin
		if (substr(ie_status_http_w,1,1) = '2') then
			if (ie_evento_w = '100') and (ds_log_w IS NOT NULL AND ds_log_w::text <> '') then --Servico de consulta da situacao das Solicitacoes
				
				retorno_lista_w := philips_json_list(ds_log_w);
				FOR i IN 1..retorno_lista_w.count LOOP
					retorno_w	:= philips_json(retorno_lista_w.get(i));
					
					ds_situacao_ret_w := substr(retorno_w.get['situacao'].get_string(),1,40);
					
					insert 	into gerint_consulta_solic(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_protocolo_solicitacao,
								ds_situacao,
								dt_solicitacao,
								nm_unidade_encaminhada,
								nr_cnes_unid_encamin,
								nr_seq_evento
							) values (
								nextval('gerint_consulta_solic_seq'),
								clock_timestamp(),
								'GERINT',
								clock_timestamp(),
								'GERINT',
								substr(obter_somente_numero(retorno_w.get['numeroCERIH'].get_string()),1,12),
								ds_situacao_ret_w,
								to_date('1970-01-01','yyyy-mm-dd') + retorno_w.get['dataSolicitacao'].get_number()/86400000,
								substr(retorno_w.get['nomeUnidadeEncaminhada'].get_string(),1,255),
								substr(retorno_w.get['cnesUnidadeEncaminhada'].get_string(),1,255),
								nr_seq_evento_w
							);
					--Verifica se a solicitacao e de transferencia.
					select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
					into STRICT	ie_reg_transf_w
					from	gerint_solic_internacao
					where	nr_cerih_transf = substr(obter_somente_numero(retorno_w.get['numeroCERIH'].get_string()),1,12)
					and		ie_situacao = 'R';
					
					if ((ie_reg_transf_w = 'S') and (upper(ds_situacao_ret_w) = 'INTERNACAO_AUTORIZADA')) then
						update	gerint_solic_internacao
						set		ie_situacao = 'T'
						where	nr_cerih_transf = substr(obter_somente_numero(retorno_w.get['numeroCERIH'].get_string()),1,12)
						and		ie_situacao = 'R';
					elsif (upper(ds_situacao_ret_w) = 'INTERNACAO_AUTORIZADA') then
						update	gerint_solic_internacao
						set		ie_situacao = 'A'
						where	nr_protocolo_solicitacao = substr(obter_somente_numero(retorno_w.get['numeroCERIH'].get_string()),1,12)
						and		ie_situacao = 'R';
					end if;
				END LOOP;
			
			elsif (ie_evento_w = '136') and (ds_log_w IS NOT NULL AND ds_log_w::text <> '') then --Servico de solicitacao de transferencia de paciente internado
				
				retorno_w	:= philips_json(ds_log_w);
				
				update	gerint_evento_int_dados
				set		NR_CERIH_TRANSF 			= substr(retorno_w.get['numeroCERIH'].get_string(),1,12),
						DS_PROCEDIMENTO_RET_TRANSF 	= substr(retorno_w.get['procedimento'].get_string(),1,100),
						NR_CARTAO_SUS_RET_TRANSF 	= substr(retorno_w.get['cartaoSUS'].get_string(),1,15)
				where	nr_seq_evento 				= nr_seq_evento_w;
				
				ie_situacao_ret_w := 'R';
				if (substr(retorno_w.get['situacao'].get_string(),1,40) = 'INTERNACAO_AUTORIZADA') then
					ie_situacao_ret_w := 'T';
				end if;
				
				update	gerint_solic_internacao
				set		NR_CERIH_TRANSF = substr(retorno_w.get['numeroCERIH'].get_string(),1,12),
						ie_situacao 	= ie_situacao_ret_w
				where	nr_sequencia 	= nr_seq_solic_inter_w;				
				
			elsif (ie_evento_w = '124') and (ds_log_w IS NOT NULL AND ds_log_w::text <> '') then --Servico de consulta das Solicitacoes de um executante
				retorno_lista_w := philips_json_list(ds_log_w);
				FOR i IN 1..retorno_lista_w.count LOOP
					retorno_w	:= philips_json(retorno_lista_w.get(i));
					
					
					dt_nascimento_w 			:= to_date(substr(retorno_w.get['dataNascimento'].get_string(),1,10),'dd/mm/yyyy');
					nr_cpf_w 					:= substr(retorno_w.get['cpf'].get_string(),1,15);
					nr_cartao_sus_w 			:= substr(retorno_w.get['cartaoSUSPaciente'].get_string(),1,15);
					nm_pessoa_fisica_w 			:= substr(retorno_w.get['nomePaciente'].get_string(),1,255);
					nm_mae_w					:= substr(retorno_w.get['nomeMae'].get_string(),1,255);
					ds_logradouro_w				:= substr(retorno_w.get['logradouro'].get_string(),1,255);
					nr_logradouro_w				:= substr(retorno_w.get['numero'].get_string(),1,255);
					ds_complemento_w			:= substr(retorno_w.get['complemento'].get_string(),1,255);
					ds_bairro_w					:= substr(retorno_w.get['bairro'].get_string(),1,255);
					nr_cep_w					:= substr(retorno_w.get['cep'].get_string(),1,10);
					ds_municipio_residencia_w	:= substr(retorno_w.get['municipioResidencia'].get_string(),1,255);
					ds_municipio_nascimento_w	:= substr(retorno_w.get['municipioNascimento'].get_string(),1,255);
					ds_sexo_w					:= substr(retorno_w.get['sexo'].get_string(),1,15);
					nr_telefone_w				:= substr(retorno_w.get['telefones'].get_string(),1,255);
					ds_nacionalidade_w			:= substr(retorno_w.get['nacionalidade'].get_string(),1,60);
					ds_raca_cor_w				:= substr(retorno_w.get['racaCor'].get_string(),1,14);
					ds_estado_civil_w			:= substr(retorno_w.get['estadoCivil'].get_string(),1,20);
					nr_cerih_w					:= substr(retorno_w.get['numeroCERIH'].get_string(),1,12);
					ds_tipo_leito_w				:= substr(retorno_w.get['tipoLeito'].get_string(),1,60);
					
					--Verifica se a pessoa fisica ja esta cadastrada.
					select	max(cd_pessoa_fisica)
					into STRICT	cd_pessoa_fisica_w
					from	pessoa_fisica
					where	dt_nascimento = dt_nascimento_w
					and		((nr_cpf = nr_cpf_w) or (nr_cartao_nac_sus = nr_cartao_sus_w));
							
					if (coalesce(cd_pessoa_fisica_w::text, '') = '') then
						select	max(cd_pessoa_fisica)
						into STRICT	cd_pessoa_fisica_w
						from	gerint_solic_executante
						where	nr_protocolo_origem = nr_cerih_w;
					end if;
						 	
					--Se nao encontrou, cadastra a pessoa.
					if (coalesce(cd_pessoa_fisica_w::text, '') = '') then
						
						select	nextval('pessoa_fisica_seq')
						into STRICT	cd_pessoa_fisica_w
						;	
						
						--pessoa fisica
						insert into pessoa_fisica(	cd_pessoa_fisica,
										nm_pessoa_fisica,
										dt_nascimento,
										ie_sexo,
										nr_ddd_celular,
										nr_telefone_celular,
										ie_revisar,
										nr_cpf,
										nr_cartao_nac_sus,
										cd_nacionalidade,
										nr_seq_cor_pele,
										ie_estado_civil,
										ie_tipo_pessoa,
										dt_atualizacao,
										dt_atualizacao_nrec, 
										nm_usuario,
										nm_usuario_nrec,
										cd_municipio_ibge)
								values (	cd_pessoa_fisica_w,
										substr(nm_pessoa_fisica_w,1,60),
										dt_nascimento_w,
										substr(ds_sexo_w,1,1),
										obter_somente_numero(substr(nr_telefone_w,1,4)),
										substr(nr_telefone_w,5,40),
										'N',
										nr_cpf_w,
										nr_cartao_sus_w,
										Obter_Conversao_interna_int(null, 'NACIONALIDADE', 'CD_NACIONALIDADE', ds_nacionalidade_w, 'GERINT'),
										Obter_Conversao_interna_int(null, 'COR_PELE', 'NR_SEQ_COR_PELE', ds_raca_cor_w, 'GERINT'),
										Obter_Conversao_interna_int(null, 'PESSOA_FISICA', 'IE_ESTADO_CIVIL', ds_estado_civil_w, 'GERINT'),
										'2',
										clock_timestamp(),
										clock_timestamp(),
										'GERINT',
										'GERINT',
										substr(ds_municipio_nascimento_w,1,6));	
										
						--Complemento residencial
						insert into compl_pessoa_fisica(
										cd_pessoa_fisica,
										nr_sequencia,
										ie_tipo_complemento,
										ds_endereco,
										nr_endereco,
										ds_complemento,
										ds_bairro,
										cd_cep,
										cd_municipio_ibge,
										nm_usuario,
										nm_usuario_nrec,
										dt_atualizacao,
										dt_atualizacao_nrec)
									values (
										cd_pessoa_fisica_w,
										1,
										4,
										substr(ds_logradouro_w,1,100),
										substr(nr_logradouro_w,1,5),
										substr(ds_complemento_w,1,40),
										substr(ds_bairro_w,1,80),
										obter_somente_numero(nr_cep_w),
										substr(ds_municipio_residencia_w,1,6),
										'GERINT',
										'GERINT',
										clock_timestamp(),
										clock_timestamp());
										
						--Complemento mae
						insert into compl_pessoa_fisica(
										cd_pessoa_fisica,
										nr_sequencia,
										ie_tipo_complemento,
										nm_contato,
										nm_usuario,
										nm_usuario_nrec,
										dt_atualizacao,
										dt_atualizacao_nrec)
									values (
										cd_pessoa_fisica_w,
										2,
										5,
										nm_mae_w,
										'GERINT',
										'GERINT',
										clock_timestamp(),
										clock_timestamp());									
					end if;
				
					
					--Grava os dados recebidos.
					insert 	into GERINT_SOLIC_EXECUTANTE(
								nr_sequencia,
								nr_seq_evento,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_protocolo_origem,
								nr_cartao_sus,
								cd_pessoa_fisica,
								nm_pessoa_fisica,
								nm_mae,
								dt_nascimento,
								ds_logradouro,
								nr_logradouro,
								ds_complemento,
								ds_bairro,
								cd_cep,
								ds_municipio_nascimento,
								ds_municipio_residencia,
								ds_sexo,
								nr_telefone,
								nr_cpf,
								ds_nacionalidade,
								ds_raca,
								ds_estado_civil,
								ds_tipo_leito,
								nm_procedimento,
								cd_procedimento,
								ds_cid_principal,
								cd_cid_principal,
								ds_sinais_sintomas,
								ds_justificativa_internacao,
								ds_cid_secundario,
								cd_cid_secundario,
								ds_comorbidade1,
								cd_comorbidade1,
								ds_comorbidade2,
								cd_comorbidade2,
								ds_comorbidade3,
								cd_comorbidade3
							) values (
								nextval('gerint_solic_executante_seq'),
								nr_seq_evento_w,
								clock_timestamp(),
								'GERINT',
								clock_timestamp(),
								'GERINT',
								nr_cerih_w,
								nr_cartao_sus_w,
								cd_pessoa_fisica_w,
								nm_pessoa_fisica_w,
								nm_mae_w,
								dt_nascimento_w,
								ds_logradouro_w,
								nr_logradouro_w,
								ds_complemento_w,
								ds_bairro_w,
								nr_cep_w,
								ds_municipio_nascimento_w,
								ds_municipio_residencia_w,
								ds_sexo_w,
								nr_telefone_w,
								nr_cpf_w,
								ds_nacionalidade_w,
								ds_raca_cor_w,
								ds_estado_civil_w,
								ds_tipo_leito_w,
								substr(retorno_w.get['nomeProcedimento'].get_string(),1,255),
								substr(retorno_w.get['codigoProcedimento'].get_string(),1,10),
								substr(retorno_w.get['descricaoCID'].get_string(),1,255),
								substr(retorno_w.get['codigoCID'].get_string(),1,4),
								substr(retorno_w.get['sinaisSintomas'].get_string(),1,2000),
								substr(retorno_w.get['justificativaInternacao'].get_string(),1,2000),
								substr(retorno_w.get['descrCidSecundario'].get_string(),1,255),
								substr(retorno_w.get['codCidSecundario'].get_string(),1,4),
								substr(retorno_w.get['descrComorbidade1'].get_string(),1,255),
								substr(retorno_w.get['codComorbidade1'].get_string(),1,4),
								substr(retorno_w.get['descrComorbidade2'].get_string(),1,255),	
								substr(retorno_w.get['codComorbidade2'].get_string(),1,4),
								substr(retorno_w.get['descrComorbidade3'].get_string(),1,255),
								substr(retorno_w.get['codComorbidade3'].get_string(),1,4)
							);
							
					--Gera as solicitacoes de internacao ja aprovadas caso ainda nao existir.
					select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
					into STRICT	ie_existe_solic_w
					from 	gerint_solic_internacao
					where	nr_protocolo_solicitacao = nr_cerih_w;
					
					if (ie_existe_solic_w = 'N') then
						insert into gerint_solic_internacao(
													nr_sequencia,
													cd_estabelecimento,
													dt_atualizacao,
													nm_usuario,
													dt_atualizacao_nrec,
													nm_usuario_nrec,
													cd_pessoa_fisica,
													nm_pessoa_fisica,
													nr_cartao_sus,
													nr_protocolo_solicitacao,
													nr_cpf_paciente,
													ie_sexo,
													qt_idade,
													ds_endereco_pf,
													ds_municipio_pf,
													ie_tipo_leito,
													cd_procedimento,
													ie_origem_proced,
													cd_cid_principal,
													ds_sinal_sintoma,
													ds_condicao_justifica,
													ie_situacao,
													cd_municipio_ibge
												) values (
													nextval('gerint_solic_internacao_seq'),
													cd_estabelecimento_w,
													clock_timestamp(),
													nm_usuario_w,
													clock_timestamp(),
													nm_usuario_w,
													cd_pessoa_fisica_w,
													substr(nm_pessoa_fisica_w,1,60),
													nr_cartao_sus_w,
													nr_cerih_w,
													nr_cpf_w,
													substr(ds_sexo_w,1,1),
													CASE WHEN coalesce(dt_nascimento_w::text, '') = '' THEN null  ELSE obter_idade(dt_nascimento_w,clock_timestamp(),'A') END ,
													ds_logradouro_w,
													substr(ds_municipio_residencia_w,1,100),
													Obter_Conversao_interna_int(null, 'GERINT_SOLIC_INTERNACAO', 'IE_TIPO_LEITO', ds_tipo_leito_w, 'GERINT'),
													substr(retorno_w.get['codigoProcedimento'].get_string(),1,10),
													7,
													substr(retorno_w.get['codigoCID'].get_string(),1,4),
													substr(retorno_w.get['sinaisSintomas'].get_string(),1,2000),
													substr(retorno_w.get['justificativaInternacao'].get_string(),1,2000),
													'A',
													substr(ds_municipio_residencia_w,1,6)
												);
					end if;		
					
				END LOOP;
			
			elsif (ds_log_w IS NOT NULL AND ds_log_w::text <> '') then
				retorno_w	:= philips_json(ds_log_w);
				
				
				if (ie_evento_w = '96') then --Servico de solicitacao de internacao
					--Atualiza o status da solicitacao de internacao para INTERNACAO AUTORIZADA.
					ie_situacao_ret_w := 'N';
					if (substr(retorno_w.get['situacao'].get_string(),1,40) = 'INTERNACAO_AUTORIZADA') then
						ie_situacao_ret_w := 'A';
					elsif (substr(retorno_w.get['situacao'].get_string(),1,40) = 'AGUARDA_REGULACAO') then
						ie_situacao_ret_w := 'R';
					end if;
					
					if (ie_situacao_ret_w = 'N') then
						ds_mensagem_ret_w := substr(retorno_w.get['mensagem'].get_string(),1,255);
					end if;
					
					update	gerint_solic_internacao
					set		nr_protocolo_solicitacao = CASE WHEN ie_situacao_ret_w='N' THEN null  ELSE substr(retorno_w.get['numeroCERIH'].get_string(),1,12) END ,
							ie_situacao = ie_situacao_ret_w
					where	nr_sequencia = nr_seq_solic_inter_w;
					
				elsif (ie_evento_w = '107') then --Servico de reinternacao da solicitacao
					update	gerint_solic_internacao
					set		ie_situacao  = 'A'
					where	nr_sequencia = nr_seq_solic_inter_w;
					
				elsif (ie_evento_w = '25') then --Servico de ocupacao de leito sem solicitacao previa cadastrada no GERINT
	
					update	gerint_solic_internacao
					set		nr_protocolo_solicitacao = substr(retorno_w.get['numeroCERIH'].get_string(),1,12),
							ie_situacao = substr(retorno_w.get['situacao'].get_string(),1,12)
					where	nr_sequencia = nr_seq_solic_inter_w;
					
					update	gerint_evento_int_dados
					set		NR_PROTOCOLO_ORIGEM 			= substr(retorno_w.get['numeroCERIH'].get_string(),1,12),
							DT_INTERNACAO 	= substr(retorno_w.get['inicioInternacao'].get_string(),1,100),
							NR_CARTAO_SUS 	= substr(retorno_w.get['cartaoSUS'].get_string(),1,15)
					where	nr_seq_evento 	= nr_seq_evento_w;
					
					ds_mensagem_ret_w := coalesce(substr(retorno_w.get['mensagem'].get_string(),1,255), '');
					
				end if;
				
			end if;
			--Atualiza o status do evento da integracao para INTEGRADO COM SUCESSO.
			update 	gerint_evento_integracao
			set		ie_situacao = CASE WHEN ie_situacao_ret_w='N' THEN 'E'  ELSE 'S' END ,
					ds_retorno_mens_erro = ds_mensagem_ret_w
			where	nr_sequencia = nr_seq_evento_w;
			
			--Atualiza o status da fila de transmissao para SUCESSO.
			update	intpd_fila_transmissao
			set		ie_status = 'S'
			where	nr_sequencia = nr_sequencia_p;
		elsif (ds_log_w IS NOT NULL AND ds_log_w::text <> '') then
			retorno_w	:= philips_json(ds_log_w);
			
			update	gerint_evento_integracao
			set		ie_situacao = 'E',
					ds_tipo_erro = substr(retorno_w.get['tipoErro'].get_string(),1,100),
					ds_retorno_mens_erro = substr(retorno_w.get['mensagemErro'].get_string(),1,2000)
			where	nr_sequencia = nr_seq_evento_w;
			
			update	intpd_fila_transmissao
			set		ie_status = 'E'
			where	nr_sequencia = nr_sequencia_p;
			
			update	gerint_solic_internacao
			set		ie_situacao = 'N'
			where	nr_sequencia = nr_seq_solic_inter_w
			and		ie_situacao = 'O';
		end if;
	exception
		when others then
		
		ds_cod_erro_w 	:= substr(SQLSTATE,1,100);
		ds_stack_w		:= substr('Erro Stack: ' || Chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK(),1,2000);
		ds_stack_w		:= substr(ds_stack_w || Chr(10) || 'Erro Backtrace: ' || Chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(),1,2000);
		
		update	gerint_evento_integracao
		set		ie_situacao = 'E',
				ds_tipo_erro = ds_cod_erro_w,
				ds_retorno_mens_erro = ds_stack_w
		where	nr_sequencia = nr_seq_evento_w;
		
		update	intpd_fila_transmissao
		set		ie_status = 'E'
		where	nr_sequencia = nr_sequencia_p;
		
		update	gerint_solic_internacao
		set		ie_situacao = 'N'
		where	nr_sequencia = nr_seq_solic_inter_w
		and		ie_situacao = 'O';
	end;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processar_retorno_int_gerint (nr_sequencia_p bigint) FROM PUBLIC;

