-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION localizador_apap_pck.get_estrutura () RETURNS SETOF ESTRUTURA_T AS $body$
DECLARE

indice_w    bigint := 0;
BEGIN
if (current_setting('localizador_apap_pck.estrutura_nivel_1_w')::estrutura_nivel_1_t.count = 0) then
   CALL CALL localizador_apap_pck.gera_niveis();

   for linha in current_setting('localizador_apap_pck.estrutura_nivel_1_w')::estrutura_nivel_1_t.first..estrutura_nivel_1_w.last loop
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.extend(1);
      indice_w := indice_w + 1;
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t(indice_w) := current_setting('localizador_apap_pck.estrutura_nivel_1_w')::estrutura_nivel_1_t(linha);
   end loop;

   for linha in current_setting('localizador_apap_pck.estrutura_nivel_2_w')::estrutura_nivel_2_t.first..estrutura_nivel_2_w.last loop
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.extend(1);
      indice_w := indice_w + 1;
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t(indice_w) := current_setting('localizador_apap_pck.estrutura_nivel_2_w')::estrutura_nivel_2_t(linha);
   end loop;

   for linha in current_setting('localizador_apap_pck.estrutura_nivel_3_w')::estrutura_nivel_3_t.first..estrutura_nivel_3_w.last loop
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.extend(1);
      indice_w := indice_w + 1;
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t(indice_w) := current_setting('localizador_apap_pck.estrutura_nivel_3_w')::estrutura_nivel_3_t(linha);
   end loop;

   for linha in current_setting('localizador_apap_pck.estrutura_nivel_4_w')::estrutura_nivel_4_t.first..estrutura_nivel_4_w.last loop
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.extend(1);
      indice_w := indice_w + 1;
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t(indice_w) := current_setting('localizador_apap_pck.estrutura_nivel_4_w')::estrutura_nivel_4_t(linha);
   end loop;

   for linha in current_setting('localizador_apap_pck.estrutura_nivel_5_w')::estrutura_nivel_5_t.first..estrutura_nivel_5_w.last loop
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.extend(1);
      indice_w := indice_w + 1;
      current_setting('localizador_apap_pck.estrutura_w')::estrutura_t(indice_w) := current_setting('localizador_apap_pck.estrutura_nivel_5_w')::estrutura_nivel_5_t(linha);
   end loop;
end if;

if (current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.count > 0) then
   for linha in current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.first..estrutura_w.last loop
      if (current_setting('localizador_apap_pck.estrutura_w')::estrutura_t.exists(linha)) then
         RETURN NEXT current_setting('localizador_apap_pck.estrutura_w'::estrutura_t(linha));
      end if;
   end loop;
end if;
return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION localizador_apap_pck.get_estrutura () FROM PUBLIC;
