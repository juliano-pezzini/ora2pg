-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE assumir_paciente_medico_pa ( ds_lista_atendimentos_p text, cd_medico_p text, ie_forma_assumir_p text, nm_usuario_p text, ie_assumir_med_regra_p INOUT text, ie_assumir_med_ini_enf_p INOUT text) AS $body$
DECLARE


ds_lista_atendimentos_w	varchar(2000);
ie_assumir_med_regra_w	varchar(1);
nr_atendimento_w	bigint;
nr_pos_virgula_w	bigint;
ie_consiste_inicio_enf_w	varchar(3);
ie_assumir_med_ini_enf_w	varchar(3);
dt_fim_triagem_w		timestamp;
ie_atualizar_medico_conta_w     varchar(1);
cd_medico_resp_ant_w		varchar(10);	
nm_setor_leito_w 		setor_atendimento.ds_setor_atendimento%type;
cd_cgc_w				    estabelecimento.cd_cgc%type;
nr_seq_interno_w		atend_paciente_unidade.nr_seq_interno%type;


BEGIN

ie_consiste_inicio_enf_w := obter_param_usuario(935, 114, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_consiste_inicio_enf_w);
ie_atualizar_medico_conta_w := obter_param_usuario(935, 150, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_atualizar_medico_conta_w);


if (ds_lista_atendimentos_p IS NOT NULL AND ds_lista_atendimentos_p::text <> '') and (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ds_lista_atendimentos_w	:= ds_lista_atendimentos_p;
	while(ds_lista_atendimentos_w IS NOT NULL AND ds_lista_atendimentos_w::text <> '') loop
		begin
		nr_pos_virgula_w	:= position(',' in ds_lista_atendimentos_w);
		if (nr_pos_virgula_w > 0) then
			begin
			nr_atendimento_w	:= (substr(ds_lista_atendimentos_w,1,nr_pos_virgula_w-1))::numeric;
			ds_lista_atendimentos_w	:= substr(ds_lista_atendimentos_w,nr_pos_virgula_w+1,length(ds_lista_atendimentos_w));
			if (nr_atendimento_w > 0) then
				begin
				
				select	substr(obter_se_assumir_pa_regra(nr_atendimento_w, cd_medico_p),1,1)
				into STRICT	ie_assumir_med_regra_w
				;
				
				ie_assumir_med_ini_enf_w := 'S';
				
				if (coalesce(ie_consiste_inicio_enf_w,'S') = 'N') then
				
					Select  max(dt_fim_triagem)					
					into STRICT	dt_fim_triagem_w
					from	atendimento_paciente
					where 	nr_atendimento = nr_atendimento_w;
					
					if (coalesce(dt_fim_triagem_w::text, '') = '') then
						ie_assumir_med_ini_enf_w := 'N';
					end if;
					
				end if;				
				
				if (ie_assumir_med_regra_w <> 'N') and (ie_assumir_med_ini_enf_w <> 'N')then
					begin					
					
					select	max(cd_medico_resp)
					into STRICT    cd_medico_resp_ant_w
					from 	atendimento_paciente 
					where 	nr_atendimento = nr_atendimento_w;					
					
					CALL assumir_paciente(nr_atendimento_w, cd_medico_p, ie_forma_assumir_p, nm_usuario_p);
					
					if (ie_atualizar_medico_conta_w = 'S') then					
						 CALL Atualizar_Medico_Conta(nr_atendimento_w, cd_medico_resp_ant_w, cd_medico_p, nm_usuario_p);
					end if;
					
					CALL gerar_lancamento_automatico(nr_atendimento_w, null, 221, nm_usuario_p, 0, null, null, null, null, null);
					
					select	obter_atepacu_paciente(nr_atendimento_w, 'IAA')
					into STRICT	nr_seq_interno_w
					;
					
					if (nr_seq_interno_w > 0)then
						select 	REPLACE(a.cd_setor_atendimento||'@'||substr(obter_nome_setor(a.cd_setor_atendimento),1,100),'.',' ')||'.'||REPLACE(a.cd_unidade_basica,'.',' ')||'.'||REPLACE(a.cd_unidade_compl,'.',' ') nome_setor_leito,
								(select max(e.cd_cgc) from estabelecimento e where e.cd_estabelecimento = obter_estab_atendimento(nr_atendimento_w)) cd_cgc
						into STRICT 	nm_setor_leito_w,
								cd_cgc_w
						from 	atend_paciente_unidade a
						where	a.nr_seq_interno = nr_seq_interno_w
						and 	a.nr_atendimento = nr_atendimento_w;
						
						-- Admissao realizada - Intregracao PFCS
						CALL pfcs_int_service_request(nr_atendimento_w, 'completed', 'order', 'E0401', 'Request for Bed', obter_pessoa_atendimento(nr_atendimento_w,'C'), nm_setor_leito_w, cd_cgc_w, nm_usuario_p, 'N');
					end if;
					
					end;
				elsif (ie_assumir_med_regra_w <> 'S') then
					ie_assumir_med_regra_p := 'N';
				else
					ie_assumir_med_ini_enf_w := 'N';
				end if;
				ie_assumir_med_ini_enf_p := ie_assumir_med_ini_enf_w;
				end;
			end if;
			end;
		else
			begin
			ds_lista_atendimentos_w	:= null;
			end;
		end if;
		end;
	end loop;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE assumir_paciente_medico_pa ( ds_lista_atendimentos_p text, cd_medico_p text, ie_forma_assumir_p text, nm_usuario_p text, ie_assumir_med_regra_p INOUT text, ie_assumir_med_ini_enf_p INOUT text) FROM PUBLIC;

