-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW yearlies_v (dt_nascimento, ph_available, be_available, ph_less, apgar_10_less, establishment) AS SELECT
            dt_nascimento,
            CASE WHEN cd_arterial_ph IS NOT NULL OR cd_venous_ph IS NOT NULL THEN 1 ELSE 0 END ph_available,
            CASE WHEN cd_arterial_base_excess IS NOT NULL THEN 1 ELSE 0 END be_available,
            CASE WHEN cd_arterial_ph < 7 OR cd_venous_ph < 7 THEN 1 ELSE 0 END ph_less,
            CASE WHEN QT_APGAR_DECIMO_MIN < 5 THEN 1 ELSE 0 END apgar_10_less,
            obter_nome_estabelecimento(obter_estab_atend(nr_atendimento)) establishment
    FROM nascimento
    WHERE dt_inativacao IS NULL;

