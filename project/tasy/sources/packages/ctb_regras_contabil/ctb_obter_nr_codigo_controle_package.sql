-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ctb_regras_contabil.ctb_obter_nr_codigo_controle ( nr_sequencia_p CTB_MOVIMENTO.NR_SEQUENCIA%type ) RETURNS varchar AS $body$
DECLARE


    nr_codigo_controle_w    MOVIMENTO_CONTABIL_DOC.NR_CODIGO_CONTROLE%type;


BEGIN

        SELECT  MAX(b.NR_CODIGO_CONTROLE)
        INTO STRICT    nr_codigo_controle_w
        FROM    CTB_MOVIMENTO a,
                MOVIMENTO_CONTABIL b
        WHERE   a.NR_SEQUENCIA = b.NR_SEQ_CTB_MOVTO
        AND     a.NR_SEQUENCIA = nr_sequencia_p;

        RETURN nr_codigo_controle_w;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ctb_regras_contabil.ctb_obter_nr_codigo_controle ( nr_sequencia_p CTB_MOVIMENTO.NR_SEQUENCIA%type ) FROM PUBLIC;