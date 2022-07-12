-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_beneficiario ( cd_usuario_plano_p text, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint;
ds_parametro_w		varchar(2);

BEGIN
ds_parametro_w := obter_valor_param_usuario(1204, 43, Obter_Perfil_Ativo, nm_usuario_p, 0);

if (ds_parametro_w = 'S') then
	select	max(a.nr_sequencia)
	into STRICT	nr_retorno_w
	from	pls_segurado a,
		pls_segurado_carteira b
	where	a.nr_sequencia		= b.nr_seq_segurado
	and	b.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_usuario_plano	= cd_usuario_plano_p;

	if (coalesce(nr_retorno_w::text, '') = '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_retorno_w
		from	pls_segurado a,
			pls_segurado_carteira b
		where	a.nr_sequencia		= b.nr_seq_segurado
		and	b.cd_estabelecimento	= cd_estabelecimento_p
		and	b.nr_cartao_intercambio	= cd_usuario_plano_p;
	end if;

elsif (ds_parametro_w = 'N') then
	select	max(a.nr_sequencia)
	into STRICT	nr_retorno_w
	from	pls_segurado a,
		pls_segurado_carteira b
	where	a.nr_sequencia		= b.nr_seq_segurado
	and	b.cd_usuario_plano	= cd_usuario_plano_p;

	if (coalesce(nr_retorno_w::text, '') = '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_retorno_w
		from	pls_segurado a,
			pls_segurado_carteira b
		where	a.nr_sequencia		= b.nr_seq_segurado
		and	b.nr_cartao_intercambio	= cd_usuario_plano_p;
	end if;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_beneficiario ( cd_usuario_plano_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

