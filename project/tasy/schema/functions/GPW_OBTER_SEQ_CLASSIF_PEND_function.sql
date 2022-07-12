-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpw_obter_seq_classif_pend ( ie_classificacao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_classif_w		bigint;


BEGIN

if (coalesce(ie_classificacao_p,'0') <> '0') then
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_classif_w
	from	gpw_classificacao
	where	ie_classificacao = ie_classificacao_p
	and	ie_situacao = 'A';
	end;
end if;

return	nr_seq_classif_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpw_obter_seq_classif_pend ( ie_classificacao_p text) FROM PUBLIC;

