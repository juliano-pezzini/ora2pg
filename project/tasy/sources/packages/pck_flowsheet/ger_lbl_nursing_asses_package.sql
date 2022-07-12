-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pck_flowsheet.ger_lbl_nursing_asses () AS $body$
BEGIN

    for i in current_setting('pck_flowsheet.ds_lbl_nur_asse_w')::nur_asse_t.first .. current_setting('pck_flowsheet.ds_lbl_nur_asse_w')::nur_asse_t.last loop

      CALL pck_flowsheet.insert_label(cd_relatorio_p => current_setting('pck_flowsheet.cd_nursing_asses')::bigint,
                   nr_ordem_p     => i,
                   ds_label_p     => current_setting('pck_flowsheet.ds_lbl_nur_asse_w')::nur_asse_t(i));

    end loop;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pck_flowsheet.ger_lbl_nursing_asses () FROM PUBLIC;
