-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_hora_enteral_lib ( dt_referencia_p timestamp, nr_atendimento_p cpoe_dieta.nr_atendimento%type, nr_seq_dieta_p cpoe_dieta.nr_sequencia%type) AS $body$
BEGIN
null;
-- Migrated to br.com.wheb.action.AtePac_OEGWT.nutricao.draw.enteral
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_hora_enteral_lib ( dt_referencia_p timestamp, nr_atendimento_p cpoe_dieta.nr_atendimento%type, nr_seq_dieta_p cpoe_dieta.nr_sequencia%type) FROM PUBLIC;
