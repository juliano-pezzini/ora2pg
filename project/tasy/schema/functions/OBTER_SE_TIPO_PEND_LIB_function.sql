-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tipo_pend_lib (cd_estabelecimento_p bigint, nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(1):= 'N';


BEGIN

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (nr_seq_tipo_p IS NOT NULL AND nr_seq_tipo_p::text <> '') then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_liberado_w
	from	cta_tipo_pend x
	where	1=1
	and	x.nr_sequencia = nr_seq_tipo_p
	and	nr_seq_classif in (SELECT nr_sequencia from cta_classif_pend x where ((coalesce(x.cd_estabelecimento::text, '') = '') or (x.cd_estabelecimento = cd_estabelecimento_p)));
end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tipo_pend_lib (cd_estabelecimento_p bigint, nr_seq_tipo_p bigint) FROM PUBLIC;

