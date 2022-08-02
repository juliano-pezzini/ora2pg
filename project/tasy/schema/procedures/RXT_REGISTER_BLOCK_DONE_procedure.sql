-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_register_block_done ( nr_seq_rxt_tratamento_p rxt_tratamento.nr_sequencia%TYPE, nm_usuario_p rxt_tratamento.nm_usuario%TYPE ) AS $body$
BEGIN

IF (nr_seq_rxt_tratamento_p IS NOT NULL AND nr_seq_rxt_tratamento_p::text <> '') THEN
    UPDATE rxt_tratamento
    SET ie_bloco_concluido = 'S',
        nm_usuario = nm_usuario_p,
        dt_atualizacao = clock_timestamp()
    WHERE nr_sequencia = nr_seq_rxt_tratamento_p;

    COMMIT;

END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_register_block_done ( nr_seq_rxt_tratamento_p rxt_tratamento.nr_sequencia%TYPE, nm_usuario_p rxt_tratamento.nm_usuario%TYPE ) FROM PUBLIC;

