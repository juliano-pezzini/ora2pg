-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reembolso_pck.agrupar_titulos ( nr_id_transacao_p pls_lote_titulo_reembolso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

				
dt_emissao_w		titulo_pagar.dt_emissao%type;
dt_vencimento_atual_w	titulo_pagar.dt_vencimento_atual%type;
dt_vencimento_orig_w	titulo_pagar.dt_vencimento_original%type;
dt_contabil_unif_w	titulo_pagar.dt_contabil%type;
nr_titulo_dest_w	titulo_pagar.nr_titulo%type;

C01 CURSOR(nr_id_transacao_pc	pls_lote_titulo_reembolso.nr_sequencia%type) FOR
	SELECT	max(a.nr_seq_protocolo) nr_seq_protocolo_ult,
		substr(xmlagg(XMLELEMENT(name e, ',' || b.nr_titulo)).extract('//text()'),2,32000) ds_lista_titulo,
		a.cd_pessoa_fisica,
		a.cd_cgc,
		count(b.nr_titulo) qt_titulo
	from	pls_lote_titulo_reembolso	a,
		titulo_pagar			b
	where	b.nr_seq_reembolso		= a.nr_seq_protocolo
	and	a.nr_id_transacao		= nr_id_transacao_pc
	and	(a.nr_lote IS NOT NULL AND a.nr_lote::text <> '')
	and	b.vl_saldo_titulo		> 0
	group by a.nr_lote, a.cd_pessoa_fisica, a.cd_cgc;
	
BEGIN

for r_c01_w in C01(nr_id_transacao_p) loop

	-- so unifica se o agrupamento gerar mais de 1 titulo
	if (r_c01_w.qt_titulo > 1) then
		select	max(dt_emissao),
			max(dt_vencimento_atual),
			max(dt_vencimento_original),
			max(dt_contabil)
		into STRICT	dt_emissao_w,
			dt_vencimento_atual_w,
			dt_vencimento_orig_w,
			dt_contabil_unif_w
		from	titulo_pagar
		where	nr_seq_reembolso = r_c01_w.nr_seq_protocolo_ult;
		
		unificar_titulos_pagar(	r_c01_w.ds_lista_titulo,
					nm_usuario_p,
					r_c01_w.cd_pessoa_fisica,
					r_c01_w.cd_cgc,
					nr_titulo_dest_w,
					dt_emissao_w,
					dt_vencimento_atual_w,
					dt_vencimento_orig_w,
					dt_contabil_unif_w,
					null,
					'U');
					
		update	titulo_pagar
		set	ie_tipo_titulo		= '10',
			ie_origem_titulo	= '6'
		where	nr_titulo		= nr_titulo_dest_w;
	end if;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reembolso_pck.agrupar_titulos ( nr_id_transacao_p pls_lote_titulo_reembolso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;