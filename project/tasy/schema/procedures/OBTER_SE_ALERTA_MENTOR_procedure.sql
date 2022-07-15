-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_alerta_mentor ( nr_atendimento_p bigint, ds_mensagem_p INOUT text, ie_acao_p INOUT text, ie_gravidade_p INOUT text, nr_seq_escala_p INOUT bigint, nr_seq_sinal_vital_p INOUT bigint, ds_deflagradores_p INOUT text, ie_fim_vida_p INOUT text, ie_doencas_atipica_p INOUT text, ds_mensagem_cliente_p INOUT text, ie_somente_alerta_p INOUT text) AS $body$
DECLARE


retorno_w                   varchar(255);
nm_usuario_w                varchar(15);
nr_sequencia_w              bigint;
dt_liberacao_med_w          timestamp;
qt_reg_w                    bigint;
qt_var_w                    bigint;
qt_susp_w                   bigint;
qt_grave_w                  bigint;
qt_geral_w                  bigint;
nr_seq_mentor_w             bigint;
ie_pessoa_destino_w         varchar(15);
cd_perfil_w                 integer;
cd_perfil_usuario_w         integer;
cd_pessoa_usuario_w         varchar(10);
nm_usuario_sepsis_w         varchar(15);
ie_status_sepsis_w          varchar(3);
ie_status_ant_sepsis_w      varchar(3);
ie_tipo_evolucao_w          varchar(3);
cd_pessoa_fisica_dest_w     varchar(10);
cd_pessoa_aux_enfer_dest_w  varchar(10);
ie_regra_sepse_w            varchar(3);
ds_sinal_w                  varchar(255);
ds_do_w                     varchar(255);
ds_sinais_w                 varchar(4000) := '';
ds_dos_w                    varchar(4000) := '';
ds_deflagradores_w          varchar(4000) := '';
cd_pf_destino_w             varchar(10);
cd_equipe_destino_w         bigint;
ds_mensagem_w               varchar(400) := '';
ie_acao_w                   varchar(15)  := '';
ie_gravidade_w              varchar(15)  := '';
nr_seq_escala_w             bigint;
nr_seq_sinal_vital_w        bigint;
qt_idade_w                  bigint;
cd_setor_Atendimento_w      integer;
dt_alta_w                   timestamp;
qt_regra_risco_enfermagem_w bigint;
ds_param_integ_hl7_w        varchar(4000);
ConstMedicoResponsavel_w    bigint := 1;
ConstMedicoAuxiliar_w       bigint := 2;
ConstUsuarioResponsavel_w   bigint := 3;
ConstEnfermeiroTurno_w      bigint := 4;
ConstTecEnfermagemTurno_w   bigint := 5;
ConstUsuarioFixo_w          bigint := 6;
ConstMedicoPlantonista_w    bigint := 7;
ConstProfissionalPlantao_w  bigint := 8;
ie_versao_sepse_w           varchar(10);
ie_transfusao_sepse_w       varchar(1);
ie_fim_vida_sepse_w			varchar(1);
ie_doencas_atipicas_sepse_w varchar(1);
qt_choqueS_w                bigint;
ie_tipo_sepse_w             varchar(1);
ds_mensagem_cliente_w		varchar(255) := '';
ie_somente_alerta_w			varchar(1);
		
C01 CURSOR FOR
	SELECT	nr_sequencia,
			qt_var_suspeita,
			qt_var_confirmada,
			ie_regra_sepse,
			ie_somente_alerta,
			ds_alerta_cliente
	from	gqa_pendencia_regra b
	where	((b.nr_seq_escala = 124 AND ie_tipo_sepse_w <> 'P') or (b.nr_seq_escala = 178 AND ie_tipo_sepse_w = 'P'))
	and		coalesce(b.cd_setor_atendimento,coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0)
	and		coalesce(qt_idade_w,0) between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,99999)
	and		ie_situacao = 'A'
	and		IE_REGRA_SEPSE = ie_status_sepsis_w;
	
C02 CURSOR FOR
	SELECT	c.ie_pessoa_destino,
			c.cd_pf_destino,
			c.cd_perfil,
            c.nr_seq_equipe
	from	gqa_pendencia_regra a,
			gqa_acao b,
			gqa_acao_regra_prof c
	where	a.nr_sequencia = b.nr_seq_pend_regra
	and		b.nr_sequencia = c.nr_seq_acao
	and		a.nr_sequencia = nr_seq_mentor_w
	and 	a.ie_situacao  = 'A'
	and		((coalesce(b.NR_SEQ_PROC::text, '') = '' and
			  coalesce(b.CD_PROTOCOLO::text, '') = '' and
			  coalesce(b.NR_SEQ_PROTOCOLO::text, '') = '')
	or (ie_status_sepsis_w in ('RC','RE','CS') or (ie_status_sepsis_w = 'SC' AND ie_versao_sepse_w = '2')));

C03 CURSOR FOR	
	SELECT	substr(obter_desc_atributo_sepse(nr_seq_atributo),1,255)				
	from	escala_sepse_item
	where	nr_seq_escala = nr_sequencia_w
	and		ie_resultado = 'S'
	and		nr_seq_atributo in (8,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,30,31,32,34, 51,54,55,56,59,60,61,62,65,66,67,41,42,72,95,102,103);

C04 CURSOR FOR	
	SELECT	substr(obter_desc_atributo_sepse(nr_seq_atributo),1,255)
	from	escala_sepse_item
	where	nr_seq_escala = nr_sequencia_w
	and		ie_resultado = 'S'
	and		nr_seq_atributo in (4,5,6,7,8,9,11,17,30,31,32,33,35, 47,48,49,50,51,59,41,95);
	
procedure verificar_regras is;
BEGIN
for mentor_infos in C01 loop
	begin			
	if (qt_geral_w >= coalesce(mentor_infos.qt_var_suspeita,0)) or (qt_var_w >= coalesce(mentor_infos.qt_var_confirmada,0)) then
		nr_seq_mentor_w := mentor_infos.nr_sequencia;
		for responsaveis in C02 loop
			begin
			if	( responsaveis.ie_pessoa_destino	= ConstMedicoResponsavel_w   AND cd_pessoa_usuario_w = cd_pessoa_fisica_dest_w) or
				( responsaveis.ie_pessoa_destino	= ConstUsuarioResponsavel_w  AND nm_usuario_sepsis_w = nm_usuario_w) or
				( responsaveis.ie_pessoa_destino	= ConstEnfermeiroTurno_w     AND cd_pessoa_aux_enfer_dest_w = cd_pessoa_usuario_w) or
				( responsaveis.ie_pessoa_destino	= ConstUsuarioFixo_w         AND responsaveis.cd_pf_destino = cd_pessoa_usuario_w) or
				(( responsaveis.ie_pessoa_destino	= ConstProfissionalPlantao_w) and (obter_pessoa_escala_gqa(nr_atendimento_p) = cd_pessoa_usuario_w)) or (responsaveis.cd_perfil = cd_perfil_usuario_w) or
				((responsaveis.nr_seq_equipe IS NOT NULL AND responsaveis.nr_seq_equipe::text <> '')                    and (obter_se_medico_equipe(responsaveis.nr_seq_equipe, cd_pessoa_usuario_w) = 'S'))
			--if (1 = 1)	
			then
				ie_acao_w := 'PED';
				ds_mensagem_w := '';
				if (ie_status_sepsis_w = 'SE') then --Status inicial, pode ir para SM ou SA
					if (ie_tipo_evolucao_w = '1') then
						ie_gravidade_w := 'SA';  --Medico
					else
						ie_gravidade_w := 'SM'; --Outros
					end if;
				else
					if (ie_status_sepsis_w not in ('SA','SM','RA')) then
						ie_acao_w := '';
					end if;	
					ie_gravidade_w := ie_status_sepsis_w;
				end if;
			end if;
			end;
		end loop;
	end if;	
	end;			
end loop;
end;
									
begin

if (coalesce(nr_atendimento_p,0) > 0) then	


	Select 	max(dt_alta)
	into STRICT	dt_alta_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;
	
	if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then

	goto Final;
	
	end if;
	

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
	cd_pessoa_usuario_w := Obter_Pessoa_Fisica_Usuario(nm_usuario_w,'C');
	cd_perfil_usuario_w := obter_perfil_ativo;
	
	select	coalesce(cd_medico_resp,0),
			Obter_Setor_Atendimento(nr_atendimento),
			Obter_Idade_PF(cd_pessoa_fisica,clock_timestamp(),'A')
	into STRICT	cd_pessoa_fisica_dest_w,
			cd_setor_atendimento_w,
			qt_idade_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;
	
	select	max(a.CD_PESSOA_FISICA)
	into STRICT	cd_pessoa_aux_enfer_dest_w
	from	atend_profissional a
	where	a.nr_atendimento = nr_atendimento_p
	and ((ie_profissional		= 'E') or (IS_COPY_BASE_LOCALE('es_MX') = 'S' and ie_profissional = '6'))
	and		a.nr_sequencia	= (	SELECT	max(x.nr_sequencia)
								from	atend_profissional x
								where	x.nr_atendimento = nr_atendimento_p
								and		x.ie_profissional = 'E');
								
	select	coalesce(max(ie_tipo_evolucao),'0')
	into STRICT	ie_tipo_evolucao_w
	from	usuario
	where	nm_usuario = nm_usuario_w;
	
	ie_tipo_sepse_w := coalesce(obter_se_sepse_liberada(nr_atendimento_p),'A');
	
	if (ie_tipo_sepse_w = 'P') then
		begin
			
		select 	max(a.nr_sequencia),
				max(a.nm_usuario_status),
				max(a.nr_seq_sv),
				max(a.ie_status_sepsis)
		into STRICT	nr_sequencia_w,
				nm_usuario_sepsis_w,
				nr_seq_sinal_vital_w,
				ie_status_sepsis_w
		from 	escala_sepse_infantil a
		where	nr_sequencia = (SELECT 	max(b.nr_sequencia)
								from 	escala_sepse_infantil b	
								where	b.nr_atendimento =   nr_atendimento_p
								and		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
								and		coalesce(b.dt_inativacao::text, '') = '');
									
		if (nr_sequencia_w > 0) then
		
			select count(a.nr_sequencia)
			into STRICT   qt_var_w
			from   escala_sepse_infantil_item a, sepse_atributo b
			where  a.nr_seq_escala = nr_sequencia_w
			and    a.nr_seq_atributo = b.nr_sequencia
			and	   a.ie_resultado = 'S'  
			and    b.ie_tipo = 'G'; --DO
			
			begin
				select *
				into STRICT   qt_geral_w
				from (SELECT count(*)
				from (select nr_seq_atributo
					  from   escala_sepse_infantil_item a, sepse_atributo b
					  where  a.nr_seq_escala = nr_sequencia_w
					  and    a.nr_seq_atributo = b.nr_sequencia
					  and	 a.ie_resultado = 'S'  
					  and    b.ie_tipo = 'S') --SIRS
				having sum(CASE WHEN nr_seq_atributo=81 THEN 1  ELSE CASE WHEN nr_seq_atributo=84 THEN 1  ELSE 0 END  END ) > 0) alias3; --Leucocitos / Temperatura
			exception when others then
				qt_geral_w := 0;
			end;			
			
			verificar_regras;

		end if;
		end;
	else
		begin
		select 	max(a.nr_sequencia),
				max(a.dt_liberacao_status),
				max(a.nm_usuario_status),
				max(a.nr_seq_sv),
				max(a.ie_status_sepsis)
		into STRICT	nr_sequencia_w,
				dt_liberacao_med_w,
				nm_usuario_sepsis_w,
				nr_seq_sinal_vital_w,
				ie_status_sepsis_w
		from 	escala_sepse a
		where	nr_sequencia = (SELECT 	max(b.nr_sequencia)
								from 	escala_sepse b	
								where	b.nr_atendimento =   nr_atendimento_p
								and		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
								and		coalesce(b.dt_inativacao::text, '') = '');	
								
		select coalesce(max(ie_versao_sepse),'1'), coalesce(max(ie_transfusao_sepse),'N'), coalesce(max(ie_fim_vida_sepse),'N'), coalesce(max(ie_doencas_atipicas_sepse),'N')
		into STRICT   ie_versao_sepse_w, ie_transfusao_sepse_w, ie_fim_vida_sepse_w, ie_doencas_atipicas_sepse_w
		from   parametro_medico
		where  cd_estabelecimento = obter_estabelecimento_ativo;
								
		if (ie_versao_sepse_w = '2') then
			if (ie_status_sepsis_w in ('RD','RF','SN')) then
				ie_status_sepsis_w := 'D';
			elsif (ie_status_sepsis_w = 'RE') then
				ie_status_sepsis_w := 'SC';
			end if;
		end if;
		
		select	coalesce(max(ie_tipo_evolucao),'0')
		into STRICT	ie_tipo_evolucao_w
		from	usuario
		where	nm_usuario = nm_usuario_w;


		select	coalesce(cd_medico_resp,0),
				Obter_Setor_Atendimento(nr_atendimento),
				Obter_Idade_PF(cd_pessoa_fisica,clock_timestamp(),'A')
		into STRICT	cd_pessoa_fisica_dest_w,
				cd_setor_atendimento_w,
				qt_idade_w
		from	atendimento_paciente
		where	nr_atendimento	= nr_atendimento_p;
		
		
		select	max(a.CD_PESSOA_FISICA)
		into STRICT	cd_pessoa_aux_enfer_dest_w
		from	atend_profissional a
		where	a.nr_atendimento = nr_atendimento_p
		and ((ie_profissional		= 'E') or (IS_COPY_BASE_LOCALE('es_MX') = 'S' and ie_profissional = '6'))
		and		a.nr_sequencia	= (	SELECT	max(x.nr_sequencia)
									from	atend_profissional x
									where	x.nr_atendimento = nr_atendimento_p
									and		x.ie_profissional = 'E');
				
		if	((nr_sequencia_w > 0) and
			((ie_status_sepsis_w <> 'RD') or (ie_versao_sepse_w = '2'))) then

			select	count(*)				
			into STRICT	qt_var_w
			from	escala_sepse_item
			where	nr_seq_escala = nr_sequencia_w
			and		ie_resultado = 'S'
			and		nr_seq_atributo in (8,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,30,31,32,34, 41,42,51,59,60,61,62,65,66,72,76,77,95,102,103);
			
			select	count(*)
			into STRICT	qt_geral_w
			from	escala_sepse_item
			where	nr_seq_escala = nr_sequencia_w
			and		ie_resultado = 'S'
			and		nr_seq_atributo in (4,5,6,7,8,9,11,17,30,31,32,33,35,47,48,49,50,54,55,56,75,95);		
			
			if (qt_var_w > 0) or (qt_geral_w > 0) then
						
				open C01;
				loop
				fetch C01 into	
					nr_seq_mentor_w,
					qt_susp_w,
					qt_grave_w,
					ie_regra_sepse_w,
					ie_somente_alerta_w,
					ds_mensagem_cliente_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
					begin
					
					if (qt_var_w >= coalesce(qt_grave_w,0)) and (qt_geral_w >= coalesce(qt_susp_w,0)) then
					
						if (qt_var_w > qt_grave_w) or ((ie_versao_sepse_w = '2') and (qt_var_w > 0) and (qt_var_w >= qt_grave_w)) then

							select	count(*)
							into STRICT	qt_regra_risco_enfermagem_w
							from	gqa_pendencia_regra b
							where	b.nr_seq_escala = 124
							and		coalesce(b.cd_setor_atendimento,coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0)
							and		coalesce(qt_idade_w,0) between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,99999)
							and		ie_situacao = 'A'
							and		ie_regra_sepse = 'RB';
							
							if (qt_regra_risco_enfermagem_w > 0) then
							
								ie_gravidade_w := 'R';
							
							else
							
								ie_gravidade_w := 'S';
								
							end if;
							
						else
							ie_gravidade_w := 'N';
						end if;	
						
						if ((ie_status_sepsis_w = 'SM' or ie_status_sepsis_w = 'RB') and ie_versao_sepse_w = '2') then
							ds_mensagem_cliente_p := ds_mensagem_cliente_w;
							ie_somente_alerta_p := ie_somente_alerta_w;
						end if;						
		
					
							open C02;
							loop
							fetch C02 into	
								ie_pessoa_destino_w,
								cd_pf_destino_w,
								cd_perfil_w,
								cd_equipe_destino_w;
							EXIT WHEN NOT FOUND; /* apply on C02 */
								begin

								if	(ie_pessoa_destino_w	= ConstMedicoResponsavel_w   AND cd_pessoa_usuario_w = cd_pessoa_fisica_dest_w)                      or
									(ie_pessoa_destino_w	= ConstUsuarioResponsavel_w  AND nm_usuario_sepsis_w = nm_usuario_w)                                 or
									(ie_pessoa_destino_w	= ConstEnfermeiroTurno_w     AND cd_pessoa_aux_enfer_dest_w = cd_pessoa_usuario_w)                   or
									(ie_pessoa_destino_w	= ConstUsuarioFixo_w         AND cd_pf_destino_w = cd_pessoa_usuario_w)                              or
									((ie_pessoa_destino_w	= ConstProfissionalPlantao_w) and (obter_pessoa_escala_gqa(nr_atendimento_p) = cd_pessoa_usuario_w))    or (cd_perfil_w = cd_perfil_usuario_w)                                                                                             or
									((cd_equipe_destino_w IS NOT NULL AND cd_equipe_destino_w::text <> '')                    and (obter_se_medico_equipe(cd_equipe_destino_w, cd_pessoa_usuario_w) = 'S'))
								then
																		
									If (ie_status_sepsis_w = 'SM') or (ie_status_sepsis_w = 'SA') then								
																		
										open C04;
										loop
										fetch C04 into	
											ds_sinal_w;
										EXIT WHEN NOT FOUND; /* apply on C04 */
											begin
											if (coalesce(ds_sinais_w::text, '') = '') then
												ds_sinais_w := substr(Wheb_mensagem_pck.get_texto(295787)||' '||chr(13)||ds_sinal_w,1,4000);
											else
												ds_sinais_w := substr(ds_sinais_w||chr(13)||ds_sinal_w,1,4000);
											end if;
											end;
										end loop;
										close C04;

										open C03;
										loop
										fetch C03 into	
											ds_do_w;
										EXIT WHEN NOT FOUND; /* apply on C03 */
											begin
											if (coalesce(ds_dos_w::text, '') = '') then
												ds_dos_w := substr(Wheb_mensagem_pck.get_texto(295788)||' '||chr(13)||ds_do_w,1,4000);
											else
												ds_dos_w := substr(ds_dos_w||chr(13)||ds_do_w,1,4000);
											end if;
											end;
										end loop;
										close C03;
										
										if (ds_sinais_w IS NOT NULL AND ds_sinais_w::text <> '') then
										
											ds_deflagradores_w := substr(ds_sinais_w||chr(13)||chr(10)||chr(13)||ds_dos_w,1,4000);
											
										elsif (ds_dos_w IS NOT NULL AND ds_dos_w::text <> '') then
											
											ds_deflagradores_w := substr(ds_dos_w,1,4000);
											
										end if;		

									end	if;
									
										
									if (ie_status_sepsis_w = 'SE') then
										
										if (ie_versao_sepse_w = '2') and (ie_transfusao_sepse_w = 'N') then
											ds_mensagem_w := substr(obter_desc_expressao(893832),1,255);
											ie_acao_w := 'Pv2';
										else
											ds_mensagem_w := substr(Wheb_mensagem_pck.get_texto(380549),1,255);
											ie_acao_w := 'P';
										end if;								

										goto Final;	
										
									elsif ((ie_status_sepsis_w = 'SM') or (ie_status_sepsis_w = 'SA')) and (ie_tipo_evolucao_w = '1') then				
																		 
										if (ie_versao_sepse_w = '2') then
											ie_fim_vida_p := ie_fim_vida_sepse_w;
											ie_doencas_atipica_p := ie_doencas_atipicas_sepse_w;
											if (ie_somente_alerta_w = 'S') then
												ds_mensagem_w := substr(obter_desc_expressao(893832) || '. ' || ds_mensagem_cliente_p,1,255);
											else
												ds_mensagem_w := substr(obter_desc_expressao(881708),1,255);
											end if;							
										else
											--ds_mensagem_w:=  substr('Foram detectados 1 ou mais sinais de alerta para sepsis na presenca de historia sugestiva de infeccao.'||chr(10)||chr(13)|| 'Voce deseja continuar o protocolo para deteccao precoce de sepsis confirmando os sinais de alerta e a presenca de sinais de disfuncao organica?',1,255);
											ds_mensagem_w:=  substr(Wheb_mensagem_pck.get_texto(380546),1,255);
										end if;
										
										ie_acao_w := 'E';

										goto Final;
									
									elsif (ie_status_sepsis_w = 'SM') and (ie_tipo_evolucao_w <> '1')then									
													
										if (ie_versao_sepse_w = '2') then
											if (ie_somente_alerta_w = 'S') then
												ds_mensagem_w := substr(obter_desc_expressao(893832) || '. ' || ds_mensagem_cliente_p,1,255);
											else
												ds_mensagem_w := substr(obter_desc_expressao(881708),1,255);
											end if;
										else
											ds_mensagem_w:=  substr(Wheb_mensagem_pck.get_texto(380546),1,255);
										end if;
										ie_acao_w := 'C';
										goto Final;
									
									elsif (ie_status_sepsis_w = 'RB') then
										if (ie_versao_sepse_w = '2') then
											if (ie_somente_alerta_w = 'S') then
												ds_mensagem_w := substr(obter_desc_expressao(893832) || '. ' || ds_mensagem_cliente_p,1,255);
											else
												ds_mensagem_w := substr(obter_desc_expressao(881708),1,255);
											end if;
										else
											--ds_mensagem_w:=  substr('Foram detectados 1 ou mais sinais de alerta/disfuncao organica para sepsis na presenca de historia sugestiva de infeccao.'||chr(10)||chr(13)|| 'Voce deseja continuar o protocolo para deteccao precoce de sepsis confirmando os sinais de alerta e a presenca de sinais de disfuncao organica?',1,255); 
											ds_mensagem_w:=  substr(Wheb_mensagem_pck.get_texto(380547),1,255);
										end if;
										
										if (ie_tipo_evolucao_w = '1') then
											if (ie_versao_sepse_w = '2') then
												ie_fim_vida_p := ie_fim_vida_sepse_w;
												ie_doencas_atipica_p := ie_doencas_atipicas_sepse_w;
											end if;
												ie_acao_w := 'J';
										else
											ie_acao_w := 'R';
										end if;
										
										goto Final;
									
									elsif (ie_status_sepsis_w = 'RN') and (ie_tipo_evolucao_w = '1') then
										
										if (ie_versao_sepse_w = '2') then
											if (ie_somente_alerta_w = 'S') then
												ds_mensagem_w := substr(obter_desc_expressao(893832) || '. ' || ds_mensagem_cliente_p,1,255);
											else
												ds_mensagem_w := substr(obter_desc_expressao(881708),1,255);
											end if;
											ie_fim_vida_p := ie_fim_vida_sepse_w;
											ie_doencas_atipica_p := ie_doencas_atipicas_sepse_w;
										else
											--ds_mensagem_w:=  substr('Foram detectados 1 ou mais sinais de alerta/disfuncao organica para sepsis na presenca de historia sugestiva de infeccao.'||chr(10)||chr(13)|| 'Voce deseja continuar o protocolo para deteccao precoce de sepsis confirmando os sinais de alerta e a presenca de sinais de disfuncao organica?',1,255);
											ds_mensagem_w:=  substr(Wheb_mensagem_pck.get_texto(380547),1,255);
										end if;
										
										ie_acao_w := 'J';

										goto Final;	
									
									elsif	((ie_status_sepsis_w in ('RC','RE')) or (ie_versao_sepse_w = '2' and ie_status_sepsis_w in ('SC','CS'))) and (ie_tipo_evolucao_w = '1') then			
										
										ds_mensagem_w :=  Wheb_mensagem_pck.get_texto(295821);

										ie_acao_w := 'M';										
										
										if (ie_versao_sepse_w = '2') and (ie_status_sepsis_w = 'RC') then
											select  count(1)
											into STRICT	qt_choqueS_w
											from	gqa_pendencia_regra b
											where	b.nr_seq_escala = 124
											and		coalesce(b.cd_setor_atendimento,coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0)
											and		coalesce(qt_idade_w,0) between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,99999)
											and		ie_situacao = 'A'
											and		IE_REGRA_SEPSE = 'CS';
											
											if (qt_choqueS_w > 0) then
												ie_gravidade_w := 'CS';
											end if;
										end if;

										goto Final;	
									
									end if;				
									
								end if;			
						
								end;
							end loop;
							close C02;
							
					end if;		
					
					end;
				end loop;
				close C01;
			
			end if;
		end if;
		end;
	end if;
end if;	
<<Final>>

-- Integracao de teste da Philips Research
if ( nm_usuario_w = 'zhristov' ) and (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then

	ds_param_integ_hl7_w := 'nr_atendimento=' || nr_atendimento_p || ';';
	ds_param_integ_hl7_w := ds_param_integ_hl7_w ||'ds_frase=' || ds_mensagem_w || ';';
	CALL gravar_agend_integracao(548, ds_param_integ_hl7_w, cd_setor_atendimento_w);


end if;

ds_mensagem_p	:= ds_mensagem_w;
ie_acao_p		:= ie_acao_w;
ie_gravidade_p	:= ie_gravidade_w;
nr_seq_escala_p := nr_sequencia_w;
nr_seq_sinal_vital_p := coalesce(nr_seq_sinal_vital_w,0);
ds_deflagradores_p := '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_alerta_mentor ( nr_atendimento_p bigint, ds_mensagem_p INOUT text, ie_acao_p INOUT text, ie_gravidade_p INOUT text, nr_seq_escala_p INOUT bigint, nr_seq_sinal_vital_p INOUT bigint, ds_deflagradores_p INOUT text, ie_fim_vida_p INOUT text, ie_doencas_atipica_p INOUT text, ds_mensagem_cliente_p INOUT text, ie_somente_alerta_p INOUT text) FROM PUBLIC;

