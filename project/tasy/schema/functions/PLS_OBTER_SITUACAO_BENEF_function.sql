-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_situacao_benef (cd_pessoa_fisica_p text, cd_usuario_convenio_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(5):= 'A';
qt_regra_w	bigint;


BEGIN
ie_retorno_w:= 'A';

select 	count(*)
into STRICT	qt_regra_w
from 	pls_segurado_carteira b,
	pls_segurado a
where 	a.cd_pessoa_fisica = cd_pessoa_fisica_p
and 	b.nr_seq_segurado = a.nr_sequencia
and 	b.cd_usuario_plano = cd_usuario_convenio_p;
--and 	b.cd_estabelecimento = cd_estabelecimento_p;
if (qt_regra_w = 0) then

	ie_retorno_w:= 'ERRO';

elsif (qt_regra_w > 0) then

	select 	coalesce(max(a.ie_situacao_atend),'A')
	into STRICT	ie_retorno_w
	from 	pls_segurado_carteira b,
		pls_segurado a
	where 	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and 	b.nr_seq_segurado = a.nr_sequencia
	and 	b.cd_usuario_plano = cd_usuario_convenio_p;
	--and 	b.cd_estabelecimento = cd_estabelecimento_p;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_situacao_benef (cd_pessoa_fisica_p text, cd_usuario_convenio_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

