-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_peca_ativa ( nr_seq_peca_p bigint) RETURNS varchar AS $body$
DECLARE


ie_situacao_w	varchar(1);


BEGIN

if (nr_seq_peca_p IS NOT NULL AND nr_seq_peca_p::text <> '') then
	select coalesce(max(ie_situacao),'A')
	into STRICT   ie_situacao_w
	from prescr_proc_peca
	where nr_sequencia = nr_seq_peca_p;
end if;
return	ie_situacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_peca_ativa ( nr_seq_peca_p bigint) FROM PUBLIC;
