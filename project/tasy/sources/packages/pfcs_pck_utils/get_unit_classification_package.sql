-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_unit_classification (nr_seq_location_p bigint) RETURNS varchar AS $body$
DECLARE

        cd_unit_classification_w setor_atendimento.cd_classif_setor%type;

BEGIN
        select (case   when sec.ie_semi_intensiva = PFCS_PCK_CONSTANTS.IE_YES_BR then PFCS_PCK_CONSTANTS.CD_TCU
                        else sec.cd_classif_setor end) cd_unit_classification
        into STRICT    cd_unit_classification_w
        from    unidade_atendimento uni,
                setor_atendimento sec
        where   uni.cd_setor_atendimento = sec.cd_setor_atendimento
        and     uni.nr_seq_location = nr_seq_location_p;

        return cd_unit_classification_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_unit_classification (nr_seq_location_p bigint) FROM PUBLIC;