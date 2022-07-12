-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_fisioterap_ep_md (qt_pt_idade_p bigint, qt_pt_cardiovascular_p bigint, qt_pt_respiratorio_p bigint, qt_pt_pa_sist_p bigint, qt_pt_fc_p bigint, qt_pt_glasgow_p bigint, qt_pt_hemoglobina_p bigint, qt_pt_glob_brancos_p bigint, qt_pt_ureia_p bigint, qt_pt_sodio_p bigint, qt_pt_potassio_p bigint, qt_pt_ecg_p bigint ) RETURNS bigint AS $body$
DECLARE


   qt_pontos_fisio_w smallint := 0;

BEGIN
  --- Inicio MD16
  qt_pontos_fisio_w := coalesce(qt_pt_idade_p,0)          +
                       coalesce(qt_pt_cardiovascular_p,0) +
                       coalesce(qt_pt_respiratorio_p,0)   +
                       coalesce(qt_pt_pa_sist_p,0)        +
                       coalesce(qt_pt_fc_p,0)             +
                       coalesce(qt_pt_glasgow_p,0)        +
                       coalesce(qt_pt_hemoglobina_p,0)    +
                       coalesce(qt_pt_glob_brancos_p,0)   +
                       coalesce(qt_pt_ureia_p,0)          + 
                       coalesce(qt_pt_sodio_p,0)          +
                       coalesce(qt_pt_potassio_p,0)       +
                       coalesce(qt_pt_ecg_p,0);
  --- Fim MD16
    RETURN coalesce(qt_pontos_fisio_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_fisioterap_ep_md (qt_pt_idade_p bigint, qt_pt_cardiovascular_p bigint, qt_pt_respiratorio_p bigint, qt_pt_pa_sist_p bigint, qt_pt_fc_p bigint, qt_pt_glasgow_p bigint, qt_pt_hemoglobina_p bigint, qt_pt_glob_brancos_p bigint, qt_pt_ureia_p bigint, qt_pt_sodio_p bigint, qt_pt_potassio_p bigint, qt_pt_ecg_p bigint ) FROM PUBLIC;
