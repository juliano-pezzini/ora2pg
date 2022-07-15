-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_suspensao_itens_adep ( nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


					
ora2pg_rowcount int;
nr_sequencia_w			bigint;
nr_seq_horario_w		bigint;
nr_prescricao_w			bigint;
nr_seq_material_w		integer;
nr_seq_alteracao_w		bigint;
nr_seq_solucao_w		integer;
ie_agrupador_w			smallint;
cd_material_w			bigint;
nr_agrupamento_w		double precision;
ie_susp_solucao_alta_w	varchar(1);
dt_horario_w			timestamp;
ie_susp_itens_pend_w	varchar(1);
ds_texto_aux			varchar(255);
cd_recomendacao_w		varchar(255);
cd_refeicao_w			varchar(15);
nr_seq_rec_w			integer;
nr_seq_dieta_w			bigint;
nr_seq_gas_w			bigint;
ie_acm_sn_w				varchar(1);
nr_seq_nut_pac_w		prescr_material.nr_seq_nut_pac%type;
ie_atualizou_w			boolean;
qt_registro_w			bigint;
ie_horario_lib_w  		varchar(1);

c01 CURSOR FOR /*Materiais e Medicamentos*/
	SELECT	a.nr_sequencia,
			a.ie_agrupador,
			a.nr_prescricao,
			a.dt_horario,
			a.cd_material,
			a.nr_agrupamento,
			a.nr_seq_material,
			Obter_informacoes_item_prescr('M',a.nr_prescricao,a.nr_seq_material,a.cd_material,1),
			Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario)
	from	prescr_mat_hor a,
			prescr_medica b		
	where	coalesce(a.dt_fim_horario::text, '') = ''
	and		coalesce(a.dt_suspensao::text, '') = ''
	and		a.ie_agrupador in (1,2,3,5,9,16,17)
	and (ie_susp_itens_pend_w <> 'S' or a.ie_agrupador <> 5) --Nao trazer os associados ao procedimento
	and		a.nr_prescricao = b.nr_prescricao
	and		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and		b.dt_validade_prescr > clock_timestamp()
	and		b.nr_atendimento = nr_atendimento_p;

c02 CURSOR FOR /*Solucoes */
	SELECT	a.nr_sequencia,
			a.nr_prescricao,
			a.dt_horario,
			a.nr_seq_solucao
	from	prescr_mat_hor a,
			prescr_medica b		
	where	coalesce(a.dt_fim_horario::text, '') = ''
	and		coalesce(a.dt_suspensao::text, '') = ''
	and		a.ie_agrupador = 4
	and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
	and		a.nr_prescricao = b.nr_prescricao
	and		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and		b.dt_validade_prescr > clock_timestamp()
	and		b.nr_atendimento = nr_atendimento_p;
	
c03 CURSOR FOR /*Suporte Nutricional Enteral e suplemento oral*/
	SELECT	a.nr_sequencia,
			a.nr_prescricao,
			a.dt_horario,
			a.nr_seq_material,
			a.ie_agrupador,
			a.cd_material,
			obter_se_acm_sn(c.ie_se_necessario, c.ie_acm)
	from	prescr_mat_hor a,
			prescr_medica b,
			prescr_material c			
	where	c.nr_prescricao = a.nr_prescricao
	and		c.nr_sequencia = a.nr_seq_material
	and		c.nr_prescricao = b.nr_prescricao
	and		coalesce(a.dt_fim_horario::text, '') = ''
	and		coalesce(a.dt_suspensao::text, '') = ''
	and		a.ie_agrupador in (8,12)
	and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
	and		b.dt_validade_prescr > clock_timestamp()
	and		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and		a.nr_prescricao = b.nr_prescricao
	and		b.nr_atendimento = nr_atendimento_p;
	
c04 CURSOR FOR /*Procedimetos*/
	SELECT	a.nr_prescricao,
			a.nr_sequencia
	from	prescr_procedimento a,
			prescr_medica b
	where	not exists ( SELECT		1
						from		procedimento_paciente c
						where		c.nr_sequencia_prescricao = a.nr_sequencia
						and			c.nr_prescricao = a.nr_prescricao
						and			b.nr_atendimento = c.nr_atendimento)
	and		a.nr_prescricao = b.nr_prescricao
	and		b.dt_validade_prescr > clock_timestamp()
	and		(coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '')
	and		b.nr_atendimento = nr_atendimento_p;
	
c05 CURSOR FOR /*Recomendacoes*/
	SELECT	c.nr_prescricao,			
			c.nr_sequencia,
			c.dt_horario,
			c.cd_recomendacao,
			c.nr_seq_recomendacao
	from	prescr_recomendacao x,
			prescr_rec_hor c,
			prescr_medica a
	where	x.nr_prescricao = c.nr_prescricao
	and		x.nr_sequencia = c.nr_seq_recomendacao
	and		x.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = a.nr_prescricao
	and		a.nr_atendimento = nr_atendimento_p
	and		a.dt_validade_prescr > clock_timestamp()
	and		coalesce(x.dt_suspensao::text, '') = ''
	and		coalesce(c.ie_situacao,'A') = 'A'
	and		coalesce(c.ie_horario_especial,'N') = 'N'
	and		coalesce(c.dt_fim_horario::text, '') = ''
	and		coalesce(c.dt_suspensao::text, '') = ''
	and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S';

c06 CURSOR FOR /*Dietas*/
	SELECT	c.nr_prescricao,
			c.nr_sequencia,
			c.dt_horario,
			c.cd_refeicao,
			c.nr_seq_dieta
	from	prescr_dieta x,
			prescr_dieta_hor c,
			prescr_medica a
	where	x.nr_prescricao = c.nr_prescricao
	and		x.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = a.nr_prescricao		
	and		c.nr_seq_dieta	= x.nr_sequencia
	and		coalesce(c.ie_situacao,'A') = 'A'
	and		obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and		a.dt_validade_prescr > clock_timestamp()
	and		a.nr_atendimento = nr_atendimento_p
	and		coalesce(c.dt_fim_horario::text, '') = ''
	and		coalesce(c.dt_suspensao::text, '') = '';
	
c07 CURSOR FOR /*Gasoterapia*/
	SELECT	c.nr_prescricao,
			c.nr_sequencia,
			c.nr_seq_gasoterapia
	from	prescr_gasoterapia x,
			prescr_gasoterapia_hor c,
			prescr_medica a
	where	x.nr_prescricao = c.nr_prescricao
	and		x.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = a.nr_prescricao
	and		c.nr_seq_gasoterapia = x.nr_sequencia
	and		coalesce(c.ie_horario_especial,'N') = 'N'
	and		obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and		a.dt_validade_prescr > clock_timestamp()
	and		a.nr_atendimento = nr_atendimento_p
	and		coalesce(c.dt_fim_horario::text, '') = ''
	and		coalesce(c.dt_suspensao::text, '') = ''
	and		coalesce(substr(obter_status_etapa_gas(x.nr_sequencia,c.nr_etapa,c.dt_fim_horario,c.dt_suspensao),1,10),'N') in ('P', 'N');

c08 CURSOR FOR /*NPT Adulto protocolo*/
	SELECT	a.nr_sequencia,
			a.ie_agrupador,
			a.nr_prescricao,
			a.dt_horario,
			a.cd_material,
			a.nr_agrupamento,
			a.nr_seq_material,
			c.nr_seq_nut_pac			
	from	prescr_mat_hor a,
			prescr_material c,
			prescr_medica b		
	where   c.nr_prescricao = a.nr_prescricao
	and		c.nr_sequencia = a.nr_seq_material
	and		c.nr_prescricao = b.nr_prescricao
	and		coalesce(a.dt_fim_horario::text, '') = ''
	and		coalesce(a.dt_suspensao::text, '') = ''
	and		a.ie_agrupador = 11
	and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
	and		a.nr_prescricao = b.nr_prescricao
	and		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and		b.dt_validade_prescr > clock_timestamp()
	and		b.nr_atendimento = nr_atendimento_p;
	
c09 CURSOR FOR /*Procedimentos em geral (inclui Controle de Glicemia e Hemoterapia)*/
	SELECT	c.nr_sequencia nr_seq_horario,
			a.nr_prescricao,
			x.nr_sequencia nr_seq_procedimento,
			c.dt_horario,			
			x.nr_seq_solic_sangue,
			x.nr_seq_prot_glic,
			'N' ie_atualizou_item
	from	prescr_procedimento x,
			prescr_proc_hor 	c,
			prescr_medica 		a	
	where	x.nr_prescricao = c.nr_prescricao
	and		x.nr_sequencia 	= c.nr_seq_procedimento
	and		x.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = a.nr_prescricao
	and		a.nr_atendimento = nr_atendimento_p
	and		a.dt_validade_prescr > clock_timestamp()
	and		coalesce(c.dt_fim_horario::text, '') = ''
	and		coalesce(c.dt_suspensao::text, '') = ''
	and (coalesce(obter_status_solucao_prescr(3,a.nr_prescricao,x.nr_sequencia),'N') = 'N' --Nao realizar a suspensao de hemoterapias ja iniciadas
	or		coalesce(x.nr_seq_solic_sangue::text, '') = '')
	and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S';
	
c10 CURSOR FOR /*NPT Adulta, Pediatrica e Neo */
	SELECT	b.dt_horario,
			a.nr_prescricao,
			x.nr_sequencia nr_seq_nut_neo,
			coalesce(x.ie_npt_adulta,'S') ie_npt_adulta,
			b.nr_sequencia nr_seq_horario,
			null ie_tipo_solucao
	from	nut_paciente_hor 	b,
			nut_pac 			x,
			prescr_medica 		a	
	where	x.nr_prescricao 		= a.nr_prescricao
	and		b.nr_seq_nut_protocolo	= x.nr_sequencia
	and		a.nr_atendimento 		= nr_atendimento_p
	and		coalesce(b.dt_fim_horario::text, '') = ''
	and		coalesce(x.dt_suspensao::text, '') = ''
	and		coalesce(b.dt_suspensao::text, '') = ''
	and		a.dt_validade_prescr > clock_timestamp()
	and     x.ie_status = 'N';

BEGIN	

ie_susp_itens_pend_w := Obter_param_Usuario(1113, 205, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_susp_itens_pend_w);

if (ie_susp_itens_pend_w <> 'N') then

	ds_texto_aux := wheb_mensagem_pck.get_texto(300577);

	open C01;
	loop
	fetch C01 into	
		nr_sequencia_w,
		ie_agrupador_w,
		nr_prescricao_w,
		dt_horario_w,
		cd_material_w,
		nr_agrupamento_w,
		nr_seq_material_w,
		ie_acm_sn_w,
		ie_horario_lib_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
    if (ie_horario_lib_w = 'S') then

		  update	prescr_mat_hor
		  set		dt_suspensao = clock_timestamp()	
		  where	nr_prescricao = nr_prescricao_w
		  and		nr_sequencia = nr_sequencia_w;

		  if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then

			  update	prescr_material
			  set		ie_horario_susp	= 'S'
			  where	nr_prescricao	= nr_prescricao_w
			  and		nr_sequencia	= nr_seq_material_w;

		  end if;

		  GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;


		  if ( ora2pg_rowcount > 0) then					
			  begin
			  select	nextval('prescr_mat_alteracao_seq')
			  into STRICT	nr_seq_alteracao_w
			;

			  insert	into	prescr_mat_alteracao(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_prescricao,
								nr_seq_prescricao,
								nr_seq_horario,
								dt_alteracao,
								cd_pessoa_fisica,
								ie_alteracao,
								ds_justificativa,
								ie_tipo_item,
								dt_horario,
								nr_atendimento,
								cd_item,
								ie_acm_sn
								--nr_agrupamento
								)
							values (
								nr_seq_alteracao_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_prescricao_w,
								nr_seq_material_w,
								nr_sequencia_w,
								clock_timestamp(),
								obter_dados_usuario_opcao(nm_usuario_p,'C'),
								24,
								ds_texto_aux,
								CASE WHEN ie_agrupador_w=1 THEN  'M'  ELSE 'MAT' END ,
								dt_horario_w,
								nr_atendimento_p,
								cd_material_w,
								ie_acm_sn_w
								--nr_agrupamento_w
								);
			  end;
  	  end if;
    else
      update prescr_material
      set   dt_suspensao = clock_timestamp()
      where nr_prescricao = nr_prescricao_w
      and   nr_sequencia = nr_seq_material_w;
    end if;
		end;
	end loop;
	close C01;

	ie_susp_solucao_alta_w := Obter_param_Usuario(1113, 626, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_susp_solucao_alta_w);

	if (coalesce(ie_susp_solucao_alta_w,'N') = 'S') then
		open C02;
		loop
		fetch C02 into	
			nr_seq_horario_w,
			nr_prescricao_w,
			dt_horario_w,
			nr_seq_solucao_w;	
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			update	prescr_mat_hor
			set		dt_suspensao = clock_timestamp(),
					nm_usuario_susp = nm_usuario_p
			where	nr_prescricao = nr_prescricao_w
			and		nr_sequencia = nr_seq_horario_w;	
			
			GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;
	
			
			if ( ora2pg_rowcount > 0) then					
				begin
				select	nextval('prescr_solucao_evento_seq')
				into STRICT	nr_seq_alteracao_w
				;

				insert into prescr_solucao_evento(
									nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									nr_prescricao,
									nr_seq_solucao,
									nr_seq_material,
									nr_seq_procedimento,
									nr_seq_nut,
									nr_seq_nut_neo,
									ie_forma_infusao,
									ie_tipo_dosagem,
									qt_dosagem,
									qt_vol_infundido,
									qt_vol_desprezado,
									cd_pessoa_fisica,
									ie_alteracao,
									dt_alteracao,
									ie_evento_valido,
									nr_seq_motivo,
									ie_tipo_solucao,
									ds_justificativa,
									dt_aprazamento,
									dt_horario)
								values (
									nr_seq_alteracao_w,
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									nr_prescricao_w,
									nr_seq_solucao_w,
									null,
									null,
									null,
									null,
									null,
									null,
									null,
									null,
									null,
									obter_dados_usuario_opcao(nm_usuario_p, 'C'),
									38,
									clock_timestamp(),
									'S',
									null,
									1,
									ds_texto_aux,
									null,
									dt_horario_w);
				end;
			end if;
				
			end;
		end loop;
		close C02;
		
		open C03;
		loop
		fetch C03 into	
			nr_seq_horario_w,
			nr_prescricao_w,
			dt_horario_w,
			nr_seq_material_w,
			ie_agrupador_w,
			cd_material_w,
			ie_acm_sn_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
						
			update	prescr_mat_hor
			set		dt_suspensao = clock_timestamp(),
					nm_usuario_susp = nm_usuario_p
			where	nr_prescricao = nr_prescricao_w
			and		nr_sequencia = nr_seq_horario_w;	
			
			GET DIAGNOSTICS ie_atualizou_w = ROW_COUNT > 0;
			
			if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
				
				update	prescr_material
				set		ie_horario_susp	= 'S',
						dt_suspensao = clock_timestamp(),
						nm_usuario_susp = nm_usuario_p
				where	nr_prescricao	= nr_prescricao_w
				and		nr_sequencia	= nr_seq_material_w;
			
			end if;
			
			if  (ie_atualizou_w AND ie_agrupador_w = 8) then					
				begin
				
				select	nextval('prescr_solucao_evento_seq')
				into STRICT	nr_seq_alteracao_w
				;

				insert into prescr_solucao_evento(
									nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									nr_prescricao,
									nr_seq_solucao,
									nr_seq_material,
									nr_seq_procedimento,
									nr_seq_nut,
									nr_seq_nut_neo,
									ie_forma_infusao,
									ie_tipo_dosagem,
									qt_dosagem,
									qt_vol_infundido,
									qt_vol_desprezado,
									cd_pessoa_fisica,
									ie_alteracao,
									dt_alteracao,
									ie_evento_valido,
									nr_seq_motivo,
									ie_tipo_solucao,
									ds_justificativa,
									dt_aprazamento,
									dt_horario)
								values (
									nr_seq_alteracao_w,
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									nr_prescricao_w,
									null,
									nr_seq_material_w,
									null,
									null,
									null,
									null,
									null,
									null,
									null,
									null,
									obter_dados_usuario_opcao(nm_usuario_p, 'C'),
									38,
									clock_timestamp(),
									'S',
									null,
									2,
									ds_texto_aux,
									null,
									dt_horario_w);
				end;
			elsif (ie_atualizou_w AND ie_agrupador_w = 12) then						
				begin
								
				select	nextval('prescr_mat_alteracao_seq')
				into STRICT	nr_seq_alteracao_w
				;

			    insert	into	prescr_mat_alteracao(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_prescricao,
								nr_seq_prescricao,
								nr_seq_horario,
								dt_alteracao,
								cd_pessoa_fisica,
								ie_alteracao,
								ds_justificativa,
								ie_tipo_item,
								dt_horario_acao,
								nr_atendimento,
								cd_item,
								ie_acm_sn															
								)
							values (
								nr_seq_alteracao_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_prescricao_w,
								nr_seq_material_w,
								nr_seq_horario_w,
								clock_timestamp(),
								obter_dados_usuario_opcao(nm_usuario_p,'C'),
								24,
								ds_texto_aux,
								'S',
								dt_horario_w,
								nr_atendimento_p,
								cd_material_w,
								ie_acm_sn_w							
								);
				
				end;
			end if;
				
			end;
		end loop;
		close C03;			
	end if;
	
	open c05;
		loop
		fetch c05 into
			nr_prescricao_w,
			nr_sequencia_w,
			dt_horario_w,
			cd_recomendacao_w,
			nr_seq_rec_w;
		EXIT WHEN NOT FOUND; /* apply on c05 */		
			begin
		
			update	prescr_rec_hor
			set		dt_suspensao = clock_timestamp()	
			where	nr_prescricao = nr_prescricao_w
			and		nr_sequencia = nr_sequencia_w;
						
			update	prescr_recomendacao
			set		ie_horario_susp	= 'S',
					ie_suspenso		= 'S',
					dt_atualizacao 	= clock_timestamp()
			where	nr_prescricao	= nr_prescricao_w
			and		nr_sequencia	= nr_seq_rec_w;			

			select	nextval('prescr_mat_alteracao_seq')
			into STRICT	nr_seq_alteracao_w
			;
	
			insert	into	prescr_mat_alteracao(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_prescricao,
							nr_seq_prescricao,
							nr_seq_horario,
							dt_alteracao,
							cd_pessoa_fisica,
							ie_alteracao,
							ds_justificativa,
							ie_tipo_item,
							dt_horario,
							nr_atendimento,
							cd_item,
							nr_seq_recomendacao
							)
						values (
							nr_seq_alteracao_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_prescricao_w,
							null,
							null,
							clock_timestamp(),
							obter_dados_usuario_opcao(nm_usuario_p,'C'),
							24,
							ds_texto_aux,
							'R',
							dt_horario_w,
							nr_atendimento_p,
							cd_recomendacao_w,
							nr_seq_rec_w							
							);	
		end;
	end loop;
	close c05;
			
	open c06;
	loop
	fetch c06 into
		nr_prescricao_w,
		nr_sequencia_w,
		dt_horario_w,
		cd_refeicao_w,
		nr_seq_dieta_w;		
	EXIT WHEN NOT FOUND; /* apply on c06 */		
			begin
		
			update	prescr_dieta_hor
			set		dt_suspensao = clock_timestamp()	
			where	nr_prescricao = nr_prescricao_w
			and		nr_sequencia = nr_sequencia_w;
						
			update	prescr_dieta
			set		ie_horario_susp	= 'S',
					ie_suspenso		= 'S',
					dt_atualizacao 	= clock_timestamp()
			where	nr_prescricao	= nr_prescricao_w
			and		nr_sequencia	= nr_seq_dieta_w;			

			select	nextval('prescr_mat_alteracao_seq')
			into STRICT	nr_seq_alteracao_w
			;
	
			insert	into	prescr_mat_alteracao(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_prescricao,
							nr_seq_prescricao,
							nr_seq_horario,
							dt_alteracao,
							cd_pessoa_fisica,
							ie_alteracao,
							ds_justificativa,
							ie_tipo_item,
							dt_horario,
							nr_atendimento,
							cd_item,
							nr_seq_horario_dieta
							)
						values (
							nr_seq_alteracao_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_prescricao_w,
							null,
							null,
							clock_timestamp(),
							obter_dados_usuario_opcao(nm_usuario_p,'C'),
							24,
							ds_texto_aux,
							'D',
							dt_horario_w,
							nr_atendimento_p,
							cd_refeicao_w,
							nr_sequencia_w
							);				
		end;
	end loop;
	close c06;
			
	open c07;
	loop
	fetch c07 into
		nr_prescricao_w,
		nr_sequencia_w,
		nr_seq_gas_w;
	EXIT WHEN NOT FOUND; /* apply on c07 */
		begin
			CALL suspender_prescr_gas_hor(nr_prescricao_w, nr_seq_gas_w, nr_sequencia_w, nm_usuario_p, 'N');

			update	prescr_gasoterapia
			set		ie_horario_susp	= 'S',
					dt_atualizacao	= clock_timestamp()
			where	nr_prescricao	= nr_prescricao_w
			and		nr_sequencia	= nr_seq_gas_w;

			update	prescr_gasoterapia a
			set		ie_suspenso		= 'S',
					dt_suspensao	= clock_timestamp()
			where	a.nr_prescricao = nr_prescricao_w
			and		a.nr_sequencia = nr_seq_gas_w
			and not exists (
						SELECT	1
						from	prescr_gasoterapia_hor b,
								prescr_gasoterapia c
						where	b.nr_prescricao = c.nr_prescricao
								and b.nr_seq_gasoterapia = c.nr_sequencia
								and b.nr_prescricao = a.nr_prescricao
								and coalesce(b.dt_suspensao::text, '') = ''
			);

			select	nextval('prescr_gasoterapia_evento_seq')
			into STRICT	nr_seq_alteracao_w
			;

			insert	into	prescr_gasoterapia_evento(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_gasoterapia,
								ie_evento,
								dt_evento,
								ie_evento_valido,
								ds_justificativa
								)
							values (
								nr_seq_alteracao_w,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_gas_w,
								'AM',
								clock_timestamp(),
								'N',
								ds_texto_aux
								);
		end;
	end loop;
	close c07;
	
	open C08;
	loop
	fetch C08 into	
		nr_sequencia_w,
		ie_agrupador_w,
		nr_prescricao_w,
		dt_horario_w,
		cd_material_w,
		nr_agrupamento_w,
		nr_seq_material_w,
		nr_seq_nut_pac_w;	
	EXIT WHEN NOT FOUND; /* apply on C08 */
		begin
		
		update	prescr_mat_hor
		set		dt_suspensao = clock_timestamp()	
		where	nr_prescricao = nr_prescricao_w
		and		nr_sequencia = nr_sequencia_w;
		
		if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
			
			update	prescr_material
			set		ie_horario_susp	= 'S'
			where	nr_prescricao	= nr_prescricao_w
			and		nr_sequencia	= nr_seq_material_w;
		
		end if;
		
		update	nut_pac
		set		dt_suspensao = clock_timestamp(),
				ie_suspenso = 'S',
				nm_usuario_susp = nm_usuario_p
		where	nr_sequencia = nr_seq_nut_pac_w;				
		
		GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;
				
		
		if ( ora2pg_rowcount > 0) then					
			begin

			select	nextval('prescr_solucao_evento_seq')
				into STRICT	nr_seq_alteracao_w
				;

				insert into prescr_solucao_evento(
									nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									nr_prescricao,
									nr_seq_solucao,
									nr_seq_material,
									nr_seq_procedimento,
									nr_seq_nut,									
									ie_forma_infusao,
									ie_tipo_dosagem,
									qt_dosagem,
									qt_vol_infundido,
									qt_vol_desprezado,
									cd_pessoa_fisica,
									ie_alteracao,
									dt_alteracao,
									ie_evento_valido,
									nr_seq_motivo,
									ie_tipo_solucao,
									ds_justificativa,
									dt_aprazamento,
									dt_horario,
									nr_seq_nut_neo)
								values (
									nr_seq_alteracao_w,
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									nr_prescricao_w,
									null,
									null,
									null,
									null,
									null,									
									null,
									null,
									null,
									null,
									obter_dados_usuario_opcao(nm_usuario_p, 'C'),
									38,
									clock_timestamp(),
									'S',
									null,
									6,
									ds_texto_aux,
									null,
									dt_horario_w,
									nr_seq_nut_pac_w);
			end;
		end if;
		
		end;
	end loop;
	close C08;

	if (ie_susp_itens_pend_w not in ('S')) then
		open C04;
		loop
		fetch C04 into	
			nr_prescricao_w,
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
				
			select	count(1)
			into STRICT	qt_registro_w
			from	result_laboratorio
			where	nr_prescricao = nr_prescricao_w
			and	nr_seq_prescricao = nr_sequencia_w;
			
			if (qt_registro_w	= 0) then
				select	count(1)
				into STRICT	qt_registro_w
				from	laudo_paciente
				where	nr_prescricao = nr_prescricao_w
				and	nr_seq_prescricao = nr_sequencia_w;
			end if;
			
			if (qt_registro_w	= 0) or (pkg_i18n.get_user_locale <> 'en_AU') then
				CALL Suspender_item_Prescricao(nr_prescricao_w, nr_sequencia_w, null,null, 'PRESCR_PROCEDIMENTO', nm_usuario_p, 'S',coalesce(obter_funcao_ativa,924));
			end if;
			
		end loop;
		close C04;
		
		for c09_w in c09 loop
			begin
			update	prescr_proc_hor	a
			set		a.dt_suspensao	= clock_timestamp()
			where	a.nr_prescricao	= c09_w.nr_prescricao
			and		a.nr_sequencia	= c09_w.nr_seq_horario;
			
			GET DIAGNOSTICS ie_atualizou_w = ROW_COUNT > 0;
			
			if ((c09_w.nr_seq_procedimento IS NOT NULL AND c09_w.nr_seq_procedimento::text <> '') and ie_atualizou_w) then
				update	prescr_procedimento	a
				set		a.ie_suspenso		= 'S',
                        a.dt_suspensao      = clock_timestamp()
				where	a.nr_sequencia		= c09_w.nr_seq_procedimento
				and		a.nr_prescricao		= c09_w.nr_prescricao
				and		coalesce(a.ie_suspenso,'N') <> 'S';
			end if;
			
			if (ie_atualizou_w) then
				if (c09_w.nr_seq_solic_sangue IS NOT NULL AND c09_w.nr_seq_solic_sangue::text <> '') then
					insert into prescr_solucao_evento(
											nr_sequencia,
											dt_atualizacao,
											nm_usuario,
											dt_atualizacao_nrec,
											nm_usuario_nrec,
											nr_prescricao,
											nr_seq_procedimento,
											cd_pessoa_fisica,
											ie_alteracao,
											dt_alteracao,
											ie_evento_valido,
											ie_tipo_solucao,
											ds_justificativa,
											dt_aprazamento,
											dt_horario)
										values (
											nextval('prescr_solucao_evento_seq'),
											clock_timestamp(),
											nm_usuario_p,
											clock_timestamp(),
											nm_usuario_p,
											c09_w.nr_prescricao,
											c09_w.nr_seq_procedimento,
											obter_dados_usuario_opcao(nm_usuario_p, 'C'),
											38,
											clock_timestamp(),
											'S',
											3,
											ds_texto_aux,
											null,
											c09_w.dt_horario);
					else
						insert into prescr_mat_alteracao(
													nr_sequencia,
													dt_atualizacao,
													nm_usuario,
													dt_atualizacao_nrec,
													nm_usuario_nrec,
													nr_prescricao,
													dt_alteracao,
													cd_pessoa_fisica,
													ie_alteracao,
													ds_justificativa,
													nr_seq_procedimento,
													nr_seq_horario_proc,
													dt_horario,
													nr_atendimento,
													nr_seq_prot_glic,
													ds_stack,
													cd_funcao)
												values (	
													nextval('prescr_mat_alteracao_seq'),
													clock_timestamp(),
													nm_usuario_p,
													clock_timestamp(),
													nm_usuario_p,
													c09_w.nr_prescricao,
													clock_timestamp(),
													obter_dados_usuario_opcao(nm_usuario_p, 'C'),
													24,
													ds_texto_aux,
													c09_w.nr_seq_procedimento,
													c09_w.nr_seq_horario,
													c09_w.dt_horario,
													nr_atendimento_p,
													c09_w.nr_seq_prot_glic,
													substr(dbms_utility.format_call_stack,1,2000),
													obter_funcao_ativa);
					end if;
			end if;
			end;
		end loop;
	end if;

	for c10_w in c10 loop
		begin
		
		update	nut_paciente_hor	a
		set		a.dt_suspensao		= clock_timestamp(),
				a.nm_usuario_susp 	= nm_usuario_p,
				a.ie_status			= 'S'
		where	a.nr_sequencia	= c10_w.nr_seq_horario;
		
		GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;

		
		if ( ora2pg_rowcount > 0) then				
			if (c10_w.nr_seq_nut_neo IS NOT NULL AND c10_w.nr_seq_nut_neo::text <> '') then
				update	nut_pac	a
				set		a.ie_suspenso	= 'S',
						a.dt_suspensao	= clock_timestamp(),
						a.nm_usuario	= nm_usuario_p,
						a.dt_atualizacao = clock_timestamp()
				where	a.nr_sequencia	= c10_w.nr_seq_nut_neo
				and		a.nr_prescricao	= c10_w.nr_prescricao;
			end if;

			if (c10_w.ie_npt_adulta = 'P') then
				c10_w.ie_tipo_solucao	:= 7;
			elsif (c10_w.ie_npt_adulta = 'N') then
				c10_w.ie_tipo_solucao	:= 5;
			else
				c10_w.ie_tipo_solucao	:= 4;
			end if;
			
			insert into prescr_solucao_evento(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_prescricao,
					cd_pessoa_fisica,
					ie_alteracao,
					dt_alteracao,
					ie_evento_valido,
					ie_tipo_solucao,
					nr_seq_nut_neo,
					ds_justificativa,
					dt_horario,
					cd_funcao,
					ds_stack,
					ie_mostra_adep)
			values (
					nextval('prescr_solucao_evento_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					c10_w.nr_prescricao,
					obter_dados_usuario_opcao(nm_usuario_p, 'C'),
					38,
					clock_timestamp(),
					'S',
					c10_w.ie_tipo_solucao,
					c10_w.nr_seq_nut_neo,
					ds_texto_aux,
					c10_w.dt_horario,
					obter_funcao_ativa,
					substr(dbms_utility.format_call_stack,1,2000),
					'S');
		end if;

		end;
	end loop;
	
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_suspensao_itens_adep ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

