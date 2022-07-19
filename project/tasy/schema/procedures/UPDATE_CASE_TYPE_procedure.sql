-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_case_type ( nr_sequencia_p episodio_paciente.nr_sequencia%type, nr_seq_tipo_episodio_p episodio_paciente.nr_seq_tipo_episodio%type) AS $body$
BEGIN

	update 	episodio_paciente
	set 	nr_seq_tipo_episodio = nr_seq_tipo_episodio_p
	where 	nr_sequencia = nr_sequencia_p;
	
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_case_type ( nr_sequencia_p episodio_paciente.nr_sequencia%type, nr_seq_tipo_episodio_p episodio_paciente.nr_seq_tipo_episodio%type) FROM PUBLIC;

