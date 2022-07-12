-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_ult_reaj_quota (nr_seq_reaj_quota_parc_p pls_reaj_quota_parc.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_retorno_w				varchar(255)	:= 'N';
nr_seq_quota_parc_w			pls_reaj_quota_parc.nr_seq_quota_parc%type;
nr_seq_reaj_quota_atual_w		pls_reaj_quota_parc.nr_seq_quota_parc%type;


BEGIN

-- obter a parcela do reajuste
select	max(nr_seq_quota_parc)
into STRICT	nr_seq_quota_parc_w
from	pls_reaj_quota_parc
where	nr_sequencia		= nr_seq_reaj_quota_parc_p;

-- obter o último reajuste desta parcela
select	max(nr_sequencia)
into STRICT	nr_seq_reaj_quota_atual_w
from	pls_reaj_quota_parc
where	nr_seq_quota_parc	= nr_seq_quota_parc_w;

-- verificar se o último reajuste é o reajuste passado como parâmetro
if (nr_seq_reaj_quota_atual_w = nr_seq_reaj_quota_parc_p) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_ult_reaj_quota (nr_seq_reaj_quota_parc_p pls_reaj_quota_parc.nr_sequencia%type) FROM PUBLIC;

