-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_lib_rec_facial ( nr_seq_segurado_p bigint, nr_seq_usuario_web_p bigint, ie_tipo_liberacao_p text, ie_tipo_guia_p text, ie_funcao_liberada_p bigint, nr_seq_prestador_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Validar se existe regra de liberacao para reconhecimento facial.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ x ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_regra_lib_w	pls_regra_lib_req_web.nr_sequencia%type;	
nr_contrato_w		varchar(255);
dt_inicio_vigencia_w	varchar(255);
nr_seq_seg_carteira_w	pls_segurado_carteira.nr_sequencia%type;
dt_emissao_w		timestamp;
ie_data_valida_w	varchar(1);
nr_seq_congenere_w	pls_congenere.nr_sequencia%type;
nr_seq_intercambio_w	pls_intercambio.nr_sequencia%type;
nr_seq_plano_w		pls_plano.nr_sequencia%type;	
ie_tipo_segurado_w	pls_segurado.ie_tipo_segurado%type;
ie_preco_w		varchar(255);
ds_retorno_w		varchar(1)	:= 'N';


BEGIN

begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_seg_carteira_w
	from	pls_segurado_carteira
	where	nr_seq_segurado = nr_seq_segurado_p;
	
	select	dt_solicitacao
	into STRICT	dt_emissao_w
	from	pls_segurado_carteira
	where	nr_sequencia = nr_seq_seg_carteira_w
	and	ie_situacao  = 'P'
	and	(nr_seq_regra_via IS NOT NULL AND nr_seq_regra_via::text <> '');
	
	if (dt_emissao_w IS NOT NULL AND dt_emissao_w::text <> '') then
		ie_data_valida_w	:= 'S';
		dt_emissao_w		:= trunc(dt_emissao_w);
	end if;	
exception
when others then
	dt_emissao_w := null;
end;

begin
	select	nr_seq_congenere,
		nr_seq_intercambio,
		ie_tipo_segurado,
		pls_obter_dados_segurado(nr_sequencia, 'NC'),
		pls_obter_dados_segurado(nr_sequencia, 'IV'),
		(	select	ie_preco	
			from	pls_plano
			where	nr_sequencia	= nr_seq_plano)
	into STRICT	nr_seq_congenere_w,
		nr_seq_intercambio_w,		
		ie_tipo_segurado_w,
		nr_contrato_w,
		dt_inicio_vigencia_w,
		ie_preco_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	nr_seq_congenere_w	:= 0;
	nr_seq_intercambio_w	:= 0;
end;

if (ie_funcao_liberada_p IS NOT NULL AND ie_funcao_liberada_p::text <> '') then
	select 	max(nr_sequencia)
	into STRICT	nr_seq_regra_lib_w
	from	pls_regra_lib_req_web
	where 	ie_situacao					= 'A'
	and	ie_tipo_liberacao				= ie_tipo_liberacao_p
	and	((coalesce(nr_seq_segurado::text, '') = '')	or (nr_seq_segurado		= nr_seq_segurado_p))
	and	((coalesce(nr_seq_contrato::text, '') = '')	or (nr_seq_contrato		= nr_contrato_w))
	and	((coalesce(nr_seq_usuario_web::text, '') = '')	or (nr_seq_usuario_web		= nr_seq_usuario_web_p))
	and	((coalesce(ie_tipo_guia::text, '') = '') 	or (ie_tipo_guia 		= ie_tipo_guia_p))
	and	((coalesce(ie_funcao_liberada::text, '') = '') 	or (ie_funcao_liberada		= ie_funcao_liberada_p))
	and	((coalesce(nr_seq_congenere::text, '') = '')	or (nr_seq_congenere		= nr_seq_congenere_w))
	and	((coalesce(ie_preco::text, '') = '')	or (ie_preco			= ie_preco_w))
	and	((coalesce(dt_ant_emissao_carteira::text, '') = '')	or (dt_ant_emissao_carteira	>= to_date(dt_inicio_vigencia_w)))
	and	((coalesce(nr_seq_contrato_int::text, '') = '')	or (nr_seq_contrato_int		= nr_seq_intercambio_w))
	and	((coalesce(qt_dias_emissao::text, '') = '')	or ((ie_data_valida_w = 'S') and (coalesce(dt_emissao_w,clock_timestamp()) + qt_dias_emissao >= clock_timestamp())))
	and	clock_timestamp() between dt_inicio_vigencia 		and coalesce(dt_fim_vigencia,clock_timestamp())
	and	((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_w))
	and	((coalesce(nr_seq_prestador::text, '') = '')	or (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '' AND nr_seq_prestador = nr_seq_prestador_p));
	
	if (nr_seq_regra_lib_w IS NOT NULL AND nr_seq_regra_lib_w::text <> '') then
		ds_retorno_w :=	'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_lib_rec_facial ( nr_seq_segurado_p bigint, nr_seq_usuario_web_p bigint, ie_tipo_liberacao_p text, ie_tipo_guia_p text, ie_funcao_liberada_p bigint, nr_seq_prestador_p bigint) FROM PUBLIC;
