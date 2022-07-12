-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function kodip_pck.generate_case_consist() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE kodip_pck.generate_case_consist ( nr_seq_episodio_p episodio_paciente_consist.nr_seq_episodio%type, ds_titulo_p episodio_paciente_consist.ds_titulo%type, ds_conteudo_p episodio_paciente_consist.ds_conteudo%type, ie_tipo_p episodio_paciente_consist.ie_tipo%type, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL kodip_pck.generate_case_consist_atx ( ' || quote_nullable(nr_seq_episodio_p) || ',' || quote_nullable(ds_titulo_p) || ',' || quote_nullable(ds_conteudo_p) || ',' || quote_nullable(ie_tipo_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE kodip_pck.generate_case_consist_atx ( nr_seq_episodio_p episodio_paciente_consist.nr_seq_episodio%type, ds_titulo_p episodio_paciente_consist.ds_titulo%type, ds_conteudo_p episodio_paciente_consist.ds_conteudo%type, ie_tipo_p episodio_paciente_consist.ie_tipo%type, nm_usuario_p text) AS $body$
BEGIN
insert into episodio_paciente_consist(
	nr_sequencia,
	dt_atualizacao,        
	nm_usuario,
	dt_atualizacao_nrec,           
	nm_usuario_nrec,   
	nr_seq_episodio,     
	ds_titulo,  
	ds_conteudo, 
	ie_tipo)
values (	nextval('episodio_paciente_consist_seq'),
	clock_timestamp(),
	coalesce(obter_usuario_ativo,'TASY'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_episodio_p,
	ds_titulo_p,
	ds_conteudo_p,
	ie_tipo_p);
	
commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE kodip_pck.generate_case_consist ( nr_seq_episodio_p episodio_paciente_consist.nr_seq_episodio%type, ds_titulo_p episodio_paciente_consist.ds_titulo%type, ds_conteudo_p episodio_paciente_consist.ds_conteudo%type, ie_tipo_p episodio_paciente_consist.ie_tipo%type, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE kodip_pck.generate_case_consist_atx ( nr_seq_episodio_p episodio_paciente_consist.nr_seq_episodio%type, ds_titulo_p episodio_paciente_consist.ds_titulo%type, ds_conteudo_p episodio_paciente_consist.ds_conteudo%type, ie_tipo_p episodio_paciente_consist.ie_tipo%type, nm_usuario_p text) FROM PUBLIC;
