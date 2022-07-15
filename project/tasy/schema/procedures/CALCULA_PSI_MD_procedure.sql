-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_psi_md (qt_ano_p bigint, ie_sexo_p text, ie_enfermagem_p text, ie_neoplasia_p text, ie_hepatica_p text, ie_icc_p text, ie_avc_p text, ie_renal_p text, ie_estado_mental_p text, ie_fr_p text, ie_pas_p text, ie_temp_p text, ie_fc_p text, ie_ph_arterial_p text, ie_ureia_p text, ie_sodio_p text, ie_glicose_p text, ie_hematocrito_p text, ie_po2_p text, ie_derrame_pleural_p text, qt_esc_ano_p INOUT bigint, qt_esc_enf_p INOUT bigint, qt_esc_neo_p INOUT bigint, qt_esc_hep_p INOUT bigint, qt_esc_icc_p INOUT bigint, qt_esc_avc_p INOUT bigint, qt_esc_ren_p INOUT bigint, qt_esc_mental_p INOUT bigint, qt_esc_fr_p INOUT bigint, qt_esc_pas_p INOUT bigint, qt_esc_temp_p INOUT bigint, qt_esc_fc_p INOUT bigint, qt_esc_ph_arterial_p INOUT bigint, qt_esc_ureia_p INOUT bigint, qt_esc_sodio_p INOUT bigint, qt_esc_glicose_p INOUT bigint, qt_esc_hematocrito_p INOUT bigint, qt_esc_po2_p INOUT bigint, qt_esc_derrame_pleural_p INOUT bigint, qt_escore_p INOUT bigint, pr_risco_p INOUT bigint ) AS $body$
BEGIN

qt_esc_ano_p := 0;
qt_esc_enf_p := 0;
qt_esc_neo_p := 0;
qt_esc_hep_p := 0;
qt_esc_icc_p := 0;
qt_esc_avc_p := 0;
qt_esc_ren_p := 0;
qt_esc_mental_p := 0;
qt_esc_fr_p := 0;
qt_esc_pas_p := 0;
qt_esc_temp_p := 0;
qt_esc_fc_p := 0;
qt_esc_ph_arterial_p := 0;
qt_esc_ureia_p := 0;
qt_esc_sodio_p := 0;
qt_esc_glicose_p := 0;
qt_esc_hematocrito_p := 0;
qt_esc_po2_p := 0;
qt_esc_derrame_pleural_p := 0;
qt_escore_p := 0;
pr_risco_p := 0;

  --INICIO MD
  if (ie_sexo_p = 'F') then
    qt_esc_ano_p	:= coalesce(qt_ano_p,0) - 10;
  else
    qt_esc_ano_p	:= coalesce(qt_ano_p,0);
  end if;

  if (ie_enfermagem_p= 'S') then
    qt_esc_enf_p		:= 10;
  end if;
  if (ie_neoplasia_p= 'S') then
    qt_esc_neo_p		:= 30;
  end if;
  if (ie_hepatica_p= 'S') then
    qt_esc_hep_p		:= 20;
  end if;
  if (ie_icc_p= 'S') then
    qt_esc_icc_p		:= 10;
  end if;
  if (ie_avc_p= 'S') then
    qt_esc_avc_p		:= 10;
  end if;
  if (ie_renal_p= 'S') then
    qt_esc_ren_p		:= 10;
  end if;
  if (ie_estado_mental_p= 'S') then
    qt_esc_mental_p		:= 20;
  end if;
  if (ie_fr_p= 'S') then
    qt_esc_fr_p		:= 20;
  end if;
  if (ie_pas_p= 'S') then
    qt_esc_pas_p		:= 20;
  end if;
  if (ie_temp_p= 'S') then
    qt_esc_temp_p		:= 15;
  end if;
  if (ie_fc_p= 'S') then
    qt_esc_fc_p		:= 10;
  end if;
  if (ie_ph_arterial_p= 'S') then
    qt_esc_ph_arterial_p	:= 30;
  end if;
  if (ie_ureia_p= 'S') then
    qt_esc_ureia_p		:= 20;
  end if;
  if (ie_sodio_p= 'S') then
    qt_esc_sodio_p		:= 10;
  end if;
  if (ie_glicose_p= 'S') then
    qt_esc_glicose_p		:= 10;
  end if;
  if (ie_hematocrito_p= 'S') then
    qt_esc_hematocrito_p	:= 10;
  end if;
  if (ie_po2_p= 'S') then
    qt_esc_po2_p		:= 10;
  end if;
  if (ie_derrame_pleural_p= 'S') then
    qt_esc_derrame_pleural_p	:= 10;
  end if;

  qt_escore_p := coalesce(qt_esc_ano_p,0) +
                 coalesce(qt_esc_enf_p,0) +
                 coalesce(qt_esc_neo_p,0) +
                 coalesce(qt_esc_hep_p,0) +
                 coalesce(qt_esc_icc_p,0) +
                 coalesce(qt_esc_avc_p,0) +
                 coalesce(qt_esc_ren_p,0) +
                 coalesce(qt_esc_mental_p,0) +
                 coalesce(qt_esc_fr_p,0) +
                 coalesce(qt_esc_pas_p,0) +
                 coalesce(qt_esc_temp_p,0) +
                 coalesce(qt_esc_fc_p,0) +
                 coalesce(qt_esc_ph_arterial_p,0) +
                 coalesce(qt_esc_ureia_p,0) +
                 coalesce(qt_esc_sodio_p,0) +
                 coalesce(qt_esc_glicose_p,0) +
                 coalesce(qt_esc_hematocrito_p,0) +
                 coalesce(qt_esc_po2_p,0) +
                 coalesce(qt_esc_derrame_pleural_p,0);

  if (qt_escore_p <= 70) then
    pr_risco_p			:= 0.6;
  elsif (qt_escore_p <= 90) then
    pr_risco_p			:= 0.9;
  elsif (qt_escore_p <= 130) then
    pr_risco_p			:= 9.3;
  elsif (qt_escore_p > 130) then
    pr_risco_p			:= 27;
  end if;
  --FIM MD    
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_psi_md (qt_ano_p bigint, ie_sexo_p text, ie_enfermagem_p text, ie_neoplasia_p text, ie_hepatica_p text, ie_icc_p text, ie_avc_p text, ie_renal_p text, ie_estado_mental_p text, ie_fr_p text, ie_pas_p text, ie_temp_p text, ie_fc_p text, ie_ph_arterial_p text, ie_ureia_p text, ie_sodio_p text, ie_glicose_p text, ie_hematocrito_p text, ie_po2_p text, ie_derrame_pleural_p text, qt_esc_ano_p INOUT bigint, qt_esc_enf_p INOUT bigint, qt_esc_neo_p INOUT bigint, qt_esc_hep_p INOUT bigint, qt_esc_icc_p INOUT bigint, qt_esc_avc_p INOUT bigint, qt_esc_ren_p INOUT bigint, qt_esc_mental_p INOUT bigint, qt_esc_fr_p INOUT bigint, qt_esc_pas_p INOUT bigint, qt_esc_temp_p INOUT bigint, qt_esc_fc_p INOUT bigint, qt_esc_ph_arterial_p INOUT bigint, qt_esc_ureia_p INOUT bigint, qt_esc_sodio_p INOUT bigint, qt_esc_glicose_p INOUT bigint, qt_esc_hematocrito_p INOUT bigint, qt_esc_po2_p INOUT bigint, qt_esc_derrame_pleural_p INOUT bigint, qt_escore_p INOUT bigint, pr_risco_p INOUT bigint ) FROM PUBLIC;

