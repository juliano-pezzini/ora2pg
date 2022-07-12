-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION same_consistir_pront_armazen ( cd_pessoa_fisica_p text, nr_prontuario_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_pront_cad_w	varchar(1) := 'N';


BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_pront_cad_w
	from	same_prontuario x
	where	x.cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	(((x.nr_atendimento	= nr_atendimento_p) and (coalesce(nr_prontuario_p::text, '') = '')) or (nr_prontuario_p IS NOT NULL AND nr_prontuario_p::text <> ''));

	if (ie_pront_cad_w = 'N') and (nr_prontuario_p IS NOT NULL AND nr_prontuario_p::text <> '') then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_pront_cad_w
		from	same_prontuario x
		where	obter_prontuario_pf(x.cd_estabelecimento, x.cd_pessoa_fisica) = nr_prontuario_p;
	end if;

	if (ie_pront_cad_w = 'N') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_pront_cad_w
		from	same_prontuario x
		where	x.nr_atendimento = nr_atendimento_p;
	end if;

end if;

return	ie_pront_cad_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION same_consistir_pront_armazen ( cd_pessoa_fisica_p text, nr_prontuario_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

