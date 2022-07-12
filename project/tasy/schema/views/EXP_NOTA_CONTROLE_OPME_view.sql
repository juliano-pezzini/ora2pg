-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_nota_controle_opme (tp_registro, cd_estabelecimento, dt_emissao, valor_registro) AS select	'01' 								tp_registro,
		n.cd_estabelecimento				cd_estabelecimento,
		n.dt_emissao						dt_emissao,
		n.nr_nota_fiscal					||';'||
		n.dt_emissao						||';'||
		n.cd_cgc 							||';'||
		campo_mascara(n.vl_total_nota,2)				valor_registro
FROM	operacao_nota o,
		nota_fiscal n
where	exists (
				select	1
				from	w_nota_fiscal x
				where	x.nr_seq_nota_fiscal = n.nr_sequencia)
and		o.cd_operacao_nf = n.cd_operacao_nf
and		substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'E'
and		n.dt_atualizacao_estoque is not null;

