-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desconto_negociacao_rec ( nr_seq_negociacao_cr_p negociacao_cr.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type) RETURNS bigint AS $body$
DECLARE


pr_desconto_max_w	regra_desconto_neg_cr.pr_desconto_max%type;
vl_negociado_w		negociacao_cr.vl_negociado%type;


C01 CURSOR FOR
	SELECT	coalesce(a.pr_desconto_max,100) pr_desconto_max
	from	regra_desconto_neg_cr	a
	where	a.cd_estabelecimento = cd_estabelecimento_p
	and (a.cd_perfil = cd_perfil_p or coalesce(a.cd_perfil::text, '') = '')
	and (a.nm_usuario_liberacao = nm_usuario_p or coalesce(a.nm_usuario_liberacao::text, '') = '')
	and	vl_negociado_w between coalesce(a.vl_minimo,0) and coalesce(a.vl_maximo,vl_negociado_w)
	order by coalesce(a.nm_usuario_liberacao,' '),
		coalesce(a.cd_perfil,0);

BEGIN

pr_desconto_max_w	:= 100;

select	coalesce(max(a.vl_negociado),0)
into STRICT	vl_negociado_w
from	negociacao_cr		a
where	a.nr_sequencia	= nr_seq_negociacao_cr_p;

for vet_c01_w in c01 loop
	begin
	pr_desconto_max_w	:= vet_c01_w.pr_desconto_max;

	end;
end loop;

return	pr_desconto_max_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desconto_negociacao_rec ( nr_seq_negociacao_cr_p negociacao_cr.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

