-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_excecao_preco_mat ( nr_seq_regra_p bigint, cd_material_p bigint, nr_seq_material_p bigint, dt_guia_p timestamp, ie_preco_p text, ie_tipo_contratacao_p text, ie_tipo_segurado_p text, nr_seq_contrato_p bigint, nr_seq_prestador_p bigint, nr_seq_congenere_p bigint, nr_seq_tipo_prestador_p bigint, nr_seq_grupo_intercambio_p bigint, nr_seq_classificacao_p bigint, nr_seq_classificacao_prest_p bigint, nr_seq_contrato_intercambio_p text, nr_seq_congenere_prot_p bigint, nr_seq_excecao_preco_proc_p INOUT bigint, ie_origem_protocolo_p text, ie_tipo_intercambio_p text, nr_seq_tipo_prestador_prot_p pls_prestador.nr_seq_tipo_prestador%type, nr_seq_tipo_atend_princ_p pls_excecao_preco_mat.nr_seq_tipo_atend_princ%type, ie_tipo_despesa_p pls_excecao_preco_mat.ie_tipo_despesa%type, nr_seq_prestador_intercambio_p pls_conta.nr_seq_prest_inter%type default null, ie_regime_atendimento_princ_p pls_criterio_recalculo_exc.ie_regime_atendimento_princ%type default null, ie_saude_ocupacional_princ_p pls_criterio_recalculo_exc.ie_saude_ocupacional%type default null) AS $body$
DECLARE

				
nr_seq_grupo_contrato_w		bigint;
nr_seq_grupo_material_w		bigint;
nr_seq_grupo_prestador_w	bigint;
nr_seq_excecao_preco_proc_w	bigint := 0;
nr_seq_excecao_preco_proc_ww	bigint := 0;
ie_grupo_contrato_w		varchar(10)	:= 'S';
ie_grupo_prestador_w		varchar(10)	:= 'S';
ie_grupo_servico_w		varchar(10)	:= 'S';
nr_seq_grupo_operadora_w	pls_excecao_preco_mat.nr_seq_grupo_operadora%type;
ie_grupo_operadora_w		varchar(10)	:= 'S';

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_grupo_contrato,
		a.nr_seq_grupo_material,
		a.nr_seq_grupo_prestador,
		a.nr_seq_grupo_operadora
	from	pls_excecao_preco_mat	a
	where	ie_situacao		= 'A'
	and	nr_seq_regra		= nr_seq_regra_p
	and	((coalesce(a.cd_material::text, '') = '') or ( a.cd_material = cd_material_p))
	and	((coalesce(a.nr_seq_material::text, '') = '') or ( a.nr_seq_material = nr_seq_material_p))
	and	((coalesce(a.ie_preco::text, '') = '') or (a.ie_preco = ie_preco_p))
	and	((coalesce(a.ie_tipo_contratacao::text, '') = '')	or (a.ie_tipo_contratacao	= coalesce(ie_tipo_contratacao_p,0)))
	and	((coalesce(a.ie_tipo_segurado::text, '') = '')	or (a.ie_tipo_segurado		= ie_tipo_segurado_p))
	and	((coalesce(a.nr_seq_contrato::text, '') = '')	or (a.nr_seq_contrato		= coalesce(nr_seq_contrato_p,0)))
	and	((coalesce(a.nr_seq_prestador::text, '') = '')	or (a.nr_seq_prestador		= coalesce(nr_seq_prestador_p,0)))
	and 	trunc(dt_guia_p) between trunc(a.dt_inicio_vigencia) and fim_dia(coalesce(a.dt_fim_vigencia,dt_guia_p+1))
	and	((coalesce(a.nr_seq_congenere::text, '') = '')	or (a.nr_seq_congenere		= coalesce(nr_seq_congenere_p,0)))
	and	((coalesce(a.nr_seq_tipo_prestador::text, '') = '')	or (a.nr_seq_tipo_prestador	= coalesce(nr_seq_tipo_prestador_p,0)))
	and	((coalesce(a.nr_seq_grupo_intercambio::text, '') = '')	or (a.nr_seq_grupo_intercambio	= coalesce(nr_seq_grupo_intercambio_p,0)))
	and	((coalesce(a.nr_seq_congenere_prot::text, '') = '')	or (a.nr_seq_congenere_prot	= coalesce(nr_seq_congenere_prot_p,0)))
	and	((a.nr_seq_classificacao = nr_seq_classificacao_prest_p) or (a.nr_seq_classificacao = coalesce(nr_seq_classificacao_p,0)) or (coalesce(nr_seq_classificacao::text, '') = ''))
	and	((coalesce(a.ie_origem_protocolo::text, '') = '') 	or (a.ie_origem_protocolo = ie_origem_protocolo_p))
	and	(((a.ie_tipo_intercambio	= 'A') 	or (a.ie_tipo_intercambio = ie_tipo_intercambio_p)) 	or (ie_tipo_intercambio_p = 'A'))
	and	((coalesce(a.nr_seq_tipo_prestador_prot::text, '') = '')	or (a.nr_seq_tipo_prestador_prot	= nr_seq_tipo_prestador_prot_p))
	and	((coalesce(a.nr_seq_tipo_atend_princ::text, '') = '')	or (a.nr_seq_tipo_atend_princ		= nr_seq_tipo_atend_princ_p))
	and	((coalesce(a.ie_regime_atendimento::text, '') = '')	or (a.ie_regime_atendimento		= ie_regime_atendimento_princ_p))
	and	((coalesce(a.ie_saude_ocupacional::text, '') = '')	or (a.ie_saude_ocupacional		= ie_saude_ocupacional_princ_p))
	and	((coalesce(a.ie_tipo_despesa::text, '') = '')		or (a.ie_tipo_despesa		= ie_tipo_despesa_p))
	and	((coalesce(a.nr_seq_prest_inter::text, '') = '') or (a.nr_seq_prest_inter = nr_seq_prestador_intercambio_p))
	and 	((coalesce(a.nr_seq_grupo_prest_int::text, '') = '') or (pls_obter_se_grupo_prest_int(a.nr_seq_grupo_prest_int, nr_seq_prestador_intercambio_p) = 'S'))
	order by coalesce(a.cd_material,0),
		 coalesce(a.nr_seq_prestador,0),
		 coalesce(a.nr_seq_contrato,0),
		 coalesce(a.ie_tipo_contratacao,'X') desc,
		 coalesce(a.ie_preco,'0'),
		 coalesce(a.ie_tipo_segurado,'A'),
		 coalesce(a.nr_seq_congenere_prot,0),
		 coalesce(a.nr_seq_tipo_atend_princ,0),
		 coalesce(a.ie_regime_atendimento, 'z'),
		 coalesce(a.ie_saude_ocupacional, 'z'),  
		 coalesce(a.nr_seq_prest_inter,0),
		 coalesce(a.nr_seq_grupo_prest_int,0);

BEGIN
open C01;
loop
fetch C01 into	
	nr_seq_excecao_preco_proc_ww,
	nr_seq_grupo_contrato_w,
	nr_seq_grupo_material_w,
	nr_seq_grupo_prestador_w,
	nr_seq_grupo_operadora_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_grupo_contrato_w		:= 'S';
	ie_grupo_prestador_w		:= 'S';
	ie_grupo_servico_w		:= 'S';
	ie_grupo_operadora_w	:= 'S';
	
	/* Grupo de materiais */

	if (coalesce(nr_seq_grupo_material_w,0) > 0) then
		ie_grupo_servico_w	:= pls_se_grupo_preco_material(nr_seq_grupo_material_w, nr_seq_material_p);
	end if;	
	/* Grupo de prestadores */

	if (coalesce(nr_seq_grupo_prestador_w,0) > 0) then
		ie_grupo_prestador_w	:= pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, nr_seq_prestador_p, coalesce(nr_seq_classificacao_prest_p,nr_seq_classificacao_p));
	end if;	
	/* Grupo de contratos */

	if (coalesce(nr_seq_grupo_contrato_w,0) > 0) then
		if	((coalesce(nr_seq_contrato_p,0)	> 0) or (coalesce(nr_seq_contrato_intercambio_p,0) > 0)) then
			ie_grupo_contrato_w	:= pls_se_grupo_preco_contrato(nr_seq_grupo_contrato_w, nr_seq_contrato_p, nr_seq_contrato_intercambio_p);
		else
			ie_grupo_contrato_w	:= 'N';
		end if;
	end if;
	
	/*Grupo operadora*/

	if (coalesce(nr_seq_grupo_operadora_w, 0) > 0) then
		ie_grupo_operadora_w := pls_se_grupo_preco_operadora(nr_seq_grupo_operadora_w,coalesce(nr_seq_congenere_p,nr_seq_congenere_prot_p));
	end if;
	
	if (ie_grupo_contrato_w	= 'S') and (ie_grupo_prestador_w	= 'S') and (ie_grupo_servico_w	= 'S') and (ie_grupo_operadora_w	= 'S') then
		nr_seq_excecao_preco_proc_w	:= nr_seq_excecao_preco_proc_ww;
	end if;
	
	end;
end loop;
close C01;

nr_seq_excecao_preco_proc_p	:= coalesce(nr_seq_excecao_preco_proc_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_excecao_preco_mat ( nr_seq_regra_p bigint, cd_material_p bigint, nr_seq_material_p bigint, dt_guia_p timestamp, ie_preco_p text, ie_tipo_contratacao_p text, ie_tipo_segurado_p text, nr_seq_contrato_p bigint, nr_seq_prestador_p bigint, nr_seq_congenere_p bigint, nr_seq_tipo_prestador_p bigint, nr_seq_grupo_intercambio_p bigint, nr_seq_classificacao_p bigint, nr_seq_classificacao_prest_p bigint, nr_seq_contrato_intercambio_p text, nr_seq_congenere_prot_p bigint, nr_seq_excecao_preco_proc_p INOUT bigint, ie_origem_protocolo_p text, ie_tipo_intercambio_p text, nr_seq_tipo_prestador_prot_p pls_prestador.nr_seq_tipo_prestador%type, nr_seq_tipo_atend_princ_p pls_excecao_preco_mat.nr_seq_tipo_atend_princ%type, ie_tipo_despesa_p pls_excecao_preco_mat.ie_tipo_despesa%type, nr_seq_prestador_intercambio_p pls_conta.nr_seq_prest_inter%type default null, ie_regime_atendimento_princ_p pls_criterio_recalculo_exc.ie_regime_atendimento_princ%type default null, ie_saude_ocupacional_princ_p pls_criterio_recalculo_exc.ie_saude_ocupacional%type default null) FROM PUBLIC;

