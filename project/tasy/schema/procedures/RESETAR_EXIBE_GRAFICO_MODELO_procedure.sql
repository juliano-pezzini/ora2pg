-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE resetar_exibe_grafico_modelo (nr_atendimento_p bigint, nr_seq_documento_p bigint) AS $body$
BEGIN
    CALL apap_dinamico_pck.resetar_exibe_grafico_modelo(nr_atendimento_p => nr_atendimento_p,
                                                   nr_seq_documento_p => nr_seq_documento_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE resetar_exibe_grafico_modelo (nr_atendimento_p bigint, nr_seq_documento_p bigint) FROM PUBLIC;
