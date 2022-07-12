-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_respondeu_questionario ( nr_seq_doacao_p bigint, nr_seq_impedimento_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'N';
ie_novo_questionario_w	varchar(1) := 'N';


BEGIN

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then

	Select 	max(ie_novo_questionario)
	into STRICT	ie_novo_questionario_w
	from 	san_parametro
	where 	cd_estabelecimento = cd_estabelecimento_p;


	if (ie_novo_questionario_w = 'N') then

		SELECT 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_retorno_w
		FROM  	san_doacao_impedimento x
		WHERE 	x.nr_seq_doacao 	= nr_seq_doacao_p
		AND 	x.nr_seq_impedimento 	= nr_seq_impedimento_p;

		if (ie_retorno_w = 'N') then

			SELECT	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_retorno_w
			FROM 	san_doacao_questionario x
			WHERE 	x.nr_seq_doacao 	 = nr_seq_doacao_p
			AND   	x.nr_seq_pergunta 	 = nr_seq_impedimento_p;
		end if;
	else
		SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_retorno_w
		FROM   	san_questionario
		WHERE  	nr_seq_impedimento = nr_seq_impedimento_p
		AND    	nr_seq_doacao 	  = nr_seq_doacao_p
		AND	(ie_resposta IS NOT NULL AND ie_resposta::text <> '');
	end if;

end if;


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_respondeu_questionario ( nr_seq_doacao_p bigint, nr_seq_impedimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

