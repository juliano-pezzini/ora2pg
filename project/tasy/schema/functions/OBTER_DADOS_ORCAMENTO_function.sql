-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_orcamento ( nr_sequencia_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_tipo_atendimento_w	orcamento_paciente.ie_tipo_atendimento%type;
ie_tipo_anestesia_w	orcamento_paciente.ie_tipo_anestesia%type;


BEGIN

/*
1	 - Tipo de atendimento
2	- Tipo de anestesia
*/
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	coalesce(max(ie_tipo_atendimento),0),
		coalesce(max(ie_tipo_anestesia),'0')
	into STRICT	ie_tipo_atendimento_w,
		ie_tipo_anestesia_w
	from	orcamento_paciente
	where	nr_sequencia_orcamento = nr_sequencia_p;

	if (ie_opcao_p = 1) then
		ds_retorno_w := to_char(ie_tipo_atendimento_w);
	elsif (ie_opcao_p = 2) then
		ds_retorno_w := ie_tipo_anestesia_w;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_orcamento ( nr_sequencia_p bigint, ie_opcao_p bigint) FROM PUBLIC;

