-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_sca_pck.gerar_taxa_inscricao ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, nr_seq_vinculo_sca_p pls_sca_vinculo.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, nr_parcela_sca_p bigint, vl_preco_sca_p pls_mensalidade_seg_item.vl_item%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, ie_titularidade_p text) AS $body$
DECLARE


vl_inscricao_w		pls_regra_inscricao.vl_inscricao%type;
tx_inscricao_w		pls_regra_inscricao.tx_inscricao%type;
vl_item_inscricao_w	pls_mensalidade_seg_item.vl_item%type;
ie_inseriu_item_w	varchar(1);


BEGIN
--Gerar valor de inscricao do SCA
begin
select	coalesce(vl_inscricao,0),
	coalesce(tx_inscricao,0)
into STRICT	vl_inscricao_w,
	tx_inscricao_w
from	pls_regra_inscricao
where	nr_seq_plano = nr_seq_plano_p
and	nr_parcela_sca_p between qt_parcela_inicial and qt_parcela_final
and (ie_grau_dependencia = ie_titularidade_p or ie_grau_dependencia = 'A')
and	dt_referencia_p between trunc(coalesce(dt_inicio_vigencia,dt_referencia_p),'month') and trunc(coalesce(dt_fim_vigencia,dt_referencia_p),'month');
exception
when others then
	vl_inscricao_w := 0;
	tx_inscricao_w := 0;
end;

vl_item_inscricao_w := ((tx_inscricao_w * vl_preco_sca_p) / 100) + vl_inscricao_w;

if (coalesce(vl_item_inscricao_w,0) <> 0) then
	ie_inseriu_item_w := pls_mens_itens_pck.add_item_taxa_insc(nr_seq_mensalidade_seg_p, '2', vl_item_inscricao_w, 'N', nr_seq_vinculo_sca_p, nr_parcela_sca_p, wheb_mensagem_pck.get_texto(1116072)||' referente ao SCA', ie_inseriu_item_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_sca_pck.gerar_taxa_inscricao ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, nr_seq_vinculo_sca_p pls_sca_vinculo.nr_sequencia%type, nr_seq_plano_p pls_plano.nr_sequencia%type, nr_parcela_sca_p bigint, vl_preco_sca_p pls_mensalidade_seg_item.vl_item%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, ie_titularidade_p text) FROM PUBLIC;