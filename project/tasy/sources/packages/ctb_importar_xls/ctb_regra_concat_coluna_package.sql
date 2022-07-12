-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_importar_xls.ctb_regra_concat_coluna ( nr_seq_regra_imp_planilha_p ctb_regra_conv_coluna.nr_seq_regra_imp_planilha%type, ds_coluna_origem_p INOUT ctb_regra_conv_coluna.ds_coluna_origem%type, cd_coluna_philips_p INOUT ctb_regra_conv_coluna.cd_coluna_philips%type ) AS $body$
BEGIN
		SELECT UPPER(ds_coluna_origem), UPPER(cd_coluna_philips)
		INTO STRICT ds_coluna_origem_p, cd_coluna_philips_p
		FROM ctb_regra_conv_coluna
		WHERE 
			nr_seq_regra_imp_planilha = nr_seq_regra_imp_planilha_p 
			AND ds_coluna_origem LIKE '%;%'
			AND UPPER(ds_coluna_origem) LIKE UPPER('%'||ds_coluna_origem_p||'%')	
			AND ie_situacao = 'A';
			
	EXCEPTION	
		WHEN no_data_found THEN
			ds_coluna_origem_p 	:= '';
			cd_coluna_philips_p := '';		
	END;
		

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_importar_xls.ctb_regra_concat_coluna ( nr_seq_regra_imp_planilha_p ctb_regra_conv_coluna.nr_seq_regra_imp_planilha%type, ds_coluna_origem_p INOUT ctb_regra_conv_coluna.ds_coluna_origem%type, cd_coluna_philips_p INOUT ctb_regra_conv_coluna.cd_coluna_philips%type ) FROM PUBLIC;
