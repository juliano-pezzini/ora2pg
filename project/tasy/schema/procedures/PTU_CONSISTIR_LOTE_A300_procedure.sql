-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_consistir_lote_a300 ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_pessoa_fisica,
		a.nm_beneficiario,
		a.nm_mae_benef,
		a.dt_nascimento,
		a.ie_sexo,
		a.cd_cgc_cpf,
		a.nr_cartao_nac_sus,
		e.cd_cep,
		e.ds_endereco,
		e.nm_municipio,
		e.sg_uf,
		a.nr_rg,
		a.ds_orgao_emissor,
		a.sg_uf_rg,
		a.cd_pais,
		(SELECT	max(x.dt_liberacao)
		from	pls_sca_vinculo x
		where	x.nr_sequencia = a.nr_seq_vinculo_sca) dt_liberacao
	from	ptu_mov_produto_benef	a,
		ptu_mov_produto_empresa	b,
		ptu_movimentacao_produto c,
		ptu_mov_produto_lote	d,
		ptu_movimento_benef_compl e
	where	b.nr_sequencia	= a.nr_seq_empresa
	and	c.nr_sequencia	= b.nr_seq_mov_produto
	and	d.nr_sequencia	= c.nr_seq_lote
	and	a.nr_sequencia	= e.nr_seq_beneficiario
	and	d.nr_sequencia	= nr_seq_lote_p;

BEGIN

for r_c01_w in C01 loop
	begin
	delete	from	ptu_intercambio_consist
	where	nr_seq_mov_prod_benef	= r_c01_w.nr_sequencia
	and	(nr_seq_inconsistencia_a300 IS NOT NULL AND nr_seq_inconsistencia_a300::text <> '');
	
	if (coalesce(r_c01_w.nm_beneficiario::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 1, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.nm_mae_benef::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 2, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if	((pls_consistir_letra_unica_pf(r_c01_w.nm_beneficiario) = 'S') or (pls_consistir_letra_unica_pf(r_c01_w.nm_mae_benef) = 'S')) then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 3, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.dt_nascimento::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 4, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.ie_sexo::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 5, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.cd_cgc_cpf::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 6, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.nr_cartao_nac_sus::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 7, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (length(r_c01_w.nr_cartao_nac_sus) <> 15) then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 8, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if	((coalesce(r_c01_w.nr_rg::text, '') = '' and coalesce(r_c01_w.ds_orgao_emissor::text, '') = '' and coalesce(r_c01_w.sg_uf_rg::text, '') = '' and coalesce(r_c01_w.cd_pais::text, '') = '') or ((r_c01_w.nr_rg IS NOT NULL AND r_c01_w.nr_rg::text <> '') and (r_c01_w.ds_orgao_emissor IS NOT NULL AND r_c01_w.ds_orgao_emissor::text <> '') and (r_c01_w.sg_uf_rg IS NOT NULL AND r_c01_w.sg_uf_rg::text <> '') and (r_c01_w.cd_pais IS NOT NULL AND r_c01_w.cd_pais::text <> ''))) then
		null;
	else
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 9, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.cd_cep::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 10, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.ds_endereco::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 11, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.nm_municipio::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 12, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.sg_uf::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 13, cd_estabelecimento_p, nm_usuario_p);
	end if;
	
	if (coalesce(r_c01_w.dt_liberacao::text, '') = '') then
		CALL pls_gravar_inc_benef_a300(r_c01_w.nr_sequencia, 14, cd_estabelecimento_p, nm_usuario_p);
	end if;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_consistir_lote_a300 ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
