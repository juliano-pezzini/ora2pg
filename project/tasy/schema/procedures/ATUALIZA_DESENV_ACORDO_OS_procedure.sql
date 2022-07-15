-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_desenv_acordo_os ( nr_seq_acordo_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

update 	desenv_acordo_os
set 	nr_seq_acordo = nr_seq_acordo_p
where 	nr_sequencia = nr_sequencia_p;
commit;

CALL man_inserir_hist_ordem_acordo(nr_sequencia_p , nm_usuario_p, 'A');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_desenv_acordo_os ( nr_seq_acordo_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

