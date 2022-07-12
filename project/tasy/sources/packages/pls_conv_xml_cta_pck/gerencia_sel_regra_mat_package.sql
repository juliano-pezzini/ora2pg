-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.gerencia_sel_regra_mat () AS $body$
DECLARE


qt_regra_w	integer;
qt_itens_w	integer;
nr_contador_w	integer;
tb_nr_seq_regra_w	pls_util_cta_pck.t_number_table;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_conversao_mat
	where	ie_envio_receb = 'R'
	and	ie_situacao = 'A';
		
C02 CURSOR FOR
	SELECT 	a.nr_sequencia nr_seq_regra,
		a.cd_material_orig_inicial,
		a.cd_material_orig_final,
		a.nr_seq_material_orig,
		a.nr_seq_tipo_prestador,
		a.nr_seq_grupo_prestador,
		a.nr_seq_prestador,
		a.ie_tipo_despesa_mat,
		a.ie_tipo_tabela,
		(SELECT count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.cd_procedimento_conv 	between pls_util_pck.obter_somente_numero(a.cd_material_orig_inicial)
						and pls_util_pck.obter_somente_numero(a.cd_material_orig_final)) qt_cod_material,
		(select count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.nr_seq_material_conv = a.nr_seq_material_orig) qt_seq_material,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			pls_prestador c
		where	c.nr_sequencia = b.nr_seq_prest_prot_conv
		and	c.nr_seq_tipo_prestador = a.nr_seq_tipo_prestador) qt_tipo_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			table(pls_grupos_pck.obter_prestadores_grupo(
			a.nr_seq_grupo_prestador, b.nr_seq_prest_prot_conv))
			where	CASE WHEN coalesce(b.nr_seq_prest_prot_conv::text, '') = '' THEN  -1  ELSE -2 END  = -2) qt_grupo_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b
		where	b.nr_seq_prest_prot_conv = a.nr_seq_prestador) qt_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			pls_material c
		where	c.nr_sequencia = b.nr_seq_material_conv
		and	c.ie_tipo_despesa = a.ie_tipo_despesa_mat) qt_tipo_despesa_mat,
		(select count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.cd_tipo_tabela_conv = a.ie_tipo_tabela) qt_tabela_importacao
	from	pls_conversao_mat a
	where	ie_envio_receb = 'R'
	and	ie_situacao = 'A';
		
BEGIN
-- limpa a tabela tempor_ria das regras

EXECUTE 'truncate table pls_regra_conv_item_tmp';

-- para inicializar a vari_vel

tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_conv_item(tb_nr_seq_regra_w);
nr_contador_w := 0;

-- conta as regras v_lidas

select	count(1)
into STRICT	qt_regra_w
from	pls_conversao_mat a
where	ie_envio_receb = 'R'
and	ie_situacao = 'A';

-- conta os itens a serem processados

select 	count(1)
into STRICT	qt_itens_w
from	pls_conta_item_imp_tmp;

-- se existirem mais itens que regras processamos todas as regras

if (qt_itens_w > qt_regra_w) then
	
	open C01;
	loop
		fetch C01 bulk collect into 	tb_nr_seq_regra_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_nr_seq_regra_w.count = 0;
	
		tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_conv_item(tb_nr_seq_regra_w);
	end loop;
	close C01;
-- se existir mais regras que itens _ feito uma pr_ selecao das regras a serem processadas

else

	for r_c02_w in C02 loop
	
		-- se algum dos itens retornou valor devemos processar a regra

		if (r_c02_w.qt_cod_material > 0) or (r_c02_w.qt_seq_material > 0) or (r_c02_w.qt_tipo_prestador > 0) or (r_c02_w.qt_grupo_prestador > 0) or (r_c02_w.qt_prestador > 0) or (r_c02_w.qt_tipo_despesa_mat > 0) or (r_c02_w.qt_tabela_importacao > 0) then

			tb_nr_seq_regra_w(nr_contador_w) := r_c02_w.nr_seq_regra;

			if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then

				tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_conv_item(tb_nr_seq_regra_w);
				nr_contador_w := 0;
			else
				nr_contador_w := nr_contador_w + 1;
			end if;
		-- incluido este else caso todos os campos sejam nulos (regra em branco) _ necess_rio processar a regra

		elsif (coalesce(r_c02_w.cd_material_orig_inicial::text, '') = '') and (coalesce(r_c02_w.cd_material_orig_final::text, '') = '') and (coalesce(r_c02_w.nr_seq_material_orig::text, '') = '') and (coalesce(r_c02_w.nr_seq_tipo_prestador::text, '') = '') and (coalesce(r_c02_w.nr_seq_grupo_prestador::text, '') = '') and (coalesce(r_c02_w.nr_seq_prestador::text, '') = '') and (coalesce(r_c02_w.ie_tipo_despesa_mat::text, '') = '') and (coalesce(r_c02_w.ie_tipo_tabela::text, '') = '') then

			tb_nr_seq_regra_w(nr_contador_w) := r_c02_w.nr_seq_regra;

			if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then

				tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_conv_item(tb_nr_seq_regra_w);
				nr_contador_w := 0;
			else
				nr_contador_w := nr_contador_w + 1;
			end if;
		end if;
	end loop;
	
	-- se sobrou algo manda pra tabela

	tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_conv_item(tb_nr_seq_regra_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.gerencia_sel_regra_mat () FROM PUBLIC;
