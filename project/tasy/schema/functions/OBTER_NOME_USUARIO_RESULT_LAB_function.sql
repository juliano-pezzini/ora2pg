-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_usuario_result_lab ( nr_prescricao_p result_laboratorio_info.nr_prescricao%type, nr_seq_prescr_p result_laboratorio_info.nr_seq_prescr%type) RETURNS varchar AS $body$
DECLARE


nm_usuario_resultado_w		result_laboratorio_info.nm_usuario%type;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	begin

	select nm_usuario
  into STRICT nm_usuario_resultado_w
  from result_laboratorio_info
  where nr_prescricao = nr_prescricao_p 
  and nr_seq_prescr = nr_seq_prescr_p;

  exception
     when no_data_found then
        nm_usuario_resultado_w := null;
    when too_many_rows then
        CALL gravar_log_lab_pragma(
          CD_LOG_P         => 24147,
          DS_LOG_P         =>'nm_usuario_resultado_w: ' || to_char(nm_usuario_resultado_w) || ';',
          NM_USUARIO_P     => nm_usuario_resultado_w,
          NR_PRESCRICAO_P  => nr_prescricao_p
        );
        nm_usuario_resultado_w := null;

  end;

else

  begin

  CALL gravar_log_lab_pragma(
    CD_LOG_P         => 24147,
    DS_LOG_P         =>'nm_usuario_resultado_w: ' || to_char(nm_usuario_resultado_w) || ';',
    NM_USUARIO_P     => nm_usuario_resultado_w,
    NR_PRESCRICAO_P  => nr_prescricao_p
  );

  end;

end if;

return	nm_usuario_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_usuario_result_lab ( nr_prescricao_p result_laboratorio_info.nr_prescricao%type, nr_seq_prescr_p result_laboratorio_info.nr_seq_prescr%type) FROM PUBLIC;
