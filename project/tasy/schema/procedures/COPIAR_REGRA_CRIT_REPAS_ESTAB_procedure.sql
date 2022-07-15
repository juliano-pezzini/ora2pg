-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_regra_crit_repas_estab (cd_regra_p bigint, cd_estab_dest_p text) AS $body$
DECLARE


cd_estabelecimento_w  estabelecimento.cd_estabelecimento%type;

c01 CURSOR FOR
  SELECT cd_estabelecimento
    from estabelecimento
   where obter_se_contido(cd_estabelecimento, elimina_aspas(cd_estab_dest_p)) = 'S';


BEGIN
  open c01;
  loop
    fetch c01 into
      cd_estabelecimento_w;
    EXIT WHEN NOT FOUND; /* apply on c01 */

    CALL copiar_regra_criterio_repasse(cd_regra_p, cd_estabelecimento_w);

  end loop;
  close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_regra_crit_repas_estab (cd_regra_p bigint, cd_estab_dest_p text) FROM PUBLIC;

