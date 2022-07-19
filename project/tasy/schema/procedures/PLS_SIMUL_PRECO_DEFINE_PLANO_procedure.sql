-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_simul_preco_define_plano ( nr_seq_simulacao_p pls_simulacao_preco.nr_sequencia%type, nr_seq_simul_plano_p pls_simulacao_preco_plano.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


dt_finalizacao_w	pls_simulacao_preco.dt_finalizacao%type;
cd_estabelecimento_w	pls_simulacao_preco.cd_estabelecimento%type;
nr_seq_contrato_w	pls_simulacao_preco.nr_seq_contrato%type;
nr_seq_plano_w		pls_simulacao_preco_plano.nr_seq_plano%type;
nr_seq_tabela_w		pls_simulacao_preco_plano.nr_seq_tabela%type;
ie_tipo_contratacao_w	pls_plano.ie_tipo_contratacao%type;

ie_lanc_auto_contrato_exist_w	varchar(1);

C01 CURSOR(	nr_seq_plano_pc		pls_plano.nr_sequencia%type,
		ie_tipo_contratacao_pc	pls_plano.ie_tipo_contratacao%type) FOR
	SELECT	c.nr_sequencia nr_seq_bonificacao
	from	pls_regra_lanc_automatico a,
		pls_regra_lanc_aut_item b,
		pls_bonificacao c
	where	a.nr_sequencia	= b.nr_seq_regra
	and	c.nr_sequencia	= b.nr_seq_bonificacao
	and	clock_timestamp() between coalesce(b.dt_inicio_vigencia,clock_timestamp()) and coalesce(b.dt_fim_vigencia,clock_timestamp())
	and	b.ie_situacao	= 'A'
	and	a.ie_situacao	= 'A'
	and	a.ie_acao_regra = '6'
	and (coalesce(a.nr_seq_plano::text, '') = '' or a.nr_seq_plano = nr_seq_plano_pc)
	and	((coalesce(a.ie_tipo_contratacao::text, '') = '') or (a.ie_tipo_contratacao = ie_tipo_contratacao_pc))
	and	not exists (	SELECT	1 --inserir a bonificacao somente se nao existir
				from	pls_bonificacao_vinculo x
				where	x.nr_seq_simulacao	= nr_seq_simulacao_p
				and	x.nr_seq_bonificacao	= b.nr_seq_bonificacao);

BEGIN

select	dt_finalizacao,
	cd_estabelecimento,
	nr_seq_contrato
into STRICT	dt_finalizacao_w,
	cd_estabelecimento_w,
	nr_seq_contrato_w
from	pls_simulacao_preco
where	nr_sequencia	= nr_seq_simulacao_p;

ie_lanc_auto_contrato_exist_w	:= coalesce(obter_valor_param_usuario(1233, 11, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w), 'N');

if (coalesce(dt_finalizacao_w::text, '') = '') then
	update	pls_simulacao_preco_plano
	set	ie_status = 'N'
	where	nr_seq_simulacao = nr_seq_simulacao_p
	and	ie_status = 'S';
	
	update	pls_simulacao_preco_plano
	set	ie_status = 'S'
	where	nr_sequencia = nr_seq_simul_plano_p;
	
	select	nr_seq_plano,
		nr_seq_tabela
	into STRICT	nr_seq_plano_w,
		nr_seq_tabela_w
	from	pls_simulacao_preco_plano
	where	nr_sequencia	= nr_seq_simul_plano_p;
	
	update	pls_simulacao_preco
	set	nr_seq_produto	= nr_seq_plano_w,
		nr_seq_tabela	= nr_seq_tabela_w,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_simulacao_p;
	
	if (ie_lanc_auto_contrato_exist_w = 'S' or coalesce(nr_seq_contrato_w::text, '') = '') then
		select	max(ie_tipo_contratacao)
		into STRICT	ie_tipo_contratacao_w
		from	pls_plano
		where	nr_sequencia = nr_seq_plano_w;
	
		delete	from	pls_bonificacao_vinculo
		where	nr_seq_simulacao	= nr_seq_simulacao_p
		and	ie_lancamento_automatico = 'S';
		
		for r_c01_w in C01(	nr_seq_plano_w,
					ie_tipo_contratacao_w) loop
			begin
			insert	into	pls_bonificacao_vinculo(	nr_sequencia, nr_seq_simulacao, nr_seq_bonificacao, ie_lancamento_automatico,
					dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec)
				values (	nextval('pls_bonificacao_vinculo_seq'), nr_seq_simulacao_p, r_c01_w.nr_seq_bonificacao, 'S',
					clock_timestamp(), clock_timestamp(), nm_usuario_p, nm_usuario_p);
			end;
		end loop;
	end if;
	
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_simul_preco_define_plano ( nr_seq_simulacao_p pls_simulacao_preco.nr_sequencia%type, nr_seq_simul_plano_p pls_simulacao_preco_plano.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

