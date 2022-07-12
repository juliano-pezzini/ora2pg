-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pck_flowsheet.ger_dados_rel (cd_relatorio_p bigint, ie_dados_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_pessoa_fisica_p bigint) AS $body$
BEGIN

    --Limpa tabela valores
    delete FROM w_rel_val_flowsheet
     where nm_usuario = wheb_usuario_pck.get_nm_usuario
       and nr_relatorio = cd_relatorio_p;

    delete FROM w_rel_audit_flowsheet
     where nm_usuario = wheb_usuario_pck.get_nm_usuario
       and nr_relatorio = cd_relatorio_p;

    commit;

    if (cd_relatorio_p = current_setting('pck_flowsheet.cd_respiratory')::bigint) then

      CALL pck_flowsheet.ger_dados_respiratory(cd_relatorio_p     => cd_relatorio_p,
                            ie_dados_p         => ie_dados_p,
                            dt_inicial_p       => dt_inicial_p,
                            dt_final_p         => dt_final_p,
                            cd_pessoa_fisica_p => cd_pessoa_fisica_p);

    elsif (cd_relatorio_p = current_setting('pck_flowsheet.cd_vital_signs')::bigint) then

      CALL pck_flowsheet.ger_dados_vital_signs(cd_relatorio_p     => cd_relatorio_p,
                            ie_dados_p         => ie_dados_p,
                            dt_inicial_p       => dt_inicial_p,
                            dt_final_p         => dt_final_p,
                            cd_pessoa_fisica_p => cd_pessoa_fisica_p);

    elsif (cd_relatorio_p = current_setting('pck_flowsheet.cd_nursing_asses')::bigint) then

      CALL pck_flowsheet.ger_dados_nursing_asses(cd_relatorio_p   => cd_relatorio_p,
                              ie_dados_p         => ie_dados_p,
                              dt_inicial_p       => dt_inicial_p,
                              dt_final_p         => dt_final_p,
                              cd_pessoa_fisica_p => cd_pessoa_fisica_p);

    elsif (cd_relatorio_p = current_setting('pck_flowsheet.cd_nursing_care')::bigint) then

      CALL pck_flowsheet.ger_dados_nursing_care(cd_relatorio_p    => cd_relatorio_p,
                             ie_dados_p         => ie_dados_p,
                             dt_inicial_p       => dt_inicial_p,
                             dt_final_p         => dt_final_p,
                             cd_pessoa_fisica_p => cd_pessoa_fisica_p);

    elsif (cd_relatorio_p = current_setting('pck_flowsheet.cd_shift_details')::bigint) then

      CALL pck_flowsheet.ger_dados_shift_details(cd_relatorio_p    => cd_relatorio_p,
                              ie_dados_p         => ie_dados_p,
                              dt_inicial_p       => dt_inicial_p,
                              dt_final_p         => dt_final_p,
                              cd_pessoa_fisica_p => cd_pessoa_fisica_p);

    end if;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pck_flowsheet.ger_dados_rel (cd_relatorio_p bigint, ie_dados_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_pessoa_fisica_p bigint) FROM PUBLIC;