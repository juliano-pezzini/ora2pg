-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_terc (nr_seq_terceiro_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_terceiro_w		varchar(1);


BEGIN

ie_terceiro_w 	:= 'N';

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '' AND nr_seq_terceiro_p IS NOT NULL AND nr_seq_terceiro_p::text <> '')	then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_terceiro_w
	from	usuario a,
		terceiro b
	where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and	a.nm_usuario = nm_usuario_p
	and	b.nr_sequencia = nr_seq_terceiro_p;

	if (ie_terceiro_w = 'N')	Then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_terceiro_w
		from	terceiro_pessoa_fisica a,
			usuario b
		where	nr_seq_terceiro = nr_seq_terceiro_p
		and	b.nm_usuario = nm_usuario_p
		and	a.cd_pessoa_fisica = b.cd_pessoa_fisica;

	end if;

end if;


return ie_terceiro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_terc (nr_seq_terceiro_p bigint, nm_usuario_p text) FROM PUBLIC;

