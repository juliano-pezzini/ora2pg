-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consulta_analise_pos_pck.set_nr_seq_item (nr_seq_item_p bigint) AS $body$
BEGIN
		PERFORM set_config('pls_consulta_analise_pos_pck.nr_seq_item_w', nr_seq_item_p, false);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consulta_analise_pos_pck.set_nr_seq_item (nr_seq_item_p bigint) FROM PUBLIC;
