-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_termo_benef (nr_seq_termo_p pls_termo_beneficiario.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

			
ds_tipo_termo_w		pls_termo_beneficiario.ds_tipo_termo%type;
			

BEGIN

select	ds_tipo_termo
into STRICT	ds_tipo_termo_w
from	pls_termo_beneficiario
where	nr_sequencia = nr_seq_termo_p;

return	ds_tipo_termo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_termo_benef (nr_seq_termo_p pls_termo_beneficiario.nr_sequencia%type) FROM PUBLIC;

