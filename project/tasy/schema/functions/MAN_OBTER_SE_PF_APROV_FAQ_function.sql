-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_pf_aprov_faq ( nr_seq_faq_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


qt_com_faq_aprov_w	com_faq_aprov.nr_sequencia%type;


BEGIN

select	count(*)
into STRICT	qt_com_faq_aprov_w
from	com_faq_aprov a
where	a.cd_pessoa_aprovacao = cd_pessoa_fisica_p
and	nr_seq_faq = nr_seq_faq_p
and	coalesce(a.dt_aprovacao::text, '') = '';

if (qt_com_faq_aprov_w > 0) then
	return 'S';
end if;

return	'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_pf_aprov_faq ( nr_seq_faq_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

