-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_consiste_idade_doador ( nr_sequencia_p bigint, cd_pessoa_fisica_p bigint, nr_seq_tipo_doacao_p bigint, ie_tipo_coleta_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'N';


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	FROM (
		SELECT  nr_sequencia
		FROM    san_regra_idade_doacao a
		where	a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
		and 	obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'A') between a.nr_idade_min and a.nr_idade_max
		AND     coalesce(a.nr_seq_tipo_doacao, nr_seq_tipo_doacao_p) = coalesce(nr_seq_tipo_doacao_p, a.nr_seq_tipo_doacao)
		AND     coalesce(a.ie_tipo_coleta, ie_tipo_coleta_p) = coalesce(ie_tipo_coleta_p, a.ie_tipo_coleta)
		and 	a.ie_situacao = 'A'
		ORDER BY a.nr_seq_tipo_doacao, a.ie_tipo_coleta
	) alias8 LIMIT 1;


end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_consiste_idade_doador ( nr_sequencia_p bigint, cd_pessoa_fisica_p bigint, nr_seq_tipo_doacao_p bigint, ie_tipo_coleta_p bigint) FROM PUBLIC;
