-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_pck_db_utils.remove_establishment_settings (cd_establishment_p bigint) AS $body$
BEGIN
        delete FROM pfcs_set_bed_status_estab where cd_establishment = cd_establishment_p;
        delete FROM pfcs_indicator_target t where t.nr_seq_rule in (
          SELECT r.nr_sequencia
          from pfcs_indicator_rule r
          where r.cd_estabelecimento = cd_establishment_p
        );
        delete FROM pfcs_indicator_rule where cd_estabelecimento = cd_establishment_p;
        delete FROM pfcs_algorithm_settings where cd_estabelecimento = cd_establishment_p;
        delete FROM pfcs_chart_config where cd_estabelecimento = cd_establishment_p;
        commit;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_pck_db_utils.remove_establishment_settings (cd_establishment_p bigint) FROM PUBLIC;