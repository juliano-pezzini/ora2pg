-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION reg_get_functions_pr ( nr_seq_product_req_p reg_product_requirement.nr_sequencia%TYPE ) RETURNS varchar AS $body$
DECLARE


c_product_requirements CURSOR(nr_product_p reg_product_requirement.nr_sequencia%TYPE) FOR
	SELECT	f.ds_funcao
	FROM	reg_funcao_pr rf,
		funcao f
	WHERE	f.cd_funcao = rf.cd_funcao
	AND	rf.ie_escopo_teste = 'S'
	AND	rf.nr_seq_product_req = nr_product_p;

ds_functions_w 	varchar(1000);

BEGIN
	FOR product_req IN c_product_requirements(nr_seq_product_req_p)
	LOOP
		ds_functions_w := ds_functions_w||product_req.ds_funcao||', ';
	END LOOP;
	
	ds_functions_w := Substr(ds_functions_w, 1, Length(ds_functions_w)-2);
	
	RETURN ds_functions_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION reg_get_functions_pr ( nr_seq_product_req_p reg_product_requirement.nr_sequencia%TYPE ) FROM PUBLIC;

