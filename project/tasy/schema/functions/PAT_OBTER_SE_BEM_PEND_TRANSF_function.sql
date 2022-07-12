-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_se_bem_pend_transf ( nr_seq_bem_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w				varchar(1)	:= 'N';
nr_seq_docto_transf_w			pat_doc_transferencia.nr_sequencia%type;


BEGIN

if (coalesce(nr_seq_bem_p,0) <> 0) then
	begin

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_docto_transf_w
	from	pat_doc_transferencia a,
		pat_transf_bem b,
		pat_tipo_historico c
	where	a.nr_sequencia	= b.nr_seq_doc_transf
	and	c.nr_sequencia	= a.nr_seq_tipo
	and	c.ie_transferencia	= 'S'
	and	b.nr_seq_bem	= nr_seq_bem_p
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	coalesce(a.dt_transferencia::text, '') = '';

	if (coalesce(nr_seq_docto_transf_w,0) <> 0) then
		ie_retorno_w	:= 'S';
	end if;
	end;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_se_bem_pend_transf ( nr_seq_bem_p bigint) FROM PUBLIC;
