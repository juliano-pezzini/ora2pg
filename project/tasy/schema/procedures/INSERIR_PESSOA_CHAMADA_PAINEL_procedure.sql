-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pessoa_chamada_painel ( nr_seq_agenda_p bigint, cd_pessoa_contato_p text) AS $body$
BEGIN


if (nr_seq_agenda_p >  0) and (cd_pessoa_contato_p IS NOT NULL AND cd_pessoa_contato_p::text <> '') THEN
	UPDATE	agenda_paciente
	SET 	cd_pessoa_chamada_setor = cd_pessoa_contato_p
	WHERE 	nr_sequencia = nr_seq_agenda_p;

END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_pessoa_chamada_painel ( nr_seq_agenda_p bigint, cd_pessoa_contato_p text) FROM PUBLIC;

