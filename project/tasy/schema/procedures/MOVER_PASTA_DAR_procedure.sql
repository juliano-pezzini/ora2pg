-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mover_pasta_dar ( nr_seq_record_p tree_report_dar.nr_sequencia%TYPE, nr_seq_folder_p tree_report_dar.nr_sequencia%TYPE) AS $body$
BEGIN

	update
	tree_report_dar 
	set nr_seq_pai = nr_seq_folder_p 
	where nr_sequencia = nr_seq_record_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mover_pasta_dar ( nr_seq_record_p tree_report_dar.nr_sequencia%TYPE, nr_seq_folder_p tree_report_dar.nr_sequencia%TYPE) FROM PUBLIC;

