-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_mala_dir_html5 ( nr_seq_registro_p bigint ) AS $body$
BEGIN

delete from pls_mala_direta where nr_sequencia = nr_seq_registro_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_mala_dir_html5 ( nr_seq_registro_p bigint ) FROM PUBLIC;

