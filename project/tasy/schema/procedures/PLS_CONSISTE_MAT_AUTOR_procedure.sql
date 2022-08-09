-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consiste_mat_autor ( nr_seq_conta_p bigint, nr_seq_conta_mat_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_prestador_p bigint, ie_consiste_guia_p INOUT text, ie_existe_regra_p INOUT text, nr_seq_regra_p INOUT pls_regra_autorizacao.nr_sequencia%type) AS $body$
DECLARE


ie_tipo_guia_w			varchar(2);
cd_guia_referencia_w		varchar(20);
nr_seq_material_w		bigint;
nr_seq_estrut_mat_w		bigint;
ie_liberado_w			varchar(1);
ie_liberado_ww			varchar(1);
ie_existe_regra_w		varchar(1);
ie_grupo_contrato_w		varchar(1);	
ie_estrut_mat_w			varchar(1);

nr_seq_tipo_atendimento_w	bigint;
nr_seq_grupo_contrato_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_contrato_intercambio_w	bigint;
nr_seq_estrut_regra_w		bigint;
dt_atendimento_w		timestamp;
nr_seq_protocolo_w		numeric(30);
nr_seq_prest_prot_w		numeric(30);
nr_seq_prestador_prot_w		numeric(30);
nr_seq_prestador_imp_w		numeric(30);
nr_seq_congenere_protocolo_w	numeric(30);
ie_tipo_conta_w			varchar(2);
cd_cgc_cooperativa_w		varchar(30);
nr_seq_congenere_w		numeric(30);

sg_estado_w			pessoa_juridica.sg_estado%type;
sg_estado_operadora_w		pessoa_juridica.sg_estado%type;	
ie_tipo_intercambio_w		varchar(1) := 'A';

ie_tipo_congenere_w		varchar(1) := 'A';
cd_cgc_congenere_w		varchar(14);
sg_estado_congenere_w		pessoa_juridica.sg_estado%type;
ie_tipo_segurado_w		varchar(3);
ie_restricao_intercambio_w	varchar(1);
ie_exige_autorizacao_w		varchar(10);
nr_seq_grupo_produto_w		bigint;
ie_grupo_produto_w		varchar(1);
nr_seq_plano_w			bigint;
nr_seq_cbo_conta_w		bigint;
nr_sequencia_w                  bigint;
cd_especialidade_w		especialidade_medica.cd_especialidade%type;
cd_cooperativa_w		pls_conta.cd_cooperativa%type;
nr_seq_guia_w			pls_conta.nr_seq_guia%type;
nr_seq_regra_w			pls_regra_autorizacao.nr_sequencia%type;
ie_carater_internacao_w		pls_regra_autorizacao.ie_carater_internacao%type;
ie_excecao_w			varchar(2);
ie_preco_w			pls_plano.ie_preco%type;
ie_regime_atendimento_w		pls_conta.ie_regime_atendimento%type;
ie_saude_ocupacional_w		pls_conta.ie_saude_ocupacional%type;

-- feito esta tratativa com dois cursores devido a performance.

-- e mais facil identificar primeiro as regras para o material e as gerais e depois aplicar os demais itens da regra no cursor 2
c01 CURSOR FOR	
	SELECT 	nr_sequencia nr_seq_regra,
		nr_seq_estrut_mat,
		nr_seq_material,
		ie_tipo_segurado
	from	pls_regra_autorizacao
	where	nr_seq_material = nr_seq_material_w
	
union all

	SELECT 	nr_sequencia nr_seq_regra,
		nr_seq_estrut_mat,
		nr_seq_material,
		ie_tipo_segurado
	from	pls_regra_autorizacao
	where	coalesce(nr_seq_material, 1) = 1
	and	coalesce(cd_procedimento, 1) = 1
	and 	coalesce(cd_area_procedimento, 1) = 1
	and	coalesce(cd_especialidade, 1) = 1
	and	coalesce(cd_grupo_proc, 1) = 1
	and 	coalesce(nr_seq_grupo_servico, 1) = 1
	order by
		nr_seq_material,
		nr_seq_estrut_mat,
		ie_tipo_segurado;

c02 CURSOR FOR	
	SELECT 	ie_liberado,
		nr_seq_material,
		ie_tipo_segurado,
		nr_seq_grupo_contrato,
		nr_seq_estrut_mat,
		nr_seq_grupo_produto,
                nr_sequencia
	from	pls_regra_autorizacao
	where	nr_sequencia = nr_seq_regra_w
	and 	cd_estabelecimento = cd_estabelecimento_p
	and	ie_situacao = 'A'
	and	((coalesce(nr_seq_prestador::text, '') = '') or (nr_seq_prestador = nr_seq_prestador_p))
	and	((coalesce(nr_seq_tipo_atendimento::text, '') = '') or (nr_seq_tipo_atendimento = nr_seq_tipo_atendimento_w))
	and	((coalesce(ie_regime_atendimento::text, '') = '') 	or ( ie_regime_atendimento = ie_regime_atendimento_w))
	and	((coalesce(ie_saude_ocupacional::text, '') = '') 	or ( ie_saude_ocupacional = ie_saude_ocupacional_w))
	and	((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_w))
	and	((ie_restricao_intercambio = 'A') or (coalesce(ie_restricao_intercambio::text, '') = '') or (ie_restricao_intercambio = ie_restricao_intercambio_w))	
	and	((((ie_tipo_intercambio	= 'A') or (coalesce(ie_tipo_intercambio::text, '') = '')) or (ie_tipo_intercambio = ie_tipo_intercambio_w))
	or (ie_restricao_intercambio = 'N'))
	and	(((ie_tipo_congenere = 'A') or (coalesce(ie_tipo_congenere::text, '') = '')) or (ie_tipo_congenere = ie_tipo_congenere_w))
	and	((coalesce(ie_guia_valida::text, '') = '') or (ie_guia_valida = 'N'))
	and	dt_atendimento_w between coalesce(dt_inicio_vigencia,dt_atendimento_w - 1) and coalesce(dt_fim_vigencia,dt_atendimento_w + 1)
	and	((coalesce(cd_especialidade_medica::text, '') = '') or (cd_especialidade_medica = cd_especialidade_w))
	and	((coalesce(ie_carater_internacao::text, '') = '') or (ie_carater_internacao = ie_carater_internacao_w))
	and	((coalesce(ie_preco::text, '') = '') or (ie_preco = ie_preco_w));

BEGIN

ie_liberado_w 		:= 'N';
ie_existe_regra_w	:= 'N';

select 	ie_tipo_guia,
	cd_guia_referencia,
	nr_seq_tipo_atendimento,
	nr_seq_segurado,
	nr_seq_protocolo,
	nr_Seq_prestador,
	nr_Seq_congenere,
	ie_tipo_conta,
	nr_seq_cbo_saude,
	cd_cooperativa,
	ie_tipo_segurado,
	ie_regime_atendimento,
	ie_saude_ocupacional
into STRICT	ie_tipo_guia_w,
	cd_guia_referencia_w,
	nr_seq_tipo_atendimento_w,
	nr_seq_segurado_w,
	nr_seq_protocolo_w,
	nr_seq_prestador_prot_w,
	nr_Seq_congenere_w,
	ie_tipo_conta_w,
	nr_seq_cbo_conta_w,
	cd_cooperativa_w,
	ie_tipo_segurado_w,
	ie_regime_atendimento_w,
	ie_saude_ocupacional_w	
from 	pls_conta
where 	nr_sequencia = nr_seq_conta_p;

ie_tipo_conta_w := coalesce(ie_tipo_conta_w,'X');

begin
select	a.nr_sequencia,
	a.nr_seq_estrut_mat,
	coalesce(b.dt_atendimento,clock_timestamp()),
	coalesce(ie_exige_autorizacao,'N')
into STRICT	nr_seq_material_w,
	nr_seq_estrut_mat_w,
	dt_atendimento_w,
	ie_exige_autorizacao_w
from	pls_conta_mat b,
	pls_material a
where	a.nr_sequencia	= b.nr_seq_material
and	b.nr_sequencia	= nr_seq_conta_mat_p;
exception
when others then
	nr_seq_material_w	:= null;
	nr_seq_estrut_mat_w	:= null;
	dt_atendimento_w	:= clock_timestamp();
	ie_exige_autorizacao_w	:= null;
end;

begin /* Obter dados do protocolo */
select	nr_seq_prestador,
	nr_seq_congenere,
	nr_seq_prestador_imp
into STRICT	nr_seq_prest_prot_w,
	nr_seq_congenere_protocolo_w,
	nr_seq_prestador_imp_w
from	pls_protocolo_conta
where	nr_sequencia	= nr_seq_protocolo_w;
exception
when others then
	nr_seq_prest_prot_w :=0;
	nr_seq_prestador_imp_w := null;
end;

/*Obtendo  dados  segurado*/

select	max(nr_seq_contrato),
	max(nr_seq_intercambio),
	max(nr_seq_plano)
into STRICT	nr_seq_contrato_w,
	nr_seq_contrato_intercambio_w,
	nr_seq_plano_w
from	pls_segurado
where	nr_sequencia = nr_seq_segurado_w;

select	max(ie_preco)
into STRICT	ie_preco_w
from	pls_plano
where	nr_sequencia = nr_seq_plano_w;

select	coalesce(max(sg_estado),'X') /* Obter a UF da operadora  - Tasy */
into STRICT	sg_estado_w
from	pessoa_juridica
where	cd_cgc	=	(SELECT	max(cd_cgc_outorgante)
			from	pls_outorgante
			where	cd_estabelecimento	= cd_estabelecimento_p );

if (ie_tipo_conta_w = 'I')	then
	select	max(sg_estado) /* Obter estado da operadora congenere */
	into STRICT	sg_estado_operadora_w
	from	pls_congenere	a,
		pessoa_juridica	b
	where	b.cd_cgc	= a.cd_cgc
	and	a.nr_sequencia	= nr_seq_congenere_protocolo_w;
elsif (ie_tipo_conta_w = 'C')	then
	select 	max(cd_cgc)
	into STRICT	cd_cgc_cooperativa_w
	from 	pls_congenere
	where 	cd_cooperativa =	cd_cooperativa_w;

	select	max(sg_estado)
	into STRICT	sg_estado_operadora_w
	from	pessoa_juridica
	where	cd_cgc	= cd_cgc_cooperativa_w;
end if;

if ( coalesce(sg_estado_w,'X') <> 'X') and (coalesce(sg_estado_operadora_w,'X') <> 'X') then /* Verifica o estado da congenere e da outorgante e o mesmo, se nao for o mesmo entao e intercambio nacional */
	if ( sg_estado_w	= sg_estado_operadora_w ) then
		ie_tipo_intercambio_w	:= 'E'; --ESTADUAL
	else
		ie_tipo_intercambio_w	:= 'N'; -- NACIONAL
	end if;
else
	ie_tipo_intercambio_w	:= 'A';
end if;

if (ie_tipo_conta_w in ('I', 'C')) then
	ie_restricao_intercambio_w	:= 'I';
else
	ie_restricao_intercambio_w	:= 'N';
end if;

-- jjung OS 490482 - Obter o estado da operadora congenere  do segurado.				
select	max(cd_cgc)	
into STRICT	cd_cgc_congenere_w
from	pls_congenere
where	nr_sequencia = (	SELECT	max(a.nr_seq_ops_congenere)
				from	pls_segurado	a,
					pls_conta	b
				where	a.nr_sequencia = b.nr_seq_segurado
				and	b.nr_sequencia = nr_seq_conta_p
			);
select	max(sg_estado)
into STRICT	sg_estado_congenere_w
from	pessoa_juridica
where	cd_cgc = cd_cgc_congenere_w;

-- jjung OS 490482 - Verificar a abragencia da congenere do beneficiario.
if ( sg_estado_w <> 'X') and (coalesce(sg_estado_congenere_w,'X') <> 'X') then
	if ( sg_estado_w	= sg_estado_congenere_w ) then
		ie_tipo_congenere_w	:= 'E'; --ESTADUAL
	else
		ie_tipo_congenere_w	:= 'N'; -- NACIONAL
	end if;
else
	ie_tipo_congenere_w	:= 'A';--AMBOS/Regra para todos. pls_regra_autorizacao ie_tipo_congenere
end if;

select	max(cd_especialidade)
into STRICT	cd_especialidade_w
from	especialidade_medica
where	nr_seq_cbo_saude = nr_seq_cbo_conta_w;

select	ie_carater_internacao
into STRICT	ie_carater_internacao_w
from	pls_conta
where 	nr_sequencia	= nr_seq_conta_p  LIMIT 1;



for r_c01_w in c01 loop

	nr_seq_regra_w := r_c01_w.nr_seq_regra;
	
	for r_c02_w in c02 loop
		ie_excecao_w := pls_obter_excecao_autorizacao(nr_seq_regra_w, nr_seq_prestador_p, null, null, nr_seq_material_w);
		--Caso retorne 'S' ja sai do cursor e nao libera
		if (ie_excecao_w = 'S') then
			ie_existe_regra_w := 'S';
			if (r_c02_w.ie_liberado = 'S') then
				ie_liberado_w := 'N';
			else
				ie_liberado_w := 'S';
			end if;
			exit;
		end if;
	
		-- alimenta as variaveis para manter a compatibilidade com a forma anterior de abertura de cursores
		ie_liberado_ww := r_c02_w.ie_liberado;
		nr_seq_grupo_contrato_w := r_c02_w.nr_seq_grupo_contrato;
		nr_seq_estrut_regra_w := r_c02_w.nr_seq_estrut_mat;
		nr_seq_grupo_produto_w := r_c02_w.nr_seq_grupo_produto;
		nr_sequencia_w := r_c02_w.nr_sequencia;

		ie_existe_regra_w 	:= 'N';
		ie_estrut_mat_w		:= 'S';
		ie_grupo_produto_w	:= 'S';

		if (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
			ie_estrut_mat_w	:= pls_obter_se_mat_estrutura(nr_seq_material_w, nr_seq_estrut_regra_w);
		end if;
		
		if (ie_estrut_mat_w = 'S') then	
			if (coalesce(nr_seq_grupo_contrato_w,0) > 0) then
				if	((coalesce(nr_seq_contrato_w,0) > 0) or (coalesce(nr_seq_contrato_intercambio_w,0) > 0)) then
					ie_grupo_contrato_w	:= pls_se_grupo_preco_contrato(nr_seq_grupo_contrato_w, nr_seq_contrato_w, nr_seq_contrato_intercambio_w);
				else
					ie_grupo_contrato_w	:= 'N';
				end if;
			else
				ie_grupo_contrato_w := 'S';
			end if;

			if (ie_grupo_contrato_w = 'S') then
				if (coalesce(nr_seq_grupo_produto_w,0) > 0) then
					ie_grupo_produto_w	:= pls_se_grupo_preco_produto(nr_seq_grupo_produto_w, nr_seq_plano_w);
				end if;
				if (ie_grupo_produto_w = 'S') then	
					ie_liberado_w		:= ie_liberado_ww;
					ie_existe_regra_w	:= 'S';
				end if;
			end if;	
		end if;
	end loop;
end loop;

if (ie_exige_autorizacao_w <> coalesce(ie_liberado_w,'N')) then
	update	pls_conta_mat
	set	ie_exige_autorizacao 	= coalesce(ie_liberado_w,'N')
	where	nr_sequencia		= nr_seq_conta_mat_p;
	commit;
end if;

if (ie_existe_regra_w = 'S') then
	nr_seq_regra_p := nr_sequencia_w;
else
	nr_seq_regra_p := null;
end if;

ie_existe_regra_p	:= ie_existe_regra_w;
ie_consiste_guia_p	:= ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consiste_mat_autor ( nr_seq_conta_p bigint, nr_seq_conta_mat_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_prestador_p bigint, ie_consiste_guia_p INOUT text, ie_existe_regra_p INOUT text, nr_seq_regra_p INOUT pls_regra_autorizacao.nr_sequencia%type) FROM PUBLIC;
