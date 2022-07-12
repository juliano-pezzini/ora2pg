-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_inconsist_rec ( nr_seq_inconsistencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	varchar(255);


BEGIN

if (ie_opcao_p = 'CD') then
	select	cd_inconsistencia
	into STRICT	ds_retorno_w
	from	pls_inconsist_cancel_rec
	where	nr_sequencia	= nr_seq_inconsistencia_p;
elsif (ie_opcao_p = 'DS') then
	select	ds_inconsistencia
	into STRICT	ds_retorno_w
	from	pls_inconsist_cancel_rec
	where	nr_sequencia	= nr_seq_inconsistencia_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_inconsist_rec ( nr_seq_inconsistencia_p bigint, ie_opcao_p text) FROM PUBLIC;
