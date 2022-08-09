-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_valor_mat_orc ( nr_seq_orcamento_mat_p bigint, ie_gravar_log_p text, nm_usuario_p text) AS $body$
DECLARE


_ora2pg_r RECORD;
cd_estabelecimento_w		bigint;
nr_seq_prestador_w		bigint;
dt_solicitacao_w		timestamp;
nr_seq_material_w		bigint;
ie_tipo_despesa_w		varchar(1);
nr_seq_outorgante_w		bigint;
nr_seq_segurado_w		bigint;
vl_material_w			double precision;
dt_ult_vigencia_w		timestamp;
nr_seq_material_preco_w		bigint;
vl_material_simpro_w		double precision;
vl_material_brasindice_w	double precision;
vl_material_tabela_w		double precision;
nr_seq_plano_w			bigint;
nr_seq_tipo_acomodacao_w	bigint;
nr_seq_categoria_w		bigint;
nr_seq_tipo_atendimento_w	bigint;
ie_tipo_atend_tiss_w		varchar(2);
nr_seq_clinica_w		bigint;
ie_tipo_guia_w			varchar(2);
nr_seq_req_mat_w		bigint;
dados_regra_preco_material_w	pls_cta_valorizacao_pck.dados_regra_preco_material;
ie_regime_atendimento_w		pls_regra_preco_mat.ie_regime_atendimento%type;
ie_saude_ocupacional_w		pls_regra_preco_mat.ie_saude_ocupacional%type;


BEGIN

/*Obter dados dos procedimentos do orcamento*/

select	nr_seq_req_mat,
	nr_seq_material
into STRICT	nr_seq_req_mat_w,
	nr_seq_material_w
from	pls_orcamento_mat
where	nr_sequencia	= nr_seq_orcamento_mat_p;

/* Obter dados da requisicao */

select	a.cd_estabelecimento,
	a.nr_seq_prestador,
	a.dt_requisicao,
	a.nr_seq_segurado,
	a.nr_seq_plano,
	a.nr_seq_tipo_acomodacao,
	a.ie_tipo_atendimento,
	a.nr_seq_clinica,
	a.ie_tipo_guia,
	a.ie_regime_atendimento,
	a.ie_saude_ocupacional
into STRICT	cd_estabelecimento_w,
	nr_seq_prestador_w,
	dt_solicitacao_w,
	nr_seq_segurado_w,
	nr_seq_plano_w,
	nr_seq_tipo_acomodacao_w,
	ie_tipo_atend_tiss_w,
	nr_seq_clinica_w,
	ie_tipo_guia_w,
	ie_regime_atendimento_w,
	ie_saude_ocupacional_w
from	pls_requisicao		a,
	pls_requisicao_mat	b
where	a.nr_sequencia		= b.nr_seq_requisicao
and	b.nr_sequencia		= nr_seq_req_mat_w;

/* Obter a categoria do tipo de acomodacao */
if (nr_seq_tipo_acomodacao_w IS NOT NULL AND nr_seq_tipo_acomodacao_w::text <> '') then
	select	max(nr_seq_categoria) 
	into STRICT	nr_seq_categoria_w
	from	pls_regra_categoria 
	where	nr_seq_tipo_acomodacao	= nr_seq_tipo_acomodacao_w;
end if;

begin
	select	nr_sequencia
	into STRICT	nr_seq_tipo_atendimento_w
	from	pls_tipo_atendimento
	where	somente_numero(cd_tiss)	= ie_tipo_atend_tiss_w;
exception
when others then
	nr_seq_tipo_atendimento_w	:= null;
end;


begin
	select	nr_seq_outorgante
	into STRICT	nr_seq_outorgante_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_plano_w;
exception
	when others then
	nr_seq_outorgante_w	:= 0;
end;

select	ie_tipo_despesa
into STRICT	ie_tipo_despesa_w
from	pls_material
where	nr_sequencia	= nr_seq_material_w;

SELECT * FROM pls_define_preco_material(	cd_estabelecimento_w, nr_seq_prestador_w, dt_solicitacao_w, nr_seq_material_w, 4, ie_tipo_despesa_w, null, 'OR', nr_seq_outorgante_w, nr_seq_segurado_w, '', null, nr_seq_categoria_w, nr_seq_tipo_acomodacao_w, nr_seq_tipo_atendimento_w, nr_seq_clinica_w, ie_tipo_guia_w, null, null, ie_gravar_log_p, nm_usuario_p, '', '', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, vl_material_w, dt_ult_vigencia_w, nr_seq_material_preco_w, vl_material_simpro_w, vl_material_brasindice_w, vl_material_tabela_w, dados_regra_preco_material_w, null, ie_regime_atendimento_w, ie_saude_ocupacional_w) INTO STRICT _ora2pg_r;
 vl_material_w := _ora2pg_r.vl_material_p; dt_ult_vigencia_w := _ora2pg_r.dt_ult_vigencia_p; nr_seq_material_preco_w := _ora2pg_r.nr_seq_material_preco_p; vl_material_simpro_w := _ora2pg_r.vl_material_simpro_p; vl_material_brasindice_w := _ora2pg_r.vl_material_brasindice_p; vl_material_tabela_w := _ora2pg_r.vl_material_tabela_p; dados_regra_preco_material_w := _ora2pg_r.dados_regra_preco_material_p;

update	pls_orcamento_mat
set	vl_material	= vl_material_w
where	nr_sequencia	= nr_seq_orcamento_mat_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_valor_mat_orc ( nr_seq_orcamento_mat_p bigint, ie_gravar_log_p text, nm_usuario_p text) FROM PUBLIC;
