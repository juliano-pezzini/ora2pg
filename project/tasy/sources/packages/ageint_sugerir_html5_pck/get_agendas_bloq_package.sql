-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ageint_sugerir_html5_pck.get_agendas_bloq (ds_lista_p text, dt_inicial_filtro_p timestamp, dt_final_filtro_p timestamp, nr_seq_item_p bigint) RETURNS SETOF REGRAS_BLOQUEIOS_T AS $body$
WITH RECURSIVE cte AS (
DECLARE


  C01 CURSOR FOR
    SELECT regexp_substr(ds_lista_p,'[^,]+', 1, level) cd_agenda
    
    (regexp_substr(ds_lista_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(ds_lista_p, '[^,]+', 1, level))::text <> '')  UNION ALL
DECLARE


  C01 CURSOR FOR 
    SELECT regexp_substr(ds_lista_p,'[^,]+', 1, level) cd_agenda
    
    (regexp_substr(ds_lista_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(ds_lista_p, '[^,]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;

  
BEGIN
    for r_c01 in C01 loop
      CALL ageint_sugerir_html5_pck.bloqueios_agenda_sugestao(r_c01.cd_agenda, dt_inicial_filtro_p, dt_final_filtro_p, nr_seq_item_p, 'S');
    end loop;
    if current_setting('ageint_sugerir_html5_pck.regras_bloqueios_w')::regras_bloqueios.count > 0 then
      for i in current_setting('ageint_sugerir_html5_pck.regras_bloqueios_w')::regras_bloqueios.first .. current_setting('ageint_sugerir_html5_pck.regras_bloqueios_w')::regras_bloqueios.last loop
        if (current_setting('ageint_sugerir_html5_pck.regras_bloqueios_w')::regras_bloqueios.exists(i)) then
          RETURN NEXT current_setting('ageint_sugerir_html5_pck.regras_bloqueios_w'::regras_bloqueios(i));
        end if;
      end loop;
    end if;

  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_sugerir_html5_pck.get_agendas_bloq (ds_lista_p text, dt_inicial_filtro_p timestamp, dt_final_filtro_p timestamp, nr_seq_item_p bigint) FROM PUBLIC;