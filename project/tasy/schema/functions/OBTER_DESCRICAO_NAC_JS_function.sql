-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_nac_js ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


cd_nacionalidade_w	varchar(8);


BEGIN

cd_nacionalidade_w	:= obter_nacionalidade_pf(cd_pessoa_fisica_p);

return	obter_desc_nacionalidade(cd_nacionalidade_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_nac_js ( cd_pessoa_fisica_p text) FROM PUBLIC;

