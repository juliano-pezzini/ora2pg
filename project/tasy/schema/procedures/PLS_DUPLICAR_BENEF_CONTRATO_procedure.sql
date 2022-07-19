-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_benef_contrato ( nr_seq_contrato_novo_p pls_contrato.nr_sequencia%type, nr_seq_segurado_atual_p pls_segurado.nr_sequencia%type, nr_seq_titular_novo_p pls_segurado.nr_seq_titular%type, nr_seq_pagador_novo_p pls_segurado.nr_seq_pagador%type, nr_seq_canal_venda_p pls_segurado.nr_seq_vendedor_canal%type, nr_seq_vendedor_pf_p pls_segurado.nr_seq_vendedor_pf%type, nr_seq_plano_novo_p pls_segurado.nr_seq_plano%type, nr_seq_tabela_novo_p pls_segurado.nr_seq_tabela%type, nr_seq_subestipulante_p pls_segurado.nr_seq_subestipulante%type, dt_contratacao_p pls_segurado.dt_contratacao%type, ie_commit_p text, nm_usuario_p text, nr_seq_segurado_novo_p INOUT pls_segurado.nr_sequencia%type) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);
dt_inclusao_operadora_w		timestamp;
nr_seq_segurado_ant_w		bigint;
nr_seq_seg_contrato_w		bigint;
nr_seq_parentesco_w		grau_parentesco.nr_sequencia%type;
ie_tipo_parentesco_w		grau_parentesco.ie_grau_parentesco%type;
cd_matricula_estipulante_w	varchar(30);
nr_seq_portabilidade_w		bigint;
nr_seq_vinculo_estip_w		bigint;
nr_seq_proposta_w		bigint;
ie_nascido_plano_w		varchar(1);
nr_seq_motivo_inclusao_w	bigint;
nr_contrato_ant_w		bigint;
ie_taxa_inscricao_w		varchar(10);
nr_seq_tipo_comercial_w		bigint;
nr_seq_localizacao_benef_w	bigint;
cd_segurado_familia_w		pls_segurado.cd_segurado_familia%type;
cd_estabelecimento_w		pls_segurado.cd_estabelecimento%type;
nr_seq_segurado_novo_w		pls_segurado.nr_sequencia%type;
nr_seq_titular_contr_novo_w	pls_segurado.nr_sequencia%type;
cd_pessoa_titular_w		pls_segurado.cd_pessoa_fisica%type;
nr_seq_titular_novo_w		pls_segurado.nr_sequencia%type;
nr_seq_classif_dependencia_w	pls_segurado.nr_seq_classif_dependencia%type;
nr_seq_classificacao_w		pls_segurado.nr_seq_classificacao%type;
ie_titularidade_w		pls_segurado.ie_titularidade%type;
ie_tipo_operacao_w		pls_contrato.ie_tipo_operacao%type;


BEGIN
nr_seq_titular_novo_w		:= nr_seq_titular_novo_p;

select	a.cd_pessoa_fisica,
	a.nr_seq_parentesco,
	a.cd_segurado_familia,
	a.dt_inclusao_operadora,
	a.nr_seq_vinculo_est,
	a.cd_matricula_estipulante,
	a.nr_seq_motivo_inclusao,	
	a.ie_nascido_plano,
	a.nr_contrato_ant,
	a.ie_taxa_inscricao,
	a.nr_seq_tipo_comercial,	
	a.nr_seq_localizacao_benef,
	a.ie_tipo_parentesco,
	a.cd_estabelecimento,
	a.nr_seq_classif_dependencia,
	(	select	max(x.cd_pessoa_fisica)
		from	pls_segurado x
		where	x.nr_sequencia	= a.nr_seq_titular) cd_pessoa_titular,
	a.nr_seq_classificacao,
	a.ie_titularidade
into STRICT   	cd_pessoa_fisica_w,
	nr_seq_parentesco_w,
	cd_segurado_familia_w,
	dt_inclusao_operadora_w,
	nr_seq_vinculo_estip_w,
	cd_matricula_estipulante_w,
	nr_seq_motivo_inclusao_w,	
	ie_nascido_plano_w,
	nr_contrato_ant_w,
	ie_taxa_inscricao_w,
	nr_seq_tipo_comercial_w,	
	nr_seq_localizacao_benef_w,
	ie_tipo_parentesco_w,
	cd_estabelecimento_w,
	nr_seq_classif_dependencia_w,
	cd_pessoa_titular_w,
	nr_seq_classificacao_w,
	ie_titularidade_w
from	pls_segurado a
where	a.nr_sequencia = nr_seq_segurado_atual_p;

if (coalesce(nr_seq_titular_novo_w,0) = 0) then
	nr_seq_titular_novo_w	:= null;
	
	if (cd_pessoa_titular_w IS NOT NULL AND cd_pessoa_titular_w::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_titular_contr_novo_w
		from	pls_segurado
		where	cd_pessoa_fisica	= cd_pessoa_titular_w
		and	nr_seq_contrato		= nr_seq_contrato_novo_p
		and	coalesce(nr_seq_titular::text, '') = ''
		and	coalesce(dt_rescisao::text, '') = '';
			
		if (nr_seq_titular_contr_novo_w IS NOT NULL AND nr_seq_titular_contr_novo_w::text <> '') then
			nr_seq_titular_novo_w	:= nr_seq_titular_contr_novo_w;						
		end if;
	end if;
end if;

if (coalesce(nr_seq_titular_novo_w::text, '') = '') then
	nr_seq_parentesco_w	:= null;
	ie_tipo_parentesco_w	:= null;
end if;

select	nextval('pls_segurado_seq')
into STRICT	nr_seq_segurado_novo_w
;

select 	ie_tipo_operacao
into STRICT   	ie_tipo_operacao_w
from	pls_contrato
where	nr_sequencia	= nr_seq_contrato_novo_p;

insert into pls_segurado(
	nr_sequencia, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, cd_pessoa_fisica,
	nr_seq_titular, nr_seq_contrato, nr_seq_pagador,
	nr_seq_plano, nr_seq_tabela, dt_liberacao, nr_seq_parentesco,
	cd_segurado_familia, dt_inclusao_operadora, dt_limite_utilizacao,
	nr_seq_vinculo_est, cd_matricula_estipulante, nr_seq_tabela_origem,
	nr_seq_motivo_inclusao, nr_seq_segurado_mig, nr_seq_vendedor_pf,
	nr_seq_vendedor_canal, ie_acao_contrato, ie_tipo_plano,
	ie_tipo_segurado,nr_seq_portabilidade,dt_contratacao,
	nr_seq_subestipulante,nr_seq_segurado_ant, ie_nascido_plano, ie_situacao_atend,
	cd_estabelecimento, nr_contrato_ant, ie_taxa_inscricao,
	ie_renovacao_carteira, nr_seq_tipo_comercial,
	nr_seq_localizacao_benef, ie_tipo_parentesco, nr_seq_classif_dependencia,ie_titularidade)
values (	nr_seq_segurado_novo_w, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, cd_pessoa_fisica_w,
	nr_seq_titular_novo_w, nr_seq_contrato_novo_p, nr_seq_pagador_novo_p,
	nr_seq_plano_novo_p, nr_seq_tabela_novo_p, null, nr_seq_parentesco_w,
	cd_segurado_familia_w, dt_inclusao_operadora_w, null,
	nr_seq_vinculo_estip_w, cd_matricula_estipulante_w, null,
	nr_seq_motivo_inclusao_w, null, nr_seq_vendedor_pf_p,
	nr_seq_canal_venda_p, null, null,
	ie_tipo_operacao_w, nr_seq_portabilidade_w, dt_contratacao_p,
	nr_seq_subestipulante_p, nr_seq_segurado_ant_w, ie_nascido_plano_w, 'A',
	cd_estabelecimento_w, nr_contrato_ant_w, ie_taxa_inscricao_w,
	'S', nr_seq_tipo_comercial_w,
	nr_seq_localizacao_benef_w, ie_tipo_parentesco_w, nr_seq_classif_dependencia_w,ie_titularidade_w);
	
insert	into	pls_segurado_compl(	nr_sequencia, nr_seq_segurado, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		dt_admissao)
	(SELECT	nextval('pls_segurado_compl_seq'), nr_seq_segurado_novo_w, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		dt_admissao
	from	pls_segurado_compl
	where	nr_Seq_segurado = nr_seq_segurado_atual_p);

if (coalesce(ie_commit_p, 'S') = 'S') then
	commit;
end if;

nr_seq_segurado_novo_p := nr_seq_segurado_novo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_benef_contrato ( nr_seq_contrato_novo_p pls_contrato.nr_sequencia%type, nr_seq_segurado_atual_p pls_segurado.nr_sequencia%type, nr_seq_titular_novo_p pls_segurado.nr_seq_titular%type, nr_seq_pagador_novo_p pls_segurado.nr_seq_pagador%type, nr_seq_canal_venda_p pls_segurado.nr_seq_vendedor_canal%type, nr_seq_vendedor_pf_p pls_segurado.nr_seq_vendedor_pf%type, nr_seq_plano_novo_p pls_segurado.nr_seq_plano%type, nr_seq_tabela_novo_p pls_segurado.nr_seq_tabela%type, nr_seq_subestipulante_p pls_segurado.nr_seq_subestipulante%type, dt_contratacao_p pls_segurado.dt_contratacao%type, ie_commit_p text, nm_usuario_p text, nr_seq_segurado_novo_p INOUT pls_segurado.nr_sequencia%type) FROM PUBLIC;

