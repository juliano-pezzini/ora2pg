-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_description_fugulin_suep (cd_chave_p text) RETURNS varchar AS $body$
DECLARE


vl_retorno_w	varchar(255);


BEGIN
	if (cd_chave_p IS NOT NULL AND cd_chave_p::text <> '') then
		select substr(obter_descricao_padrao('GCA_GRADACAO', 'DS_GRADACAO', NR_SEQ_GRADACAO),1,100)
		into STRICT vl_retorno_w
		from GCA_ATENDIMENTO
		where nr_sequencia = cd_chave_p;

	end if;

return vl_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_description_fugulin_suep (cd_chave_p text) FROM PUBLIC;

