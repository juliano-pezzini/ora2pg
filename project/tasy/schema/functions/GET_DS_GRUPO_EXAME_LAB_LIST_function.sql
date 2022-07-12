-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_ds_grupo_exame_lab_list ( NR_ATENDIMENTO_P bigint, nr_prescricao_p bigint, ie_status_report_p text ) RETURNS varchar AS $body$
DECLARE

  ds_texto_retorno_w  varchar(2000) := NULL;
  cur_rec RECORD;

BEGIN
  FOR cur_rec IN (

       SELECT distinct d.DS_GRUPO_EXAME_LAB 
                from RESULT_LABORATORIO a,     
                prescr_procedimento b,     
                exame_laboratorio c,     
                grupo_exame_lab d,     
                prescr_medica e,     
                prescr_procedimento_compl f   
                where a.nr_prescricao = b.nr_prescricao     
                and a.nr_seq_prescricao = b.nr_sequencia     
                and b.nr_seq_exame = c.nr_seq_exame     
                and d.nr_sequencia = c.nr_seq_grupo     
                and a.nr_prescricao = e.nr_prescricao     
                and e.nr_atendimento = NR_ATENDIMENTO_P     
                and b.nr_seq_proc_compl = f.nr_sequencia  
                and (f.ie_status_report = ie_status_report_p or coalesce(f.ie_status_report::text, '') = '')
                and a.nr_prescricao = nr_prescricao_p
                order by e.nr_atendimento desc
  
  
  ) LOOP
    ds_texto_retorno_w := ds_texto_retorno_w || ',' || cur_rec.DS_GRUPO_EXAME_LAB;
  END LOOP;
  RETURN LTRIM(ds_texto_retorno_w, ',');
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_ds_grupo_exame_lab_list ( NR_ATENDIMENTO_P bigint, nr_prescricao_p bigint, ie_status_report_p text ) FROM PUBLIC;

