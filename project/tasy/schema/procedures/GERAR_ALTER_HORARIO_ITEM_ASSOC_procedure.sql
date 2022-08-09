-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alter_horario_item_assoc (nr_atendimento_p bigint, ie_tipo_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, cd_item_p text, dt_horario_p timestamp, dt_evento_p timestamp, ie_alteracao_p bigint, nm_usuario_p text, ie_alterar_item_assoc_p text default 'N', ie_palm_p text default 'N') AS $body$
DECLARE


nr_prescricao_w		bigint;
nr_seq_item_w		integer;
nr_seq_horario_w	bigint;
nr_seq_alteracao_w	bigint;
dt_atualizacao_w	timestamp := clock_timestamp();
ie_lancar_conta_w	varchar(1);
cd_setor_pac_w		bigint;
nr_seq_map_w		bigint;
nr_seq_processo_w	bigint;
cd_estabelecimento_w	bigint;
ie_tipo_item_w		varchar(15);
cd_item_w			varchar(50);
ie_prot_cobra_adm_w	varchar(1);
ie_ivc_w			varchar(1);
cd_perfil_w			integer	:= obter_perfil_Ativo;
qt_minutos_apraz_cg_w		smallint;
nr_seq_hor_glic_w		bigint;
nr_seq_proc_ccg_w		bigint;
ie_inconsistencia_ccg_w		varchar(20);
ds_inconsistentes_ccg_w		varchar(20);
ds_sql_cursor_w			varchar(10000);
ds_sql_where_w			varchar(10000);
nr_seq_item_cpoe_w		bigint;
ie_tipo_dieta_cpoe_w		varchar(10);
cd_proc_ccg_w			bigint;
cd_interv_ccg_w			varchar(7);
qt_proc_ccg_w			double precision;
nr_seq_proc_int_ccg_w		bigint;
ie_acm_sn_ccg_w			varchar(1);
nr_seq_prot_ccg_w		bigint;
nr_prescr_ccg_w			bigint;
ie_lanca_itens_assoc_w  varchar(1);
ie_atualiza_processo_w	varchar(1) := 'S';
ie_adm_itens_assoc_w	varchar(1) := 'N';
ie_conferir_med_antes_adm_w	varchar(1) := 'N';
nr_seq_lote_w		prescr_mat_hor.nr_seq_lote%type;
ie_param716_w       varchar(1);
ie_susp_nurse_w varchar(2);
ie_status_processo_w adep_processo.ie_status_processo%type;
nr_seq_processo_orig_w adep_processo.nr_sequencia%type;
nr_atendimento_w adep_processo.nr_atendimento%type;
cd_local_estoque_w adep_processo.cd_local_estoque%type;

c01 CURSOR FOR
SELECT	a.nr_prescricao nr_prescricao, /* itens associados ao procedimento */
	b.nr_sequencia nr_seq_item,
	c.nr_sequencia nr_seq_hor,
	b.cd_material,
	c.nr_seq_processo,
    b.nr_seq_mat_cpoe
from	prescr_mat_hor c,
	prescr_material b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_material = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	b.ie_agrupador in (5,15)
and	coalesce(c.ie_situacao,'A') = 'A'
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and (ie_adm_itens_assoc_w  = 'S' or coalesce(b.ie_checar_adep,'N') = 'N' or ie_alterar_item_assoc_p = 'S')
and	((b.nr_sequencia_proc = nr_seq_item_p AND ie_tipo_item_p	<> 'IAO') or
	 (b.nr_seq_gasoterapia = nr_seq_item_p AND ie_tipo_item_p	= 'IAO'))
and	((c.dt_horario = dt_horario_p) or (coalesce(b.ie_urgencia,'N') = 'S'))
and	ie_tipo_item_w in ('IA','IAG','IAO')
and	coalesce(c.ie_horario_especial,'N') <> 'S'
and (ie_adm_itens_assoc_w <> 'S' or (ie_tipo_item_w <> 'IAG' or (coalesce(c.ie_dose_especial, 'N') <> 'S' or coalesce(ie_palm_p, 'N') = 'S')))
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S';


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (dt_horario_p IS NOT NULL AND dt_horario_p::text <> '') and (dt_evento_p IS NOT NULL AND dt_evento_p::text <> '') and (ie_alteracao_p IS NOT NULL AND ie_alteracao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	cd_setor_pac_w	:= Obter_Unidade_Atendimento(nr_atendimento_p, 'IA', 'CS');

	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	ie_lancar_conta_w := obter_param_usuario(1113, 416, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_lancar_conta_w);
	ie_lanca_itens_assoc_w := Obter_Param_Usuario(1113, 663, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_lanca_itens_assoc_w);
    ie_param716_w := obter_param_usuario(1113, 716, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_param716_w);

	if (ie_tipo_item_p in ('CIG','CCG')) then
		ie_tipo_item_w	:= 'IAG';
	elsif (ie_tipo_item_p in ('AP','IAO')) then
		ie_tipo_item_w	:= 'IA';
	else
		ie_tipo_item_w	:= ie_tipo_item_p;
	end if;

	--Se o usuario estiver checando o item associado ao procedimento/gasoterapia
	--ira administrar o item mesmo que o ie_checar_adep_esteja S
	if (wheb_usuario_pck.get_cd_funcao = 88) then
		ie_conferir_med_antes_adm_w := Obter_Param_Usuario(88, 291, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_conferir_med_antes_adm_w);
		if	(ie_conferir_med_antes_adm_w <> 'N' AND ie_tipo_item_w = 'IA') or (ie_tipo_item_w = 'IAG') then
			ie_adm_itens_assoc_w	:= 'S';
		end if;		
	end if;


	/* gerar alteracao horarios x itens associados */

	open c01;
	loop
	fetch c01 into
		nr_prescricao_w,
		nr_seq_item_w,
		nr_seq_horario_w,
		cd_item_w,
		nr_seq_processo_w,
        nr_seq_item_cpoe_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (ie_tipo_item_w in ('IA','IAG')) then /* itens associados ao procedimento */
			if (ie_alteracao_p = 3) then /* administracao do horario */
				update	prescr_mat_hor
				set	dt_fim_horario	= dt_atualizacao_w,
					nm_usuario_adm	= nm_usuario_p
				where	nr_sequencia		= nr_seq_horario_w
				and	coalesce(dt_fim_horario::text, '') = ''
				and	coalesce(dt_suspensao::text, '') = '';

				/*Lancar os itens associados aos procedimentos na conta paciente*/

				if (ie_lancar_conta_w = 'S' and ie_tipo_item_p <> 'IAO') or (ie_lanca_itens_assoc_w = 'S' and ie_tipo_item_p = 'IAO') then

					if (ie_tipo_item_w	= 'IAG') then
						select	coalesce(max(c.ie_cobra_adm),'N')
						into STRICT	ie_prot_cobra_adm_w
						from	pep_protocolo_glicemia c,
								prescr_procedimento b,
								prescr_material a
						where	a.nr_prescricao	= b.nr_prescricao
						and		a.nr_sequencia_proc	= b.nr_sequencia
						and		b.nr_seq_prot_glic	= c.nr_sequencia
						and		a.nr_prescricao	= nr_prescricao_w
						and		a.nr_sequencia	= nr_seq_item_w;
					elsif (ie_tipo_item_w	= 'IA') then

						select	coalesce(max(b.ie_ivc),'N')
						into STRICT	ie_ivc_w
						from	proc_interno b,
								prescr_procedimento a
						where	a.nr_seq_proc_interno = b.nr_sequencia
						and		a.nr_prescricao = nr_prescricao_p
						and		a.nr_sequencia	= nr_seq_item_p;

						if (ie_ivc_w	= 'S') then
							ie_prot_cobra_adm_w := obter_param_usuario(1113, 672, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_prot_cobra_adm_w);						
						else
							ie_prot_cobra_adm_w	:= 'N';
						end if;	
					else
						ie_prot_cobra_adm_w	:= 'N';
					end if;

					if (ie_prot_cobra_adm_w	= 'N') then
						nr_seq_map_w := Gerar_estornar_adep_map(NULL, nr_seq_horario_w, NULL, 'G', dt_horario_p, nm_usuario_p, nr_seq_map_w, 'GAP', null, null);
					end if;
				end if;		
				if (coalesce(nr_seq_processo_w,0) > 0) then			

					select coalesce(max('N'), 'S')
					  into STRICT ie_atualiza_processo_w
					  from adep_processo a,
						   prescr_mat_hor p  
					 where a.nr_sequencia = nr_seq_processo_w 
					   and p.nr_seq_processo = a.nr_sequencia 
					   and coalesce(a.dt_paciente::text, '') = ''
					   and p.ie_agrupador not in (5, 15);				

					if (ie_atualiza_processo_w = 'S') then
						CALL atualiza_status_processo_adep(nr_seq_processo_w, null, 'A', 'A', clock_timestamp(), nm_usuario_p);
					end if;						
				end if;
			elsif (ie_alteracao_p = 4) then /* reversao da realizacao do horario */
                update  prescr_mat_hor a
                set     a.dt_fim_horario  = NULL,
                        a.nm_usuario_adm  = NULL
                where   a.nr_sequencia = nr_seq_horario_w
                and     (a.dt_fim_horario IS NOT NULL AND a.dt_fim_horario::text <> '');

                select  max(a.nr_seq_processo)
                into STRICT    nr_seq_processo_w
                from    prescr_mat_hor a,
                        adep_processo b
                where   a.nr_seq_processo = b.nr_sequencia
                and     a.nr_sequencia = nr_seq_horario_w
                and     Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S';

                if (nr_seq_processo_w IS NOT NULL AND nr_seq_processo_w::text <> '') then
                    CALL Reverter_processo_horario(nr_seq_horario_p	=> nr_seq_horario_w,
                                              nr_seq_processo_p	=> nr_seq_processo_w,
                                              nm_usuario_p		=> nm_usuario_p);
                end if;

                select  max(a.nr_seq_processo),
                        max(b.nr_atendimento),
                        max(b.cd_local_estoque),
                        max(b.ie_status_processo)
                into STRICT    nr_seq_processo_w,
                        nr_atendimento_w,
                        cd_local_estoque_w,
                        ie_status_processo_w
                from    prescr_mat_hor a,
                        adep_processo b
                where   a.nr_seq_processo = b.nr_sequencia
                and     a.nr_sequencia = nr_seq_horario_w
                and     Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S';

                nr_seq_processo_orig_w := nr_seq_processo_w;

                select  max(a.nr_sequencia)
                into STRICT    nr_seq_processo_w
                from    adep_processo a
                where   a.nr_atendimento = nr_atendimento_w
                and     a.cd_local_estoque = cd_local_estoque_w
                and     a.ie_status_processo = ie_status_processo_w
                and     a.dt_horario_processo = dt_horario_p
                and     a.nr_prescricao = nr_prescricao_w
                and     a.nr_sequencia <> nr_seq_processo_orig_w;

                if (nr_seq_processo_orig_w <> nr_seq_processo_w) then
                    CALL adep_agrupar_processos(nr_atendimento_p         => nr_atendimento_p,
                                            dt_horario_p            => dt_horario_p,
                                            nr_processo_origem_p    => nr_seq_processo_orig_w,
                                            nr_processo_destino_p   => nr_seq_processo_w,
                                            nr_seq_area_prep_p      => 0,
                                            nm_usuario_p            => nm_usuario_p);
                end if;
			elsif (ie_alteracao_p = 5) then /* suspensao do horario */
				update	prescr_mat_hor
				set	dt_suspensao		= dt_atualizacao_w,
					nm_usuario_susp		= nm_usuario_p
				where	nr_sequencia		= nr_seq_horario_w
				and	coalesce(dt_suspensao::text, '') = ''
				and	coalesce(dt_fim_horario::text, '') = '';
			elsif (ie_alteracao_p = 6) then /* reversao da suspensao do horario */
				update	prescr_mat_hor
				set	dt_suspensao		 = NULL,
					nm_usuario_susp		 = NULL
				where	nr_sequencia		= nr_seq_horario_w
				and	(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '');
			end if;
		end if;

		/* gerar evento alteracao conforme tipo item */

		select	nextval('prescr_mat_alteracao_seq')
		into STRICT	nr_seq_alteracao_w
		;

		if (ie_tipo_item_w in ('IA','IAG')) then /* itens associados ao procedimento */
			if (ie_tipo_item_w = 'IA') then
				select 	max(a.nr_seq_lote)
				  into STRICT 	nr_seq_lote_w
				  from 	prescr_mat_hor a
				where 	a.nr_sequencia = nr_seq_horario_w;
			end if;

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
								qt_dose_adm,
								cd_um_dose_adm,
								nr_seq_lote
								)
							values (
								nr_seq_alteracao_w,
								dt_atualizacao_w,
								nm_usuario_p,
								dt_atualizacao_w,
								nm_usuario_p,
								nr_prescricao_w,
								nr_seq_item_w,
								nr_seq_horario_w,
								dt_evento_p,
								obter_dados_usuario_opcao(nm_usuario_p,'C'),
								ie_alteracao_p,
								null,
								ie_tipo_item_w,
								dt_horario_p,
								nr_atendimento_p,
								cd_item_w,
								null,
								null,
								nr_seq_lote_w
								);


			if (ie_alteracao_p	= 3) and (ie_tipo_item_w = 'IAG') then
				select	coalesce(max(qt_minutos_apraz_cg),0),
					max(nr_seq_hor_glic)
				into STRICT	qt_minutos_apraz_cg_w,
					nr_seq_hor_glic_w
				from	prescr_mat_hor
				where	nr_sequencia	= nr_seq_horario_w;

				if (qt_minutos_apraz_cg_w	> 0) then

					select	max(a.nr_sequencia),
						max(a.cd_procedimento),
						max(a.cd_intervalo),
						max(a.qt_procedimento),
						max(a.nr_seq_proc_interno),
						max(CASE WHEN a.ie_acm='N' THEN CASE WHEN a.ie_se_necessario='S' THEN 'S'  ELSE 'N' END   ELSE a.ie_acm END ),
						max(a.nr_seq_prot_glic),
						max(a.nr_prescricao)
					into STRICT	nr_seq_proc_ccg_w,
						cd_proc_ccg_w,
						cd_interv_ccg_w,
						qt_proc_ccg_w,
						nr_seq_proc_int_ccg_w,
						ie_acm_sn_ccg_w,
						nr_seq_prot_ccg_w,
						nr_prescr_ccg_w
					from	prescr_procedimento a,
						prescr_proc_hor b
					where	a.nr_prescricao	= b.nr_prescricao
					and	a.nr_sequencia	= b.nr_seq_procedimento
					and	b.nr_sequencia	= nr_seq_hor_glic_w;

					Aprazar_item_prescr('N',
					obter_estab_atend(nr_atendimento_p),
					nr_atendimento_p,
					'G',
					0,
					cd_proc_ccg_w,
					cd_interv_ccg_w,
					qt_proc_ccg_w,
					(clock_timestamp() + (qt_minutos_apraz_cg_w/1440)),
					to_char(nr_prescr_ccg_w),
					nr_prescr_ccg_w,
					nr_seq_proc_ccg_w,
					'N',
					null,
					wheb_mensagem_pck.get_texto(307600), -- Realizado pelo sistema
					nm_usuario_p,
					ie_inconsistencia_ccg_w,
					ds_inconsistentes_ccg_w,
					nr_seq_proc_int_ccg_w,
					null,
					ie_acm_sn_ccg_w,
					null,
					null,
					'S',
					nr_seq_hor_glic_w,
					nr_seq_prot_ccg_w,
					null,
					null,
					'',
					null,
					null);

				end if;
			end if;

        if (ie_param716_w <> 'N') then
            ie_susp_nurse_w := 'N';
            if (ie_alteracao_p = 4) then
                ie_susp_nurse_w := 'S';
            end if;
            CALL generate_nurse_ack(ie_susp_nurse_w, ie_tipo_item_w, nr_atendimento_p, nr_seq_item_cpoe_w, cd_item_w);
        end if;

		end if;
		end;
	end loop;
	close c01;
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alter_horario_item_assoc (nr_atendimento_p bigint, ie_tipo_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, cd_item_p text, dt_horario_p timestamp, dt_evento_p timestamp, ie_alteracao_p bigint, nm_usuario_p text, ie_alterar_item_assoc_p text default 'N', ie_palm_p text default 'N') FROM PUBLIC;
