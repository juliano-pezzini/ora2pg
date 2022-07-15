-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_prescricao_nutricao (nr_prescricao_p bigint, nr_seq_serv_rep_p bigint, nr_seq_serv_dia_p bigint, ie_tipo_p text, nm_usuario_p text, cd_perfil_p bigint default 0, cd_estabelecimento_p bigint default 0) AS $body$
DECLARE


nr_seq_serv_rep_w	bigint;				
ie_prescr_oral_w	varchar(1);
ie_prescr_jejum_w	varchar(1);
ie_prescr_compl_w	varchar(1);
ie_prescr_enteral_w	varchar(1);
ie_prescr_npt_adulta_w	varchar(1);
ie_prescr_npt_neo_w	varchar(1);
ie_prescr_npt_ped_w	varchar(1);
ie_prescr_leite_deriv_w	varchar(1);
nr_seq_def_rep_w	varchar(255);
ie_prescricao_valida_w	varchar(1);
ie_pac_jejum_w  	varchar(1);
ie_prescr_hor_w		varchar(1);
cd_perfil_w 		bigint;
cd_estabelecimento_w 	bigint;

/*Declaracao de constrantes*/

IS_VAR_S_W 		CONSTANT varchar(1) := 'S';
IS_VAR_N_W 		CONSTANT varchar(1) := 'N';
IS_PRESCR_ORAL_W 	CONSTANT varchar(2) := 'DO';
IS_PRESCR_JEJUM_W 	CONSTANT varchar(2) := 'JE';
IS_PRESCR_COMPL_W 	CONSTANT varchar(2) := 'SO';
IS_PRESCR_ENTERAL_W 	CONSTANT varchar(2) := 'NE';
IS_PRESCR_NPT_ADULTA_W 	CONSTANT varchar(2) := 'NA';
IS_PRESCR_NPT_NEO_W 	CONSTANT varchar(2) := 'NN';
IS_PRESCR_NPT_PED_W 	CONSTANT varchar(2) := 'NP';
IS_PRESCR_LEITE_DERIV_W CONSTANT varchar(2) := 'LD';
IS_PRESC_TODAS_W	CONSTANT varchar(1) := 'T';
IS_NPT_ADULTA_W		CONSTANT varchar(1) := 'P';
IE_TIPO_PRESCR_JEJUM_W 	CONSTANT bigint := 2;

/*
ie_tipo_p :
T - Todas
DO - Dieta oral
JE - Jejum
SO - Suplemento
NE - Enteral
NA - NPT Adulto
NN - NPT Neonatal
NP - NPT Pediatrica
LD - Leite e derivados
*/
					

BEGIN

cd_perfil_w := cd_perfil_p;
cd_estabelecimento_w := cd_estabelecimento_p;

if ( cd_perfil_w = 0 ) then
	cd_perfil_w := obter_perfil_ativo();
end if;

if ( cd_estabelecimento_w = 0 ) then
	select	max(cd_estabelecimento)
		into STRICT	cd_estabelecimento_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;
end if;

ie_prescr_hor_w := obter_param_usuario(1003, 125, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_prescr_hor_w);

if ( ie_prescr_hor_w <> 'S' ) then

	SELECT	COALESCE(max(IS_VAR_S_W), IS_VAR_N_W)
	into STRICT	ie_prescricao_valida_w
	FROM	prescr_medica a,
		nut_atend_serv_dia b,
		nut_servico c
	WHERE	a.nr_prescricao = nr_prescricao_p
	AND	b.nr_sequencia	= nr_seq_serv_dia_p   
	and	c.nr_sequencia = b.nr_seq_servico           
	AND	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '') 
	AND	((b.dt_servico BETWEEN a.dt_inicio_prescr AND a.dt_validade_prescr) OR (coalesce(a.dt_validade_prescr::text, '') = ''))                  
	AND 	((EXISTS	(SELECT  1 
				FROM prescr_dieta x
LEFT OUTER JOIN cpoe_dieta y ON (x.nr_seq_dieta_cpoe = y.nr_sequencia)
WHERE (a.nr_prescricao = x.nr_prescricao)  AND (((x.ie_suspenso = 'N' or coalesce(x.ie_suspenso::text, '') = '') and coalesce(y.nr_sequencia::text, '') = '')
					OR ((coalesce(y.dt_lib_suspensao::text, '') = '' OR y.dt_lib_suspensao > b.dt_servico) 
					AND b.dt_servico BETWEEN TRUNC(y.dt_inicio,'MI') AND coalesce(y.dt_fim, b.dt_servico))) ) 
				and     c.IE_TIPO_PRESCRICAO_SERVICO = 1)                                   
		OR (EXISTS (SELECT 1 FROM rep_jejum c WHERE a.nr_prescricao = c.nr_prescricao))                                                      
		OR (EXISTS (SELECT 1 FROM prescr_material d WHERE (a.nr_prescricao = d.nr_prescricao AND d.ie_agrupador = 8)) and c.IE_TIPO_PRESCRICAO_SERVICO = 4)   
		OR (EXISTS (SELECT 1 FROM prescr_material d WHERE (a.nr_prescricao = d.nr_prescricao AND d.ie_agrupador = 12)) and c.IE_TIPO_PRESCRICAO_SERVICO = 3)   
		OR (EXISTS (SELECT 1 FROM nut_pac e WHERE (a.nr_prescricao = e.nr_prescricao)) and c.IE_TIPO_PRESCRICAO_SERVICO in (5,6,7)) 
		OR (EXISTS (SELECT 1 FROM prescr_leite_deriv e WHERE a.nr_prescricao = e.nr_prescricao) and c.IE_TIPO_PRESCRICAO_SERVICO = 8));
else

	SELECT	COALESCE(max(IS_VAR_S_W), IS_VAR_N_W)                          
	into STRICT	ie_prescricao_valida_w
	FROM	prescr_medica a,
		nut_atend_serv_dia b,
		nut_servico c,
		nut_servico_horario d
	WHERE	a.nr_prescricao = nr_prescricao_p
	AND	b.nr_sequencia	= nr_seq_serv_dia_p   
	AND	c.nr_sequencia = b.nr_seq_servico 
	AND 	d.nr_seq_servico = c.nr_sequencia          
	AND	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '') 
	AND	((b.dt_servico BETWEEN a.dt_inicio_prescr AND a.dt_validade_prescr) OR (coalesce(a.dt_validade_prescr::text, '') = ''))
	AND 	((EXISTS	(SELECT  1 
				FROM prescr_dieta_hor z, prescr_dieta x
LEFT OUTER JOIN cpoe_dieta y ON (x.nr_seq_dieta_cpoe = y.nr_sequencia)
WHERE (a.nr_prescricao = x.nr_prescricao)  and z.nr_prescricao = x.nr_prescricao AND (((x.ie_suspenso = 'N' or coalesce(x.ie_suspenso::text, '') = '') and coalesce(y.nr_sequencia::text, '') = '')
					OR ((coalesce(y.dt_lib_suspensao::text, '') = '' OR y.dt_lib_suspensao > b.dt_servico) 
					    and (coalesce(z.dt_suspensao::text, '') = '' or z.dt_suspensao > b.dt_servico) 
					AND b.dt_servico BETWEEN PKG_DATE_UTILS.get_Time(z.dt_horario, d.ds_horarios) and PKG_DATE_UTILS.get_Time(coalesce(z.dt_horario, b.dt_servico), coalesce(d.ds_horarios_fim,d.ds_horarios)))) )
				and     c.IE_TIPO_PRESCRICAO_SERVICO = 1)                                   
		OR (EXISTS (SELECT 1 FROM rep_jejum c WHERE a.nr_prescricao = c.nr_prescricao))                                                      
		OR (EXISTS (SELECT 1 FROM prescr_material d WHERE (a.nr_prescricao = d.nr_prescricao AND d.ie_agrupador = 8)) and c.IE_TIPO_PRESCRICAO_SERVICO = 4)   
		OR (EXISTS (SELECT 1 FROM prescr_material d WHERE (a.nr_prescricao = d.nr_prescricao AND d.ie_agrupador = 12)) and c.IE_TIPO_PRESCRICAO_SERVICO = 3)   
		OR (EXISTS (SELECT 1 FROM nut_pac e WHERE (a.nr_prescricao = e.nr_prescricao)) and c.IE_TIPO_PRESCRICAO_SERVICO in (5,6,7)) 
		OR (EXISTS (SELECT 1 FROM prescr_leite_deriv e WHERE a.nr_prescricao = e.nr_prescricao) and c.IE_TIPO_PRESCRICAO_SERVICO = 8));
end if;

if (ie_prescricao_valida_w = IS_VAR_S_W) then

	if (nr_seq_serv_rep_p = 0) then
	
		select	nextval('nut_atend_serv_dia_rep_seq')
		into STRICT	nr_seq_serv_rep_w
		;
	
		insert into nut_atend_serv_dia_rep(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_serv_dia)
			values (
			nr_seq_serv_rep_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_serv_dia_p);	
	
	else
		nr_seq_serv_rep_w := nr_seq_Serv_rep_p;
	end if;	

	if (ie_tipo_p = IS_PRESC_TODAS_W) then
	
		ie_pac_jejum_w := nut_obter_se_tem_jejum(nr_seq_serv_dia_p);
		
		if ( ie_prescr_hor_w = 'S' ) then

			select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
			into STRICT	ie_prescr_oral_w
			FROM prescr_dieta_hor z, nut_servico_horario f, prescr_medica d, nut_servico c, nut_atend_serv_dia b, prescr_dieta a
LEFT OUTER JOIN cpoe_dieta e ON (a.nr_seq_dieta_cpoe = e.nr_sequencia)
WHERE a.nr_prescricao = d.nr_prescricao  and a.nr_prescricao = nr_prescricao_p and b.nr_seq_servico = c.nr_sequencia and b.nr_sequencia = nr_seq_serv_dia_p and f.nr_seq_servico = c.nr_sequencia and z.nr_prescricao = a.nr_prescricao and c.ie_tipo_prescricao_servico = 1 and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W) and ie_pac_jejum_w = IS_VAR_N_W AND (((a.ie_suspenso = 'N' or coalesce(a.ie_suspenso::text, '') = '') and coalesce(e.nr_sequencia::text, '') = '')
				OR ((coalesce(e.dt_lib_suspensao::text, '') = '' OR e.dt_lib_suspensao > b.dt_servico) 
				    and (coalesce(z.dt_suspensao::text, '') = '' or z.dt_suspensao > b.dt_servico) 
				AND z.dt_horario >= PKG_DATE_UTILS.get_Time(z.dt_horario, f.ds_horarios) and (coalesce(f.ds_horarios_fim::text, '') = '' or z.dt_horario <=PKG_DATE_UTILS.get_Time(coalesce(z.dt_horario, b.dt_servico), f.ds_horarios_fim)  )
				)) and not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 1 and coalesce(x.ie_situacao,'A') = 'A');
		else
			select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
			into STRICT	ie_prescr_oral_w
			FROM prescr_medica d, nut_servico c, nut_atend_serv_dia b, prescr_dieta a
LEFT OUTER JOIN cpoe_dieta e ON (a.nr_seq_dieta_cpoe = e.nr_sequencia)
WHERE a.nr_prescricao = d.nr_prescricao  and a.nr_prescricao = nr_prescricao_p and b.nr_seq_servico = c.nr_sequencia and b.nr_sequencia = nr_seq_serv_dia_p and c.ie_tipo_prescricao_servico = 1 and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W) and ie_pac_jejum_w = IS_VAR_N_W AND (((a.ie_suspenso = 'N' or coalesce(a.ie_suspenso::text, '') = '') and coalesce(e.nr_sequencia::text, '') = '')
				OR ((coalesce(e.dt_lib_suspensao::text, '') = '' OR e.dt_lib_suspensao > b.dt_servico)
				AND b.dt_servico BETWEEN e.dt_inicio AND coalesce(e.dt_fim, b.dt_servico))) and not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 1 and coalesce(x.ie_situacao,'A') = 'A');
		end if;
		
                select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
		into STRICT	ie_prescr_jejum_w
		from	rep_jejum a,
                        nut_atend_serv_dia b, 
                        nut_servico c
		where	a.nr_prescricao = nr_prescricao_p
                and     b.nr_seq_servico = c.nr_sequencia
                and     b.nr_sequencia = nr_seq_serv_dia_p 
                and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W)
                and (c.ie_tipo_prescricao_servico = IE_TIPO_PRESCR_JEJUM_W or ie_pac_jejum_w = IS_VAR_S_W)
                and	not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = IE_TIPO_PRESCR_JEJUM_W and coalesce(x.ie_situacao,'A') = 'A');

                select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
                into STRICT	ie_prescr_compl_w
                from	prescr_material a, 
                        nut_atend_serv_dia b, 
                        nut_servico c
                where	a.nr_prescricao = nr_prescricao_p
                and     c.nr_sequencia = b.nr_seq_servico
                and     b.nr_sequencia = nr_seq_serv_dia_p
                and     c.ie_tipo_prescricao_servico = 3
                and	a.ie_agrupador = 12
                and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W)
		        and	not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 3 and coalesce(x.ie_situacao,'A') = 'A');
		
                select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
                into STRICT	ie_prescr_enteral_w
                from	prescr_material a,
                        nut_atend_serv_dia b, 
                        nut_servico c
                where	a.nr_prescricao = nr_prescricao_p
                and     c.nr_sequencia = b.nr_seq_servico
                and     b.nr_sequencia = nr_seq_serv_dia_p
                and     c.ie_tipo_prescricao_servico = 4
                and	a.ie_agrupador = 8
                and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W)
		and	not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 4 and coalesce(x.ie_situacao,'A') = 'A');
		
                select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
		into STRICT	ie_prescr_npt_adulta_w
		from	nut_pac a,
                        nut_atend_serv_dia b,
                        nut_servico c
		where	a.nr_prescricao = nr_prescricao_p
                and     b.nr_seq_servico = c.nr_sequencia
                and     b.nr_sequencia = nr_seq_serv_dia_p 
                and	ie_npt_adulta = IS_VAR_S_W
                and     c.ie_tipo_prescricao_servico = 5
		and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W)
                and	not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 5 and coalesce(x.ie_situacao,'A') = 'A');
		
                select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
		into STRICT	ie_prescr_npt_neo_w
		from	nut_pac a,
                        nut_atend_serv_dia b, 
                        nut_servico c
		where	a.nr_prescricao = nr_prescricao_p
                and     b.nr_seq_servico = c.nr_sequencia
                and     b.nr_sequencia = nr_seq_serv_dia_p 
                and	ie_npt_adulta = IS_VAR_N_W
                and     c.ie_tipo_prescricao_servico = 6
		and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W)
                and	not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 6 and coalesce(x.ie_situacao,'A') = 'A');
		
		select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
		into STRICT	ie_prescr_npt_ped_w
		from	nut_pac a,
                        nut_atend_serv_dia b, 
                        nut_servico c
		where	a.nr_prescricao = nr_prescricao_p
                and     b.nr_seq_servico = c.nr_sequencia
                and     b.nr_sequencia = nr_seq_serv_dia_p  
                and     c.ie_tipo_prescricao_servico = 7               
                and	ie_npt_adulta = IS_NPT_ADULTA_W
		and (coalesce(a.ie_suspenso::text, '') = '' or a.ie_suspenso = IS_VAR_N_W)
		and	not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 7 and coalesce(x.ie_situacao,'A') = 'A');
		
		select	coalesce(max(IS_VAR_S_W), IS_VAR_N_W)
		into STRICT	ie_prescr_leite_deriv_w
		from	prescr_leite_deriv a,                
                        nut_atend_serv_dia b, 
                        nut_servico c
		where	a.nr_prescricao = nr_prescricao_p
                and     b.nr_seq_servico = c.nr_sequencia
                and     b.nr_sequencia = nr_seq_serv_dia_p
                and     c.ie_tipo_prescricao_servico = 8
                and	not exists (SELECT 1 from nut_bloquear_conduta x where x.ie_tipo_prescricao_servico = 8 and coalesce(x.ie_situacao,'A') = 'A');

		update 	nut_atend_serv_dia_rep
		set 	nr_prescr_oral 		= CASE WHEN ie_prescr_oral_w=IS_VAR_N_W THEN nr_prescr_oral  ELSE nr_prescricao_p END ,
			nr_prescr_jejum 	= CASE WHEN ie_prescr_jejum_w=IS_VAR_N_W THEN nr_prescr_jejum  ELSE nr_prescricao_p END ,
			nr_prescr_compl 	= CASE WHEN ie_prescr_compl_w=IS_VAR_N_W THEN nr_prescr_compl  ELSE nr_prescricao_p END ,
			nr_prescr_enteral 	= CASE WHEN ie_prescr_enteral_w=IS_VAR_N_W THEN nr_prescr_enteral  ELSE nr_prescricao_p END ,
			nr_prescr_npt_adulta 	= CASE WHEN ie_prescr_npt_adulta_w=IS_VAR_N_W THEN nr_prescr_npt_adulta  ELSE nr_prescricao_p END ,
			nr_prescr_npt_neo 	= CASE WHEN ie_prescr_npt_neo_w=IS_VAR_N_W THEN nr_prescr_npt_neo  ELSE nr_prescricao_p END ,
			nr_prescr_npt_ped 	= CASE WHEN ie_prescr_npt_ped_w=IS_VAR_N_W THEN nr_prescr_npt_ped  ELSE nr_prescricao_p END ,
			nr_prescr_leite_deriv	= CASE WHEN ie_prescr_leite_deriv_w=IS_VAR_N_W THEN nr_prescr_leite_deriv  ELSE nr_prescricao_p END ,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_seq_serv_rep_w;
	
	else

		update 	nut_atend_serv_dia_rep
		set 	nr_prescr_oral 		= CASE WHEN ie_tipo_p=IS_PRESCR_ORAL_W THEN nr_prescricao_p  ELSE nr_prescr_oral END ,
			nr_prescr_jejum 	= CASE WHEN ie_tipo_p=IS_PRESCR_JEJUM_W THEN nr_prescricao_p  ELSE nr_prescr_jejum END ,
			nr_prescr_compl 	= CASE WHEN ie_tipo_p=IS_PRESCR_COMPL_W THEN nr_prescricao_p  ELSE nr_prescr_compl END ,
			nr_prescr_enteral 	= CASE WHEN ie_tipo_p=IS_PRESCR_ENTERAL_W THEN nr_prescricao_p  ELSE nr_prescr_enteral END ,
			nr_prescr_npt_adulta 	= CASE WHEN ie_tipo_p=IS_PRESCR_NPT_ADULTA_W THEN nr_prescricao_p  ELSE nr_prescr_npt_adulta END ,
			nr_prescr_npt_neo 	= CASE WHEN ie_tipo_p=IS_PRESCR_NPT_NEO_W THEN nr_prescricao_p  ELSE nr_prescr_npt_neo END ,
			nr_prescr_npt_ped 	= CASE WHEN ie_tipo_p=IS_PRESCR_NPT_PED_W THEN nr_prescricao_p  ELSE nr_prescr_npt_ped END ,
			nr_prescr_leite_deriv	= CASE WHEN ie_tipo_p=IS_PRESCR_LEITE_DERIV_W THEN nr_prescricao_p  ELSE nr_prescr_leite_deriv END ,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_seq_serv_rep_w;

	end if; 	

	/*Log de criacao do registro:*/

	select	nextval('nut_definicao_prescr_log_seq')
	into STRICT	nr_seq_def_rep_w
	; 	

	insert into nut_definicao_prescr_log(NR_SEQUENCIA,
					DT_ATUALIZACAO,
					NM_USUARIO,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO_NREC,
					IE_DEFINIR,
					NR_PRESCRICAO,
					IE_TIPO_DEFINICAO)
				values (nr_seq_def_rep_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					NM_USUARIO_p,
					'D',
					nr_prescricao_p,
					ie_tipo_p);	

	insert into log_tasy(  dt_atualizacao,
				nm_usuario, 
				cd_log, 
				ds_log)
		values ( 	clock_timestamp(), 
				nm_usuario_p,  
				8579, 
				substr('nr_prescricao_p: ' || nr_prescricao_p || ' Seq serv dia: '||nr_seq_serv_dia_p||' - Seq serv rep: '||nr_seq_serv_rep_w||' - Seq_log: '||nr_seq_def_rep_w||' - '||dbms_utility.format_call_stack,1,2000));
										
end if;
										
if (coalesce(wheb_usuario_pck.get_ie_commit, IS_VAR_S_W) = IS_VAR_S_W) then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_prescricao_nutricao (nr_prescricao_p bigint, nr_seq_serv_rep_p bigint, nr_seq_serv_dia_p bigint, ie_tipo_p text, nm_usuario_p text, cd_perfil_p bigint default 0, cd_estabelecimento_p bigint default 0) FROM PUBLIC;

