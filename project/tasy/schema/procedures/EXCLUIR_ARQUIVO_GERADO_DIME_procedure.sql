-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_arquivo_gerado_dime ( nr_sequencia_p text) AS $body$
BEGIN
                delete from
	w_dime_arquivo
	where nr_seq_controle_dime = nr_sequencia_p;

	delete  from
                fis_dime_controle
	where   nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_arquivo_gerado_dime ( nr_sequencia_p text) FROM PUBLIC;
