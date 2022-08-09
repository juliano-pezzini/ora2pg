-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dose_terap_med_terap_md (ie_unidade_p text, ie_unidade_vel_p text, qt_dose_p bigint, qt_tempo_p bigint, qt_concent_med_mg_p bigint, qt_corrigido_p bigint, qt_tempo_infusao_p bigint, qt_equipo_p bigint, ie_tempo_p text, qt_dose_terap_p INOUT bigint, qt_corrigido_terap_p INOUT bigint, qt_diluente_p INOUT bigint, qt_corrigido_dilu_p INOUT bigint, qt_total_dose_p INOUT bigint, qt_total_corrigido_p INOUT bigint, qt_micrograma_p INOUT bigint, qt_micro_corrigido_p INOUT bigint ) AS $body$
DECLARE


  qt_dose_terap_w           double precision;
  qt_corrigido_w            double precision;
  qt_corrigido_ww	          double precision;
  qt_dose_terapeutica_w     double precision;
  qt_diluente_w             double precision;
  qt_corrigido_dilu_w       double precision;
  qt_total_dose_w           double precision;
  qt_total_corrigido_w      double precision;
  qt_tot_micro_corrigido_w  double precision;

BEGIN
  if (upper(ie_unidade_vel_p) <> 'GTM') then
    if (ie_unidade_p = 'MG') then
      qt_dose_terap_w  	:= (qt_dose_p * qt_tempo_p);
      qt_corrigido_w	 	:=  dividir_sem_round_md(qt_dose_terap_w,qt_concent_med_mg_p);

    elsif (ie_unidade_p = 'MCG') then			
      qt_dose_terap_w  	:= round((qt_dose_p * qt_tempo_p)::numeric, 2);
      qt_corrigido_w	 	:= qt_corrigido_p;

    elsif (ie_unidade_p = 'MEQ') then 			
      qt_dose_terap_w 	:= qt_dose_p;
      qt_corrigido_w		:=  qt_corrigido_p;

    elsif (ie_unidade_p = 'UI') then 			
      qt_dose_terap_w  	:= (qt_dose_p * qt_tempo_p);
      qt_corrigido_w	 	:=  qt_corrigido_p;
    end if;

    qt_corrigido_ww          := dividir_sem_round_md((coalesce(qt_tempo_infusao_p,0) + coalesce(qt_equipo_p,0)),qt_tempo_infusao_p);
    qt_dose_terapeutica_w    := qt_corrigido_w;
    qt_corrigido_w           := qt_corrigido_w * qt_corrigido_ww;
    qt_diluente_w            := coalesce(qt_tempo_infusao_p,0) - coalesce(qt_dose_terapeutica_w,0);
    qt_corrigido_dilu_w      := (coalesce(qt_tempo_infusao_p,0) + coalesce(qt_equipo_p,0)) - qt_corrigido_w;
    qt_total_dose_w          := coalesce(qt_dose_terapeutica_w,0) + coalesce(qt_diluente_w,0);
    qt_total_corrigido_w     := coalesce(qt_corrigido_w,0) + coalesce(qt_corrigido_dilu_w,0);
    qt_tot_micro_corrigido_w := ((dividir_sem_round_md(qt_dose_terap_w,qt_dose_terapeutica_w)) * qt_corrigido_w);

  elsif (upper(ie_unidade_vel_p) = 'GTM') and (ie_tempo_p = 'H') then
    if (ie_unidade_p = 'MG') then
      qt_dose_terap_w  	:= (qt_dose_p * qt_tempo_p);
      qt_corrigido_w		:=  dividir_sem_round_md(qt_dose_terap_w,qt_concent_med_mg_p);

    elsif (ie_unidade_p = 'MCG') then			
      qt_dose_terap_w  	:= round((qt_dose_p * qt_tempo_p)::numeric, 2);
      qt_corrigido_w	 	:= dividir_sem_round_md(qt_dose_terap_w,qt_concent_med_mg_p);

    elsif (ie_unidade_p = 'MEQ') then 						
      qt_dose_terap_w  	:= qt_dose_p;
      qt_corrigido_w	 	:= qt_corrigido_p;

    elsif (ie_unidade_p = 'UI') then 						
      qt_dose_terap_w  	:= round((qt_dose_p * qt_tempo_p)::numeric, 2);
      qt_corrigido_w	 	:= dividir_sem_round_md(qt_dose_terap_w,qt_concent_med_mg_p);
    end if;

    qt_dose_terapeutica_w    := qt_corrigido_w;
    qt_corrigido_ww          := dividir_sem_round_md((qt_tempo_infusao_p * 60),20);
    qt_corrigido_w           := dividir_sem_round_md(qt_dose_terap_w,qt_dose_p);	
    qt_diluente_w            := coalesce(qt_corrigido_ww,0) - coalesce(qt_dose_terapeutica_w,0);
    qt_corrigido_dilu_w		   := (coalesce(qt_corrigido_ww,0) + coalesce(qt_equipo_p,0)) - qt_corrigido_w;
    qt_total_dose_w          := coalesce(qt_dose_terapeutica_w,0) + coalesce(qt_diluente_w,0);
    qt_total_corrigido_w     := coalesce(qt_corrigido_w,0) + coalesce(qt_corrigido_dilu_w,0);
    qt_tot_micro_corrigido_w := ((dividir_sem_round_md(qt_dose_terap_w,qt_dose_terapeutica_w)) * qt_corrigido_w);

  elsif (upper(ie_unidade_vel_p) = 'GTM') and (ie_tempo_p <> 'H') then			
    if (ie_unidade_p = 'MG') then
        qt_dose_terap_w := (qt_dose_p * qt_tempo_p);
      qt_corrigido_w	 	:=  dividir_sem_round_md(qt_dose_terap_w,qt_concent_med_mg_p);

    elsif (ie_unidade_p = 'MCG') then			
        qt_dose_terap_w	:= round((qt_dose_p * qt_tempo_p)::numeric, 2);
      qt_corrigido_w	 	:=  dividir_sem_round_md(qt_dose_terap_w,qt_concent_med_mg_p);

    elsif (ie_unidade_p = 'MEQ') then 			
      qt_dose_terap_w   :=  qt_dose_p;
      qt_corrigido_w	 	:=  qt_corrigido_p;

    elsif (ie_unidade_p = 'UI') then 						
      qt_dose_terap_w  	:= round((qt_dose_p * qt_tempo_p)::numeric, 2);
      qt_corrigido_w	 	:= dividir_sem_round_md(qt_dose_terap_w,qt_concent_med_mg_p);
    end if;

    qt_dose_terapeutica_w    := qt_corrigido_w;
    qt_corrigido_ww          := dividir_sem_round_md((coalesce(qt_tempo_infusao_p,0) + coalesce(qt_equipo_p,0)),qt_tempo_infusao_p);
    qt_corrigido_w           := qt_corrigido_w * qt_corrigido_ww;	
    qt_corrigido_ww          := dividir_sem_round_md((qt_tempo_infusao_p * 60),20);
    qt_diluente_w            := coalesce(qt_corrigido_ww,0) - coalesce(qt_dose_terapeutica_w,0);
    qt_corrigido_dilu_w      := (coalesce(qt_corrigido_ww,0) + coalesce(qt_equipo_p,0)) - qt_corrigido_w;
    qt_total_dose_w          := coalesce(qt_dose_terapeutica_w,0) + coalesce(qt_diluente_w,0);
    qt_total_corrigido_w     := coalesce(qt_corrigido_w,0) + coalesce(qt_corrigido_dilu_w,0);
    qt_tot_micro_corrigido_w := ((dividir_sem_round_md(qt_dose_terap_w,qt_dose_terapeutica_w)) * qt_corrigido_w);		
  end if;

  qt_dose_terap_p       := trunc(qt_dose_terapeutica_w,4);
  qt_corrigido_terap_p  := trunc(qt_corrigido_w,4);
  qt_diluente_p         := trunc(qt_diluente_w,4);
  qt_corrigido_dilu_p   := trunc(qt_corrigido_dilu_w,4);
  qt_total_dose_p       := trunc(qt_total_dose_w,4);
  qt_total_corrigido_p  := trunc(qt_total_corrigido_w,4);
  qt_micrograma_p       := trunc(qt_dose_terap_w * 1000,4);
  qt_micro_corrigido_p  := trunc(qt_tot_micro_corrigido_w * 1000,4);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dose_terap_med_terap_md (ie_unidade_p text, ie_unidade_vel_p text, qt_dose_p bigint, qt_tempo_p bigint, qt_concent_med_mg_p bigint, qt_corrigido_p bigint, qt_tempo_infusao_p bigint, qt_equipo_p bigint, ie_tempo_p text, qt_dose_terap_p INOUT bigint, qt_corrigido_terap_p INOUT bigint, qt_diluente_p INOUT bigint, qt_corrigido_dilu_p INOUT bigint, qt_total_dose_p INOUT bigint, qt_total_corrigido_p INOUT bigint, qt_micrograma_p INOUT bigint, qt_micro_corrigido_p INOUT bigint ) FROM PUBLIC;
