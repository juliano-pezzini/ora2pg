-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_programacao_reajuste_pck.limpar_vetor_delete () AS $body$
BEGIN
indice_delete_w	:= 0;
tb_nr_seq_programacao_w.delete;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_programacao_reajuste_pck.limpar_vetor_delete () FROM PUBLIC;
