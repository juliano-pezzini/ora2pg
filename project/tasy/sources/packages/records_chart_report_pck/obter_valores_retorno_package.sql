-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE records_chart_report_pck.obter_valores_retorno ( registros_p dados_table, dt_registro_str_p text, ie_sinal_vital_p text, nr_seq_cirur_agente_p bigint, retorno_p INOUT dados_table) AS $body$
DECLARE

   w           bigint;
   x           bigint := 0;
   retorno_w   dados_table;

BEGIN
   for 	w in 1..registros_p.count loop		
      begin
      if (registros_p[w].dt_registro_str = dt_registro_str_p) and (registros_p[w].ie_sinal_vital = ie_sinal_vital_p) and (registros_p[w].nr_seq_cirur_agente = nr_seq_cirur_agente_p) and
         ((registros_p[w].qt_valor > 0) or (registros_p[w].code_group in ('PR','AN','PA'))) then
         x := x + 1;
         retorno_w(x) := registros_p(w);
      end if;
      end;
   end loop;
   
   retorno_p := retorno_w;
   end;
   

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE records_chart_report_pck.obter_valores_retorno ( registros_p dados_table, dt_registro_str_p text, ie_sinal_vital_p text, nr_seq_cirur_agente_p bigint, retorno_p INOUT dados_table) FROM PUBLIC;