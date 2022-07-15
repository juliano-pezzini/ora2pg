-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_conv_retorno_glosa ( nr_seq_ret_item_p bigint) AS $body$
BEGIN

delete FROM convenio_retorno_glosa
where nr_seq_ret_item = nr_seq_ret_item_p;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_conv_retorno_glosa ( nr_seq_ret_item_p bigint) FROM PUBLIC;

