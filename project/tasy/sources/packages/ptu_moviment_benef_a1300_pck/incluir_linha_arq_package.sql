-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_moviment_benef_a1300_pck.incluir_linha_arq ( tp_reg_p text, ds_conteudo_p text, arq_texto_p utl_file.file_type) AS $body$
DECLARE

	ds_linha_w	varchar(2000);
	
BEGIN
	
	PERFORM set_config('ptu_moviment_benef_a1300_pck.nr_sequencial_arq_w', current_setting('ptu_moviment_benef_a1300_pck.nr_sequencial_arq_w')::integer + 1, false);
	
	ds_linha_w	:= lpad(current_setting('ptu_moviment_benef_a1300_pck.nr_sequencial_arq_w')::integer,8,0) || tp_reg_p || ds_conteudo_p || chr(13);
	
	dbms_lob.append(current_setting('ptu_moviment_benef_a1300_pck.ds_arquivo_w')::text, ds_linha_w);
	
	utl_file.put_line(arq_texto_p, ds_linha_w);
	utl_file.fflush(arq_texto_p);
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benef_a1300_pck.incluir_linha_arq ( tp_reg_p text, ds_conteudo_p text, arq_texto_p utl_file.file_type) FROM PUBLIC;
