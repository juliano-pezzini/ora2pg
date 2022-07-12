-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_de_para_sup_integr ( ie_evento_p text, ie_forma_p text, nm_tabela_p text) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w			bigint;
ie_de_para_w			varchar(15);


BEGIN

select	coalesce(max(b.nr_sequencia),0)
into STRICT	nr_Sequencia_w
from	sup_parametro_integracao a,
	sup_integracao_tabela b
where	a.nr_sequencia = b.nr_seq_integracao
and	a.ie_evento = ie_evento_p
and	a.ie_forma = ie_forma_p
and	a.ie_situacao = 'A'
and	b.nm_tabela = nm_tabela_p;

if (nr_sequencia_w > 0) then
	select	ie_de_para
	into STRICT	ie_de_para_w
	from	sup_integracao_tabela
	where	nr_sequencia = nr_sequencia_w;
end if;

return	ie_de_para_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_de_para_sup_integr ( ie_evento_p text, ie_forma_p text, nm_tabela_p text) FROM PUBLIC;
