-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_delete_w_analise_selecao (nr_seq_analise_p w_pls_analise_selecao_item.nr_seq_analise%type, nm_usuario_p text) AS $body$
BEGIN
	delete 	from w_pls_analise_selecao_item
	where 	nm_usuario = nm_usuario_p
			and nr_seq_analise = nr_seq_analise_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_delete_w_analise_selecao (nr_seq_analise_p w_pls_analise_selecao_item.nr_seq_analise%type, nm_usuario_p text) FROM PUBLIC;
