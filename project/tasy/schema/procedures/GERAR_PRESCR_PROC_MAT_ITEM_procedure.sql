-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_proc_mat_item ( nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_prescr_p bigint default null) AS $body$
DECLARE


qt_registros_w      bigint;
nr_registro_w       bigint;
nr_seq_prescr_w			integer;
nr_seq_exame_w			bigint;
nr_seq_grupo_w			bigint;
nr_seq_grupo_imp_w		bigint;
nr_seq_origem_w 		integer;
nr_seq_material_w		bigint;
qt_coleta_w			smallint;
qt_volume_padrao_w		integer;
qt_volume_frasco_w		integer;
qt_frascos_w         integer;
qt_volume_sobra_w integer;
qt_volume_w integer;
qt_volume_material_w  integer;
qt_volume_somado_w  integer;
qt_tempo_padrao_w		real;
ie_padrao_amostra_w		varchar(5);
nr_seq_prescr_proc_mat_w 	bigint;
ie_status_atend_w		smallint;
nr_seq_lab_w			varchar(20);
dt_liberacao_ddmmyyyy_w			varchar(8);
dt_liberacao_ddmmyy_w			varchar(8);
cd_barras_w			varchar(100);
ie_amostra_w    		varchar(1);
qt_exames_amostra_exame_w	bigint;
qt_exames_amostra_w		bigint;
nr_seq_frasco_w			bigint;
qt_exames_amostra_grupo_w	bigint;
ie_grupo_imp_amostra_seq_w	varchar(1);
--nr_identificador_w	number(10);
nr_seq_barras_w			bigint;
cd_identificador_w		varchar(5);
nr_seq_material_integracao_w	varchar(3);
nr_seq_int_prescr_w		bigint;
ie_agrupa_amostra_horario_w		varchar(1);
dt_prev_execucao_w timestamp;
ie_considera_vol_amostra_w varchar(1);
ie_nova_amostra_w varchar(1);
nr_seq_frasco_ant_w			bigint;
nr_seq_material_ant_w    bigint;
nr_seq_grupo_ant_w			bigint;
nr_seq_grupo_imp_ant_w		bigint;
nr_seq_origem_ant_w 		integer;
nr_seq_prescr_ant_w			integer;
qt_tempo_padrao_ant_w		real;
qt_coleta_ant_w			smallint;
ie_amostra_ant_w    		varchar(1);
nr_seq_lab_ant_w			varchar(20);
ie_status_atend_ant_w		smallint;
dt_prescricao_w         varchar(8);
dt_liberacao_medico_w varchar(8);
ie_rule_age_w   		varchar(1);
ie_ordena_amostra_w		lab_parametro.ie_ordena_amostra%type;
dt_padrao_amostra_ddmm_w varchar(4);
dt_padrao_amostra_dd_w varchar(2);

nr_seq_motivo_recoleta_w	prescr_procedimento.nr_seq_recoleta%type;
ie_urgencia_w			prescr_procedimento.ie_urgencia%type;

ie_pendente_amostra_w prescr_procedimento.ie_pendente_amostra%type;
ie_cons_pend_amostra_w lab_parametro.IE_CONS_PEND_AMOSTRA%type;

c01 CURSOR FOR
	        SELECT COUNT(*) OVER (),
                a.nr_sequencia,
		a.nr_seq_exame,
		b.nr_seq_grupo,
		b.nr_seq_grupo_imp,
		coalesce(a.nr_seq_origem,0),
		d.nr_sequencia,
		coalesce(c.qt_coleta,1),
		coalesce(d.qt_volume_padrao,CASE WHEN ie_considera_vol_amostra_w='S' THEN  coalesce(c.qt_volume_referencia,0)  ELSE 0 END ),
		coalesce(d.qt_tempo_padrao,0),
		coalesce(a.ie_status_atend,10),
		a.nr_seq_lab,
		a.ie_amostra,
		nr_seq_frasco,
		a.DT_PREV_EXECUCAO,
		a.nr_seq_recoleta,
		coalesce(a.ie_urgencia,'N'),
		CASE WHEN ie_rule_age_w='S' THEN lab_obter_volume_frasco_age(nr_prescricao_p)  ELSE lab_obter_volume_frasco(nr_seq_frasco) END ,
		a.ie_pendente_amostra
    	from	exame_lab_material c,
		material_exame_lab d,
		exame_laboratorio b,
		prescr_procedimento a,
		prescr_medica k
	where	k.nr_prescricao = nr_prescricao_p
	and	k.nr_prescricao = a.nr_prescricao
	and	a.nr_seq_exame = b.nr_seq_exame
	and	(a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '')
	and	d.nr_sequencia = Obter_Mat_Exame_Lab_prescr(a.nr_prescricao, a.nr_sequencia, 1)
	and	c.nr_seq_material = d.nr_sequencia
	and	c.nr_seq_exame = a.nr_seq_exame
	and	((coalesce(nr_seq_prescr_p::text, '') = '') or (nr_seq_prescr_p = a.nr_sequencia))
	and (d.ie_volume_tempo = 'S' or coalesce(c.qt_coleta,1) > 0)
	and	not exists (SELECT 1 from prescr_proc_mat_item w where a.nr_prescricao = w.nr_prescricao and a.nr_sequencia = w.nr_seq_prescr)
	order by d.nr_sequencia, coalesce(c.qt_coleta,1) desc, b.nr_seq_grupo,CASE WHEN coalesce(ie_ordena_amostra_w,'N')='S' THEN b.nr_seq_apresent  ELSE 1 END , coalesce(a.nr_seq_origem,0), a.nr_sequencia;

BEGIN
  qt_volume_somado_w :=0;
  nr_registro_w      :=1;
  nr_seq_frasco_ant_w:=0;

begin
    select  to_char(coalesce(dt_liberacao,dt_liberacao_medico), 'ddmmyyyy'),
            to_char(dt_prescricao,'ddmmyy'),
            to_char(coalesce(dt_liberacao,dt_liberacao_medico), 'ddmmyy'),
            to_char(coalesce(dt_liberacao_medico,dt_liberacao), 'ddmmyy'),
            to_char(coalesce(dt_liberacao_medico, dt_liberacao, dt_prescricao), 'ddmm'),
            to_char(coalesce(dt_liberacao_medico, dt_liberacao, dt_prescricao), 'dd')
    into STRICT    dt_liberacao_ddmmyyyy_w,
            dt_prescricao_w,
            dt_liberacao_ddmmyy_w,
            dt_liberacao_medico_w,
            dt_padrao_amostra_ddmm_w,
            dt_padrao_amostra_dd_w
    from    prescr_medica
    where   nr_prescricao = nr_prescricao_p;
exception
    when no_data_found or data_exception or data_exception or too_many_rows then
        CALL gravar_log_lab(49,obter_desc_expressao(1076636)||' - '||nr_prescricao_p, nm_usuario_p, nr_prescricao_p);
end;

select  coalesce(max(ie_padrao_amostra),'PM'),
		coalesce(max(qt_exames_amostra),0),
		coalesce(max(ie_gerar_padrao_grupo_imp),'N'),
		coalesce(max(ie_agrupa_amostra_horario),'N'),
		coalesce(max(IE_CONSIDERA_VOL_AMOSTRA),'N'),
		coalesce(max(ie_ordena_amostra),'N'),
		coalesce(max(ie_cons_pend_amostra),'N'),
                coalesce(max(ie_rule_years_old_vol),'N')
into STRICT 	ie_padrao_amostra_w,
		qt_exames_amostra_exame_w,
		ie_grupo_imp_amostra_seq_w,
		ie_agrupa_amostra_horario_w,
		ie_considera_vol_amostra_w,
		ie_ordena_amostra_w,
		ie_cons_pend_amostra_w,
                ie_rule_age_w
from 	lab_parametro
where 	cd_estabelecimento = cd_estabelecimento_p;

select	max(a.cd_identificador)
into STRICT	cd_identificador_w
from  	empresa_integr_dados a
where	(a.cd_identificador IS NOT NULL AND a.cd_identificador::text <> '')
and		a.nr_seq_empresa_integr = 34
and		a.cd_estabelecimento = cd_estabelecimento_p;

open C01;
loop
fetch c01 into	
qt_registros_w,
nr_seq_prescr_w,
nr_seq_exame_w,
nr_seq_grupo_w,
nr_seq_grupo_imp_w,
nr_seq_origem_w,
nr_seq_material_w,
qt_coleta_w,
qt_volume_padrao_w,
qt_tempo_padrao_w,
ie_status_atend_w,
nr_seq_lab_w,
ie_amostra_w,
nr_seq_frasco_w,
dt_prev_execucao_w,
nr_seq_motivo_recoleta_w,
ie_urgencia_w,
qt_volume_frasco_w,
ie_pendente_amostra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

        select 	coalesce(max(qt_exames_amostra),0)
        into STRICT	qt_exames_amostra_grupo_w
        from 	grupo_exame_lab
        where	nr_sequencia = nr_seq_grupo_w;

        if (qt_exames_amostra_grupo_w > 0) then
                qt_exames_amostra_exame_w	:= qt_exames_amostra_grupo_w;
        end if;

        for i in 1..qt_coleta_w loop
                if (coalesce(nr_seq_motivo_recoleta_w::text, '') = '') then

                        if (ie_agrupa_amostra_horario_w = 'U') then

                                SELECT 	coalesce(MAX(NR_SEQ_PRESCR_PROC_MAT),0)
                                into STRICT	nr_seq_prescr_proc_mat_w          
                                FROM   	prescr_procedimento a,  
                                        prescr_proc_material m,
                                        prescr_proc_mat_item b 
                                where (((nr_seq_grupo = nr_seq_grupo_w AND ie_grupo_imp_amostra_seq_w = 'N') or
                                        (nr_seq_grupo_imp = nr_seq_grupo_imp_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
                                and	((coalesce(a.nr_seq_frasco,0) = coalesce(nr_seq_frasco_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
                                and (nr_amostra = i)
                                AND nr_seq_material = nr_seq_material_w
                                AND a.nr_prescricao = b.nr_prescricao
                                AND b.NR_SEQ_PRESCR_PROC_MAT = m.nr_sequencia
                                AND a.nr_sequencia = b.nr_seq_prescr  
                                AND a.nr_prescricao = nr_prescricao_p
                                AND a.nr_sequencia <> nr_seq_prescr_w       
                                and a.ie_urgencia  =  ie_urgencia_w 
                                and ((nr_seq_origem_w = 0) or (nr_seq_origem = nr_seq_origem_w))
                                and ((ie_cons_pend_amostra_w = 'S' and a.ie_pendente_amostra = ie_pendente_amostra_w) or ie_cons_pend_amostra_w = 'N');

                        elsif (ie_agrupa_amostra_horario_w = 'S') then

                                SELECT 	coalesce(MAX(NR_SEQ_PRESCR_PROC_MAT),0)
                                into STRICT	nr_seq_prescr_proc_mat_w          
                                FROM  prescr_procedimento a,  
                                prescr_proc_material m,
                                prescr_proc_mat_item b 
                                where (((nr_seq_grupo = nr_seq_grupo_w AND ie_grupo_imp_amostra_seq_w = 'N') or
                                (nr_seq_grupo_imp = nr_seq_grupo_imp_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
                                and	((coalesce(a.nr_seq_frasco,0) = coalesce(nr_seq_frasco_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
                                and (nr_amostra = i)
                                and ((ie_agrupa_amostra_horario_w = 'S') or (nr_seq_origem_w = 0))
                                AND nr_seq_material = nr_seq_material_w
                                AND a.nr_prescricao = b.nr_prescricao
                                AND b.NR_SEQ_PRESCR_PROC_MAT = m.nr_sequencia
                                AND a.nr_sequencia = b.nr_seq_prescr  
                                AND a.nr_prescricao = nr_prescricao_p
                                AND a.nr_sequencia <> nr_seq_prescr_w         
                                AND (PKG_DATE_UTILS.start_of(a.dt_prev_execucao, 'mi', 0) = PKG_DATE_UTILS.start_of(dt_prev_execucao_w, 'mi', 0))
                                                and ((ie_cons_pend_amostra_w = 'S' and a.ie_pendente_amostra = ie_pendente_amostra_w) or ie_cons_pend_amostra_w = 'N');

			else
				if (ie_cons_pend_amostra_w = 'S') then

					select 	coalesce(max(m.NR_SEQUENCIA),0)
					into STRICT	nr_seq_prescr_proc_mat_w
					from 	prescr_procedimento a,
							prescr_proc_material m,
							prescr_proc_mat_item b 
					where 	a.nr_prescricao = nr_prescricao_p
					and 	m.nr_seq_material = nr_seq_material_w
					and 	(((m.nr_seq_grupo = nr_seq_grupo_w AND ie_grupo_imp_amostra_seq_w = 'N') or
						(m.nr_seq_grupo_imp = nr_seq_grupo_imp_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
					and	((coalesce(m.nr_seq_frasco,0) = coalesce(nr_seq_frasco_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
					and	m.nr_amostra = i
					AND 	a.nr_prescricao = b.nr_prescricao
					AND 	b.nr_seq_prescr_proc_mat = m.nr_sequencia
					AND 	a.nr_sequencia = b.nr_seq_prescr  
					AND 	a.nr_sequencia <> nr_seq_prescr_w         
					and ((ie_agrupa_amostra_horario_w = 'S') or (nr_seq_origem_w = 0))							
					and ((ie_cons_pend_amostra_w = 'S' and a.ie_pendente_amostra = ie_pendente_amostra_w) or ie_cons_pend_amostra_w = 'N');

				else

					select 	coalesce(max(NR_SEQUENCIA),0)
					into STRICT	nr_seq_prescr_proc_mat_w
					from 	prescr_proc_material
					where 	nr_prescricao = nr_prescricao_p
					and 	nr_seq_material = nr_seq_material_w
					and 	(((nr_seq_grupo = nr_seq_grupo_w AND ie_grupo_imp_amostra_seq_w = 'N') or
						(nr_seq_grupo_imp = nr_seq_grupo_imp_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
					and	((coalesce(nr_seq_frasco,0) = coalesce(nr_seq_frasco_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
					and	nr_amostra = i
					and ((ie_agrupa_amostra_horario_w = 'S') or (nr_seq_origem_w = 0));

				end if;

			end if;
		else
			select 	coalesce(max(m.NR_SEQUENCIA),0)
			into STRICT	nr_seq_prescr_proc_mat_w
			from 	prescr_procedimento a,
			        prescr_proc_material m,
			        prescr_proc_mat_item b 
			where 	a.nr_prescricao = nr_prescricao_p
			and 	m.nr_seq_material = nr_seq_material_w
			and 	(((m.nr_seq_grupo = nr_seq_grupo_w AND ie_grupo_imp_amostra_seq_w = 'N') or
				(m.nr_seq_grupo_imp = nr_seq_grupo_imp_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
			and	((coalesce(m.nr_seq_frasco,0) = coalesce(nr_seq_frasco_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
			and	m.nr_amostra = i
			AND 	a.nr_prescricao = b.nr_prescricao
			AND 	b.nr_seq_prescr_proc_mat = m.nr_sequencia
			AND 	a.nr_sequencia = b.nr_seq_prescr  
			AND 	a.nr_sequencia <> nr_seq_prescr_w         
			and 	a.nr_seq_recoleta = nr_seq_motivo_recoleta_w
			and ((ie_agrupa_amostra_horario_w = 'S') or (nr_seq_origem_w = 0))							
			and ((ie_cons_pend_amostra_w = 'S' and a.ie_pendente_amostra = ie_pendente_amostra_w) or ie_cons_pend_amostra_w = 'N');

		end if;

                if ((ie_considera_vol_amostra_w = 'S') and (ie_padrao_amostra_w IN ('AM11F','AM10F')) and (nr_seq_frasco_w IS NOT NULL AND nr_seq_frasco_w::text <> '') and (qt_volume_frasco_w > 0)) then

                        if (nr_seq_frasco_ant_w <> 0 AND nr_seq_frasco_ant_w <> nr_seq_frasco_w) then
                                update prescr_proc_material set qt_volume = qt_volume_somado_w
                                where nr_seq_material = nr_seq_material_ant_w
                                and (((nr_seq_grupo = nr_seq_grupo_ant_w AND ie_grupo_imp_amostra_seq_w = 'N') or
                                        (nr_seq_grupo_imp = nr_seq_grupo_imp_ant_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
                                and ((coalesce(nr_seq_frasco,0) = coalesce(nr_seq_frasco_ant_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
                                and nr_amostra = i
                                AND nr_sequencia = nr_seq_prescr_proc_mat_w
                                and ((ie_agrupa_amostra_horario_w = 'S') or (nr_seq_origem_ant_w = 0));

                                CALL gerar_prescr_proc_mat_frasco(nr_prescricao_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_prescr_ant_w, nr_seq_material_ant_w, qt_volume_somado_w, qt_tempo_padrao_ant_w, qt_coleta_ant_w, nr_seq_grupo_ant_w, i, 
                                                                ie_amostra_ant_w, nr_seq_frasco_ant_w, nr_seq_grupo_imp_ant_w, ie_padrao_amostra_w, nr_seq_lab_ant_w, dt_liberacao_ddmmyyyy_w, cd_identificador_w, ie_status_atend_ant_w);
                                qt_volume_somado_w := 0;
                        end if;

                        qt_volume_somado_w := qt_volume_somado_w + qt_volume_padrao_w;

                        if (qt_volume_somado_w <= qt_volume_frasco_w) then
                                ie_nova_amostra_w  := 'N';
                        else
                                update prescr_proc_material set qt_volume = qt_volume_frasco_w
                                where nr_seq_material = nr_seq_material_w
                                and (((nr_seq_grupo = nr_seq_grupo_w AND ie_grupo_imp_amostra_seq_w = 'N') or
                                        (nr_seq_grupo_imp = nr_seq_grupo_imp_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
                                and ((coalesce(nr_seq_frasco,0) = coalesce(nr_seq_frasco_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
                                and nr_amostra = i
                                AND nr_sequencia = nr_seq_prescr_proc_mat_w
                                and ((ie_agrupa_amostra_horario_w = 'S') or (nr_seq_origem_w = 0));

                                qt_frascos_w:=trunc(qt_volume_somado_w/qt_volume_frasco_w);

                                for x in 1..qt_frascos_w loop
                                        qt_volume_sobra_w:= qt_volume_somado_w - qt_volume_frasco_w;
                                        qt_volume_w:= qt_volume_somado_w - qt_volume_sobra_w;

                                        update prescr_proc_material set qt_volume = qt_volume_w
                                        where nr_seq_material = nr_seq_material_w
                                        and (((nr_seq_grupo = nr_seq_grupo_w AND ie_grupo_imp_amostra_seq_w = 'N') or
                                                (nr_seq_grupo_imp = nr_seq_grupo_imp_w AND ie_grupo_imp_amostra_seq_w = 'S')) or (ie_padrao_amostra_w in ('PM','PM11','PMR11','PM13')))
                                        and ((coalesce(nr_seq_frasco,0) = coalesce(nr_seq_frasco_w,0)) or (ie_padrao_amostra_w not in ('AM11F','AM10F')))
                                        and nr_amostra = i
                                        AND nr_sequencia = nr_seq_prescr_proc_mat_w
                                        and ((ie_agrupa_amostra_horario_w = 'S') or (nr_seq_origem_w = 0));

                                        if (qt_volume_somado_w >= qt_volume_frasco_w) then
                                                CALL gerar_prescr_proc_mat_frasco(nr_prescricao_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_prescr_w, nr_seq_material_w, qt_volume_w, qt_tempo_padrao_w, qt_coleta_w, nr_seq_grupo_w, i, 
                                                                                ie_amostra_w, nr_seq_frasco_w, nr_seq_grupo_imp_w, ie_padrao_amostra_w, nr_seq_lab_w, dt_liberacao_ddmmyyyy_w, cd_identificador_w, ie_status_atend_w);
                                        end if;

                                        qt_volume_somado_w:= qt_volume_somado_w - qt_volume_w;
                                end loop;

                                if (qt_volume_sobra_w > 0) then
                                ie_nova_amostra_w  := 'N';
                                qt_volume_somado_w:= qt_volume_sobra_w;
                                else
                                ie_nova_amostra_w  := 'S';
                                qt_volume_somado_w:= 0;
                                end if;
                        end if;

                        if (qt_volume_somado_w < qt_volume_frasco_w) then
                                ie_nova_amostra_w  := 'N';
                        end if;

                        if ((nr_seq_prescr_proc_mat_w <> 0) and (nr_registro_w = qt_registros_w) and (qt_volume_somado_w > 0)) then
                                CALL gerar_prescr_proc_mat_frasco(nr_prescricao_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_prescr_w, nr_seq_material_w, qt_volume_somado_w, qt_tempo_padrao_w, qt_coleta_w, nr_seq_grupo_w, i,
                                                                ie_amostra_w, nr_seq_frasco_w, nr_seq_grupo_imp_w, ie_padrao_amostra_w, nr_seq_lab_w, dt_liberacao_ddmmyyyy_w, cd_identificador_w, ie_status_atend_w);
                        end if;
                else
                        if ((ie_considera_vol_amostra_w = 'S') and (ie_padrao_amostra_w IN ('AM11F','AM10F'))) then
                                if (coalesce(nr_seq_frasco_w::text, '') = '') then    
                                        CALL gravar_log_lab(49,obter_desc_expressao(775681)||': Nr_Prescricao:'||nr_prescricao_p||' - Nr_Seq_Exame:'||nr_seq_exame_w||' - Nr_Seq_Material:'||nr_seq_material_w,nm_usuario_p);
                                end if;

                                if (nr_seq_frasco_w IS NOT NULL AND nr_seq_frasco_w::text <> '' AND qt_volume_frasco_w < 1) then    
                                        CALL gravar_log_lab(49,obter_desc_expressao(775691)||': Nr_Prescricao:'||nr_prescricao_p||' - Nr_Seq_Exame:'||nr_seq_exame_w||' - Nr_Seq_Material:'||nr_seq_material_w||' - Nr_Seq_Frasco:'||nr_seq_frasco_w,nm_usuario_p);
                                end if;
                        end if;

                        ie_nova_amostra_w  := 'N';
                end if;

		if ((nr_seq_prescr_proc_mat_w = 0 and ie_considera_vol_amostra_w = 'N') or (ie_considera_vol_amostra_w = 'S' AND ie_nova_amostra_w ='S')) then
                        select 	nextval('prescr_proc_material_seq')
                        into STRICT	nr_seq_prescr_proc_mat_w
;

                        select 	coalesce(max(nr_seq_int_prescr),0) + 1
                        into STRICT	nr_seq_int_prescr_w
                        from	prescr_proc_material
                        where	nr_prescricao = nr_prescricao_p;

                        insert into prescr_proc_material(nr_sequencia,
                                        nr_prescricao,
                                        nr_seq_material,
                                        qt_volume,
                                        dt_atualizacao,
                                        qt_tempo,
                                        qt_minuto,
                                        nm_usuario,
                                        dt_coleta,
                                        nr_seq_grupo,
                                        nr_amostra,
                                        ie_amostra,
                                        nr_seq_frasco,
                                        nr_seq_grupo_imp,
                                        nr_seq_int_prescr)
                        values (nr_seq_prescr_proc_mat_w,
                                nr_prescricao_p,
                                nr_seq_material_w,
                                qt_volume_padrao_w,
                                clock_timestamp(),
                                qt_tempo_padrao_w,
                                0,
                                nm_usuario_p,
                                CASE WHEN qt_coleta_w=1 THEN clock_timestamp()  ELSE null END ,
                                nr_seq_grupo_w,
                                i,
                                ie_amostra_w,
                                nr_seq_frasco_w,
                                nr_seq_grupo_imp_w,
                                nr_seq_int_prescr_w);

                        if (ie_padrao_amostra_w IN ('AMO9','AMO10','AMO11','AM11F','AM10F','AMO13','WEB')) then
                                cd_barras_w := nr_seq_prescr_proc_mat_w;
                        elsif (ie_padrao_amostra_w = 'EAM10') then
                                cd_barras_w := lpad(substr(coalesce(cd_estabelecimento_p,1),1,2),2,0) || nr_seq_prescr_proc_mat_w;
                        elsif (ie_padrao_amostra_w = 'DGIS') then
                                cd_barras_w := dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_imp_w,2,'0') || lpad(nr_seq_lab_w,3,'0');
                        elsif (ie_padrao_amostra_w = 'DS4GI') then
                                cd_barras_w := dt_padrao_amostra_ddmm_w|| lpad(nr_seq_lab_w,4,'0') || lpad(nr_seq_grupo_imp_w,2,'0');
                        elsif (ie_padrao_amostra_w = 'DGS5') then
                                cd_barras_w := dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,5,0);
                        elsif (ie_padrao_amostra_w = 'DGS6') then
                                cd_barras_w := dt_padrao_amostra_ddmm_w|| lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,6,0);
                        elsif (ie_padrao_amostra_w = 'DGS7') then
                                cd_barras_w := dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,7,0);
                        elsif (ie_padrao_amostra_w = 'DGSL') then
                                cd_barras_w:= dt_padrao_amostra_dd_w || lpad(nr_seq_grupo_w,2,0) ||  lpad(nr_seq_lab_w,4,0);
                        elsif (ie_padrao_amostra_w = 'DGS') then
                                cd_barras_w :=  dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_w,2,'0') || lpad(nr_seq_lab_w,3,'0');
                        elsif (ie_padrao_amostra_w = 'DAGS4') then
                                if ('LE' = lab_obter_valor_parametro(722,373)) then
                                        cd_barras_w := coalesce(dt_liberacao_ddmmyy_w,dt_prescricao_w) || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,4,0);
                                else
                                        cd_barras_w := coalesce(dt_liberacao_medico_w,dt_prescricao_w) || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,4,0);
                                end if;
                        elsif (ie_padrao_amostra_w = 'SISB') then
                        
                                select	substr(max(ds_material_integracao),1,3)
                                into STRICT	nr_seq_material_integracao_w
                                from	material_exame_lab
                                where	nr_sequencia = nr_seq_material_w;

                                cd_barras_w := substr(cd_identificador_w,1,1)||lpad(to_char(nr_prescricao_p),8,'0')||'M'||lpad(substr(nr_seq_material_integracao_w,1,3),3,'0');

                        
                        else
                                cd_barras_w := dt_liberacao_ddmmyyyy_w || lpad(nr_seq_grupo_w,2,'0') || lpad(nr_seq_lab_w,20,'0') || i;
                        end if;

                        begin
                        update 	prescr_proc_material
                        set 	cd_barras = cd_barras_w
                        where 	nr_sequencia = nr_seq_prescr_proc_mat_w;

                        exception
                        when others then

                                update 	prescr_procedimento
                                set 	nr_seq_lab  = NULL
                                where 	nr_prescricao = nr_prescricao_p
                                and	nr_sequencia = nr_seq_prescr_w;

                        end;

		else

                        select 	count(*)
                        into STRICT	qt_exames_amostra_w
                        from	prescr_proc_mat_item
                        where	nr_seq_prescr_proc_mat = nr_seq_prescr_proc_mat_w;

                        if (qt_exames_amostra_exame_w > 0) and (ie_padrao_amostra_w IN ('AMO9','AMO10','AMO11','AM11F','AM10F','AMO13','EAM10','WEB')) and (qt_exames_amostra_w >= qt_exames_amostra_exame_w) then

                                select 	nextval('prescr_proc_material_seq')
                                into STRICT	nr_seq_prescr_proc_mat_w
;

                                select 	coalesce(max(nr_seq_int_prescr),0)
                                into STRICT	nr_seq_int_prescr_w
                                from	prescr_proc_material
                                where	nr_prescricao = nr_prescricao_p;


                                insert into prescr_proc_material(nr_sequencia,
                                                nr_prescricao,
                                                nr_seq_material,
                                                qt_volume,
                                                dt_atualizacao,
                                                qt_tempo,
                                                qt_minuto,
                                                nm_usuario,
                                                dt_coleta,
                                                nr_seq_grupo,
                                                nr_amostra,
                                                ie_amostra,
                                                nr_seq_frasco,
                                                nr_seq_grupo_imp,
                                                nr_seq_int_prescr)
                                values (nr_seq_prescr_proc_mat_w,
                                        nr_prescricao_p,
                                        nr_seq_material_w,
                                        qt_volume_padrao_w,
                                        clock_timestamp(),
                                        qt_tempo_padrao_w,
                                        0,
                                        nm_usuario_p,
                                        CASE WHEN qt_coleta_w=1 THEN clock_timestamp()  ELSE null END ,
                                        nr_seq_grupo_w,
                                        i,
                                        ie_amostra_w,
                                        nr_seq_frasco_w,
                                        nr_seq_grupo_imp_w,
                                        nr_seq_int_prescr_w);

                                if (ie_padrao_amostra_w IN ('AMO9','AMO10','AMO11','AM11F','AM10F','AMO13','WEB')) then
                                        cd_barras_w := nr_seq_prescr_proc_mat_w;
                                elsif (ie_padrao_amostra_w = 'EAM10') then
                                        cd_barras_w := lpad(substr(coalesce(cd_estabelecimento_p,1),1,2),2,0) || nr_seq_prescr_proc_mat_w;
                                elsif (ie_padrao_amostra_w = 'DGIS') then
                                        cd_barras_w := dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_imp_w,2,'0') || lpad(nr_seq_lab_w,3,'0');
                                elsif (ie_padrao_amostra_w = 'DS4GI') then
                                        cd_barras_w := dt_padrao_amostra_ddmm_w|| lpad(nr_seq_lab_w,4,'0') || lpad(nr_seq_grupo_imp_w,2,'0');
                                elsif (ie_padrao_amostra_w = 'DGS5') then
                                        cd_barras_w := dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,5,0);
                                elsif (ie_padrao_amostra_w = 'DGS6') then
                                        cd_barras_w := dt_padrao_amostra_ddmm_w|| lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,6,0);
                                elsif (ie_padrao_amostra_w = 'DGS7') then
                                        cd_barras_w := dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,7,0);
                                elsif (ie_padrao_amostra_w = 'DGSL') then
                                        cd_barras_w:= dt_padrao_amostra_dd_w || lpad(nr_seq_grupo_w,2,0) ||  lpad(nr_seq_lab_w,4,0);
                                elsif (ie_padrao_amostra_w = 'DGS') then
                                        cd_barras_w :=  dt_padrao_amostra_ddmm_w || lpad(nr_seq_grupo_w,2,'0') || lpad(nr_seq_lab_w,3,'0');
                                elsif (ie_padrao_amostra_w = 'DAGS4') then
                                        if ('LE' = lab_obter_valor_parametro(722,373)) then
                                                cd_barras_w := coalesce(dt_liberacao_ddmmyy_w,dt_prescricao_w) || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,4,0);
                                        else
                                                cd_barras_w := coalesce(dt_liberacao_medico_w,dt_prescricao_w) || lpad(nr_seq_grupo_w,2,0) || lpad(nr_seq_lab_w,4,0);
                                        end if;
                                elsif (ie_padrao_amostra_w = 'SISB') then
                                
                                        select	substr(max(ds_material_integracao),1,3)
                                        into STRICT	nr_seq_material_integracao_w
                                        from	material_exame_lab
                                        where	nr_sequencia = nr_seq_material_w;

                                        cd_barras_w := substr(cd_identificador_w,1,1)||lpad(to_char(nr_prescricao_p),8,'0')||'M'||lpad(substr(nr_seq_material_integracao_w,1,3),3,'0');
                                else
                                        cd_barras_w := dt_liberacao_ddmmyyyy_w || lpad(nr_seq_grupo_w,2,'0') || lpad(nr_seq_lab_w,20,'0') || i;
                                end if;

                                begin
                                update prescr_proc_material
                                set cd_barras = cd_barras_w
                                where nr_sequencia = nr_seq_prescr_proc_mat_w;

                                exception
                                when others then

                                        update 	prescr_procedimento
                                        set 	nr_seq_lab  = NULL
                                        where 	nr_prescricao = nr_prescricao_p
                                        and	nr_sequencia = nr_seq_prescr_w;

                                end;


			else

                                select 	max(cd_barras)
                                into STRICT	cd_barras_w
                                from 	prescr_proc_material
                                where 	nr_sequencia = nr_seq_prescr_proc_mat_w;
			end if;

		end if;

		if (nr_seq_prescr_proc_mat_w > 0) then
                insert into prescr_proc_mat_item(nr_sequencia,
                                        dt_atualizacao,
                                        nm_usuario,
                                        dt_atualizacao_nrec,
                                        nm_usuario_nrec,
                                        nr_prescricao,
                                        nr_seq_prescr,
                                        nr_seq_prescr_proc_mat,
                                        ie_status,
                                        cd_barras,
                                        nr_seq_frasco)
                values (nextval('prescr_proc_mat_item_seq'),
                                        clock_timestamp(),
                                        nm_usuario_p,
                                        clock_timestamp(),
                                        nm_usuario_p,
                                        nr_prescricao_p,
                                        nr_seq_prescr_w,
                                        nr_seq_prescr_proc_mat_w,
                                        ie_status_atend_w,
                                        cd_barras_w,
                                        nr_seq_frasco_w);
		end if;

	end loop;
        nr_registro_w          := nr_registro_w + 1;
        nr_seq_frasco_ant_w    := nr_seq_frasco_w;
        nr_seq_material_ant_w  := nr_seq_material_w;
        nr_seq_grupo_ant_w     := nr_seq_grupo_w;
        nr_seq_grupo_imp_ant_w := nr_seq_grupo_imp_w;
        nr_seq_origem_ant_w    := nr_seq_origem_w;
        nr_seq_prescr_ant_w    := nr_seq_prescr_w;
        qt_tempo_padrao_ant_w  := qt_tempo_padrao_w;
        qt_coleta_ant_w        := qt_coleta_w;
        ie_amostra_ant_w       := ie_amostra_w;
        nr_seq_lab_ant_w       := nr_seq_lab_w;
        ie_status_atend_ant_w  := ie_status_atend_w;
end loop;
close c01;

CALL lab_gerar_etiq_externa(nr_prescricao_p, nm_usuario_p, cd_estabelecimento_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_proc_mat_item ( nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_prescr_p bigint default null) FROM PUBLIC;

