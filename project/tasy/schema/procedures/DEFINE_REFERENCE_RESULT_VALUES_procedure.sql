-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE define_reference_result_values (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, qt_resultado_p bigint, pr_resultado_p bigint, ds_resultado_p text, nr_seq_exame_p bigint, nr_seq_material_p bigint, nr_seq_metodo_p bigint, qt_minima_p INOUT bigint, qt_maxima_p INOUT bigint, pr_minimo_p INOUT bigint, pr_maximo_p INOUT bigint, ds_referencia_p INOUT text, ie_consiste_p INOUT text, nr_sequencia_padrao_p INOUT bigint, ds_mensagem_criterio_p INOUT text, ie_acao_criterio_lote_p INOUT text, nr_sequencia_criterio_p INOUT bigint ) AS $body$
DECLARE


ie_sexo_w			        pessoa_fisica.ie_sexo%type;
qt_dias_coleta_w		    bigint 	:= 0;
qt_horas_coleta_w		    double precision 	:= 0;
qt_dias_w			        double precision	:= 0;
qt_horas_w			        double precision	:= 0;
qt_dias_transf_w		    bigint 	:= 0;
qt_horas_transf_w		    double precision 	:= 0;
qt_casas_decimais_dias_w	bigint 	:= 2;
dt_coleta_w			        timestamp;
dt_transf_w			        timestamp;

ie_formato_resultado_w		exame_laboratorio.ie_formato_resultado%type;
lote_qt_idade_gest_w		bigint;
lote_qt_peso_w			double precision;
lote_nr_seq_classif_w		bigint;
lote_nr_seq_grau_w		bigint;
lote_qt_media_w			double precision;
ds_lote_qt_media_w			varchar(255);
lote_qt_gest_w			smallint;
ie_classif_lote_ent_w		smallint;
lote_ie_amamentado_w		varchar(1);
lote_ie_prematuro_w		varchar(1);
lote_ie_transfundido_w		varchar(1);
lote_ie_mae_veg_w		varchar(1);
lote_ie_ictericia_w		varchar(1);
lote_ie_npp_w			varchar(1);
lote_ie_cor_pf_w		varchar(10);
lote_ie_gemelar_w		varchar(1);
lote_ie_tipo_parto_w		varchar(1);
lote_ie_alim_leite_w		varchar(1);
lote_ie_data_coleta_w		timestamp;
lote_ie_hora_coleta_w		timestamp;
lote_ie_data_nascimento_w	timestamp;
lote_ie_hora_nascimento_w	timestamp;
lote_dt_ult_menst_w		timestamp;
ie_corticoide_f_w		lab_valor_padrao_criterio.ie_corticoide%type;

cd_pessoa_fisica_prescr_w	pessoa_fisica.cd_pessoa_fisica%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
dt_nascimento_w         timestamp;


BEGIN

CALL lote_ent_sec_ficha_pck.load_row_by_prescr(nr_prescricao_p);

select  obter_valores_prescr_trigger(nr_prescricao_p, 'A'),
        obter_valores_prescr_trigger(nr_prescricao_p, 'PF'),
        obter_valores_prescr_trigger(nr_prescricao_p, 'E')
into STRICT	nr_atendimento_w,
        cd_pessoa_fisica_prescr_w,
        cd_estabelecimento_w
;

select  max(ie_formato_resultado)
into STRICT	ie_formato_resultado_w
from	exame_laboratorio
where	nr_seq_exame = nr_seq_exame_p;

nr_sequencia_padrao_p	:= 0;

ie_sexo_w    := obter_sexo_prescricao(nr_prescricao_p);
qt_dias_w    := obter_dias_entre_datas_lab(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp());
qt_horas_w    := obter_hora_entre_datas(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp());



begin

	if (lote_ent_sec_ficha_pck.get_row().nr_sequencia <> 0 and nr_prescricao_p = lote_ent_sec_ficha_pck.get_row().nr_prescricao) then
	
		lote_qt_peso_w              := lote_ent_sec_ficha_pck.get_row().qt_peso_f;
		lote_qt_idade_gest_w        := lote_ent_sec_ficha_pck.get_row().nr_idade_gest_f;
		lote_ie_prematuro_w         := lote_ent_sec_ficha_pck.get_row().ie_premat_s_f;
		lote_ie_amamentado_w        := lote_ent_sec_ficha_pck.get_row().ie_amamentado_f;
		lote_ie_transfundido_w      := lote_ent_sec_ficha_pck.get_row().ie_transfusao_f;
		lote_nr_seq_grau_w          := lote_ent_sec_ficha_pck.get_row().nr_seq_grau_parentesco;
		lote_ie_mae_veg_w           := lote_ent_sec_ficha_pck.get_row().ie_mae_veg_f;
		lote_ie_ictericia_w         := lote_ent_sec_ficha_pck.get_row().ie_ictericia_f;
		lote_ie_npp_w               := lote_ent_sec_ficha_pck.get_row().ie_npp_f;
		lote_ie_cor_pf_w            := lote_ent_sec_ficha_pck.get_row().ie_cor_pf_f;
		lote_ie_gemelar_w           := lote_ent_sec_ficha_pck.get_row().ie_gemelar_f;
		lote_qt_gest_w              := lote_ent_sec_ficha_pck.get_row().qt_gest_f;
		lote_dt_ult_menst_w         := lote_ent_sec_ficha_pck.get_row().dt_ult_menst;
		lote_ie_tipo_parto_w        := lote_ent_sec_ficha_pck.get_row().ie_tipo_parto;
		lote_ie_alim_leite_w        := lote_ent_sec_ficha_pck.get_row().ie_alim_leite_f;
		ie_corticoide_f_w           := lote_ent_sec_ficha_pck.get_row().ie_corticoide_f;
		lote_ie_data_coleta_w       := lote_ent_sec_ficha_pck.get_row().dt_coleta_ficha_f;
		lote_ie_hora_coleta_w       := lote_ent_sec_ficha_pck.get_row().hr_coleta_f;
		lote_ie_data_nascimento_w   := lote_ent_sec_ficha_pck.get_row().dt_nascimento_f;
		lote_ie_hora_nascimento_w   := lote_ent_sec_ficha_pck.get_row().hr_nascimento_f;
	
		dt_nascimento_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(lote_ie_data_nascimento_w, coalesce(lote_ie_hora_nascimento_w, establishment_timezone_utils.startOfDay(clock_timestamp())));

		qt_dias_w		:= obter_dias_entre_datas_lab(dt_nascimento_w,clock_timestamp());
		qt_horas_w		:= obter_hora_entre_datas(dt_nascimento_w,clock_timestamp());
		
		dt_coleta_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(coalesce(lote_ent_sec_ficha_pck.get_row().DT_COLETA_FICHA_F,clock_timestamp()), coalesce(lote_ent_sec_ficha_pck.get_row().HR_COLETA_F, dt_nascimento_w, establishment_timezone_utils.startOfDay(clock_timestamp())));
		dt_transf_w := coalesce(lote_ent_sec_ficha_pck.get_row().DT_TRANSF_F,dt_nascimento_w);

		if (dt_coleta_w IS NOT NULL AND dt_coleta_w::text <> '') then
			qt_dias_coleta_w	:= obter_dias_entre_datas(dt_nascimento_w, dt_coleta_w);
			qt_horas_coleta_w	:= Obter_Hora_Entre_datas(dt_nascimento_w, dt_coleta_w);
		end if;

		if (dt_transf_w IS NOT NULL AND dt_transf_w::text <> '') then
			qt_dias_transf_w	:= obter_dias_entre_datas(dt_transf_w,dt_coleta_w);
			qt_horas_transf_w	:= Obter_Hora_Entre_datas(dt_transf_w,dt_coleta_w);
		end if;

		begin
		
		

			select max(substr(obter_classif_atendimento(nr_atendimento_w),1,10))
			into STRICT lote_nr_seq_classif_w
			;

			select max(substr(lote_ent_obter_result_ant(nr_prescricao_p, nr_seq_prescr_p, nr_seq_resultado_p, nr_seq_exame_p, 99,'S',qt_resultado_p,pr_resultado_p),1,255))
			into STRICT ds_lote_qt_media_w
			;

            if (ds_lote_qt_media_w IS NOT NULL AND ds_lote_qt_media_w::text <> '') then
                begin
                     lote_qt_media_w := (ds_lote_qt_media_w)::numeric;
                exception when data_exception then
                    begin
                        lote_qt_media_w := (replace(ds_lote_qt_media_w, ',', '.'))::numeric;
                    exception when data_exception then
                        begin
                            lote_qt_media_w := (replace(ds_lote_qt_media_w, '.', ','))::numeric;
                        exception when data_exception then

                            CALL gravar_log_lab_pragma(
                                cd_log_p            => 51,
                                ds_log_p            => 'Falha ao converter o valor: ' || ds_lote_qt_media_w,
                                nm_usuario_p        => coalesce(wheb_usuario_pck.get_nm_usuario(), 'tasy'),
                                nr_prescricao_p     => nr_prescricao_p
                            );

                            --Nao foi possivel converter o valor do resultado, favor contactar o DBA.
                            CALL wheb_mensagem_pck.exibir_mensagem_abort(1118976);
                        end;
                    end;
                end;
            else
                lote_qt_media_w := null;
            end if;

			select	max(ie_classif_lote_ent)
			into STRICT	ie_classif_lote_ent_w
			from	atendimento_paciente
			where	nr_atendimento = nr_atendimento_w;

			select 	qt_minima,
				qt_maxima,
				qt_percent_min,
				qt_percent_max,
				ds_observacao,
				CASE WHEN ie_tipo_valor=3 THEN 'N'  ELSE 'S' END ,
				nr_sequencia,
				ds_mensagem,
				ie_acao_criterio,
				nr_sequencia_criterio
			into STRICT 	qt_minima_p,
				qt_maxima_p,
				pr_minimo_p,
				pr_maximo_p,
				ds_referencia_p,
				ie_consiste_p,
				nr_sequencia_padrao_p,
				ds_mensagem_criterio_p,
				ie_acao_criterio_lote_p,
				nr_sequencia_criterio_p
				from (
				SELECT 	a.qt_minima,
				a.qt_maxima,
				a.qt_percent_min,
				a.qt_percent_max,
				a.ds_observacao,
				a.ie_tipo_valor,
				a.nr_sequencia,
				b.ds_mensagem,
				b.ie_acao_criterio,
				b.nr_seq_prioridade,
				a.nr_seq_prioridade,
				b.nr_sequencia nr_sequencia_criterio
			from 	exame_lab_padrao a,
				lab_valor_padrao_criterio b
			where 	a.nr_sequencia = b.nr_seq_padrao
			and	a.nr_seq_exame = b.nr_seq_exame
			and 	((a.ie_sexo = coalesce(ie_sexo_w, '0')) or (a.ie_sexo = '0'))
			and 	a.nr_seq_exame = nr_seq_exame_p
			and 	coalesce(a.nr_seq_material,coalesce(nr_seq_material_p,0)) = coalesce(nr_seq_material_p,0)
			and 	coalesce(a.nr_seq_metodo, coalesce(nr_seq_metodo_p,0)) = coalesce(nr_seq_metodo_p,0)
			and 	(((coalesce(a.ie_tipo_data,'N') = 'N') and (((coalesce(trunc((qt_dias_w / 365.25),2),0) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'A')) or
			(((coalesce((qt_dias_w / 365.25),0) * 12) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'M')) or
			(((coalesce(qt_dias_w,0)) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'D')) or
			(((coalesce(qt_horas_w,0)) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'H'))))
			or	((coalesce(a.ie_tipo_data,'N') = 'C') and (((coalesce((qt_dias_coleta_w / 365.25),0) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'A')) or
			(((coalesce((qt_dias_coleta_w / 365.25),0) * 12) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'M')) or
			(((coalesce(qt_dias_coleta_w,0)) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'D')) or
			(((coalesce(qt_horas_coleta_w,0)) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'H'))))
			or	((coalesce(a.ie_tipo_data,'N') = 'T') and (((coalesce((qt_dias_transf_w / 365.25),0) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'A')) or
			(((coalesce((qt_dias_transf_w / 365.25),0) * 12) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'M')) or
			(((coalesce(qt_dias_transf_w,0)) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'D')) or
			(((coalesce(qt_horas_transf_w,0)) between a.qt_idade_min and a.qt_idade_max) and (a.ie_periodo = 'H')))))
			and 	coalesce(a.ie_situacao,'A') = 'A'
			and		  ((lote_qt_peso_w between b.qt_peso_inic and b.qt_peso_fim) or (coalesce(lote_qt_peso_w,'0') = '0') or (coalesce(b.qt_peso_inic::text, '') = '') or (coalesce(b.qt_peso_fim::text, '') = ''))
			and	((lote_qt_idade_gest_w between b.QT_IDADE_GESTACIONAL and b.QT_IDADE_GEST_FIM) or (coalesce(lote_qt_idade_gest_w,0) = 0) or (coalesce(b.QT_IDADE_GESTACIONAL::text, '') = '') or (coalesce(b.QT_IDADE_GEST_FIM::text, '') = ''))
			and	((lote_ie_prematuro_w = coalesce(b.ie_prematuro,lote_ie_prematuro_w)) or (coalesce(lote_ie_prematuro_w,'I') = 'I'))
			and	((lote_ie_amamentado_w = coalesce(b.ie_amamentado,lote_ie_amamentado_w)) or (coalesce(lote_ie_amamentado_w,'I') = 'I'))
			and	((lote_ie_transfundido_w = coalesce(b.ie_transfundido,lote_ie_transfundido_w)) or (coalesce(lote_ie_transfundido_w,'I') = 'I'))
			and	((lote_nr_seq_grau_w = coalesce(b.nr_seq_grau_parentesco,lote_nr_seq_grau_w)) or (coalesce(lote_nr_seq_grau_w,0) = 0))
			and	((lote_nr_seq_classif_w = coalesce(b.nr_seq_classificacao,lote_nr_seq_classif_w)) or (coalesce(lote_nr_seq_classif_w,0) = 0))
			and 	((lote_ie_mae_veg_w = coalesce(b.IE_MAE_VEG,lote_ie_mae_veg_w)) or (coalesce(lote_ie_mae_veg_w,'I') = 'I'))
			and 	((lote_ie_ictericia_w = coalesce(b.IE_ICTERICIA,lote_ie_ictericia_w)) or (coalesce(lote_ie_ictericia_w,'I') = 'I'))
			and 	((lote_ie_npp_w = coalesce(b.IE_NPP,lote_ie_npp_w)) or (coalesce(lote_ie_npp_w,'I') = 'I'))
			and 	((lote_ie_cor_pf_w = coalesce(b.IE_COR_PF,lote_ie_cor_pf_w)) or (coalesce(lote_ie_cor_pf_w,'N') = 'N'))
			and 	((lote_ie_gemelar_w = coalesce(b.IE_GEMELAR,lote_ie_gemelar_w)) or (coalesce(lote_ie_gemelar_w,'N') = 'N'))
			and	((((b.QT_MINIMA IS NOT NULL AND b.QT_MINIMA::text <> '') and (b.QT_MAXIMA IS NOT NULL AND b.QT_MAXIMA::text <> '') and (lote_qt_media_w IS NOT NULL AND lote_qt_media_w::text <> '')) and (lote_qt_media_w  between b.QT_MINIMA and b.QT_MAXIMA))
			or (coalesce(b.QT_MINIMA::text, '') = '' or coalesce(b.QT_MAXIMA::text, '') = '' or coalesce(lote_qt_media_w::text, '') = ''))
			and	((lote_qt_gest_w between b.QT_GEST_INI and b.QT_GEST_FIM) or (coalesce(lote_qt_gest_w,'0') = '0') or (coalesce(b.QT_GEST_INI::text, '') = '') or (coalesce(b.QT_GEST_FIM::text, '') = ''))
			and	((coalesce(lote_dt_ult_menst_w::text, '') = '') or (lote_dt_ult_menst_w between b.DT_ULT_MENST_INI and b.DT_ULT_MENST_FIM))
			and	((lote_ie_tipo_parto_w = coalesce(b.IE_TIPO_PARTO,lote_ie_tipo_parto_w)) or (coalesce(lote_ie_tipo_parto_w,'N') = 'N'))
			and 	((lote_ie_alim_leite_w = coalesce(b.IE_ALIM_LEITE,lote_ie_alim_leite_w)) or (coalesce(lote_ie_alim_leite_w,'I') = 'I'))
			and	((ie_classif_lote_ent_w = b.IE_CLASSIF_LOTE_ENT) or (coalesce(ie_classif_lote_ent_w::text, '') = '' and coalesce(b.IE_CLASSIF_LOTE_ENT::text, '') = ''))
			and	((ie_corticoide_f_w = coalesce(b.ie_corticoide,ie_corticoide_f_w)) OR (coalesce(ie_corticoide_f_w,'0') = '0'))
			and 	(((coalesce(lote_ie_data_coleta_w::text, '') = '') and (coalesce(b.ie_data_coleta, 'N') = 'I')) or (coalesce(b.ie_data_coleta, 'N') = 'N'))
			and 	(((coalesce(lote_ie_hora_coleta_w::text, '') = '') and (coalesce(b.ie_hora_coleta, 'N') = 'I')) or (coalesce(b.ie_hora_coleta, 'N') = 'N'))
			and 	(((coalesce(lote_ie_data_nascimento_w::text, '') = '') and (coalesce(b.ie_data_nascimento, 'N') = 'I')) or (coalesce(b.ie_data_nascimento, 'N') = 'N'))
			and 	(((coalesce(lote_ie_hora_nascimento_w::text, '') = '') and (coalesce(b.ie_hora_nascimento, 'N') = 'I')) or (coalesce(b.ie_hora_nascimento, 'N') = 'N'))
			and     (( ie_formato_resultado_w = 'P'  and pr_resultado_p between a.qt_percent_min and a.qt_percent_max) or
			((ie_formato_resultado_w = 'V'  or (ie_formato_resultado_w = 'DV' and coalesce(ds_resultado_p,'0') =  '0')) and qt_resultado_p between a.qt_minima and a.qt_maxima) or
			((ie_formato_resultado_w = 'D'  or (ie_formato_resultado_w = 'DV' and coalesce(ds_resultado_p,'0') <> '0')) and upper(ELIMINA_ACENTOS(ds_resultado_p)) like upper(ELIMINA_ACENTOS(a.DS_OBSERVACAO))))
			order by coalesce(a.nr_seq_prioridade,1) desc, b.nr_seq_prioridade desc, a.nr_seq_material, a.ie_sexo, a.ie_tipo_valor) alias244 LIMIT 1;
			exception
			when no_data_found then

                CALL gravar_log_lab_pragma(51,
                    DBMS_UTILITY.FORMAT_CALL_STACK || CHR(13) || CHR(10) || CHR(13) || CHR(10)
                    || 'ds_resultado_p              = ' || coalesce(to_char(ds_resultado_p), 'null')                                       || ';' || CHR(13) || CHR(10)
                    || 'ie_classif_lote_ent_w       = ' || coalesce(to_char(ie_classif_lote_ent_w), 'null')                                || ';' || CHR(13) || CHR(10)
                    || 'ie_corticoide_f_w           = ' || coalesce(to_char(ie_corticoide_f_w), 'null')                                    || ';' || CHR(13) || CHR(10)
                    || 'ie_formato_resultado_w      = ' || coalesce(to_char(ie_formato_resultado_w), 'null')                               || ';' || CHR(13) || CHR(10)
                    || 'ie_sexo_w                   = ' || coalesce(to_char(ie_sexo_w), 'null')                                            || ';' || CHR(13) || CHR(10)
                    || 'lote_dt_ult_menst_w         = ' || coalesce(to_char(lote_dt_ult_menst_w), 'null')                                  || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_alim_leite_w        = ' || coalesce(to_char(lote_ie_alim_leite_w), 'null')                                 || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_amamentado_w        = ' || coalesce(to_char(lote_ie_amamentado_w), 'null')                                 || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_cor_pf_w            = ' || coalesce(to_char(lote_ie_cor_pf_w), 'null')                                     || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_data_coleta_w       = ' || coalesce(to_char(lote_ie_data_coleta_w, 'dd/mm/yyyy hh24:mi:ss'), 'null')       || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_data_nascimento_w   = ' || coalesce(to_char(lote_ie_data_nascimento_w, 'dd/mm/yyyy hh24:mi:ss'), 'null')   || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_gemelar_w           = ' || coalesce(to_char(lote_ie_gemelar_w), 'null')                                    || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_hora_coleta_w       = ' || coalesce(to_char(lote_ie_hora_coleta_w, 'dd/mm/yyyy hh24:mi:ss'), 'null')       || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_hora_nascimento_w   = ' || coalesce(to_char(lote_ie_hora_nascimento_w, 'dd/mm/yyyy hh24:mi:ss'), 'null')   || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_ictericia_w         = ' || coalesce(to_char(lote_ie_ictericia_w), 'null')                                  || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_mae_veg_w           = ' || coalesce(to_char(lote_ie_mae_veg_w), 'null')                                    || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_npp_w               = ' || coalesce(to_char(lote_ie_npp_w), 'null')                                        || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_prematuro_w         = ' || coalesce(to_char(lote_ie_prematuro_w), 'null')                                  || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_tipo_parto_w        = ' || coalesce(to_char(lote_ie_tipo_parto_w), 'null')                                 || ';' || CHR(13) || CHR(10)
                    || 'lote_ie_transfundido_w      = ' || coalesce(to_char(lote_ie_transfundido_w), 'null')                               || ';' || CHR(13) || CHR(10)
                    || 'lote_nr_seq_classif_w       = ' || coalesce(to_char(lote_nr_seq_classif_w), 'null')                                || ';' || CHR(13) || CHR(10)
                    || 'lote_nr_seq_grau_w          = ' || coalesce(to_char(lote_nr_seq_grau_w), 'null')                                   || ';' || CHR(13) || CHR(10)
                    || 'lote_qt_gest_w              = ' || coalesce(to_char(lote_qt_gest_w), 'null')                                       || ';' || CHR(13) || CHR(10)
                    || 'lote_qt_idade_gest_w        = ' || coalesce(to_char(lote_qt_idade_gest_w), 'null')                                 || ';' || CHR(13) || CHR(10)
                    || 'lote_qt_media_w             = ' || coalesce(to_char(lote_qt_media_w), 'null')                                      || ';' || CHR(13) || CHR(10)
                    || 'lote_qt_peso_w              = ' || coalesce(to_char(lote_qt_peso_w), 'null')                                       || ';' || CHR(13) || CHR(10)
                    || 'nr_seq_exame_p              = ' || coalesce(to_char(nr_seq_exame_p), 'null')                                       || ';' || CHR(13) || CHR(10)
                    || 'nr_seq_material_p           = ' || coalesce(to_char(nr_seq_material_p), 'null')                                    || ';' || CHR(13) || CHR(10)
                    || 'nr_seq_metodo_p             = ' || coalesce(to_char(nr_seq_metodo_p), 'null')                                      || ';' || CHR(13) || CHR(10)
                    || 'pr_resultado_p              = ' || coalesce(to_char(pr_resultado_p), 'null')                                       || ';' || CHR(13) || CHR(10)
                    || 'qt_dias_coleta_w            = ' || coalesce(to_char(qt_dias_coleta_w), 'null')                                     || ';' || CHR(13) || CHR(10)
                    || 'qt_dias_transf_w            = ' || coalesce(to_char(qt_dias_transf_w), 'null')                                     || ';' || CHR(13) || CHR(10)
                    || 'qt_dias_w                   = ' || coalesce(to_char(qt_dias_w), 'null')                                            || ';' || CHR(13) || CHR(10)
                    || 'qt_horas_coleta_w           = ' || coalesce(to_char(qt_horas_coleta_w), 'null')                                    || ';' || CHR(13) || CHR(10)
                    || 'qt_horas_transf_w           = ' || coalesce(to_char(qt_horas_transf_w), 'null')                                    || ';' || CHR(13) || CHR(10)
                    || 'qt_horas_w                  = ' || coalesce(to_char(qt_horas_w), 'null')                                           || ';' || CHR(13) || CHR(10)
                    || 'qt_resultado_p              = ' || coalesce(to_char(qt_resultado_p), 'null')                                       || ';',
                    'Tasy', nr_prescricao_p);

				nr_sequencia_padrao_p := 0;
		end;

	end if;

	if (nr_sequencia_padrao_p = 0) then

		select	CASE WHEN coalesce(max(ie_idade_int_val_ref), 'N')='N' THEN  2  ELSE 0 END
		into STRICT	qt_casas_decimais_dias_w
		from	lab_parametro
		where	cd_estabelecimento = cd_estabelecimento_w;

		select 	qt_minima,
			qt_maxima,
			qt_percent_min,
			qt_percent_max,
			ds_observacao,
		CASE WHEN ie_tipo_valor=3 THEN 'N'  ELSE 'S' END
		into STRICT	qt_minima_p,
			qt_maxima_p,
			pr_minimo_p,
			pr_maximo_p,
			ds_referencia_p,
			ie_consiste_p
		from (
			SELECT 	qt_minima,
			qt_maxima, 
			qt_percent_min,
			qt_percent_max,
			ds_observacao,
			ie_tipo_valor
			from    exame_lab_padrao
			where   ((ie_sexo = ie_sexo_w) or (ie_sexo = '0'))
			and   nr_seq_exame = nr_seq_exame_p
			and   coalesce(nr_seq_material, coalesce(nr_seq_material_p,0)) = coalesce(nr_seq_material_p,0)
			and   coalesce(nr_seq_metodo, coalesce(nr_seq_metodo_p,0)) = coalesce(nr_seq_metodo_p,0)
			and   (((trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
			((trunc(((qt_dias_w / 365.25) * 12), qt_casas_decimais_dias_w) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
			(qt_dias_w between qt_idade_min and qt_idade_max AND ie_periodo = 'D') or
			(qt_horas_w between qt_idade_min and qt_idade_max AND ie_periodo = 'H'))
			and   ie_tipo_valor in (0,3)
			and   coalesce(ie_situacao,'A') = 'A'
			order by coalesce(nr_seq_material, 9999999999), coalesce(nr_seq_metodo, 9999999999), ie_sexo,CASE WHEN ie_periodo='D' THEN 1 WHEN ie_periodo='M' THEN 2  ELSE 3 END , coalesce(nr_seq_prioridade,1)
		) alias28 LIMIT 1;

	end if;

	exception
	when others then

		qt_minima_p 	:= coalesce(qt_minima_p, null);
		qt_maxima_p 	:= coalesce(qt_maxima_p, null);
		pr_minimo_p 	:= coalesce(pr_minimo_p, null);
		pr_maximo_p 	:= coalesce(pr_maximo_p, null);
		ds_referencia_p	:= coalesce(ds_referencia_p, null);
		ie_consiste_p	:= coalesce(ie_consiste_p, 'N');
		ie_acao_criterio_lote_p := coalesce(ie_acao_criterio_lote_p, null);
		ds_mensagem_criterio_p  := coalesce(ds_mensagem_criterio_p, null);
	    CALL gravar_log_lab_pragma(51, 'Problema ao obter valor de referencia: ' || sqlerrm, 'Tasy', nr_prescricao_p);
	end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE define_reference_result_values (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_resultado_p bigint, qt_resultado_p bigint, pr_resultado_p bigint, ds_resultado_p text, nr_seq_exame_p bigint, nr_seq_material_p bigint, nr_seq_metodo_p bigint, qt_minima_p INOUT bigint, qt_maxima_p INOUT bigint, pr_minimo_p INOUT bigint, pr_maximo_p INOUT bigint, ds_referencia_p INOUT text, ie_consiste_p INOUT text, nr_sequencia_padrao_p INOUT bigint, ds_mensagem_criterio_p INOUT text, ie_acao_criterio_lote_p INOUT text, nr_sequencia_criterio_p INOUT bigint ) FROM PUBLIC;
