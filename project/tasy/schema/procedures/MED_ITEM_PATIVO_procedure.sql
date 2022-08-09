-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_item_pativo ( nr_sequencia_item_p med_principio_ativo.nr_sequencia_item%type, ds_nome_p med_principio_ativo.ds_nome%type, ds_cas_p med_principio_ativo.ds_cas%type) AS $body$
BEGIN
	insert into med_principio_ativo(	nr_sequencia,
		nr_sequencia_item,
		ds_nome,
		ds_cas,
		dt_atualizacao,
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec 
	) 
	values (	nextval('med_principio_ativo_seq'),
		nr_sequencia_item_p,
		ds_nome_p,
		ds_cas_p,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario
	);
	
	commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_item_pativo ( nr_sequencia_item_p med_principio_ativo.nr_sequencia_item%type, ds_nome_p med_principio_ativo.ds_nome%type, ds_cas_p med_principio_ativo.ds_cas%type) FROM PUBLIC;
