-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_id_nota_principal (nr_seq_conta_p pls_conta.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(2);
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
nr_seq_conta_referencia_w	pls_conta.nr_seq_conta_referencia%type;
/*Identifica se a conta pode ser considera de referencia ou não*/

BEGIN

select	max(ie_tipo_guia),
	max(nr_seq_conta_referencia)
into STRICT	ie_tipo_guia_w,
	nr_seq_conta_referencia_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

if (ie_tipo_guia_w	= '3') then
	ie_retorno_w	:= 'S';
elsif (ie_tipo_guia_w	= '6') then
	ie_retorno_w	:= 'N';
else
	if (nr_seq_conta_referencia_w IS NOT NULL AND nr_seq_conta_referencia_w::text <> '') then
		ie_retorno_w	:= 'N';
	else
		ie_retorno_w	:= 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_id_nota_principal (nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;

