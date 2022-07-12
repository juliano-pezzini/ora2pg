-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_xml_pacote_pck.gerar_pacotes ( nr_seq_lote_p pls_imp_lote_pacote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


c01 CURSOR(	nr_seq_lote_pc	pls_imp_lote_pacote.nr_sequencia%type) FOR
	SELECT	ie_tipo_registro,
		ds_linha
	from	w_pls_pacote
	where	nr_seq_imp_lote_pacote = nr_seq_lote_pc
	order by nr_sequencia;

nr_seq_imp_pacote_w	pls_imp_pacote.nr_sequencia%type;
dt_inicio_vigencia_w	pls_imp_pacote.dt_inicio_vigencia%type;
cd_tipo_tabela_imp_w	pls_imp_pacote.cd_tipo_tabela_imp%type;
cd_pacote_w		pls_imp_pacote.cd_pacote%type;
cd_tipo_tabela_comp_w	pls_imp_pacote.cd_tipo_tabela_comp%type;
cd_composicao_w		pls_imp_pacote.cd_composicao%type;
qt_composicao_w		pls_imp_pacote.qt_composicao%type;
vl_unit_composicao_w	pls_imp_pacote.vl_unit_composicao%type;

BEGIN

for r_C01_w in C01( nr_seq_lote_p ) loop

	if (r_C01_w.ie_tipo_registro = 1) then

		select	to_date(to_char(pls_extrair_dado_tag_xml(r_C01_w.ds_linha,'<InicioVigencia>')),'dd/mm/yyyy hh24:mi:ss'),
			pls_extrair_dado_tag_xml(r_C01_w.ds_linha,'<TipoTabelaServico>'),
			to_char((pls_extrair_dado_tag_xml(r_C01_w.ds_linha,'<Servico>'))::numeric )
		into STRICT	dt_inicio_vigencia_w,
			cd_tipo_tabela_imp_w,
			cd_pacote_w
		;

	elsif (r_C01_w.ie_tipo_registro = 2) then

		select	pls_extrair_dado_tag_xml(r_C01_w.ds_linha,'<TipoTabelaServico>'),
			pls_extrair_dado_tag_xml(r_C01_w.ds_linha,'<Composicao>'),
			(pls_extrair_dado_tag_xml(replace(r_C01_w.ds_linha,'.',','),'<Quantidade>'))::numeric ,
			coalesce((replace(pls_extrair_dado_tag_xml(r_C01_w.ds_linha,'<Valor>'),'.',','))::numeric ,0)
		into STRICT	cd_tipo_tabela_comp_w,
			cd_composicao_w,
			qt_composicao_w,
			vl_unit_composicao_w
		;

		insert into pls_imp_pacote(
			nr_sequencia,			dt_atualizacao,		nm_usuario,
			dt_atualizacao_nrec,		nm_usuario_nrec,	nr_seq_lote_pct,
			dt_inicio_vigencia,		cd_tipo_tabela_imp,	cd_pacote,
			cd_tipo_tabela_comp,		cd_composicao,		qt_composicao,
			vl_unit_composicao,		vl_tot_composicao
		)values (nextval('pls_imp_pacote_seq'),	clock_timestamp(),		nm_usuario_p,
			clock_timestamp(),			nm_usuario_p,		nr_seq_lote_p,
			dt_inicio_vigencia_w,		cd_tipo_tabela_imp_w,	cd_pacote_w,
			cd_tipo_tabela_comp_w,		cd_composicao_w,	qt_composicao_w,
			vl_unit_composicao_w,		qt_composicao_w * vl_unit_composicao_w);
	end if;
end loop;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_xml_pacote_pck.gerar_pacotes ( nr_seq_lote_p pls_imp_lote_pacote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;