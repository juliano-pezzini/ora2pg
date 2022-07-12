-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_assist_pck.set_regra_rastr_adep ( nr_seq_regra_p rastreabilidade_adep.nr_sequencia%type, nr_chave_rastr_p bigint, nr_prescricao_p bigint) AS $body$
BEGIN
    if (nr_seq_regra_p IS NOT NULL AND nr_seq_regra_p::text <> '') then
        PERFORM set_config('wheb_assist_pck.nr_seq_regra_rastr_adep_w', nr_seq_regra_p, false);
        PERFORM set_config('wheb_assist_pck.nr_chave_rastr_adep_w', nr_chave_rastr_p, false);
        PERFORM set_config('wheb_assist_pck.nr_prescr_rastr_adep_w', nr_prescricao_p, false);
    end if;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_assist_pck.set_regra_rastr_adep ( nr_seq_regra_p rastreabilidade_adep.nr_sequencia%type, nr_chave_rastr_p bigint, nr_prescricao_p bigint) FROM PUBLIC;
