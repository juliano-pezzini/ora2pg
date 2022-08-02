-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_segurado_nasc_plano ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, ie_nascido_plano_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


ie_isentar_carencia_nasc_w	pls_parametros.ie_isentar_carencia_nasc%type;
dt_nascimento_w			pessoa_fisica.dt_nascimento%type;
dt_contratacao_w		pls_segurado.dt_contratacao%type;
ie_nascido_plano_w		pls_segurado.ie_nascido_plano%type;
nr_seq_titular_w		pls_segurado.nr_sequencia%type;
dt_contratacao_titular_w	pls_segurado.dt_contratacao%type;
ie_segmentacao_plano_titular_w	pls_plano.ie_segmentacao%type;
ie_plano_obstetricia_w		varchar(1);


BEGIN

select	max(ie_isentar_carencia_nasc)
into STRICT	ie_isentar_carencia_nasc_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (coalesce(ie_isentar_carencia_nasc_w,'N') = 'N') then
	ie_nascido_plano_p	:= 'N';
elsif (coalesce(ie_isentar_carencia_nasc_w,'N') = 'S') then
	begin
	select	b.nr_seq_titular,
		a.dt_nascimento,
		b.dt_contratacao,
		b.ie_nascido_plano
	into STRICT	nr_seq_titular_w,
		dt_nascimento_w,
		dt_contratacao_w,
		ie_nascido_plano_w
	from	pls_segurado	b,
		pessoa_fisica	a
	where	b.cd_pessoa_fisica	= a.cd_pessoa_fisica
	and	b.nr_sequencia		= nr_seq_segurado_p;
	exception
	when others then
		ie_nascido_plano_p	:= 'N';
	end;

	select	max(a.dt_contratacao),
		max(b.ie_segmentacao)
	into STRICT	dt_contratacao_titular_w,
		ie_segmentacao_plano_titular_w
	from	pls_segurado a,
		pls_plano b
	where	b.nr_sequencia	= a.nr_seq_plano
	and	a.nr_sequencia	= nr_seq_titular_w;

	if (ie_segmentacao_plano_titular_w in ('2','5','6','9','11')) then
		ie_plano_obstetricia_w	:= 'S';
	else
		ie_plano_obstetricia_w	:= 'N';
	end if;

	if (ie_nascido_plano_w	= 'S') then
		ie_nascido_plano_p	:= 'S';
	elsif	((nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') and (dt_nascimento_w > dt_contratacao_titular_w) and
		(((dt_contratacao_w - dt_nascimento_w) <= 30)) and (ie_plano_obstetricia_w = 'S')) then
		ie_nascido_plano_p	:= 'S';
	else
		ie_nascido_plano_p	:= 'N';
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_segurado_nasc_plano ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, ie_nascido_plano_p INOUT text, nm_usuario_p text) FROM PUBLIC;

