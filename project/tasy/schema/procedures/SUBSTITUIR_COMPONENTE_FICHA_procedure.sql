-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_componente_ficha ( nr_seq_ficha_p bigint, cd_material_selec_p bigint, cd_material_novo_p bigint, qt_dose_nova_p bigint, qt_fixa_nova_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE

/*
E -  excluir componente  da ficha.
S -  substituir componente da ficha.
*/
BEGIN
if (nr_seq_ficha_p > 0) and (cd_material_selec_p > 0) then
   if (ie_opcao_p = 'E') then
      delete from ficha_tecnica_comp_regra
      where nr_ficha_tecnica = nr_seq_ficha_p
      and nr_seq_componente in (SELECT  nr_seq_componente
                                               	   from     ficha_tecnica_componente
                                               	   where  nr_ficha_tecnica = nr_seq_ficha_p
                                                   and      cd_material         = cd_material_selec_p);

      delete from ficha_tecnica_componente
      where   nr_ficha_tecnica = nr_seq_ficha_p
      and      cd_material          = cd_material_selec_p;

   else
      update  ficha_tecnica_componente
      set        cd_material 	= cd_material_novo_p,
                  qt_dose 		= qt_dose_nova_p,
                  qt_fixa 		= qt_fixa_nova_p,
                  nm_usuario 	= nm_usuario_p,
                  dt_atualizacao 	= clock_timestamp()
      where   nr_ficha_tecnica = nr_seq_ficha_p
      and      cd_material          = cd_material_selec_p;
   end if;

   commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_componente_ficha ( nr_seq_ficha_p bigint, cd_material_selec_p bigint, cd_material_novo_p bigint, qt_dose_nova_p bigint, qt_fixa_nova_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

