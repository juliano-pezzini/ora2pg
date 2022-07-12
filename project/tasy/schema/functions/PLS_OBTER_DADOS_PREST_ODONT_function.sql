-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_prest_odont ( nr_seq_prestador_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter dados do prestador com relação a odontologia
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

IE_OPCAO_P
PO - Retorna se tem o tipo prestador odontológico

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_retorno_w	varchar(1) := 'N';


BEGIN

if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then
	if (ie_opcao_p = 'PO') then
		select	CASE WHEN count(*)=1 THEN 'S'  ELSE 'N' END
		into STRICT	ie_retorno_w
		from	pls_prestador a
		where	nr_sequencia	= nr_seq_prestador_p
		and	exists (	SELECT	1
				from	pls_tipo_prestador p
				where	p.nr_sequencia = a.nr_seq_tipo_prestador
				and	ie_odontologico  = 'S');
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_prest_odont ( nr_seq_prestador_p bigint, ie_opcao_p text) FROM PUBLIC;

