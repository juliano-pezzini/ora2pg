-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_store_data_mens_pck.set_nr_seq_intercambio (nr_seq_intercambio_p pls_segurado.nr_seq_intercambio%type) AS $body$
BEGIN
		current_setting('pls_store_data_mens_pck.segurado_w')::pls_segurado%rowtype.nr_seq_intercambio	:= nr_seq_intercambio_p;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_store_data_mens_pck.set_nr_seq_intercambio (nr_seq_intercambio_p pls_segurado.nr_seq_intercambio%type) FROM PUBLIC;
