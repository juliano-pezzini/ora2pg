-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_peso_altura_js ( nr_prescricao_p bigint, nr_sequencias_p text, qt_peso_p bigint, qt_altura_p bigint, ds_obs_coleta_p text) AS $body$
DECLARE


  qt_Peso_Anterior_P   bigint;
  qt_Altura_Anterior_P bigint;


BEGIN

  select coalesce(qt_peso, 0)
    into STRICT qt_Peso_Anterior_P
    from prescr_medica
   where nr_prescricao = nr_prescricao_p;

  if (qt_peso_p > 0 AND qt_peso_p <> qt_peso_anterior_p) then

  	update prescr_medica
       set qt_peso = qt_peso_p,
           dt_atualizacao = clock_timestamp(),
           nm_usuario = wheb_usuario_pck.get_nm_usuario
	   where nr_prescricao = nr_prescricao_p;
  end if;

  select coalesce(qt_altura_cm,0)
    into STRICT qt_Altura_Anterior_P
    from prescr_medica
   where nr_prescricao = nr_prescricao_p;

  if (qt_altura_p > 0 AND qt_altura_p <> qt_altura_anterior_p) then
  	update prescr_medica
	     set qt_altura_cm = qt_altura_p,
		       dt_atualizacao = clock_timestamp(),
           nm_usuario = wheb_usuario_pck.get_nm_usuario
	   where nr_prescricao = nr_prescricao_p;
  end if;

  if (ds_obs_coleta_p IS NOT NULL AND ds_obs_coleta_p::text <> '') then
  	update prescr_procedimento
       set ds_observacao_coleta = ds_obs_coleta_p,
		       dt_atualizacao = clock_timestamp(),
           nm_usuario = wheb_usuario_pck.get_nm_usuario
	   where nr_prescricao = nr_prescricao_p
	     and obter_se_contido(nr_sequencia ,(nr_sequencias_p)) = 'S';
  end if;

  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_peso_altura_js ( nr_prescricao_p bigint, nr_sequencias_p text, qt_peso_p bigint, qt_altura_p bigint, ds_obs_coleta_p text) FROM PUBLIC;

