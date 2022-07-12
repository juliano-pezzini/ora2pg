-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_faturamento_pck.refaturar_saldo_discussao ( nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, dt_vencimento_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

					
ie_valor_refat_disc_w			pls_parametros.ie_valor_refat_disc%type; -- N - Negado / S - Saldo
vl_refaturado_w				pls_discussao_proc.vl_contestado%type;

c01 CURSOR(	nr_seq_lote_disc_pc	pls_lote_discussao.nr_sequencia%type) FOR
	SELECT	c.nr_seq_conta,
		coalesce(a.vl_negado, 0) vl_negado,
		a.nr_seq_conta_proc,
		null nr_seq_conta_mat,
		a.nr_sequencia nr_seq_disc_proc,
		null nr_seq_disc_mat,
		l.nr_seq_pls_fatura,
		CASE WHEN coalesce(a.qt_negada, 0)=0 THEN  1  ELSE a.qt_negada END  qt_item,
		coalesce(a.vl_contestado, 0) - coalesce(a.vl_ndc, 0) vl_saldo,
		(	SELECT	max(x.cd_procedimento)
			from	pls_conta_proc	x
			where	x.nr_sequencia	= a.nr_seq_conta_proc) cd_procedimento,
		(	select	max(x.ie_origem_proced)
			from	pls_conta_proc	x
			where	x.nr_sequencia	= a.nr_seq_conta_proc) ie_origem_proced	
	from	pls_discussao_proc		a,
		pls_contestacao_discussao	b,
		pls_contestacao			c,
		pls_lote_contestacao		l
	where	l.nr_sequencia			= c.nr_seq_lote
	and	b.nr_sequencia			= a.nr_seq_discussao
	and	c.nr_sequencia			= b.nr_seq_contestacao
	and	b.nr_seq_lote			= nr_seq_lote_disc_p
	and not exists (	select	1
			from	pls_conta_pos_proc 	z
			where	z.nr_seq_conta_proc	= a.nr_seq_conta_proc
			and	z.nr_seq_disc_proc	= a.nr_sequencia
			and	coalesce(z.nr_seq_lote_fat::text, '') = '')
	
union all

	select	c.nr_seq_conta,
		coalesce(a.vl_negado, 0) vl_negado,
		null nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		null nr_seq_disc_proc,
		a.nr_sequencia nr_seq_disc_mat,
		l.nr_seq_pls_fatura,
		CASE WHEN coalesce(a.qt_negada, 0)=0 THEN  1  ELSE a.qt_negada END  qt_item,
		coalesce(a.vl_contestado, 0) - coalesce(a.vl_ndc, 0) vl_saldo,
		null cd_procedimento,
		null ie_origem_proced
	from	pls_discussao_mat		a,
		pls_contestacao_discussao	b,
		pls_contestacao			c,
		pls_lote_contestacao		l
	where	l.nr_sequencia			= c.nr_seq_lote
	and	b.nr_sequencia			= a.nr_seq_discussao
	and	c.nr_sequencia			= b.nr_seq_contestacao
	and	b.nr_seq_lote			= nr_seq_lote_disc_p
	and not exists (	select	1
			from	pls_conta_pos_mat 	z
			where	z.nr_seq_conta_mat	= a.nr_seq_conta_mat
			and	z.nr_seq_disc_mat	= a.nr_sequencia
			and	coalesce(z.nr_seq_lote_fat::text, '') = '');
			
BEGIN

select	coalesce(max(ie_valor_refat_disc), 'N')
into STRICT	ie_valor_refat_disc_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

for r_c01_w in c01( nr_seq_lote_disc_p ) loop

	-- Tipo de valor a refaturar
	if (ie_valor_refat_disc_w = 'N') then
		vl_refaturado_w := r_c01_w.vl_negado;
		
	elsif (ie_valor_refat_disc_w = 'S') then
		vl_refaturado_w := r_c01_w.vl_saldo;
	end if;
	
	if (vl_refaturado_w > 0) then
		-- Procedimentos
		if (r_c01_w.nr_seq_conta_proc IS NOT NULL AND r_c01_w.nr_seq_conta_proc::text <> '') then
			insert into pls_conta_pos_proc(	nr_sequencia,				nr_seq_conta,			vl_medico,
							dt_atualizacao,				nm_usuario,			dt_atualizacao_nrec,
							nm_usuario_nrec,			nr_seq_conta_proc,		ie_status_faturamento,
							nr_seq_disc_proc,			qt_item,			nr_seq_lote_disc,
							vl_custo_operacional,			vl_materiais,			tx_administracao,
							vl_taxa_servico,			vl_taxa_co,			vl_taxa_material,
							vl_lib_taxa_servico,			vl_lib_taxa_co,			vl_lib_taxa_material,
							vl_glosa_taxa_servico,			vl_glosa_taxa_co,		vl_glosa_taxa_material,
							cd_procedimento,			ie_origem_proced)
						values (nextval('pls_conta_pos_proc_seq'),	r_c01_w.nr_seq_conta,		vl_refaturado_w,
							clock_timestamp(),				nm_usuario_p,			clock_timestamp(),
							nm_usuario_p,				r_c01_w.nr_seq_conta_proc,	'L',
							r_c01_w.nr_seq_disc_proc,		r_c01_w.qt_item,		nr_seq_lote_disc_p,
							0,					0,				0,
							0,					0,				0,
							0,					0,				0,
							0,					0,				0,
							r_c01_w.cd_procedimento,		r_c01_w.ie_origem_proced);
		-- Gerar os valores do contabil e PTU
		CALL pls_pos_estabelecido_pck.gerar_valores_adicionais(null, null, null, null, null, null, r_c01_w.nr_seq_conta_proc, 'S', nm_usuario_p, cd_estabelecimento_p);
		
		-- Materiais
		elsif (r_c01_w.nr_seq_conta_mat IS NOT NULL AND r_c01_w.nr_seq_conta_mat::text <> '') then
			insert into pls_conta_pos_mat(	nr_sequencia,				nr_seq_conta,			vl_materiais,
							dt_atualizacao,				nm_usuario,			dt_atualizacao_nrec,
							nm_usuario_nrec,			nr_seq_conta_mat,		ie_status_faturamento,
							nr_seq_disc_mat,			qt_item,			nr_seq_lote_disc,
							vl_administracao,			tx_administracao,		vl_taxa_material,
							vl_lib_taxa_material,			vl_glosa_taxa_material)
						values (nextval('pls_conta_pos_mat_seq'),		r_c01_w.nr_seq_conta,		vl_refaturado_w,
							clock_timestamp(),				nm_usuario_p,			clock_timestamp(),
							nm_usuario_p,				r_c01_w.nr_seq_conta_mat,	'L',
							r_c01_w.nr_seq_disc_mat,		r_c01_w.qt_item,		nr_seq_lote_disc_p,
							0,					0,				0,
							0,					0);
		-- Gerar os valores do contabil e PTU
		CALL pls_pos_estabelecido_pck.gerar_valores_adicionais(null, null, null, null, null, r_c01_w.nr_seq_conta_mat, null, 'S', nm_usuario_p, cd_estabelecimento_p);
		
		end if;
	end if;
end loop;

-- Gerar lote de faturamento
CALL pls_faturamento_pck.gerar_lote_refaturamento_disc(nr_seq_lote_disc_p, coalesce(dt_vencimento_p, clock_timestamp()), 'N', cd_estabelecimento_p, nm_usuario_p);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_faturamento_pck.refaturar_saldo_discussao ( nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, dt_vencimento_p timestamp, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;