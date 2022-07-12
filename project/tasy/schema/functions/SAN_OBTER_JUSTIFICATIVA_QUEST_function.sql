-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_justificativa_quest ( nr_seq_doacao_p bigint, nr_seq_impedimento_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_justificativa_w	varchar(255);
ie_novo_questionario_w	varchar(1) := 'N';


BEGIN


IF (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') THEN

	Select 	max(ie_novo_questionario)
	into STRICT	ie_novo_questionario_w
	from 	san_parametro
	where 	cd_estabelecimento = cd_estabelecimento_p;


	if (ie_novo_questionario_w = 'N') then

		SELECT 	max(ds_justificativa)
		into STRICT	ds_justificativa_w
		FROM  	san_doacao_impedimento x
		WHERE 	x.nr_seq_doacao 	= nr_seq_doacao_p
		AND 	x.nr_seq_impedimento 	= nr_seq_impedimento_p;

		IF (coalesce(ds_justificativa_w::text, '') = '') THEN

			SELECT 	max(ds_justificativa)
			INTO STRICT	ds_justificativa_w
			FROM 	san_doacao_questionario x
			WHERE 	x.nr_seq_doacao 	 = nr_seq_doacao_p
			AND   	x.nr_seq_pergunta 	 = nr_seq_impedimento_p;
		END IF;
	else
		SELECT 	max(ds_justificativa)
		INTO STRICT	ds_justificativa_w
		FROM 	san_questionario x
		WHERE 	x.nr_seq_doacao 	 = nr_seq_doacao_p
		AND   	x.nr_seq_impedimento 	 = nr_seq_impedimento_p;
	end if;

END IF;

return	ds_justificativa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_justificativa_quest ( nr_seq_doacao_p bigint, nr_seq_impedimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
