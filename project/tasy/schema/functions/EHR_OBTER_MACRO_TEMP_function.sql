-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ehr_obter_macro_temp ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_template_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_sequencia_w		bigint;
ie_macro_w		varchar(30);
ds_retorno_w		varchar(4000);
ds_resultado_w		varchar(4000) := '';

C01 CURSOR FOR 
	SELECT	b.nr_sequencia, 
		b.ie_macro 
	from	ehr_template_conteudo b, 
		ehr_template a 
	where	a.nr_sequencia	= nr_seq_template_p 
	and	a.nr_sequencia	= b.nr_seq_template 
	and	(b.ie_macro IS NOT NULL AND b.ie_macro::text <> '');
	
 

BEGIN 
 
open	c01;
loop 
fetch	c01 into 
	nr_sequencia_w, 
	ie_macro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	ds_resultado_w	:= ehr_obter_valor_macro(cd_pessoa_fisica_p,nr_atendimento_p,ie_macro_w);
 
	ds_retorno_w := substr(ds_retorno_w || to_char(nr_sequencia_w) ||'='|| to_char(ds_resultado_w) ||'#@#@',1,4000);
 
	end;
end	loop;
close	c01;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ehr_obter_macro_temp ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_template_p bigint) FROM PUBLIC;

