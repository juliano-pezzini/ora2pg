-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_vol_sol_etapa_adep ( nr_prescricao_p bigint, nr_Seq_solucao_p bigint, ie_solucao_agrupada_p text default 'N') RETURNS varchar AS $body$
DECLARE



cd_unidade_medida_w	varchar(255);
ds_total_w		varchar(255);
ds_bomba_w		varchar(255);
ds_dosagem_w		varchar(255);
ds_dosagem_ww		varchar(255);
ds_solucao_w		varchar(255);
ds_retorno_w		varchar(2000);
ds_descricao_sol_w	varchar(2000);
ie_esquema_alternado_w	varchar(1);
ds_acm_agora_w		varchar(255);
hr_prim_horario_w	varchar(255);
ds_via_w		varchar(255);
ie_solucao_especial_w	varchar(2);
qt_dose_terapeutica_w	double precision;
ds_unid_terapeutica_w	varchar(255);
qt_volume_w		double precision;
qt_hora_fase_w		double precision;
nr_etapas_w		bigint;
dt_prev_term_w		timestamp;

ie_solucao_pca_w	varchar(1);
ie_pca_modo_prog_w	varchar(255);
qt_vol_infusao_pca_w	double precision;
ie_um_fluxo_pca_w	varchar(255);
qt_bolus_pca_w		double precision;
ie_um_bolus_pca_w	varchar(255);
qt_intervalo_bloqueio_w	double precision;
qt_dose_inicial_pca_w	double precision;
ie_um_dose_inicio_pca_w	varchar(255);
qt_limite_quatro_hora_w	double precision;
ie_um_limite_pca_w	varchar(255);
qt_limite_uma_hora_w	double precision;
qt_dosagem_w		double precision;
ie_um_limite_hora_pca_w	varchar(255);
ds_prescricao_w		varchar(60);

ds_modo_w		varchar(255);
ds_disp_infusao_w	varchar(255);
ds_fluxo_w		varchar(255);
ds_bolus_w		varchar(255);
ds_interv_bloqueio_w	varchar(255);
ds_dose_inicial_w	varchar(255);
ds_limite4hr_w		varchar(255);
ds_limite1hr_w		varchar(255);
ie_acm_w		prescr_solucao.ie_acm%type;
ie_etapa_especial_w	prescr_solucao.ie_etapa_especial%type;
qt_dose_ataque_w	prescr_solucao.qt_dose_ataque%type;
qt_min_dose_ataque_w	prescr_solucao.qt_min_dose_ataque%type;
qt_fluxo_sangue_w	hd_prescricao.qt_fluxo_sangue%type;
qt_hora_sessao_w	hd_prescricao.qt_hora_sessao%type;
qt_min_sessao_w		hd_prescricao.qt_min_sessao%type;
qt_ultrainfiltracao_w	hd_prescricao.qt_ultrafiltracao%type;
qt_ultrafiltracao_total_w	 hd_prescricao.qt_ultrafiltracao_total%type;
qt_sodio_w		hd_prescricao.qt_sodio%type;
qt_bicarbonato_w	hd_prescricao.qt_bicarbonato%type;
nr_seq_ulta_w 		hd_prescricao.nr_seq_ultra%type;
ds_perfil_ultra_w	varchar(255);
ds_tipo_hemodialise_w	varchar(255);
ds_modelo_dialisador_w	varchar(255);
ds_ultrainfiltracao_w	varchar(255);
ds_sol_hemodialise_w	varchar(255);
ds_tipo_solucao_w	varchar(255);
qt_solucao_total_w	prescr_solucao.qt_solucao_total%type;
qt_temp_solucao_w	prescr_solucao.qt_temp_solucao%type;
ds_un_medida_w		varchar(255);
ds_tipo_dosagem_w	varchar(255);

ds_fluxo_duracao_w	varchar(255);
ie_altera_label_campo_w	varchar(1);
qt_min_sessao_ww 	varchar(2);
qt_hora_sessao_ww	varchar(2);
nr_seq_dialise_w	prescr_solucao.nr_seq_dialise%type;
ds_ultrainfiltracao_ww 	varchar(255);
ds_stat_w varchar(255);
ie_tipo_sol_w		varchar(2);
nr_seq_cpoe_w		cpoe_material.nr_sequencia%type;
nr_etapas_sol_adep_w	bigint := null;
ds_dose_information_w varchar(255) := '';

function get_UoM( ds_valor_p text) return text is
	;
BEGIN
		if (ds_valor_p = 'ml') and (pkg_i18n.get_user_locale() = 'en_AU') then
			return 'mL';
		else
			return ds_valor_p;
		end if;
	end;

BEGIN

ie_altera_label_campo_w := Obter_Param_Usuario(924, 1171, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_altera_label_campo_w);

if (coalesce(nr_prescricao_p,0) <> 0) then
	begin
	select	a.qt_volume_adep,
		a.cd_unidade_medida,
		a.qt_hora_fase,
		a.ds_solucao,		
		CASE WHEN a.ie_bomba_infusao='N' THEN ''  ELSE substr(obter_valor_dominio_idioma(1537, a.ie_bomba_infusao,wheb_usuario_pck.get_nr_seq_idioma),1,255) END ,
		CASE WHEN obtain_user_locale(wheb_usuario_pck.get_nm_usuario)='pt_BR' THEN (CASE WHEN upper(a.ie_tipo_dosagem)='ACM' THEN  '(ACM)'  ELSE coalesce(obter_dados_solucao(1, a.nr_prescricao, a.nr_seq_solucao, 'VA'),a.qt_dosagem)  || ' ' ||CASE WHEN upper(a.ie_tipo_dosagem)='MGM' THEN 'mcg/m'  ELSE a.ie_tipo_dosagem END  ||' ' || CASE WHEN a.ie_acm='S' THEN  ' ACM'  ELSE '' END  END  || ' ' ||CASE WHEN a.ie_se_necessario='S' THEN  ' SN'  ELSE '' END )  ELSE (cpoe_dose_formatada(coalesce(obter_dados_solucao(1, a.nr_prescricao, a.nr_seq_solucao, 'VA'),a.qt_dosagem))  ||' ' || CASE WHEN a.ie_acm='S' THEN  obter_desc_expressao(283158)  ELSE '' END  || ' ' ||CASE WHEN a.ie_se_necessario='S' THEN  obter_desc_expressao(309405)  ELSE '' END ) END ,
		cpoe_dose_formatada(coalesce(obter_dados_solucao(1, a.nr_prescricao, a.nr_seq_solucao, 'VA'),a.qt_dosagem)),
		CASE WHEN a.ie_acm='S' THEN  obter_desc_expressao(283158)  ELSE '' END  || ' ' ||CASE WHEN a.ie_se_necessario='S' THEN  obter_desc_expressao(309405)  ELSE '' END  || ' ' || CASE WHEN a.ie_urgencia='S' THEN obter_desc_expressao(283261)  ELSE '' END ,
		a.ie_esquema_alternado,
		coalesce(a.nr_etapas,0),
		obter_data_prev_term_etapa_sol(a.nr_prescricao, a.nr_seq_solucao, 1),
		coalesce(a.ie_etapa_especial,'N'),
		substr(obter_Desc_via(a.ie_via_aplicacao),1,30),
		a.hr_prim_horario,
		coalesce(a.ie_solucao_pca,'N'),
		substr(obter_valor_dominio_idioma(2714,a.ie_pca_modo_prog,wheb_usuario_pck.get_nr_seq_idioma),1,60) ds_modo,
		a.qt_vol_infusao_pca qt_fluxo,
		a.ie_um_fluxo_pca ie_um_fluxo,
		a.qt_bolus_pca ,
		a.ie_um_bolus_pca,
		a.qt_intervalo_bloqueio,
		a.qt_dose_inicial_pca,
		a.ie_um_dose_inicio_pca,
		a.qt_limite_quatro_hora,
		a.ie_um_limite_pca,
		a.qt_limite_uma_hora,
		a.ie_um_limite_hora_pca,
		a.ie_solucao_especial,
		a.qt_dose_terapeutica,
		substr(Obter_desc_unid_terap(a.nr_unid_terapeutica),1,255),
		a.qt_dosagem,
		coalesce(a.ie_acm,'N'),
		coalesce(a.qt_dose_ataque, 0),
		coalesce(a.qt_min_dose_ataque, 0),
		coalesce(z.ds_prescricao,z.ds_intervalo),
		a.nr_seq_dialise,
		substr(obter_descricao_padrao('PROTOCOLO_NPT', 'DS_NPT', a.nr_seq_protocolo),1,255),
		substr(obter_valor_dominio_idioma(1935, a.ie_tipo_solucao,wheb_usuario_pck.get_nr_seq_idioma),1,255),
		a.qt_solucao_total,
		a.qt_temp_solucao,
		substr(obter_valor_dominio_idioma(1954, a.ie_unid_vel_inf,wheb_usuario_pck.get_nr_seq_idioma),1,255),
		lower(substr(obter_valor_dominio_idioma(93, a.ie_tipo_dosagem,wheb_usuario_pck.get_nr_seq_idioma),1,255)),
		CASE WHEN a.ie_urgencia='S' THEN obter_desc_expressao(283261)  ELSE '' END ,
		a.ie_tipo_sol
into STRICT 		qt_volume_w,
		cd_unidade_medida_w,
		qt_hora_fase_w,
		ds_solucao_w,
		ds_bomba_w,
		ds_dosagem_w,
		ds_dosagem_ww,
		ds_acm_agora_w,
		ie_esquema_alternado_w,
		nr_etapas_w,
		dt_prev_term_w,
		ie_etapa_especial_w,
		ds_via_w,
		hr_prim_horario_w,
		ie_solucao_pca_w,
		ie_pca_modo_prog_w,
		qt_vol_infusao_pca_w,
		ie_um_fluxo_pca_w,
		qt_bolus_pca_w,
		ie_um_bolus_pca_w,
		qt_intervalo_bloqueio_w,
		qt_dose_inicial_pca_w,
		ie_um_dose_inicio_pca_w,
		qt_limite_quatro_hora_w,
		ie_um_limite_pca_w,
		qt_limite_uma_hora_w,
		ie_um_limite_hora_pca_w,
		ie_solucao_especial_w,
		qt_dose_terapeutica_w,
		ds_unid_terapeutica_w,
		qt_dosagem_w,
		ie_acm_w,
		qt_dose_ataque_w,
		qt_min_dose_ataque_w,
		ds_prescricao_w,
		nr_seq_dialise_w,
		ds_sol_hemodialise_w,
		ds_tipo_solucao_w,
		qt_solucao_total_w,
		qt_temp_solucao_w,
		ds_un_medida_w,
		ds_tipo_dosagem_w,
		ds_stat_w,
		ie_tipo_sol_w
	FROM prescr_solucao a
LEFT OUTER JOIN intervalo_prescricao z ON (a.cd_intervalo = z.cd_intervalo)
WHERE a.nr_prescricao 	= nr_prescricao_p  and a.nr_seq_solucao	= nr_seq_solucao_p;



	if (ie_solucao_agrupada_p = 'S') then
		select	max(nr_seq_mat_cpoe)
		into STRICT	nr_seq_cpoe_w
		from	prescr_material	a
		where	a.nr_prescricao	= nr_prescricao_p
		and	a.nr_sequencia_solucao = nr_seq_solucao_p;

		if (nr_seq_cpoe_w IS NOT NULL AND nr_seq_cpoe_w::text <> '') then

			select	sum(nr_etapas)
			into STRICT	nr_etapas_w
			from (	SELECT	a.nr_etapas
						from	prescr_solucao a,
								prescr_material b
						where	a.nr_prescricao = b.nr_prescricao
						and		a.nr_seq_solucao = b.nr_sequencia_solucao
						and		b.nr_seq_mat_cpoe = nr_seq_cpoe_w
						group by	a.nr_prescricao,
									a.nr_etapas) alias2;

		nr_etapas_sol_adep_w	:= obter_etapas_adep_sol_cpoe( 	ie_tipo_solucao_p => 1,
									nr_seq_cpoe_p	=> nr_seq_cpoe_w);	

		ds_tipo_dosagem_w   	:=  coalesce(valores_adep_pck.obter_val_sol_agrupada('ie_tipo_dosagem', '5,3', nr_seq_cpoe_w),ds_tipo_dosagem_w);
		ds_dosagem_w       	:=  coalesce(valores_adep_pck.obter_val_sol_agrupada('cpoe_dose_formatada(qt_dosagem)',  '5,3', nr_seq_cpoe_w),ds_dosagem_w);
		ds_dosagem_ww   	:=  coalesce(valores_adep_pck.obter_val_sol_agrupada('cpoe_dose_formatada(qt_dosagem)',  '5,3', nr_seq_cpoe_w),ds_dosagem_ww);
        end if;
	end if;

	if (coalesce(nr_etapas_sol_adep_w::text, '') = '') then
		nr_etapas_sol_adep_w	:= obter_etapas_adep_sol( 	ie_tipo_solucao_p => 1,
									nr_prescricao_p	=> nr_prescricao_p,
									nr_seq_solucao_p => nr_Seq_solucao_p);
	end if;

	if (nr_etapas_w = 0) and (ie_etapa_especial_w = 'S') then
		nr_etapas_w	:= 1;
	end if;

	ds_descricao_sol_w := '';

	if (coalesce(ds_sol_hemodialise_w, 'XPTO') <> 'XPTO') then
		ds_descricao_sol_w := substr(ds_descricao_sol_w || obter_desc_expressao(682928, null) || ': ' || ds_sol_hemodialise_w, 1, 2000);
	end if;

	if (coalesce(ds_tipo_solucao_w, 'XPTO') <> 'XPTO') then
		ds_descricao_sol_w := substr(ds_descricao_sol_w || '. ' || chr(10) ||  obter_desc_expressao(299713, null) || ': ' || ds_tipo_solucao_w, 1, 2000);
	end if;

	if (coalesce(qt_solucao_total_w, 0) > 0) then
		ds_descricao_sol_w := substr(ds_descricao_sol_w || '. ' || chr(10) || obter_desc_expressao(302288, null) || ': ' || qt_solucao_total_w, 1, 2000);
	end if;

	if (coalesce(qt_temp_solucao_w, 0) > 0) then
		ds_descricao_sol_w := substr(ds_descricao_sol_w || '. ' || chr(10) || obter_desc_expressao(299210, null) || ': ' || qt_temp_solucao_w, 1, 2000);
	end if;

	if (coalesce(ds_dosagem_w, 'XPTO') <> 'XPTO') then
		ds_descricao_sol_w := substr(ds_descricao_sol_w || '. ' || chr(10) || obter_desc_expressao(290188, null) || ': ' || ds_dosagem_w, 1, 2000);

		if (coalesce(ds_un_medida_w, 'XPTO') <> 'XPTO') then
			ds_descricao_sol_w := substr(ds_descricao_sol_w || ' ' || ds_un_medida_w, 1, 2000);
		end if;
	end if;

	ds_descricao_sol_w :=	ds_descricao_sol_w || chr(10);

	if (ie_solucao_pca_w = 'N') then

		if (coalesce(qt_volume_w, 0) <> 0) and (coalesce(ie_solucao_especial_w,'N')	<> 'S') and (coalesce(qt_dose_terapeutica_w::text, '') = '') then
				if (coalesce(qt_hora_fase_w,0) = 0 or coalesce(ie_tipo_sol_w,0) = 4) then
					ds_total_w	:= 'Vol. ' || cpoe_dose_formatada(qt_volume_w) || get_UoM('ml');
				else
					ds_total_w	:= 'Vol. ' || cpoe_dose_formatada(qt_volume_w) || get_UoM('ml') ||'/'|| qt_hora_fase_w || 'h';
				end if;
		elsif (qt_hora_fase_w > 0) then
			ds_total_w	:= qt_hora_fase_w || 'h';
		else
			ds_total_w	:= ' ';
		end if;

		if (ds_via_w IS NOT NULL AND ds_via_w::text <> '') then
			ds_total_w	:= ds_via_w || ' ' || ds_total_w;
		end if;

		if (ie_esquema_alternado_w = 'N') and (coalesce(qt_dose_terapeutica_w::text, '') = '') and (qt_dosagem_w IS NOT NULL AND qt_dosagem_w::text <> '') then
			if (coalesce(ie_solucao_especial_w,'N')	<> 'S') then
				ds_retorno_w	:= obter_desc_expressao(794684) || ' : ' || trim(both ds_dosagem_w) || ' ' || ds_tipo_dosagem_w || ' ' || ds_stat_w || ' ' || ds_total_w || ' ' || ds_bomba_w;
			else
                    ds_retorno_w	:= obter_desc_expressao(794684) || ' : ' || ds_dosagem_ww || ' ' || ds_tipo_dosagem_w || ' ' || ds_stat_w || ' ' || ds_total_w || ' ' || ds_bomba_w;
			end if;


		elsif (ie_esquema_alternado_w = 'S') then
			ds_retorno_w	:= ds_total_w ||' '|| obter_desc_expressao(288235) || ds_acm_agora_w ||' '|| ds_bomba_w;
		else
			ds_retorno_w	:= ds_total_w ||' ' || ds_bomba_w;
		end if;

		if (coalesce(nr_etapas_w,0) > 0) then
			if (ie_etapa_especial_w	= 'N') then
				if (nr_etapas_w = 1) then
				   ds_retorno_w	:=  ds_retorno_w || chr(10) || '  '||obter_desc_expressao(289624) || ': ' || nr_etapas_sol_adep_w || '/' || nr_etapas_w;
				else
				   ds_retorno_w	:=  ds_retorno_w || chr(10) ||'  '|| obter_desc_expressao(289637) || ': ' || nr_etapas_sol_adep_w || '/' ||  nr_etapas_w;
				end if;
			else
				ds_retorno_w	:=  nr_etapas_w ||chr(10) || ' ' ||  obter_desc_expressao(781845) || hr_prim_horario_w || ' ' || ds_retorno_w;
			end if;
		else
			ds_retorno_w	:= ds_retorno_w;
		end if;

		if (ie_solucao_especial_w	= 'S') and (qt_dose_terapeutica_w IS NOT NULL AND qt_dose_terapeutica_w::text <> '') then
			ds_retorno_w	:= ds_retorno_w || ' ' || qt_dose_terapeutica_w || ' ' || ds_unid_terapeutica_w;
		else
			ds_dose_information_w := obter_terap_dose_solucao(nr_seq_solucao_p, nr_prescricao_p);
			if (ds_dose_information_w IS NOT NULL AND ds_dose_information_w::text <> '') then
				ds_retorno_w	:= ds_retorno_w || chr(10) || ds_dose_information_w;
			end if;
		end if;

		if (coalesce(nr_etapas_w,0) = 0) and (ie_acm_w = 'S') then
		    ds_retorno_w	:= ds_retorno_w || ' ' || ds_prescricao_w;
		end if;

	else if (ie_solucao_pca_w = 'S') then

		if (ie_pca_modo_prog_w IS NOT NULL AND ie_pca_modo_prog_w::text <> '') then
			ds_modo_w  := chr(10) || substr(obter_desc_expressao(293391)||': ' || ie_pca_modo_prog_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_modo_w || ' ';
		end if;

		if (ds_via_w IS NOT NULL AND ds_via_w::text <> '') then
			ds_retorno_w	:= ds_via_w || ' ' || ds_retorno_w;
		end if;

		if (ds_bomba_w IS NOT NULL AND ds_bomba_w::text <> '') then
			ds_disp_infusao_w := chr(10) || substr(obter_desc_expressao(288009) ||': '|| ds_bomba_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_disp_infusao_w || ' ';
		end if;

		if (qt_vol_infusao_pca_w IS NOT NULL AND qt_vol_infusao_pca_w::text <> '') then
			ds_fluxo_w := chr(10) || substr(obter_desc_expressao(290188)||': ' || qt_vol_infusao_pca_w ||' ' || ie_um_fluxo_pca_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_fluxo_w || ' ';
		end if;

		if (qt_bolus_pca_w IS NOT NULL AND qt_bolus_pca_w::text <> '') then
			ds_bolus_w := chr(10) || substr(obter_desc_expressao(284344)||': ' || qt_bolus_pca_w || ' ' || ie_um_bolus_pca_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_bolus_w || ' ';
		end if;

		if (qt_intervalo_bloqueio_w IS NOT NULL AND qt_intervalo_bloqueio_w::text <> '') then
			ds_interv_bloqueio_w := chr(10) || substr(obter_desc_expressao(603863) ||': '|| qt_intervalo_bloqueio_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_interv_bloqueio_w ||' min' || ' ';
		end if;

		if (qt_dose_inicial_pca_w IS NOT NULL AND qt_dose_inicial_pca_w::text <> '') then
			ds_dose_inicial_w := chr(10) || substr(obter_desc_expressao(288243)||': ' || qt_dose_inicial_pca_w ||' ' || ie_um_dose_inicio_pca_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_dose_inicial_w || ' ';
		end if;

		if (qt_limite_quatro_hora_w IS NOT NULL AND qt_limite_quatro_hora_w::text <> '') then
			ds_limite4hr_w := chr(10) || substr(obter_desc_expressao(292592)||': ' || qt_limite_quatro_hora_w ||' '|| ie_um_limite_pca_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_limite4hr_w || ' ';
		end if;

		if (qt_limite_uma_hora_w IS NOT NULL AND qt_limite_uma_hora_w::text <> '') then
			ds_limite1hr_w := chr(10) || substr(obter_desc_expressao(292590)||': '|| qt_limite_uma_hora_w || ' ' || ie_um_limite_hora_pca_w,1,255);
			ds_retorno_w :=	ds_retorno_w || ds_limite1hr_w;
		end if;

		ds_retorno_w := obter_desc_expressao(945020) || ' ' || ds_retorno_w;

	end if;
	end if;

	if (nr_seq_dialise_w IS NOT NULL AND nr_seq_dialise_w::text <> '') then

		select 	max(h.qt_fluxo_sangue),
				max(h.qt_hora_sessao),
				max(h.qt_min_sessao),
				max(substr(obter_valor_dominio_idioma(1934, h.ie_tipo_hemodialise,wheb_usuario_pck.get_nr_seq_idioma),1,255)),
				max(d.ds_modelo),
				max(substr(obter_valor_dominio_idioma(1936, h.ie_ultrafiltracao,wheb_usuario_pck.get_nr_seq_idioma),1,255)),
				max(h.qt_ultrafiltracao),
				max(h.qt_ultrafiltracao_total),
				max(h.qt_sodio),
				max(h.qt_bicarbonato),
				max(h.nr_seq_ultra)
		into STRICT	qt_fluxo_sangue_w,
				qt_hora_sessao_w,
				qt_min_sessao_w,
				ds_tipo_hemodialise_w,
				ds_modelo_dialisador_w,
				ds_ultrainfiltracao_w,
				qt_ultrainfiltracao_w,
				qt_ultrafiltracao_total_w,
				qt_sodio_w,
				qt_bicarbonato_w,
				nr_seq_ulta_w
		 FROM hd_prescricao h
LEFT OUTER JOIN hd_modelo_dialisador d ON (h.nr_seq_mod_dialisador = d.nr_sequencia)
WHERE h.nr_prescricao = nr_prescricao_p;

		if (coalesce(ds_tipo_hemodialise_w, 'XPTO') <> 'XPTO') then
			ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || obter_desc_expressao(665642, null) || ': ' || ds_tipo_hemodialise_w, 1, 2000);
		end if;

		if (qt_hora_sessao_w IS NOT NULL AND qt_hora_sessao_w::text <> '' AND qt_min_sessao_w IS NOT NULL AND qt_min_sessao_w::text <> '') then

			if (qt_min_sessao_w < 10) then
				qt_min_sessao_ww := '0' || to_char(qt_min_sessao_w);
			else
				qt_min_sessao_ww := to_char(qt_min_sessao_w);
			end if;

			if (qt_hora_sessao_w < 10) then
				qt_hora_sessao_ww := '0' || to_char(qt_hora_sessao_w);
			else
				qt_hora_sessao_ww := to_char(qt_hora_sessao_w);
			end if;

			-- Duracao (h/min)
			ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || obter_desc_expressao(289010, null) || ': ' || qt_hora_sessao_ww || ':' || qt_min_sessao_ww,1,255);
		end if;

		if (coalesce(ds_modelo_dialisador_w, 'XPTO') <> 'XPTO') then
			ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || obter_desc_expressao(293388, null) || ': ' || ds_modelo_dialisador_w, 1, 2000);
		end if;

		if (coalesce(qt_fluxo_sangue_w,0) > 0) then
			-- Fluxo de sangue
			if (coalesce(ie_altera_label_campo_w,'N') = 'S') then
				ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || obter_desc_expressao(713194, null) || ': ' || qt_fluxo_sangue_w,1,255);
			else
				ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || obter_desc_expressao(290190, null) || ': ' || qt_fluxo_sangue_w,1,255);
			end if;
		end if;		

		if (coalesce(ds_ultrainfiltracao_w, 'XPTO') <> 'XPTO') then
			ds_ultrainfiltracao_ww := substr(obter_desc_expressao(300680, null) || ': ' || ds_ultrainfiltracao_w, 1, 2000);
		end if;

		if (qt_ultrainfiltracao_w > 0 and (ds_ultrainfiltracao_ww IS NOT NULL AND ds_ultrainfiltracao_ww::text <> '')) then
			ds_ultrainfiltracao_ww := substr(ds_ultrainfiltracao_ww || ', ' || obter_desc_expressao(701494, null) || ': ' || qt_ultrainfiltracao_w, 1, 2000);
		elsif (qt_ultrainfiltracao_w > 0) then
			ds_ultrainfiltracao_ww := substr(obter_desc_expressao(701494, null) || ': ' || qt_ultrainfiltracao_w, 1, 2000);
		end if;

		if (qt_ultrafiltracao_total_w > 0 and (ds_ultrainfiltracao_ww IS NOT NULL AND ds_ultrainfiltracao_ww::text <> '')) then
			ds_ultrainfiltracao_ww := substr(ds_ultrainfiltracao_ww || ', ' || obter_desc_expressao(1029116, null) || ': ' || qt_ultrafiltracao_total_w, 1, 2000);
		elsif (qt_ultrafiltracao_total_w > 0) then
			ds_ultrainfiltracao_ww := substr(obter_desc_expressao(1029116, null) || ': ' || qt_ultrafiltracao_total_w, 1, 2000);
		end if;

		if (nr_seq_ulta_w > 0) then
			select ds_perfil
			into STRICT ds_perfil_ultra_w
			from hd_perfil_ultra
			where nr_sequencia = nr_seq_ulta_w;

			if (ds_ultrainfiltracao_ww IS NOT NULL AND ds_ultrainfiltracao_ww::text <> '') then
				ds_ultrainfiltracao_ww := substr(ds_ultrainfiltracao_ww || ', ' || obter_desc_expressao(295475, null) || ': ' || ds_perfil_ultra_w, 1, 2000);
			else
				ds_ultrainfiltracao_ww := substr(obter_desc_expressao(295475, null) || ': ' || ds_perfil_ultra_w, 1, 2000);
			end if;
		end if;

		if (ds_ultrainfiltracao_ww IS NOT NULL AND ds_ultrainfiltracao_ww::text <> '') then
			ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || ds_ultrainfiltracao_ww, 1, 2000);
		end if;

		if (qt_sodio_w > 0) then
			ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || obter_desc_expressao(298623, null) || ': ' || qt_sodio_w, 1, 2000);
		end if;

		if (qt_bicarbonato_w > 0) then
			ds_retorno_w := substr(ds_retorno_w || '. ' || chr(10) || obter_desc_expressao(284301, null) || ': ' || qt_bicarbonato_w, 1, 2000);
		end if;

		if (coalesce(ds_descricao_sol_w, 'XPTO') <> 'XPTO') then
			ds_retorno_w := substr(ds_retorno_w || chr(10) || ds_descricao_sol_w, 1, 2000);
		end if;

	end if;

	end;
end if;

RETURN replace(replace(replace(ds_retorno_w,' .',' 0,'),' ,',' 0,'),'/,','/0,');

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_vol_sol_etapa_adep ( nr_prescricao_p bigint, nr_Seq_solucao_p bigint, ie_solucao_agrupada_p text default 'N') FROM PUBLIC;

