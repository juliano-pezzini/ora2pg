-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_triagem ( cd_agenda_dest_p bigint, dt_agenda_p timestamp, nr_seq_agenda_p bigint, ie_encaixe_urgencia_p text, cd_medico_p text, nm_usuario_p text, ie_tipo_reg_orig_p text, nr_seq_reg_orig_p bigint ) AS $body$
DECLARE


nr_seq_agenda_w		agenda_consulta.nr_sequencia%type;
cd_paciente_w		varchar(10);
nr_atendimento_w		bigint;
nr_minuto_duracao_w		bigint;
nr_seq_agenda_nova_w	bigint;
dt_agenda_futura_w		timestamp;
dt_nascimento_w		timestamp;
dt_agenda_w		timestamp;
ie_classif_agenda_w		varchar(05);
nr_seq_turno_w		bigint;
nr_seq_sala_w		bigint;
ie_atualizar_sala_w		varchar(1);
cd_turno_w		varchar(1);
cd_setor_agenda_w		bigint;
nr_seq_hora_w		bigint;
ie_gerar_pendencia_w	varchar(1);
cd_convenio_w		bigint;
cd_pessoa_fisica_ret_w	varchar(10);
cd_plano_ret_w		varchar(20);
cd_usuario_convenio_ret_w	varchar(30);
ds_erro_ret_w		varchar(255)	:= null;
cd_medico_Agenda_w	varchar(10);
ds_observacao_w		varchar(4000);		
ds_retorno_w	varchar(255);	

cd_prof_req_w 	agenda_consulta.cd_medico_req%type;
cd_med_req_w	agenda_consulta.cd_pessoa_indicacao%type;


BEGIN

if (nr_seq_reg_orig_p IS NOT NULL AND nr_seq_reg_orig_p::text <> '' AND ie_tipo_reg_orig_p IS NOT NULL AND ie_tipo_reg_orig_p::text <> '') then
	
	if (OBTER_SE_PF_MEDICO(cd_medico_p) = 'S') then
		cd_med_req_w	:= cd_medico_p;
	else
		cd_prof_req_w	:= cd_medico_p;
	end if;
	
	
	dt_agenda_w := dt_agenda_p;

	if ie_tipo_reg_orig_p in ('ESCUTA','SOAP','ATEND') then
		Select	max(cd_pessoa_fisica),
				max(nr_atendimento),
				coalesce(max(ie_gerar_pendencia),'N'),
				max(ds_observacao)
		into STRICT	cd_paciente_w,
				nr_atendimento_w,
				ie_gerar_pendencia_w,
				ds_observacao_w
		from 	atend_encaminhamento
		where 	nr_sequencia = nr_seq_reg_orig_p;
	end if;

	if (ie_encaixe_urgencia_p = 'S') then
		dt_agenda_w := clock_timestamp();
	end if;
	
	if (ie_gerar_pendencia_w = 'N') then

		if (cd_agenda_dest_p IS NOT NULL AND cd_agenda_dest_p::text <> '') and (dt_agenda_w IS NOT NULL AND dt_agenda_w::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
			
			ds_retorno_w := horario_livre_consulta(wheb_usuario_pck.get_cd_estabelecimento, cd_agenda_dest_p, 'N', dt_agenda_w, nm_usuario_p, 'S', 'N', 'N', 0, ds_retorno_w);

			if (ie_encaixe_urgencia_p = 'S') then

				select	min(nr_sequencia)
				into STRICT	nr_seq_agenda_w
				from	agenda_consulta
				where	cd_agenda = cd_agenda_dest_p
				and	trunc(dt_agenda) = trunc(dt_agenda_w)
				and	dt_agenda > clock_timestamp()
				and	coalesce(dt_chamada_atend::text, '') = ''
				and	coalesce(dt_cancelamento::text, '') = '';

			else

				nr_seq_agenda_w := nr_seq_agenda_p;

			end if;

			IF (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
			
				if (ie_encaixe_urgencia_p = 'S')  then
				
					Select 	max(nr_minuto_duracao),
						max(dt_agenda)
					into STRICT	nr_minuto_duracao_w,
						dt_agenda_futura_w
					from	agenda_consulta
					where 	nr_sequencia = nr_seq_agenda_w;

					begin
					select	OBTER_DATA_NASCTO_PF(cd_paciente_w)
					into STRICT	dt_nascimento_w
					;
					exception
					when others then
						dt_nascimento_w	:= null;
					end;

					select	max(cd_setor_agenda)
					into STRICT	cd_setor_agenda_w
					from	agenda
					where	cd_agenda	= cd_agenda_dest_p;
					
					select	coalesce(max(nr_seq_hora),0)+1
					into STRICT	nr_seq_hora_w
					from	agenda_consulta
					where	cd_agenda = cd_agenda_dest_p
					and	dt_agenda = dt_agenda_futura_w;
					
					select	obter_turno_encaixe_agecons(cd_agenda_dest_p,dt_agenda_futura_w)
					into STRICT	nr_seq_turno_w
					;
					
					select	coalesce(max(obter_valor_param_usuario(821,42,  obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)), 'E'),
						coalesce(max(obter_valor_param_usuario(821, 427,  obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)),'N')
					into STRICT	ie_classif_agenda_w,
						ie_atualizar_sala_w
					;
					
					if (ie_atualizar_sala_w = 'S') then
						select	max(nr_seq_sala)
						into STRICT	nr_seq_sala_w
						from	agenda_turno
						where	nr_sequencia = nr_seq_turno_w;
					end if;	
					
					select	obter_turno_horario_agenda(cd_agenda_dest_p, dt_agenda_futura_w)
					into STRICT	cd_turno_w
					;
				
					select	nextval('agenda_consulta_seq')
					into STRICT	nr_seq_agenda_nova_w
					;
					
				
					insert into agenda_consulta(
							nr_sequencia,
							cd_agenda,
							dt_agenda,					
							nr_minuto_duracao,
							ie_status_agenda,
							cd_pessoa_fisica,
							nm_paciente,
							nr_telefone,					
							cd_medico_req,					
							cd_pessoa_indicacao,
							cd_turno,					
							dt_agendamento,
							nm_usuario_origem,
							nm_usuario,
							dt_atualizacao,
							ie_encaixe,
							ie_classif_agenda,
							dt_nascimento_pac,
							qt_idade_pac,
							nr_seq_turno,
							nr_seq_hora,
							nr_seq_sala,
							cd_setor_atendimento,
							ds_observacao)
						values (
							nr_seq_agenda_nova_w,
							cd_agenda_dest_p,
							dt_agenda_futura_w,					
							nr_minuto_duracao_w,
							'N',
							cd_paciente_w,
							substr(obter_nome_pf(cd_paciente_w),1,60),
							substr(obter_fone_pac_agenda(cd_paciente_w),1,255),					
							cd_med_req_w,	
							cd_prof_req_w,
							cd_turno_w,					
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p,
							clock_timestamp(),
							'S',
							ie_classif_agenda_w,
							dt_nascimento_w,
							substr(obter_dados_pf(cd_paciente_w,'I'),1,255),
							nr_seq_turno_w,
							nr_seq_hora_w,
							nr_seq_sala_w,
							cd_setor_agenda_w,
							substr(ds_observacao_w,1,2000));
				
						commit;
				
				else
				
				
					update	agenda_consulta
					set	nm_usuario = nm_usuario_p,
						dt_atualizacao = clock_timestamp(),
						ie_status_agenda = 'N',
						cd_pessoa_fisica = cd_paciente_w,
						nm_paciente = 	substr(obter_nome_pf(cd_paciente_w),1,60),
						nr_telefone = 	substr(obter_fone_pac_agenda(cd_paciente_w),1,255),
						cd_medico_req = 	cd_med_req_w,
						cd_pessoa_indicacao = cd_prof_req_w,
						ie_encaixe = 	'N',
						dt_nascimento_pac = OBTER_DATA_NASCTO_PF(cd_paciente_w),
						qt_idade_pac =	substr(obter_dados_pf(cd_paciente_w,'I'),1,255),
						ds_observacao = substr((ds_observacao || ' ' ||ds_observacao_w),1,2000)
					where	nr_sequencia		= nr_seq_agenda_w;
					
					commit;
				
					CALL Gerar_Agenda_integrada_pep(cd_agenda_dest_p,dt_agenda_w,cd_paciente_w,coalesce(nr_seq_agenda_nova_w,nr_seq_agenda_w),nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento);
				
				end if;
			
			if (ie_tipo_reg_orig_p in ('ATEND','ESCUTA')) then
			
				if (trunc(clock_timestamp()) = trunc(dt_agenda_w)) then
				
					select 	obter_convenio_atendimento(nr_atendimento_w),
							agecons_obter_medico_agenda(cd_agenda_dest_p)
					into STRICT	cd_convenio_w,
							cd_medico_Agenda_w
					;
				
					SELECT * FROM Vincular_Atendimento_Agenda(nr_atendimento_w, cd_convenio_w, cd_pessoa_fisica_ret_w, cd_plano_ret_w, cd_usuario_convenio_ret_w, ds_erro_ret_w) INTO STRICT cd_convenio_w, cd_pessoa_fisica_ret_w, cd_plano_ret_w, cd_usuario_convenio_ret_w, ds_erro_ret_w;
					
					if (coalesce(ds_erro_ret_w::text, '') = '' ) then

								
					
						update 	agenda_consulta
						set 	nr_atendimento   = nr_atendimento_w,
								cd_convenio			= cd_convenio_w
						where	nr_sequencia		= coalesce(nr_seq_agenda_nova_w,nr_seq_agenda_w);
						
						commit;
						
						update	atendimento_paciente
						set		cd_medico_resp = cd_medico_Agenda_w
						where	nr_atendimento = nr_atendimento_w;

						commit;
					
					end if;					
				
				end if;
			
			end if;

			END IF;
		end if;
	end if;
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_triagem ( cd_agenda_dest_p bigint, dt_agenda_p timestamp, nr_seq_agenda_p bigint, ie_encaixe_urgencia_p text, cd_medico_p text, nm_usuario_p text, ie_tipo_reg_orig_p text, nr_seq_reg_orig_p bigint ) FROM PUBLIC;
