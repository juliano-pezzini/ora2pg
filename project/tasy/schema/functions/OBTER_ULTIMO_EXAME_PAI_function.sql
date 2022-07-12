-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_exame_pai (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_resultado_w 		varchar(255);


BEGIN

IF (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') THEN

	SELECT	MAX(d.ds_resultado)
	INTO STRICT	ds_resultado_w
	FROM	san_transfusao b,
		san_exame_lote c,
		san_exame_realizado d,
		san_exame e
	WHERE	b.nr_sequencia		= c.nr_seq_transfusao
	AND	c.nr_sequencia		= d.nr_seq_exame_lote
	AND	d.nr_seq_exame		= e.nr_sequencia
	AND	e.ie_tipo_exame		= '2'
	AND	b.cd_pessoa_fisica	= cd_pessoa_fisica_p
	AND	b.nr_sequencia		= (	SELECT MAX(f.nr_sequencia)
						FROM   san_transfusao f
					        WHERE  f.cd_pessoa_fisica = cd_pessoa_fisica_p);

end if;


RETURN	ds_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_exame_pai (cd_pessoa_fisica_p text) FROM PUBLIC;
