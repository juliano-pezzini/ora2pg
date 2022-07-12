-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hmlb_verifica_impressao_csan59 ( cd_pessoa_p text, nr_seq_doacao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);
ie_permite_impressao_w	varchar(5);

BEGIN
ie_retorno_w := 'S';

ie_permite_impressao_w := Obter_param_Usuario(450, 405, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_permite_impressao_w);

if (cd_pessoa_p IS NOT NULL AND cd_pessoa_p::text <> '') and (ie_permite_impressao_w = 'N') then

	SELECT	COUNT(*)
	INTO STRICT	ie_retorno_w
	FROM	san_doacao a,
		san_exame_lote b,
		san_exame_realizado c
	WHERE	a.nr_sequencia = b.nr_seq_doacao
	AND	b.nr_sequencia = c.nr_seq_exame_lote
	AND	a.cd_pessoa_fisica = cd_pessoa_p
	AND	UPPER(coalesce(c.ds_resultado,c.vl_resultado)) = 'ANDAMENTO'
	AND	((a.nr_sequencia = nr_seq_doacao_p) or (nr_seq_doacao_p = 0));

	if (coalesce(ie_retorno_w,0) = 0) then
		ie_retorno_w := 'S';
	else
		ie_retorno_w := 'N';
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hmlb_verifica_impressao_csan59 ( cd_pessoa_p text, nr_seq_doacao_p bigint) FROM PUBLIC;

