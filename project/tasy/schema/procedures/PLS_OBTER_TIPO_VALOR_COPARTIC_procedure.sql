-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_tipo_valor_copartic ( nr_seq_segurado_p pls_conta.nr_seq_segurado%type, dt_procedimento_p pls_conta_proc.dt_procedimento%type, nm_usuario_p text, ie_tipo_despesa_p pls_conta_proc.ie_tipo_despesa%type, ie_origem_conta_p pls_conta.ie_origem_conta%type, ie_glosa_p pls_conta.ie_glosa%type, ie_tipo_protocolo_p pls_protocolo_conta.ie_tipo_protocolo%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prest_exec_p pls_conta.nr_seq_prestador_exec%type, nr_seq_prest_solic_p pls_conta.nr_seq_prestador_solic_ref%type, nr_seq_clinica_p pls_clinica.nr_sequencia%type, ie_tipo_valor_p INOUT text, nr_seq_regra_p INOUT bigint, ie_multi_internacao_p INOUT pls_regra_preco_copartic.ie_multi_internacao%type) AS $body$
DECLARE


ie_tipo_valor_w		varchar(2)	:= 0;
ie_tipo_despesa_w	varchar(1);
nr_seq_regra_w		bigint	:= 0;
nr_seq_contrato_w	bigint;
ie_valido_w		varchar(2);
ie_multi_internacao_w	pls_regra_preco_copartic.ie_multi_internacao%type := 'N';
nr_seq_plano_w		pls_segurado.nr_seq_plano%type;

C01 CURSOR FOR
	SELECT	/* + USE_CONCAT */
		a.nr_sequencia,
		a.ie_tipo_valor,
		a.nr_seq_prestador,
		a.nr_seq_grupo_prestador,
		coalesce(a.ie_tipo_prestador,'A') ie_tipo_prestador, --Esse campo na verdade verifica se deve aplicar a regra quando prest exec for o mesmo que o solicitante ou não.
		coalesce(ie_multi_internacao,'N') ie_multi_internacao,
		nr_seq_grupo_produto
	from	pls_regra_preco_copartic	a
	where	a.ie_situacao	= 'A'
	and	((coalesce(a.nr_seq_contrato::text, '') = '') or (a.nr_seq_contrato = nr_seq_contrato_w))
	and	((coalesce(a.ie_tipo_despesa::text, '') = '') or (a.ie_tipo_despesa = ie_tipo_despesa_w))
	and	((coalesce(a.ie_origem_conta::text, '') = '') or (a.ie_origem_conta = ie_origem_conta_p))
	and	dt_procedimento_p between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,dt_procedimento_p)
	and	((coalesce(ie_item_glosado::text, '') = '')or ( ie_item_glosado = coalesce(ie_glosa_p,'N')))
	and	((coalesce(a.ie_tipo_protocolo::text, '') = '') or (a.ie_tipo_protocolo = ie_tipo_protocolo_p))
	and	((coalesce(a.nr_seq_clinica::text, '') = '') or (a.nr_seq_clinica = nr_seq_clinica_p))
	order by
		coalesce(a.nr_seq_prestador, 0),
		coalesce(a.nr_seq_grupo_prestador, 0),
		coalesce(a.ie_origem_conta,'0') desc,
		coalesce(a.ie_tipo_despesa,'0'),
		coalesce(a.nr_seq_contrato,0),
		coalesce(a.ie_item_glosado,'N'),
		coalesce(a.nr_seq_clinica,0),
		coalesce(a.nr_seq_grupo_produto,0);

BEGIN
ie_tipo_despesa_w	:= ie_tipo_despesa_p;

select	max(nr_seq_contrato),
	max(nr_seq_plano)
into STRICT	nr_seq_contrato_w,
	nr_seq_plano_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

for r_C01_w in C01() loop
	begin

		ie_valido_w := 'S';
		--Se prestador solicitante e executor deve ser o mesmo
		if (r_C01_w.ie_tipo_prestador = 'S') then
			--Se forem difetentes então a regra não é válida
			if ( nr_seq_prest_exec_p <> coalesce(nr_seq_prest_solic_p,-1)) then
				ie_valido_w := 'N';
			end if;
		--Se prestador solicitante e executor deve ser diferente(Somente verifica se ie_valido = S, ou seja, não falhou nas outras verificações)
		elsif (r_C01_w.ie_tipo_prestador = 'N' AND ie_valido_w = 'S')then
			--Se forem iguais, então a regra não é válida
			if ( nr_seq_prest_exec_p = coalesce(nr_seq_prest_solic_p,-1)) then
				ie_valido_w := 'N';
			end if;
		end if;

		--Se regra restringir por prestador executor(Somente verifica se ie_valido = S, ou seja, não falhou nas outras verificações)
		if	(r_C01_w.nr_seq_prestador IS NOT NULL AND r_C01_w.nr_seq_prestador::text <> '' AND ie_valido_w = 'S') then
			--Prestador executor apontado na regra diferente do prestador executor da conta
			if (r_C01_w.nr_seq_prestador <> nr_seq_prest_exec_p) then
				ie_valido_w := 'N';
			end if;
		end if;

		if ((r_c01_w.nr_seq_grupo_produto IS NOT NULL AND r_c01_w.nr_seq_grupo_produto::text <> '') and ie_valido_w	= 'S') then
			ie_valido_w := pls_se_grupo_preco_produto(r_c01_w.nr_seq_grupo_produto, nr_seq_plano_w);
		end if;
		--Se regra restringir por grupo de prestador(Somente verifica se ie_valido = S, ou seja, não falhou nas outras verificações)
		if	(r_C01_w.nr_seq_grupo_prestador IS NOT NULL AND r_C01_w.nr_seq_grupo_prestador::text <> '' AND ie_valido_w = 'S') then

			ie_valido_w := 	pls_obter_se_grupo_prestador(nr_seq_prest_exec_p ,r_C01_w.nr_seq_grupo_prestador);

		end if;

		if (ie_valido_w = 'S') then
			nr_seq_regra_w  := r_C01_w.nr_sequencia;
			ie_tipo_valor_w := r_C01_w.ie_tipo_valor;
			ie_multi_internacao_w := r_C01_w.ie_multi_internacao;
		end if;

	end;
end loop;

ie_tipo_valor_p	:= ie_tipo_valor_w;
nr_seq_regra_p	:= nr_seq_regra_w;
ie_multi_internacao_p := ie_multi_internacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_tipo_valor_copartic ( nr_seq_segurado_p pls_conta.nr_seq_segurado%type, dt_procedimento_p pls_conta_proc.dt_procedimento%type, nm_usuario_p text, ie_tipo_despesa_p pls_conta_proc.ie_tipo_despesa%type, ie_origem_conta_p pls_conta.ie_origem_conta%type, ie_glosa_p pls_conta.ie_glosa%type, ie_tipo_protocolo_p pls_protocolo_conta.ie_tipo_protocolo%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prest_exec_p pls_conta.nr_seq_prestador_exec%type, nr_seq_prest_solic_p pls_conta.nr_seq_prestador_solic_ref%type, nr_seq_clinica_p pls_clinica.nr_sequencia%type, ie_tipo_valor_p INOUT text, nr_seq_regra_p INOUT bigint, ie_multi_internacao_p INOUT pls_regra_preco_copartic.ie_multi_internacao%type) FROM PUBLIC;

