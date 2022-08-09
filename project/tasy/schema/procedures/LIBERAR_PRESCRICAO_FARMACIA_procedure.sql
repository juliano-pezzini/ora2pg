-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_prescricao_farmacia ( nr_prescricao_p bigint, nr_seq_item_p bigint, nm_usuario_p text, ie_lib_parc_p text, ie_copia_diaria_p text default 'N', cd_funcao_ativa_p funcao.cd_funcao%type default null) AS $body$
DECLARE


											

cont_w				bigint;											
cd_pessoa_fisica_w		varchar(10);
ie_gerar_kit_w			varchar(1);
cd_estabelecimento_w		smallint;
cd_setor_atendimento_w		integer;
ie_lib_individual_w		varchar(1);
ie_gera_nutricao_w		varchar(1);
ie_define_conduta_w		varchar(1);
ie_prescr_conduta_w        	varchar(1);
nr_seq_serv_dia_w        	nut_atend_serv_dia.nr_sequencia%type;
nr_seq_serv_dia_rep_w 		nut_atend_serv_dia_rep.nr_sequencia%type;
IE_SCHEDULED_DIET_W 		cpoe_dieta.ie_duracao%type;
qt_dieta_w			bigint;
nr_sequencia_w			bigint;
qt_hora_intervalo_w		double precision;
dt_inicio_prescr_w		timestamp;
dt_validade_prescr_w		timestamp;
dt_proxima_dose_w		timestamp;
dt_horario_w			timestamp;
cd_motivo_baixa_w		smallint;
ie_altera_dt_proxima_dose_w	varchar(1);
qt_hor_nao_liberados_w		bigint;
qt_item_sem_dt_lib_w		bigint;
varControlarMedic24_w		varchar(15);
ie_motivo_prescricao_w		varchar(5);
nr_sequencia_orig_w		bigint;
nr_prescricao_orig_w		bigint;
dt_proxima_dose_orig_w		timestamp;
cd_material_w			bigint;
qt_dia_prim_hor_w		bigint;
hr_prim_horario_w		varchar(5);
cd_intervalo_w			varchar(10);
ie_liberado_farmacia_w		boolean := false;
cd_setor_atend_w		integer;
cd_protocolo_w			bigint;
nr_seq_evento_w			bigint;
nr_sequencia_ww			bigint;
nr_seq_protocolo_w		bigint;
ie_proc_mat_dieta_w		char(1);
ie_gerar_evento_w		varchar(1);
nr_atendimento_w		bigint;
ie_grava_historico_hor_w	varchar(1);
cd_funcao_origem_w		prescr_medica.cd_funcao_origem%type;
ie_gera_integracao_w		varchar(1);
qt_existe_regra_rec_w		varchar(2);
nr_prescricoes_w		prescr_medica.nr_prescricoes%type;
dt_geracao_novos_horarios_w	timestamp;
qt_novos_horarios_w		integer;
ie_far_gera_lote_unico_w	parametros_farmacia.ie_gerar_lote_unico%type;
ie_gerar_lote_unico_w		setor_atendimento.ie_gerar_lote_unico%type;
nr_seq_atend_w			prescr_medica.nr_seq_atend%type;
ie_info_rastre_prescr_w		varchar(1);
ds_alteracao_rastre_w		varchar(1800);
ie_rastre_prescr_libfarm_w	varchar(1);
ds_rastre_prescr_libfarm_w	varchar(1800);
cd_funcao_ativa_w			constant funcao.cd_funcao%type := coalesce(cd_funcao_ativa_p, obter_funcao_ativa, 0);

C07 CURSOR FOR
SELECT  b.nr_sequencia,
        obter_ocorrencia_intervalo(b.cd_intervalo,coalesce(a.nr_horas_validade, 24),'H'),
        b.dt_proxima_dose,
        b.nr_sequencia_anterior,
        coalesce(b.nr_prescricao_anterior,b.nr_prescricao_original),
        b.cd_material,
        b.cd_intervalo,
        b.hr_prim_horario
from    prescr_material b,
        prescr_medica a
where   obter_se_interv_superior_24h(b.cd_intervalo,null) = 'S'
and (exists (select 1 from prescr_material x where x.nr_seq_substituto = b.nr_sequencia and x.nr_prescricao = b.nr_prescricao)
		 or (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_inicio_medic) > ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_inicio_prescr)))
and     b.ie_origem_inf    <> 'K'
and     coalesce(b.dt_proxima_dose::text, '') = ''
and     b.ie_agrupador    in (1,2)
and     a.nr_prescricao    = b.nr_prescricao
and     a.nr_prescricao    = nr_prescricao_p;

c08 CURSOR FOR
SELECT	distinct a.nr_sequencia
from	prescr_mat_hor b,
		prescr_material a,
		prescr_medica c
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_sequencia	= b.nr_seq_material
and		c.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = c.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		coalesce(b.dt_lib_horario::text, '') = ''
and		coalesce(a.ie_urgencia,'N')	= 'S'
and		a.ie_agrupador in (1,3,7,9)
and		(c.dt_liberacao_farmacia IS NOT NULL AND c.dt_liberacao_farmacia::text <> '')
and		c.nr_prescricao = nr_prescricao_p;

c09 CURSOR FOR
	SELECT	a.nr_seq_evento,
			a.nr_sequencia
	from	regra_envio_sms a
	where	coalesce(a.ie_situacao,'A') = 'A'
	and		((coalesce(a.cd_protocolo::text, '') = '') or (a.cd_protocolo = cd_protocolo_w))
	and		((coalesce(a.nr_seq_protocolo::text, '') = '') or (a.nr_seq_protocolo = nr_seq_protocolo_w))
	and		a.ie_evento_disp = 'LPF';
	
C10 CURSOR FOR
	SELECT	a.nr_sequencia
	from	nut_atend_serv_dia a,
		prescr_medica b
	where	((to_date(a.dt_servico) between trunc(b.dt_inicio_prescr) and fim_dia(b.dt_validade_prescr)) or (coalesce(b.dt_validade_prescr::text, '') = ''))
	and	b.nr_prescricao  = nr_prescricao_p
	and	a.nr_atendimento = b.nr_atendimento
	and (not exists (  SELECT  1
				from  nut_atend_serv_dia_rep
				where  (coalesce(nr_prescr_oral,nr_prescr_jejum,nr_prescr_compl,nr_prescr_enteral,nr_prescr_npt_adulta,nr_prescr_npt_ped,nr_prescr_npt_neo,nr_prescr_leite_deriv) IS NOT NULL AND (coalesce(nr_prescr_oral,nr_prescr_jejum,nr_prescr_compl,nr_prescr_enteral,nr_prescr_npt_adulta,nr_prescr_npt_ped,nr_prescr_npt_neo,nr_prescr_leite_deriv))::text <> '')
				and  nr_seq_serv_dia  = a.nr_sequencia)
					or ( IE_SCHEDULED_DIET_W = 'S'  and Wheb_assist_pck.obterParametroFuncao(44,2314) = 'S'))
				order by 1;
	

BEGIN

CALL gravar_processo_longo(obter_desc_expressao(726286)/*'Realizando a liberacao da prescricao'*/
,'LIBERAR_PRESCRICAO_FARMACIA',1);

ie_info_rastre_prescr_w := 'N';

if (nr_prescricao_p > 0) then
	begin
	
	select	coalesce(max(cd_estabelecimento),0),
			coalesce(max(cd_setor_atendimento),0),
			max(ie_motivo_prescricao),
			coalesce(max(cd_funcao_origem),0),
			coalesce(max(nr_prescricoes),',0'),
			max(nr_seq_atend)
	into STRICT	cd_estabelecimento_w,
			cd_setor_atendimento_w,
			ie_motivo_prescricao_w,
			cd_funcao_origem_w,
			nr_prescricoes_w,
			nr_seq_atend_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	ie_rastre_prescr_libfarm_w := obter_se_info_rastre_prescr('LF', nm_usuario_p, obter_perfil_ativo, cd_estabelecimento_w);

	if (ie_rastre_prescr_libfarm_w = 'S') then
		ds_rastre_prescr_libfarm_w := 'Rastreabilidade dos processos de prescricao / liberar_prescricao_farmacia ';
		ds_rastre_prescr_libfarm_w := substr(ds_rastre_prescr_libfarm_w || '|nr_prescricao_p:' || nr_prescricao_p || '|nr_seq_item_p:' || nr_seq_item_p, 1, 1800);
		ds_rastre_prescr_libfarm_w := substr(ds_rastre_prescr_libfarm_w || '|nm_usuario_p:' || nr_prescricao_p || '|ie_lib_parc_p:' || nr_seq_item_p, 1, 1800);
		ds_rastre_prescr_libfarm_w := substr(ds_rastre_prescr_libfarm_w || chr(10), 1, 1800);
	end if;
		
	if (obter_funcao_ativa = 252) then
		ie_gerar_kit_w := 'S';
		
		if (cd_funcao_origem_w = 998) then
			ie_gerar_kit_w := Obter_Param_Usuario(998, 15, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_kit_w);		
		end if;
		
	else
		ie_gerar_kit_w := Obter_Param_Usuario(7010, 22, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_kit_w);
	end if;
	
	CALL wheb_assist_pck.set_informacoes_usuario(cd_estabelecimento_w, obter_perfil_ativo, nm_usuario_p);
	ie_lib_individual_w := wheb_assist_pck.obterValorParametroREP(530, ie_lib_individual_w);
	
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	usuario
	where	nm_usuario	= nm_usuario_p;
	
	cd_motivo_baixa_w := wheb_assist_pck.obterValorParametroREP(194, cd_motivo_baixa_w);
	update	prescr_material
	set		cd_motivo_baixa	= cd_motivo_baixa_w
	where	nr_prescricao	= nr_prescricao_p
	and		coalesce(cd_motivo_baixa,0) = 0
	and		coalesce(ie_regra_disp,'S')	= 'N';

	if (coalesce(ie_lib_parc_p,'N') = 'N') then
		
		ie_liberado_farmacia_w := true;
		
		begin	
			update	prescr_medica
			set		dt_liberacao_farmacia	= clock_timestamp(),
					cd_farmac_lib		= cd_pessoa_fisica_w
			where	nr_prescricao		= nr_prescricao_p
			and		coalesce(dt_liberacao_farmacia::text, '') = '';
			
			update	prescr_material
			set		dt_lib_farmacia	= clock_timestamp()
			where	nr_prescricao	= nr_prescricao_p
			and		coalesce(dt_lib_farmacia::text, '') = '';
			
			update	prescr_solucao
			set		dt_lib_farmacia	= clock_timestamp()
			where	nr_prescricao	= nr_prescricao_p
			and		coalesce(dt_lib_farmacia::text, '') = '';		
		exception
			when others then
				if (ie_rastre_prescr_libfarm_w = 'S') then
					ds_rastre_prescr_libfarm_w := substr(ds_rastre_prescr_libfarm_w || 'sqlerrm:' || to_char(sqlerrm) || chr(10), 1, 1800);
				end if;
		end;
		
		select	coalesce(max(ie_grava_historico_hor),'N')
		into STRICT	ie_grava_historico_hor_w
		from	parametro_medico
		where	cd_estabelecimento	= cd_estabelecimento_w;
		
		if (ie_grava_historico_hor_w	= 'S') then
			CALL PLT_gravar_historico(nr_prescricao_p, nm_usuario_p, 'F');
		end if;	
		
	else
		update	prescr_material a
		set		a.dt_lib_farmacia	= clock_timestamp(),
				a.dt_lib_material	= clock_timestamp()
		where	a.nr_prescricao	= nr_prescricao_p
		and		coalesce(a.dt_lib_farmacia::text, '') = ''
		and		coalesce(a.nr_seq_inconsistencia::text, '') = ''
		and		not exists(	SELECT 	1
							from	prescr_material_incon_farm y
							where	y.nr_prescricao 	= a.nr_prescricao
							and		((y.nr_seq_material 	= a.nr_sequencia) or (y.nr_seq_material = a.nr_seq_kit))
							and		coalesce(y.ie_situacao,'A') 	= 'A')
		and		((coalesce(a.nr_sequencia_solucao::text, '') = '') or (not exists (	select 	1
								from	prescr_material_incon_farm y
								where	y.nr_prescricao 	= a.nr_prescricao
								and		y.nr_seq_solucao 	= a.nr_sequencia_solucao
								and		coalesce(y.ie_situacao,'A') 	= 'A')));
							
		update	prescr_solucao a
		set		a.dt_lib_farmacia	= clock_timestamp(),
				a.dt_lib_material	= clock_timestamp()
		where	a.nr_prescricao	= nr_prescricao_p
		and		coalesce(a.dt_lib_farmacia::text, '') = ''
		and		coalesce(a.nr_seq_inconsistencia::text, '') = ''
		and		not exists (	SELECT 	1
							from	prescr_material_incon_farm y
							where	y.nr_prescricao 	= a.nr_prescricao
							and		y.nr_seq_solucao 	= a.nr_seq_solucao
							and		coalesce(y.ie_situacao,'A') 	= 'A');
			
			
		update 	prescr_medica
		set 	dt_liberacao_parc_farm	= clock_timestamp(),
				cd_farmac_lib_parc	= cd_pessoa_fisica_w
		where	nr_prescricao = nr_prescricao_p
		and		coalesce(dt_liberacao_parc_farm::text, '') = '';

	end if;

	if (cd_funcao_origem_w = 2314 and cd_funcao_ativa_w <> 252) or (cd_funcao_origem_w = 924 and cd_funcao_ativa_w <> 252) or (cd_funcao_origem_w = 281 and cd_funcao_ativa_w <> 252) or (cd_funcao_origem_w = 3130 and cd_funcao_ativa_w <> 252 and (nr_seq_atend_w IS NOT NULL AND nr_seq_atend_w::text <> '')) then
		CALL cpoe_atualizar_enferm_farm(nr_prescricao_p, nm_usuario_p, 'FARM');
	end if;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	
	CALL define_local_disp_prescr(nr_prescricao_p, null, obter_perfil_ativo, nm_usuario_p);	
	
	if (ie_gerar_kit_w = 'S') then
		CALL gravar_processo_longo(obter_desc_expressao(782486)/*'Verificando kits da prescricao'*/
,'LIBERAR_PRESCRICAO_FARMACIA',2);
		CALL Gerar_Kit_Medic_Prescricao(cd_estabelecimento_w,nr_prescricao_p,null, nm_usuario_p);
	end if;
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	
	if (ie_lib_individual_w = 'N') then
		CALL gravar_processo_longo(obter_desc_expressao(781570)/*'Gerando horarios da prescricao'*/
,'LIBERAR_PRESCRICAO_FARMACIA',3);
		CALL Gerar_prescr_mat_hor(nr_prescricao_p, null, Obter_perfil_ativo,nm_usuario_p,ie_lib_parc_p,'N',null);

	else
		select	count(nr_sequencia) qt_hor
		into STRICT	qt_hor_nao_liberados_w
		from	prescr_mat_hor where		nr_prescricao = nr_prescricao_p
		and		coalesce(dt_lib_horario::text, '') = '' LIMIT 1;
		
		if (qt_hor_nao_liberados_w = 0) then
			select	count(nr_sequencia) qt_hor
			into STRICT	qt_hor_nao_liberados_w
			from	prescr_proc_hor where		nr_prescricao = nr_prescricao_p
			and		coalesce(dt_lib_horario::text, '') = '' LIMIT 1;
			
			if (qt_hor_nao_liberados_w = 0) then
				select	count(nr_sequencia) qt_hor
				into STRICT	qt_hor_nao_liberados_w
				from	prescr_rec_hor where		nr_prescricao = nr_prescricao_p
				and		coalesce(dt_lib_horario::text, '') = '' LIMIT 1;
			
				if (qt_hor_nao_liberados_w = 0) then
					select	count(nr_sequencia) qt_hor
					into STRICT	qt_hor_nao_liberados_w
					from	prescr_dieta_hor where		nr_prescricao = nr_prescricao_p
					and		coalesce(dt_lib_horario::text, '') = '' LIMIT 1;
					
					if (qt_hor_nao_liberados_w = 0) then
						select	count(nr_sequencia) qt_hor
						into STRICT	qt_hor_nao_liberados_w
						from	prescr_gasoterapia_hor where		nr_prescricao = nr_prescricao_p
						and		coalesce(dt_lib_horario::text, '') = '' LIMIT 1;
					end if;
					
					
				end if;
			end if;
		end if;
		CALL gravar_processo_longo(obter_desc_expressao(781570)/*'Gerando horarios da prescricao'*/
,'LIBERAR_PRESCRICAO_FARMACIA',4);
			if (qt_hor_nao_liberados_w > 0) or
				 ((nr_prescricoes_w <> '0,') and (nr_prescricoes_w IS NOT NULL AND nr_prescricoes_w::text <> '') and (cd_funcao_origem_w = 2314)) then
			
			CALL Gerar_prescr_mat_sem_dt_lib(nr_prescricao_p,null,obter_perfil_ativo, 'S' ,nm_usuario_p,ie_lib_parc_p);
			CALL gerar_prescr_proc_sem_dt_lib(nr_prescricao_p,null,obter_perfil_ativo, 'S' ,nm_usuario_p);
			CALL Gerar_prescr_hor_sem_lib(nr_prescricao_p,null,obter_perfil_ativo, 'S' ,nm_usuario_p);
			CALL Gerar_prescr_gas_hor(nr_prescricao_p, nm_usuario_p, 'S', null, ie_lib_parc_p);
			
			SELECT	count(*)
			INTO STRICT	qt_dieta_w
			FROM	dieta b,
					prescr_dieta a,
					prescr_medica k where		b.ie_situacao = 'A'
			and		b.cd_dieta = a.cd_dieta
			and		k.nr_prescricao = nr_prescricao_p
			and		k.nr_prescricao	= a.nr_prescricao
			and		coalesce(a.ie_suspenso,'N') <> 'S'
			and		coalesce(k.dt_suspensao::text, '') = '' LIMIT 1;
			
			if (qt_dieta_w > 0) then
				CALL gerar_prescr_dieta_hor_sem_lib(nr_prescricao_p,null, obter_perfil_ativo, 'S','', 'N',nm_usuario_p);

				ie_gera_nutricao_w := obter_param_usuario(924, 545, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gera_nutricao_w);
				ie_define_conduta_w := obter_param_usuario(924, 1154, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_define_conduta_w);
				if (ie_gera_nutricao_w = 'S') then
					CALL gerar_servico_nut_pep(nr_prescricao_p,nm_usuario_p,obter_perfil_ativo);
				end if;

				if (ie_define_conduta_w = 'C') then
					-- Se parametro [1154] estiver para 'Somente prescricoes de copia', ira verificar nesse select se a prescricao de origem estava definida como conduta.
					select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END 
						into STRICT  ie_prescr_conduta_w
					from	prescr_medica x,
						nut_atend_serv_dia c
					where	x.nr_prescricao = nr_prescricao_p
					and 	c.nr_atendimento = x.nr_atendimento
					and  	(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')
					and  	exists (	SELECT  1
							from  prescr_medica b
							where	b.nr_atendimento = x.nr_atendimento
							and	b.dt_prescricao > clock_timestamp() - interval '7 days'
							and (b.nr_prescricao = coalesce(x.nr_prescricao_anterior,0)
									or  obter_se_contido(b.nr_prescricao,replace(x.nr_prescricoes,';',',')) = 'S')
									and  substr(obter_se_prescricao_nut_dia(b.nr_prescricao, c.nr_sequencia),1,2) = 'S');
				end if;

				if	((ie_define_conduta_w = 'S') or (ie_prescr_conduta_w = 'S' and ie_define_conduta_w = 'C')) then
				
					-- verifica se existe prescricao de dieta do tipo programada    
					select	coalesce(max('S'), 'N')
						into STRICT	IE_SCHEDULED_DIET_W
					FROM prescr_dieta a
LEFT OUTER JOIN cpoe_dieta e ON (a.nr_seq_dieta_cpoe = e.nr_sequencia)
WHERE a.nr_prescricao = nr_prescricao_p and e.ie_duracao = 'P' and e.ie_tipo_dieta = 'O' and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = 'N') and coalesce(e.dt_suspensao::text, '') = '' and coalesce(e.dt_lib_suspensao::text, '') = '';

					open C10;
					loop
					fetch C10 into
						nr_seq_serv_dia_w;
					EXIT WHEN NOT FOUND; /* apply on C10 */
						select	max(coalesce(nr_sequencia,0))
							into STRICT	nr_seq_serv_dia_rep_w
						from	nut_atend_serv_dia_rep
						where	nr_seq_serv_dia = nr_seq_serv_dia_w
						and	coalesce(dt_liberacao::text, '') = '';
							
						CALL Definir_Prescricao_Nutricao(nr_prescricao_p, coalesce(nr_seq_serv_dia_rep_w,0), nr_seq_serv_dia_w, 'T', nm_usuario_p);
					end loop;
					close C10;
				end if;

    
			end if;		
		else
			dt_geracao_novos_horarios_w := clock_timestamp();
			
			CALL Gerar_prescr_mat_hor(nr_prescricao_p, null, Obter_perfil_ativo,nm_usuario_p,ie_lib_parc_p,'N',null);		
			
			select	count(nr_sequencia) qt_hor
			into STRICT	qt_novos_horarios_w
			from	prescr_mat_hor where		nr_prescricao = nr_prescricao_p
			and		ie_agrupador = 5
			and		dt_atualizacao_nrec >= dt_geracao_novos_horarios_w LIMIT 1;
			
			if (qt_novos_horarios_w > 0) then
				CALL atualizar_seq_hor_glicemia(nr_prescricao_p);
			end if;
		end if;
		
		select	count(a.nr_sequencia) qt_hor
		into STRICT	qt_hor_nao_liberados_w
		from	prescr_mat_hor a,
				prescr_material b where		a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_material = b.nr_sequencia
		and		a.nr_prescricao = nr_prescricao_p
		and		coalesce(a.dt_lib_horario::text, '') = ''
		and		b.ie_agrupador = 1
		and		(b.nr_seq_substituto IS NOT NULL AND b.nr_seq_substituto::text <> '') LIMIT 1;

		if (qt_hor_nao_liberados_w > 0) then
		
			update	prescr_mat_hor b
			set		b.dt_lib_horario = clock_timestamp()
			where	b.nr_prescricao = nr_prescricao_p
			and		b.nr_seq_material in (	SELECT 	a.nr_sequencia
											from	prescr_material a
											where	a.nr_prescricao = nr_prescricao_p
											and		a.ie_agrupador = 1
											and		(a.nr_seq_substituto IS NOT NULL AND a.nr_seq_substituto::text <> ''))
			and		coalesce(b.dt_lib_horario::text, '') = ''
			and		not exists (	select 	1
							from	prescr_material_incon_farm c
							where	coalesce(c.ie_situacao,'A')  = 'A'
							and		c.nr_seq_material 	= b.nr_seq_material
							and		c.nr_prescricao 	= b.nr_prescricao );

		end if;
		
	end if;
	
	select	max(dt_inicio_prescr),
			max(dt_validade_prescr)
	into STRICT	dt_inicio_prescr_w,
			dt_validade_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	varControlarMedic24_w := wheb_assist_pck.obterValorParametroREP(992, varControlarMedic24_w);
	if (varControlarMedic24_w = 'S') then
		ie_altera_dt_proxima_dose_w := wheb_assist_pck.obterValorParametroREP(694, ie_altera_dt_proxima_dose_w);
		open c07;
		loop
		fetch c07 into
			nr_sequencia_w,
			qt_hora_intervalo_w,
			dt_proxima_dose_w,
			nr_sequencia_orig_w,
			nr_prescricao_orig_w,
			cd_material_w,
			cd_intervalo_w,
			hr_prim_horario_w;
		EXIT WHEN NOT FOUND; /* apply on c07 */
			begin
			dt_proxima_dose_orig_w	:= dt_proxima_dose_w;
			dt_horario_w			:= null;
				
			hr_prim_horario_w	:= coalesce(hr_prim_horario_w, to_char(dt_inicio_prescr_w, 'hh24:mi'));

			if (nr_sequencia_orig_w IS NOT NULL AND nr_sequencia_orig_w::text <> '') then	
				
				select	max(dt_proxima_dose)
				into STRICT	dt_proxima_dose_w
				from	prescr_material
				where	((coalesce(hr_prim_horario, hr_prim_horario_w) = hr_prim_horario_w) or (mod(qt_hora_intervalo_w,24) > 0))
				and		cd_intervalo = cd_intervalo_w
				and		cd_material = cd_material_w
				and		nr_sequencia = nr_sequencia_orig_w
				and		nr_prescricao = nr_prescricao_orig_w;
				
				if (coalesce(dt_proxima_dose_w::text, '') = '') then
					dt_proxima_dose_w	:= dt_proxima_dose_orig_w;
					
					select	max(dt_horario)
					into STRICT	dt_horario_w
					from	prescr_mat_hor
					where	nr_seq_material	= nr_sequencia_w
					and		coalesce(ie_horario_especial,'N') <> 'S'
					and		nr_prescricao	= nr_prescricao_p;
				else
					
					update	prescr_material
					set		dt_proxima_dose	= dt_proxima_dose_w,
							dt_administrar 	= dt_proxima_dose_w
					where	nr_sequencia	= nr_sequencia_w
					and		nr_prescricao	= nr_prescricao_p;
				end if;
			else
			
				select	max(dt_horario)
				into STRICT	dt_horario_w
				from	prescr_mat_hor
				where	nr_seq_material	= nr_sequencia_w
				and		coalesce(ie_horario_especial,'N') <> 'S'
				and		nr_prescricao	= nr_prescricao_p;
			
				dt_proxima_dose_w	:= dt_horario_w;
			end if;
			
			CALL gravar_processo_longo(obter_desc_expressao(726290)/*'Calculando horarios das etapas'*/
,'LIBERAR_PRESCRICAO_FARMACIA',5);
			
			if (qt_hora_intervalo_w > 24) then
				if	((coalesce(dt_proxima_dose_w::text, '') = '') or (dt_proxima_dose_w between dt_inicio_prescr_w and dt_validade_prescr_w)) then
					begin
					
					if (dt_proxima_dose_w IS NOT NULL AND dt_proxima_dose_w::text <> '') then
						if (dt_inicio_prescr_w > dt_proxima_dose_w) then
							qt_dia_prim_hor_w := ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_prescr_w) - ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_proxima_dose_w);
						else
							qt_dia_prim_hor_w := ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_proxima_dose_w) - ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_prescr_w);
						end if;
					else
						if (hr_prim_horario_w < to_char(dt_inicio_prescr_w,'hh24:mi')) then

							qt_dia_prim_hor_w	:= 1;
						else
							qt_dia_prim_hor_w	:= 0;
						end if;
					end if;
					
					if (qt_dia_prim_hor_w not between 0 and 1) then
						qt_dia_prim_hor_w	:= 0;
					end if;
					
					dt_proxima_dose_w	:= coalesce(dt_horario_w, dt_proxima_dose_w) + qt_hora_intervalo_w/24;
					
					if (mod(qt_hora_intervalo_w,24) > 0) then
						update	prescr_material
						set		dt_proxima_dose	= dt_proxima_dose_w,
								ie_administrar	 = NULL,
								qt_dia_prim_hor	= qt_dia_prim_hor_w
						where	nr_sequencia	= nr_sequencia_w
						and		nr_prescricao	= nr_prescricao_p;
					else
						update	prescr_material
						set		hr_prim_horario	= to_char(dt_proxima_dose_w,'hh24:mi'),
								ds_horarios	= to_char(dt_proxima_dose_w,'hh24:mi '),
								dt_proxima_dose	= dt_proxima_dose_w,
								ie_administrar	 = NULL,
								qt_dia_prim_hor	= qt_dia_prim_hor_w
						where	nr_sequencia	= nr_sequencia_w
						and		nr_prescricao	= nr_prescricao_p;
					end if;
					
					end;
				elsif (ie_altera_dt_proxima_dose_w = 'S') and (dt_proxima_dose_w IS NOT NULL AND dt_proxima_dose_w::text <> '') and (dt_proxima_dose_w < dt_inicio_prescr_w) then
					begin
					
					if	((dt_horario_w IS NOT NULL AND dt_horario_w::text <> '') and (dt_horario_w	>= dt_inicio_prescr_w) and (dt_horario_w	< dt_validade_prescr_w)) then
						dt_proxima_dose_w	:= dt_horario_w + qt_hora_intervalo_w/24;
					else
						dt_proxima_dose_w	:= dt_inicio_prescr_w + qt_hora_intervalo_w/24;
					end if;
					
					qt_dia_prim_hor_w := to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_prescr_w),'dd') - to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_proxima_dose_w),'dd');
					if (qt_dia_prim_hor_w	< 0) then
						qt_dia_prim_hor_w	:= 0;
					end if;
				
					update	prescr_material
					set		hr_prim_horario = to_char(dt_proxima_dose_w, 'hh24:mi'),
							dt_proxima_dose	= dt_proxima_dose_w,
							dt_administrar 	= dt_proxima_dose_w,
							ds_horarios		= to_char(dt_proxima_dose_w, 'hh24:mi'),
							qt_dia_prim_hor = qt_dia_prim_hor_w,
							ie_administrar	 = NULL
					where	nr_sequencia	= nr_sequencia_w
					and		nr_prescricao	= nr_prescricao_p;
					
					end;
				elsif (dt_proxima_dose_w IS NOT NULL AND dt_proxima_dose_w::text <> '') then
					begin
					
					update	prescr_material
					set		ie_administrar	= 'N',
							ie_regra_disp	= 'N'
					where	nr_sequencia	= nr_sequencia_w
					and		nr_prescricao	= nr_prescricao_p;

					update	prescr_material
					set		ie_administrar		= 'N',
							ie_regra_disp		= 'N'
					where	nr_sequencia_diluicao	= nr_sequencia_w
					and		nr_prescricao		= nr_prescricao_p;

					update	prescr_mat_hor
					set		ie_situacao	= 'I'
					where	nr_seq_material	= nr_sequencia_w
					and		nr_prescricao	= nr_prescricao_p;
					
					update	prescr_mat_hor
					set		ie_situacao	= 'I'
					where	nr_seq_superior	= nr_sequencia_w
					and		nr_prescricao	= nr_prescricao_p;
					
					end;
				end if;
			elsif (ie_altera_dt_proxima_dose_w = 'S') and (dt_proxima_dose_w IS NOT NULL AND dt_proxima_dose_w::text <> '') and (dt_proxima_dose_w < dt_inicio_prescr_w) then
				begin
				
				if	((dt_horario_w IS NOT NULL AND dt_horario_w::text <> '') and (dt_horario_w	>= dt_inicio_prescr_w) and (dt_horario_w	< dt_validade_prescr_w)) then
					dt_proxima_dose_w	:= dt_horario_w + qt_hora_intervalo_w/24;
				else
					dt_proxima_dose_w	:= dt_inicio_prescr_w + qt_hora_intervalo_w/24;
				end if;	
				
				qt_dia_prim_hor_w := to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_prescr_w),'dd') -
									 to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_proxima_dose_w),'dd');
				if (qt_dia_prim_hor_w	< 0) then
					qt_dia_prim_hor_w	:= 0;
				end if;
			
				update	prescr_material
				set		hr_prim_horario = to_char(dt_proxima_dose_w, 'hh24:mi'),
						dt_proxima_dose	= dt_proxima_dose_w,
						dt_administrar 	= dt_proxima_dose_w,
						ds_horarios		= to_char(dt_proxima_dose_w, 'hh24:mi'),
						qt_dia_prim_hor = qt_dia_prim_hor_w,
						ie_administrar	 = NULL
				where	nr_sequencia	= nr_sequencia_w
				and		nr_prescricao	= nr_prescricao_p;
				
				end;
			end if;
			end;
		end loop;
		close c07;
	end if;
	
	update	prescr_material
	set		cd_motivo_baixa	= cd_motivo_baixa_w
	where	nr_prescricao	= nr_prescricao_p
	and		coalesce(cd_motivo_baixa,0) = 0
	and		coalesce(ie_regra_disp,'S')	= 'N';
	CALL gravar_processo_longo(obter_desc_expressao(782488)/*'Atualizando horarios da prescricao.'*/
,'LIBERAR_PRESCRICAO_FARMACIA',5);
	if (ie_lib_individual_w = 'S') then
		
		open C08;
		loop
		fetch C08 into	
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C08 */
			begin
			CALL Atualiza_prescr_mat_hor(nr_prescricao_p,nr_sequencia_w,obter_perfil_ativo,nm_usuario_p,ie_lib_parc_p, 'M',null);
			end;
		end loop;
		close C08;
	end if;	
	
	if (ie_liberado_farmacia_w) then
		CALL gravar_processo_longo(obter_desc_expressao(782490)/*'Liberando prescricao.'*/
,'LIBERAR_PRESCRICAO_FARMACIA',6);
		select	max(cd_protocolo),
				max(nr_seq_protocolo),
				max(cd_pessoa_fisica),
				max(cd_setor_atendimento)
		into STRICT	cd_protocolo_w,
				nr_seq_protocolo_w,
				cd_pessoa_fisica_w,
				cd_setor_atend_w
		from	prescr_medica
		where	nr_prescricao	= nr_prescricao_p;

		open C09;
		loop
		fetch C09 into	
			nr_seq_evento_w,
			nr_sequencia_ww;
		EXIT WHEN NOT FOUND; /* apply on C09 */

			ie_gerar_evento_w := obter_se_evento_prescr_lib(nr_seq_evento_w,nr_prescricao_p,clock_timestamp(),'LPF');
			if (ie_gerar_evento_w = 'S') then
			
				select	coalesce(max('P'),'X')
				into STRICT	ie_proc_mat_dieta_w
				from	regra_envio_sms_proc where		nr_seq_regra = nr_sequencia_ww LIMIT 1;
				
				if (ie_proc_mat_dieta_w = 'X') then
					select	coalesce(max('M'),'X')
					into STRICT	ie_proc_mat_dieta_w
					from	regra_envio_sms_material where		nr_seq_regra = nr_sequencia_ww LIMIT 1;
				
					if (ie_proc_mat_dieta_w = 'X') then
							Select 	coalesce(max('D'),'X')
							into STRICT	ie_proc_mat_dieta_w
							from	regra_envio_sms_dieta where		nr_seq_regra = nr_sequencia_ww LIMIT 1;
					
						if (ie_proc_mat_dieta_w = 'X') then
							Select 	coalesce(max('R'),'X')
							into STRICT	ie_proc_mat_dieta_w
							from	regra_envio_sms_rec where		nr_seq_regra = nr_sequencia_ww LIMIT 1;
						end if;
						
					end if;				
					
				end if;
				
				if (ie_proc_mat_dieta_w <> 'X') then
					if (Obter_se_pac_regra_evento(nr_prescricao_p,nr_sequencia_ww,ie_proc_mat_dieta_w) = 'S') then
						CALL gerar_evento_liberar_prescr(nr_seq_evento_w,nr_atendimento_w,cd_pessoa_fisica_w,nm_usuario_p,null, cd_setor_atend_w, nr_prescricao_p);
					end if;
				else
					CALL gerar_evento_liberar_prescr(nr_seq_evento_w,nr_atendimento_w,cd_pessoa_fisica_w,nm_usuario_p,null, cd_setor_atend_w, nr_prescricao_p);	
				end if;			
			end if;
		end loop;
		close C09;
		
		select	count(*)
		into STRICT	qt_item_sem_dt_lib_w
		from	prescr_mat_hor
		where	nr_prescricao = nr_prescricao_p
		and	coalesce(dt_lib_horario::text, '') = '';
		
		if (qt_item_sem_dt_lib_w > 0) then
		
			update 	prescr_mat_hor
			set 	dt_lib_horario = clock_timestamp()
			where	nr_prescricao = nr_prescricao_p
			and	coalesce(dt_lib_horario::text, '') = '';

			CALL gerar_log_prescricao(nr_prescricao_p, null, null, null, null,
			PKG_DATE_FORMATERS_TZ.TO_VARCHAR(clock_timestamp(),'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.GETTIMEZONE), nm_usuario_p, 4404, 'S');
		
		end if;				

	end if;
	
	ie_info_rastre_prescr_w := obter_se_info_rastre_prescr( 'L', nm_usuario_p, obter_perfil_ativo, cd_estabelecimento_w );

    if (ie_info_rastre_prescr_w = 'S') then
		ds_alteracao_rastre_w := substr('Gerar log Rastreabilidade Alteracoes / liberar_prescricao_farmacia = ' || 'NR_PRESCRICAO_P: ' || nr_prescricao_p
			,1,1800);

		CALL Gerar_log_prescr_mat(nr_prescricao_p, null, null, null, null, ds_alteracao_rastre_w, nm_usuario_p, 'N');
	end if;
	
	CALL gravar_processo_longo(obter_desc_expressao(782492)/*'Verificando lotes da prescricao'*/
,'LIBERAR_PRESCRICAO_FARMACIA',7);
	CALL Gerar_Lote_Atend_Prescricao(nr_prescricao_p, null, 0, 'N', nm_usuario_p, 'GPMH');
		
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	
	CALL gravar_processo_longo(obter_desc_expressao(782484)/*'Atualizando plano terapeutico. '*/
,'LIBERAR_PRESCRICAO_FARMACIA',8);	
	CALL Atualizar_plt_controle(null, null, null, 'TODOS', 'S', nr_prescricao_p);

	CALL integracao_dispensario_pck.cubixx_admissao_paciente(null, nr_prescricao_p, cd_estabelecimento_w, cd_setor_atendimento_w);
	CALL integracao_dispensario_pck.cubixx_enviar_prescricao(null, nr_prescricao_p, cd_estabelecimento_w, cd_setor_atendimento_w);
	
	select	coalesce(max(ie_gera_integracao),'N'),
		coalesce(max(ie_gerar_lote_unico),'N')
	into STRICT	ie_gera_integracao_w,
		ie_far_gera_lote_unico_w
	from	parametros_farmacia
	where	cd_estabelecimento = cd_estabelecimento_w;
	
	if (ie_far_gera_lote_unico_w = 'S') then
		select	coalesce(max(ie_gerar_lote_unico),'N')
		into STRICT	ie_gerar_lote_unico_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_w
		and	cd_estabelecimento = cd_estabelecimento_w;
		
		if (ie_gerar_lote_unico_w = 'S') then
			CALL Gerar_Lote_Unico_Prescricao(nr_prescricao_p,0,0,'N',nm_usuario_p,'GPMH');
		end if;	
	end if;

	/*if	(ie_gera_integracao_w = 'S') then
		disp_prescr_mat_hor(nr_prescricao_p,0,nm_usuario_p);
	end if;*/
	end;
end if;

if (obter_funcao_ativa = 252 and coalesce(ie_copia_diaria_p, 'N') = 'N') then
	CALL gpt_atualizar_enferm_farm(nr_prescricao_p, nm_usuario_p, 'FARM');
end if;

cont_w := 0;
select count(*)
into STRICT   cont_w
from   prescr_medica_compl
where  nr_prescricao = nr_prescricao_p;

if (cont_w > 0) then
	update  prescr_medica_compl
	set     cd_perfil_farm = obter_perfil_ativo(), 
			cd_funcao_ativa_farm = obter_funcao_ativa() 
	where   nr_prescricao = nr_prescricao_p;
else
	insert
	into prescr_medica_compl(
		DT_ATUALIZACAO,
		IE_LIBERACAO_CPOE,
		NM_USUARIO,
		NR_PRESCRICAO,
		cd_perfil_farm,
		cd_funcao_ativa_farm)
	values (
		clock_timestamp(), 
		'N', 
		nm_usuario_p, 
		nr_prescricao_p, 
		obter_perfil_ativo(), 
		obter_funcao_ativa()
	);
end if;

if (ie_rastre_prescr_libfarm_w = 'S') then
	CALL gerar_log_prescr_mat(nr_prescricao_p, null, null, null, null, ds_rastre_prescr_libfarm_w, nm_usuario_p, 'N');
end if;

if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'es_CO') then
  begin
    select max(a.nr_atendimento)
    into STRICT nr_atendimento_w
    from prescr_medica a
    where a.nr_prescricao = nr_prescricao_p;
  exception
    when no_data_found then nr_atendimento_w := null;
  end;

  CALL insert_prescr_mipres(nr_prescricao_p, nr_atendimento_w);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_prescricao_farmacia ( nr_prescricao_p bigint, nr_seq_item_p bigint, nm_usuario_p text, ie_lib_parc_p text, ie_copia_diaria_p text default 'N', cd_funcao_ativa_p funcao.cd_funcao%type default null) FROM PUBLIC;
