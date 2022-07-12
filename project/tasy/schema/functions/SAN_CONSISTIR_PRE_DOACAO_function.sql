-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_consistir_pre_doacao ( nr_seq_tipo_doacao_p bigint, ie_tipo_coleta_p text) RETURNS varchar AS $body$
DECLARE


ie_consistir_w		varchar(1) := 'S';

BEGIN

if (nr_seq_tipo_doacao_p IS NOT NULL AND nr_seq_tipo_doacao_p::text <> '') and (ie_tipo_coleta_p IS NOT NULL AND ie_tipo_coleta_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_consistir_w
	from	san_regra_pre_doacao
	where	nr_seq_tipo_doacao = nr_seq_tipo_doacao_p
	and	ie_tipo_coleta = ie_tipo_coleta_p
	and	ie_situacao = 'A';

end if;

if (ie_consistir_w = 'N') then

	select	CASE WHEN count(*)=0 THEN  'S'  ELSE 'N' END
	into STRICT	ie_consistir_w
	from	san_regra_pre_doacao
	where	ie_situacao = 'A';

end if;



return	ie_consistir_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_consistir_pre_doacao ( nr_seq_tipo_doacao_p bigint, ie_tipo_coleta_p text) FROM PUBLIC;
