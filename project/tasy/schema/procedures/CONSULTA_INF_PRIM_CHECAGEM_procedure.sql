-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consulta_inf_prim_checagem ( nr_seq_horario_p bigint, cd_item_p bigint, cd_procedimento_p bigint, nm_usuario_p text, ie_opcao_p text, ie_tipo_item_p text, nr_prescricao_p text default '0', ds_retorno_p INOUT text DEFAULT NULL, ie_acao_p bigint DEFAULT NULL, nr_etapa_p bigint DEFAULT NULL, nr_seq_glicemia_p bigint default null) AS $body$
DECLARE


ie_retorno_w			char(1);
nr_etapa_atual_sol_w	bigint;
ie_existe_proc_w		varchar(1);
nr_agrupamento_w		prescr_mat_hor.nr_agrupamento%type;
nr_prescricao_w			prescr_medica.nr_prescricao%type;
ie_agrupador_w			prescr_material.ie_agrupador%type;
nr_seq_processo_w		prescr_mat_hor.nr_seq_processo%type;
nr_seq_horario_w		prescr_mat_hor.nr_sequencia%type;
nr_seq_item_w			prescr_material.nr_sequencia%type;
nm_usuario_w			usuario.nm_usuario%type;
nr_etapa_atual_w		prescr_mat_hor.nr_etapa_sol%type;

/*
MPC -	Mensagem: Realizar 1a checagem // 135872
MMU - 	Mensagem: O usuario que realizou a 1a checagem nao pode administrar o horario! // 160630
*/
BEGIN

if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') and (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	
	select	coalesce(max(a.nm_usuario), nm_usuario_p) nm_usuario
	into STRICT	nm_usuario_w
	from	usuario a
	where	upper(a.ds_login) = upper(nm_usuario_p);
			
	if	(nr_seq_glicemia_p IS NOT NULL AND nr_seq_glicemia_p::text <> '' AND ie_opcao_p = 'MMU') then
			
		select	coalesce(max('S'), 'N')
		into STRICT	ie_retorno_w
		from	atend_glicemia_evento b
		where	nr_seq_glicemia = nr_seq_glicemia_p
		and		ie_evento = 13
		and		upper(b.nm_usuario) = upper(nm_usuario_p);
		
		if (ie_retorno_w = 'S') then
			ds_retorno_p	:= Wheb_mensagem_pck.get_texto(160630);
		end if;
				
	elsif (ie_tipo_item_p in ('IAH','M','S','IA','IAG')) then -- Verifica para medicamentos e suplemento oral
	
		ie_retorno_w	:= coalesce(obter_se_medic_dupla_chec(cd_item_p, wheb_usuario_pck.get_cd_estabelecimento, nr_prescricao_p),'N');
		
		if (ie_retorno_w = 'N') then		
			select	coalesce(max(ie_dupla_checagem),'N')
			into STRICT	ie_retorno_w
			from	material
			where	cd_material = cd_item_p;
			
			if (ie_retorno_w = 'N') then	

				select	coalesce(max(b.nr_agrupamento),0),
						max(a.nr_prescricao),
						max(b.ie_agrupador),
						max(nr_seq_processo)
				into STRICT	nr_agrupamento_w,
						nr_prescricao_w,
						ie_agrupador_w,
						nr_seq_processo_w
				from	prescr_mat_hor a,
						prescr_material b
				where	a.nr_sequencia = nr_seq_horario_p
				and		a.nr_prescricao = b.nr_prescricao
				and		a.nr_seq_material = b.nr_sequencia;
			
			    select	coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	material
				where	cd_material in (	SELECT 	b.cd_material
											from	prescr_material b
											where	nr_prescricao = coalesce(nr_prescricao_p,nr_prescricao_w)
											and		nr_agrupamento = nr_agrupamento_w
											and		ie_agrupador = ie_agrupador_w
											and		cd_material <> cd_item_p)
				and		ie_dupla_checagem = 'S';
				
				if (ie_retorno_w = 'N') and (nr_seq_processo_w IS NOT NULL AND nr_seq_processo_w::text <> '')	then

						select	coalesce(max('S'),'N')
						into STRICT	ie_retorno_w
						from	material
						where	((ie_dupla_checagem = 'S') or (coalesce(obter_se_medic_dupla_chec(cd_material, wheb_usuario_pck.get_cd_estabelecimento, coalesce(nr_prescricao_p,nr_prescricao_w)),'N') = 'S'))
						and		cd_material in (	SELECT	b.cd_material	
													from	prescr_mat_hor b
													where	b.nr_seq_processo = nr_seq_processo_w
													and		b.ie_agrupador = ie_agrupador_w)
						and		coalesce(obter_funcao_ativa,-1113) not in (1113,88);
						
				end if;
				
			end if;
			
		end if;
		
		if (ie_retorno_w = 'S') then
			if (ie_opcao_p = 'MPC') then
			
				select  coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	prescr_mat_hor where		nr_sequencia = nr_seq_horario_p
				and		coalesce(dt_primeira_checagem::text, '') = ''
				and		coalesce(dt_fim_horario::text, '') = ''
				and		coalesce(dt_suspensao::text, '') = '' LIMIT 1;	
				
				if (ie_retorno_w = 'S') then  -- Se encontrou horario sem primeira checagem
											   -- Verificar se o item nao esta  com o processo tendo primeira checagem	
				
					select	coalesce(max('N'), 'S')
					into STRICT	ie_retorno_w
					from	prescr_mat_hor a
					where	a.nr_sequencia = nr_seq_horario_p
					and		exists ( 	SELECT 	1
										from	adep_processo b
										where	b.nr_sequencia = a.nr_seq_processo
										and		(dt_primeira_checagem IS NOT NULL AND dt_primeira_checagem::text <> ''));
				
				end if;
				
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(135872);
				end if;
				
			elsif (ie_opcao_p = 'MMU') then

				select	coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	prescr_mat_hor a,
						prescr_mat_alteracao b where		a.nr_sequencia = nr_seq_horario_p
				and		a.nr_sequencia = b.nr_seq_horario
				and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
				and		coalesce(a.dt_fim_horario::text, '') = ''
				and		coalesce(a.dt_suspensao::text, '') = ''
				and		b.ie_alteracao = 47
				and		upper(b.nm_usuario) = upper(nm_usuario_p)
				and		b.nr_sequencia = (	SELECT	max(b.nr_sequencia)
											from	prescr_mat_hor a,
													prescr_mat_alteracao b
											where	a.nr_sequencia = nr_seq_horario_p
											and		a.nr_sequencia = b.nr_seq_horario
											and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
											and		coalesce(a.dt_fim_horario::text, '') = ''
											and		coalesce(a.dt_suspensao::text, '') = ''
											and		b.ie_alteracao = 47) LIMIT 1;
											
				if (ie_retorno_w = 'N') then
											
					select 	max(nr_seq_processo)										
					into STRICT	nr_seq_processo_w
					from	prescr_mat_hor
					where	nr_sequencia = nr_seq_horario_p;
						

					if (nr_seq_processo_w IS NOT NULL AND nr_seq_processo_w::text <> '') then
											
				        select	coalesce(max('S'),'N')
						into STRICT	ie_retorno_w
						from	prescr_mat_hor a,
								prescr_mat_alteracao b where		a.nr_seq_processo = nr_seq_processo_w
						and		a.nr_sequencia = b.nr_seq_horario
						and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
						and		coalesce(a.dt_fim_horario::text, '') = ''
						and		coalesce(a.dt_suspensao::text, '') = ''
						and		b.ie_alteracao = 47
						and		upper(b.nm_usuario) = upper(nm_usuario_p)					
						and		b.nr_sequencia = (	SELECT	max(b.nr_sequencia)
													from	prescr_mat_hor a,
															prescr_mat_alteracao b
													where	a.nr_seq_processo = nr_seq_processo_w
													and		a.nr_sequencia = b.nr_seq_horario
													and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
													and		coalesce(a.dt_fim_horario::text, '') = ''
													and		coalesce(a.dt_suspensao::text, '') = ''
													and		b.ie_alteracao = 47) LIMIT 1;		
					end if;
					
				end if;		

				if	(ie_agrupador_w = 5 AND ie_retorno_w = 'N') then
				
					select	coalesce(max('S'),'N')
					into STRICT	ie_retorno_w
					from	prescr_mat_hor a,
							prescr_mat_alteracao b where		a.nr_sequencia = nr_seq_horario_p
					and		a.nr_sequencia = b.nr_seq_horario
					and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
					and		coalesce(a.dt_fim_horario::text, '') = ''
					and		coalesce(a.dt_suspensao::text, '') = ''
					and		b.ie_alteracao = 47
					and		upper(b.nm_usuario) = upper(nm_usuario_p)
					and		b.nr_sequencia = (	SELECT	max(b.nr_sequencia)
												from	prescr_mat_hor a,
														prescr_mat_alteracao b
												where	a.nr_sequencia = nr_seq_horario_p
												and		a.nr_sequencia = b.nr_seq_horario
												and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
												and		coalesce(a.dt_fim_horario::text, '') = ''
												and		coalesce(a.dt_suspensao::text, '') = ''
												and		b.ie_alteracao = 47) LIMIT 1;
					
				end if;				
						
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(160630);
				end if;
			end if;
		end if;
	elsif (ie_tipo_item_p in ('P','L','C','G','HM')) then
	
		ie_retorno_w	:= coalesce(obter_se_medic_dupla_chec(cd_item_p, wheb_usuario_pck.get_cd_estabelecimento, nr_prescricao_p),'N');

		if (ie_retorno_w = 'N') then
			if (ie_tipo_item_p = 'HM') then
				select	coalesce(max(ie_dupla_checagem),'N')
				into STRICT	ie_retorno_w
				from	procedimento
				where	cd_procedimento = cd_procedimento_p;
			else
				select	coalesce(max(ie_dupla_checagem),'N')
				into STRICT	ie_retorno_w
				from	procedimento
				where	cd_procedimento = cd_item_p;
			end if;
		end if;
		
		if (ie_retorno_w = 'S') then
			if (ie_opcao_p = 'MPC') then
			
				select	coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	prescr_proc_hor where		nr_sequencia = nr_seq_horario_p
				and		coalesce(dt_primeira_checagem::text, '') = ''
				and		coalesce(dt_fim_horario::text, '') = ''
				and		coalesce(dt_suspensao::text, '') = '' LIMIT 1;	
				
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(135872);
				end if;
			elsif (ie_opcao_p = 'MMU') then
				if (ie_tipo_item_p = 'HM')	then
					select	coalesce(max('S'),'N')
					into STRICT	ie_retorno_w
					from	prescr_proc_hor a,
							prescr_solucao_evento b where		a.nr_prescricao = b.nr_prescricao
					and	a.nr_sequencia = nr_seq_horario_p
					and	a.nr_prescricao = nr_prescricao_p
					and	a.nr_seq_procedimento = cd_item_p
					and	a.nr_etapa = b.nr_etapa_evento
					and	(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
					and	coalesce(a.dt_fim_horario::text, '') = ''
					and	coalesce(a.dt_suspensao::text, '') = ''
					and	b.ie_alteracao = 37
					and	upper(b.nm_usuario) = upper(nm_usuario_w)
					and	b.nr_sequencia = (	SELECT	max(b.nr_sequencia)
									from	prescr_proc_hor a,
										prescr_solucao_evento b
									where	a.nr_sequencia = nr_seq_horario_p
									and		a.nr_prescricao = b.nr_prescricao
									and	a.nr_prescricao = nr_prescricao_p
									and	a.nr_seq_procedimento = cd_item_p
									and	a.nr_etapa = b.nr_etapa_evento
									and	(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
									and	coalesce(a.dt_fim_horario::text, '') = ''
									and	coalesce(a.dt_suspensao::text, '') = ''
									and	b.ie_alteracao = 37) LIMIT 1;
				else
					select	coalesce(max('S'),'N')
					into STRICT	ie_retorno_w
					from	prescr_proc_hor a,
							prescr_mat_alteracao b
					where	a.nr_sequencia = nr_seq_horario_p
					and		a.nr_sequencia = b.nr_seq_horario_proc
					and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
					and		coalesce(a.dt_fim_horario::text, '') = ''
					and		coalesce(a.dt_suspensao::text, '') = ''
					and		b.ie_alteracao = 47
					and		upper(b.nm_usuario) = upper(nm_usuario_p)
					and		b.nr_sequencia = (	SELECT	max(b.nr_sequencia)
												from	prescr_proc_hor a,
														prescr_mat_alteracao b
												where	a.nr_sequencia = nr_seq_horario_p
												and		a.nr_sequencia = b.nr_seq_horario_proc
												and		(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
												and		coalesce(a.dt_fim_horario::text, '') = ''
												and		coalesce(a.dt_suspensao::text, '') = ''
												and		b.ie_alteracao = 47);
				end if;
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(160630);
				end if;
			end if;
		end if;
	elsif (ie_tipo_item_p in ('SOL')) then -- Verifica solucoes
	
		ie_retorno_w	:= coalesce(obter_se_medic_dupla_chec(cd_item_p, wheb_usuario_pck.get_cd_estabelecimento, nr_prescricao_p),'N');
		
		if (ie_retorno_w = 'N') then		
			select	coalesce(max('S'), 'N')
			into STRICT	ie_retorno_w
			from	material
			where	cd_material in (	  SELECT 	cd_material
						  from 		prescr_material
						  where 	nr_sequencia_solucao = cd_item_p
						  and 		nr_prescricao = nr_prescricao_p)
			and	coalesce(ie_dupla_checagem,'N') = 'S';
		end if;
		
		if (ie_retorno_w = 'S') then
			if (ie_opcao_p = 'MPC') then
			
				select  coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	prescr_mat_hor where	nr_etapa_sol = nr_seq_horario_p
				and	nr_prescricao = nr_prescricao_p
				and	nr_seq_solucao = cd_item_p
				and	coalesce(dt_primeira_checagem::text, '') = ''
				and	coalesce(dt_fim_horario::text, '') = ''
				and	coalesce(dt_suspensao::text, '') = '' LIMIT 1;	
				
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(135872);
				end if;
				
			elsif (ie_opcao_p = 'MMU') then
						
				nr_etapa_atual_sol_w := obter_etapa_atual(nr_prescricao_p, cd_item_p);								
				if (ie_acao_p = 3) then
					nr_etapa_atual_sol_w	:= nr_etapa_atual_sol_w +1;
				end if;
				
				if (nr_etapa_p > 0) then
					nr_etapa_atual_sol_w := nr_etapa_p;
				end if;

				select	coalesce(max(a.nm_usuario), nm_usuario_p) nm_usuario
				into STRICT	nm_usuario_w
				from	usuario a
				where	upper(a.ds_login) = upper(nm_usuario_p);

				select	coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	prescr_mat_hor a,
					prescr_solucao_evento b where	a.nr_etapa_sol = nr_etapa_atual_sol_w
				and	a.nr_prescricao = nr_prescricao_p
				and	a.nr_seq_solucao = cd_item_p
				and	a.nr_etapa_sol = b.nr_etapa_evento
				and	((a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '') or (ie_acao_p = 99))
				and	coalesce(a.dt_fim_horario::text, '') = ''
				and	coalesce(a.dt_suspensao::text, '') = ''
				and	b.ie_alteracao = 37
				and	upper(b.nm_usuario) = upper(nm_usuario_w)
				and	b.nr_sequencia = (	SELECT	max(b.nr_sequencia)
							from	prescr_mat_hor a,
								prescr_solucao_evento b
							where	a.nr_etapa_sol = nr_etapa_atual_sol_w
							and	a.nr_prescricao = nr_prescricao_p
							and	a.nr_seq_solucao = cd_item_p
							and	a.nr_etapa_sol = b.nr_etapa_evento
							and	((a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '') or (ie_acao_p = 99))
							and	coalesce(a.dt_fim_horario::text, '') = ''
							and	coalesce(a.dt_suspensao::text, '') = ''
							and	b.ie_alteracao = 37) LIMIT 1;
								
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(160630);
				end if;
			end if;
		end if;	
		
	elsif (ie_tipo_item_p = 'DI')	then -- verifica dialise
	
		ie_retorno_w	:= coalesce(obter_se_medic_dupla_chec(cd_item_p, wheb_usuario_pck.get_cd_estabelecimento, nr_prescricao_p),'N');
		
		if (ie_retorno_w = 'N') then		
			select	coalesce(max('S'), 'N')
			into STRICT	ie_retorno_w
			from	material
			where	cd_material in (	  SELECT 	cd_material
						  from 		prescr_material
						  where 	nr_sequencia_solucao = cd_item_p
						  and 		nr_prescricao = nr_prescricao_p)
			and	coalesce(ie_dupla_checagem,'N') = 'S';
		end if;
		
		if (ie_retorno_w = 'S') then
			if (ie_opcao_p = 'MMU') then
			
				nr_etapa_atual_sol_w := obter_etapa_atual_DI(nr_prescricao_p, cd_item_p);
				
				if (nr_etapa_p > 0) then
					nr_etapa_atual_sol_w := nr_etapa_p;
				end if;
				
				select 	coalesce(max('S'),'N')
				into STRICT 	ie_retorno_w
				from 	prescr_mat_hor a,
						hd_prescricao_evento b where 	a.nr_etapa_sol 		= nr_etapa_atual_sol_w
				and		a.nr_prescricao 	= nr_prescricao_p
				and		a.nr_seq_solucao	= cd_item_p
				and 	a.nr_etapa_sol		= b.nr_etapa_evento
				and 	(a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '')
				and		coalesce(a.dt_fim_horario::text, '') = ''
				and		coalesce(a.dt_suspensao::text, '') = ''
				and		b.ie_evento			= 'PC'
				and 	upper(b.nm_usuario) = upper(nm_usuario_p)
				and		b.nr_sequencia		= ( SELECT 	max(x.nr_sequencia)
												from 	hd_prescricao_evento x
												where 	x.nr_prescricao 	= nr_prescricao_p
												and		x.nr_seq_solucao	= cd_item_p ) LIMIT 1;
				
				if (ie_retorno_w = 'N') then
					select 	coalesce(max('S'),'N')
					into STRICT 	ie_retorno_w
					from 	hd_prescricao_evento
					where 	nr_prescricao 		= nr_prescricao_p  
					and		nr_seq_solucao 		= cd_item_p
					and		ie_evento			= 'PC'
					and 	upper(nm_usuario) 	= upper(nm_usuario_p)
					and		nr_sequencia		= ( SELECT 	max(x.nr_sequencia)
													from 	hd_prescricao_evento x
													where 	x.nr_prescricao 	= nr_prescricao_p
													and		x.nr_seq_solucao	= cd_item_p );
				end if;
				
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(160630);
				end if;
			end if;
		end if;
		
	
	elsif (ie_tipo_item_p in ('SNE')) then -- Verifica solucoes	
	
		ie_retorno_w	:= coalesce(obter_se_medic_dupla_chec(cd_item_p, wheb_usuario_pck.get_cd_estabelecimento, nr_prescricao_p),'N');
		
		if (ie_retorno_w = 'N') then		
			select	coalesce(max('S'), 'N')
			into STRICT	ie_retorno_w
			from	material
			where	cd_material = cd_item_p
			and		coalesce(ie_dupla_checagem,'N') = 'S';
			
		end if;
		
		if (ie_retorno_w = 'S') then
			if (ie_opcao_p = 'MPC') then
			
				select  coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	prescr_mat_hor where		nr_sequencia = nr_seq_horario_p				
				and		coalesce(dt_primeira_checagem::text, '') = ''
				and		coalesce(dt_fim_horario::text, '') = ''
				and		coalesce(dt_suspensao::text, '') = '' LIMIT 1;	
				
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(135872);
				end if;
				
			elsif (ie_opcao_p = 'MMU') then
			
				select	max(nr_sequencia)
				into STRICT	nr_seq_item_w
				from	prescr_material
				where	nr_prescricao	= nr_prescricao_p
				and		cd_material		= cd_item_p;
			
				nr_etapa_atual_sol_w	:= obter_etapa_atual_sne(nr_prescricao_p,nr_seq_item_w);
	
				if (nr_etapa_atual_sol_w = 0) then
					nr_etapa_atual_sol_w	:= nr_etapa_atual_sol_w + 1;
				end if;

				nr_etapa_atual_w	:= nr_etapa_atual_sol_w;

				select	min(nr_etapa_sol)
				into STRICT	nr_etapa_atual_w
				from	prescr_mat_hor
				where	nr_prescricao	= nr_prescricao_p
				and		nr_seq_material	= nr_seq_item_w
				and		nr_etapa_sol	>= nr_etapa_atual_sol_w
				and		coalesce(dt_suspensao::text, '') = ''
				and		coalesce(ie_horario_especial,'N') <> 'S'
				and		coalesce(dt_inicio_horario::text, '') = '';

				select	coalesce(max('S'),'N')
				into STRICT	ie_retorno_w
				from	prescr_mat_hor a,
						prescr_solucao_evento b where		a.nr_prescricao = b.nr_prescricao
				and		a.nr_etapa_sol = b.nr_etapa_evento
				and		a.nr_prescricao = nr_prescricao_p
				and		a.cd_material = cd_item_p
				and		b.ie_evento_valido = 'S'
				and		b.nr_etapa_evento 	= nr_etapa_atual_w
				and		((a.dt_primeira_checagem IS NOT NULL AND a.dt_primeira_checagem::text <> '') or (ie_acao_p = 99))
				and		coalesce(a.dt_fim_horario::text, '') = ''
				and		coalesce(a.dt_suspensao::text, '') = ''
				and		b.ie_alteracao = 37
				and		upper(b.nm_usuario) = upper(nm_usuario_p) LIMIT 1;
								
				if (ie_retorno_w = 'S') then
					ds_retorno_p	:= Wheb_mensagem_pck.get_texto(160630);
				end if;
			end if;
		end if;	
		
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consulta_inf_prim_checagem ( nr_seq_horario_p bigint, cd_item_p bigint, cd_procedimento_p bigint, nm_usuario_p text, ie_opcao_p text, ie_tipo_item_p text, nr_prescricao_p text default '0', ds_retorno_p INOUT text DEFAULT NULL, ie_acao_p bigint DEFAULT NULL, nr_etapa_p bigint DEFAULT NULL, nr_seq_glicemia_p bigint default null) FROM PUBLIC;
