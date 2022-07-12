-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_notifica_titulo (nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_notific_w	bigint;
ie_permite_inclusao_w	varchar(1);
ie_incluir_notif_tit_w	varchar(1);


BEGIN

begin
select	max(b.nr_sequencia)
into STRICT	nr_seq_notific_w
from	titulo_receber_notif	b,
	titulo_receber		a
where	a.nr_titulo	= b.nr_titulo
and	a.nr_titulo	= nr_titulo_p;
exception
when others then
	nr_seq_notific_w := null;
end;

if (nr_seq_notific_w IS NOT NULL AND nr_seq_notific_w::text <> '') then
	select	coalesce(ie_permite_inclusao,'N')
	into STRICT	ie_permite_inclusao_w
	from	titulo_receber_notif
	where	nr_sequencia = nr_seq_notific_w;

	if (ie_permite_inclusao_w = 'N') then
		ie_incluir_notif_tit_w	:= 'N';
	else
		ie_incluir_notif_tit_w	:= 'S';
	end if;
else
	ie_incluir_notif_tit_w	:= 'S';
end if;

return	ie_incluir_notif_tit_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_notifica_titulo (nr_titulo_p bigint) FROM PUBLIC;
