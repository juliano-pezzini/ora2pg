-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_dia_data_validade ( nr_seq_requisicao_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


qt_dias_retorno_w		bigint;
qt_dias_param_w			smallint;
ie_tipo_segurado_w		varchar(3);
ie_preco_w			varchar(3) := '1';
nr_seq_contrato_w		bigint;
nr_seq_contrato_intercambio_w	bigint;
nr_seq_congenere_w		bigint;
qt_dias_w			bigint;
nr_seq_segurado_w		bigint;
ie_tipo_guia_w			varchar(2);
ie_tipo_intercambio_w		varchar(2)	:= 'X';
ie_origem_solicitacao_w		varchar(2)	:= 'X';
ie_tipo_processo_w		varchar(2)	:= 'X';
ie_scs_w			varchar(2)	:= 'N';
ie_tipo_atendimento_w	varchar(2);
nr_seq_plano_w			pls_plano.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	qt_dias
	from (
		SELECT	qt_dias,
			ie_tipo_guia,
			ie_tipo_segurado,
			ie_preco,
			nr_seq_plano,
			nr_seq_grupo_produto
		from	pls_regra_validade_aut
		where	coalesce(ie_tipo_guia,ie_tipo_guia_w)				= ie_tipo_guia_w
		and	coalesce(ie_tipo_segurado,ie_tipo_segurado_w)			= ie_tipo_segurado_w
		and	coalesce(ie_preco,ie_preco_w)					= ie_preco_w
		and	coalesce(nr_seq_contrato,nr_seq_contrato_w)				= nr_seq_contrato_w
		and	coalesce(nr_seq_congenere,nr_seq_congenere_w)			= nr_seq_congenere_w
		and (coalesce(nr_seq_contrato_int::text, '') = ''	or nr_seq_contrato_int		= nr_seq_contrato_intercambio_w)
		and (coalesce(ie_origem_solicitacao::text, '') = ''	or ie_origem_solicitacao	= ie_origem_solicitacao_w)
		and (coalesce(nr_seq_grupo_contrato::text, '') = ''
		or	pls_se_grupo_preco_contrato(nr_seq_grupo_contrato, nr_seq_contrato_w, nr_seq_contrato_intercambio_w)	= 'S')
		and	ie_requisicao		= 'S'
		and	ie_situacao 		= 'A'
		and (coalesce(ie_tipo_atendimento::text, '') = ''	or ie_tipo_atendimento = ie_tipo_atendimento_w)
		and (coalesce(nr_seq_plano::text, '') = ''	or nr_seq_plano = nr_seq_plano_w)
		and (coalesce(nr_seq_grupo_produto::text, '') = '' or exists (	select	1
									from	pls_preco_produto x
									where	x.nr_seq_plano	= nr_seq_plano_w
									and	x.nr_seq_grupo	= nr_seq_grupo_produto))
		and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento and (pls_obter_se_controle_estab('RE') = 'S'))
		
union all

		select	qt_dias,
			ie_tipo_guia,
			ie_tipo_segurado,
			ie_preco,
			nr_seq_plano,
			nr_seq_grupo_produto
		from	pls_regra_validade_aut
		where	coalesce(ie_tipo_guia,ie_tipo_guia_w)				= ie_tipo_guia_w
		and	coalesce(ie_tipo_segurado,ie_tipo_segurado_w)			= ie_tipo_segurado_w
		and	coalesce(ie_preco,ie_preco_w)					= ie_preco_w
		and	coalesce(nr_seq_contrato,nr_seq_contrato_w)				= nr_seq_contrato_w
		and	coalesce(nr_seq_congenere,nr_seq_congenere_w)			= nr_seq_congenere_w
		and (coalesce(nr_seq_contrato_int::text, '') = ''	or nr_seq_contrato_int		= nr_seq_contrato_intercambio_w)
		and (coalesce(ie_origem_solicitacao::text, '') = ''	or ie_origem_solicitacao	= ie_origem_solicitacao_w)
		and (coalesce(nr_seq_grupo_contrato::text, '') = ''
		or	pls_se_grupo_preco_contrato(nr_seq_grupo_contrato, nr_seq_contrato_w, nr_seq_contrato_intercambio_w)	= 'S')
		and	ie_requisicao		= 'S'
		and	ie_situacao 		= 'A'
		and (coalesce(ie_tipo_atendimento::text, '') = ''	or ie_tipo_atendimento = ie_tipo_atendimento_w)
		and (coalesce(nr_seq_plano::text, '') = ''	or nr_seq_plano = nr_seq_plano_w)
		and (coalesce(nr_seq_grupo_produto::text, '') = '' or exists (	select	1
									from	pls_preco_produto x
									where	x.nr_seq_plano	= nr_seq_plano_w
									and	x.nr_seq_grupo	= nr_seq_grupo_produto))
		and (pls_obter_se_controle_estab('RE') = 'N')) alias43
	order by coalesce(ie_tipo_guia,0),
		coalesce(ie_tipo_segurado,0),
		coalesce(ie_preco,0),
		coalesce(nr_seq_plano,0),
		coalesce(nr_seq_grupo_produto,0);


BEGIN

begin
	select	ie_tipo_guia,
		nr_seq_segurado,
		ie_tipo_intercambio,
		ie_tipo_processo,
		ie_tipo_atendimento,
		nr_seq_plano
	into STRICT	ie_tipo_guia_w,
		nr_seq_segurado_w,
		ie_tipo_intercambio_w,
		ie_tipo_processo_w,
		ie_tipo_atendimento_w,
		nr_seq_plano_w
	from	pls_requisicao
	where	nr_sequencia = nr_seq_requisicao_p;
exception
when others then
	ie_tipo_guia_w		:= 'X';
	nr_seq_segurado_w	:= 0;
	ie_tipo_intercambio_w	:= 'X';
	ie_tipo_processo_w	:= 'X';
end;

if (coalesce(ie_tipo_processo_w,'X')	= 'I') and (coalesce(ie_tipo_intercambio_w,'X')	= 'E') then
	ie_scs_w	:= 'S';
end if;

qt_dias_param_w	:= obter_valor_param_usuario(1271, 6, Obter_Perfil_Ativo, nm_usuario_p, 0);

if (coalesce(qt_dias_param_w::text, '') = '') and (ie_scs_w	<> 'S') then
	qt_dias_param_w	:= coalesce((pls_obter_param_padrao_funcao(6, 1271))::numeric ,0);
elsif (ie_scs_w	= 'S') then
	qt_dias_param_w	:= 0;
end if;

if (qt_dias_param_w	<> 0) then
	qt_dias_retorno_w := qt_dias_param_w;
elsif (qt_dias_param_w	= 0) then
	begin
	select	b.ie_tipo_segurado,
		a.ie_preco,
		coalesce(b.nr_seq_contrato,0),
		coalesce(b.nr_seq_intercambio,0),
		coalesce(b.nr_seq_congenere,0)
	into STRICT	ie_tipo_segurado_w,
		ie_preco_w,
		nr_seq_contrato_w,
		nr_seq_contrato_intercambio_w,
		nr_seq_congenere_w
	from	pls_plano	a,
		pls_segurado	b
	where	b.nr_seq_plano	= a.nr_sequencia
	and	b.nr_sequencia 	= nr_seq_segurado_w;
	exception
	when others then
		ie_tipo_segurado_w 		:= 'X';
		ie_preco_w 			:= 'X';
		nr_seq_contrato_w		:= 0;
		nr_seq_contrato_intercambio_w	:= 0;
		nr_seq_congenere_w		:= 0;
	end;

	if (coalesce(ie_tipo_intercambio_w,'X')	= 'E') then
		ie_origem_solicitacao_w	:= 'AE';
	elsif (coalesce(ie_tipo_intercambio_w,'X')	<> 'E') then
		ie_origem_solicitacao_w	:= 'AI';
	end if;

	open C01;
	loop
	fetch C01 into
		qt_dias_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	qt_dias_retorno_w := qt_dias_w;
end if;

return	qt_dias_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_dia_data_validade ( nr_seq_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;

