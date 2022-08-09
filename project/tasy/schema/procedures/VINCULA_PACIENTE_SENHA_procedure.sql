-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincula_paciente_senha ( nr_seq_senha_p bigint, cd_pessoa_fisica_P bigint) AS $body$
BEGIN

update	PACIENTE_SENHA_FILA
set		cd_pessoa_fisica = cd_pessoa_fisica_p
where	nr_sequencia = nr_seq_senha_p;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincula_paciente_senha ( nr_seq_senha_p bigint, cd_pessoa_fisica_P bigint) FROM PUBLIC;
