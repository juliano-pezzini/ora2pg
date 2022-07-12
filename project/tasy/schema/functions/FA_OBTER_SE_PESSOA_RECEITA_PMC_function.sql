-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_se_pessoa_receita_pmc (cd_pessoa_fisica_p text, nr_receita_p text) RETURNS varchar AS $body$
DECLARE


cd_pessoa_w	varchar(10);
ie_achou_pf	varchar(1);

c01 CURSOR FOR
	SELECT	CD_PESSOA_FISICA
	FROM	FA_RECEITA_FARMACIA
	WHERE	NR_RECEITA = NR_RECEITA_P;


BEGIN
ie_achou_pf := 'N';
Open 	c01;
Loop
Fetch 	c01 into
	cd_pessoa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	If (cd_pessoa_w = cd_pessoa_fisica_p)
	And (ie_achou_pf <> 'S') then
		 ie_achou_pf := 'S';
	End if;
End loop;
Close c01;

Return	ie_achou_pf;

End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_se_pessoa_receita_pmc (cd_pessoa_fisica_p text, nr_receita_p text) FROM PUBLIC;

