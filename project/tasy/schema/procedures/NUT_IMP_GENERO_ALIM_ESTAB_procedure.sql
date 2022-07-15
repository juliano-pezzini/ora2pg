-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE nut_gen_alim_w AS (
        nr_sequencia                pls_util_cta_pck.t_number_table,
        cd_estabelecimento          pls_util_cta_pck.t_number_table,
        cd_estab_origem_imp         pls_util_cta_pck.t_number_table,
        cd_material                 pls_util_cta_pck.t_number_table,
        cd_unidade_medida           pls_util_cta_pck.t_varchar2_table_50,
        ds_genero                   pls_util_cta_pck.t_varchar2_table_100,
        dt_atualizacao              pls_util_cta_pck.t_date_table,
        ie_arred_req                pls_util_cta_pck.t_varchar2_table_1,
        ie_gerar_solic_compra       pls_util_cta_pck.t_varchar2_table_1,
        ie_mostra_item_extra        pls_util_cta_pck.t_varchar2_table_1,
        ie_situacao                 pls_util_cta_pck.t_varchar2_table_1,
        nm_usuario                  pls_util_cta_pck.t_varchar2_table_15,
        nr_seq_receita_origem_imp   pls_util_cta_pck.t_number_table,
        nr_seq_tabela               pls_util_cta_pck.t_number_table,
        nr_seq_tipo_alimento        pls_util_cta_pck.t_number_table,
        qt_conversao                pls_util_cta_pck.t_number_table,
        qt_fator_coccao             pls_util_cta_pck.t_number_table,
        qt_fator_correcao           pls_util_cta_pck.t_number_table,
        nr_seq_genero_origem_imp    pls_util_cta_pck.t_number_table
);
CREATE TYPE nut_com_nutric_w AS (
        dt_atualizacao      pls_util_cta_pck.t_date_table,
        ie_informacao       pls_util_cta_pck.t_varchar2_table_1,
        nm_usuario          pls_util_cta_pck.t_varchar2_table_15,
        nr_seq_apresent     pls_util_cta_pck.t_number_table,
        nr_seq_nutriente    pls_util_cta_pck.t_number_table,
        nr_sequencia        pls_util_cta_pck.t_number_table,
        qt_composicao       pls_util_cta_pck.t_number_table,
        nr_seq_genero     	pls_util_cta_pck.t_number_table
);
CREATE TYPE nut_grup_w AS (
		dt_atualizacao      pls_util_cta_pck.t_date_table,
		dt_atualizacao_nrec pls_util_cta_pck.t_date_table,
		nr_seq_grupo        pls_util_cta_pck.t_number_table,
		nr_sequencia        pls_util_cta_pck.t_number_table,
		nr_seq_genero       pls_util_cta_pck.t_number_table
);


CREATE OR REPLACE PROCEDURE nut_imp_genero_alim_estab (cd_estab_p bigint, cd_tab_comp_alim_p bigint, ie_importar_receitas_p text, nm_usuario_p text) AS $body$
DECLARE


nr_vetor_w              bigint := 0;
cd_estabelecimento_w    estabelecimento.cd_estabelecimento%type;

nut_genero_alim_w       nut_gen_alim_w;
nut_comp_nutricional_w  nut_com_nutric_w;
nut_grupo_genero_w      nut_grup_w;

c01 CURSOR FOR
SELECT  nr_sequencia,
        cd_estabelecimento,
        cd_estab_origem_imp,
        cd_material,
        cd_unidade_medida,
        ds_genero,
        dt_atualizacao,
        ie_arred_req,
        ie_gerar_solic_compra,
        ie_mostra_item_extra,
        ie_situacao,
        nm_usuario,
        nr_seq_receita_origem_imp,
        nr_seq_tabela,
        nr_seq_tipo_alimento,
        qt_conversao,
        qt_fator_coccao,
        qt_fator_correcao,
        nr_seq_genero_origem_imp
from    nut_genero_alim
where   cd_estabelecimento = cd_estab_p
and (nr_seq_tabela = cd_tab_comp_alim_p or coalesce(cd_tab_comp_alim_p::text, '') = '')
and 	ie_situacao = 'A';

c02 CURSOR FOR
SELECT  a.dt_atualizacao,
        a.ie_informacao,
        a.nm_usuario,
        a.nr_seq_apresent,
        a.nr_seq_nutriente,
        a.nr_sequencia,
        a.qt_composicao,
        b.nr_sequencia nr_seq_genero
from    nut_comp_nutricional a,
	    nut_genero_alim b
where   b.nr_seq_genero_origem_imp = a.nr_seq_gen_alim
and 	b.cd_estabelecimento = cd_estabelecimento_w
and	b.ie_situacao = 'A';

c03 CURSOR FOR
SELECT  a.dt_atualizacao,
        a.dt_atualizacao_nrec,
        a.nr_seq_grupo,
        a.nr_sequencia,
        b.nr_sequencia nr_seq_genero
from    nut_grupo_genero a,
	nut_genero_alim b
where   b.nr_seq_genero_origem_imp = a.nr_seq_genero
and 	b.cd_estabelecimento = cd_estabelecimento_w
and	b.ie_situacao = 'A';


BEGIN

select 	obter_estabelecimento_ativo()
into STRICT 	cd_estabelecimento_w
;

update	nut_genero_alim
set 	ie_situacao = 'I',
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where 	cd_estabelecimento = cd_estabelecimento_w;

open c01;
loop
begin

	nut_genero_alim_w.nr_sequencia.delete;
	nut_genero_alim_w.cd_estabelecimento.delete;
	nut_genero_alim_w.cd_estab_origem_imp.delete;
	nut_genero_alim_w.cd_material.delete;
	nut_genero_alim_w.cd_unidade_medida.delete;
	nut_genero_alim_w.ds_genero.delete;
	nut_genero_alim_w.dt_atualizacao.delete;
	nut_genero_alim_w.ie_arred_req.delete;
	nut_genero_alim_w.ie_gerar_solic_compra.delete;
	nut_genero_alim_w.ie_mostra_item_extra.delete;
	nut_genero_alim_w.ie_situacao.delete;
	nut_genero_alim_w.nm_usuario.delete;
	nut_genero_alim_w.nr_seq_receita_origem_imp.delete;
	nut_genero_alim_w.nr_seq_tabela.delete;
	nut_genero_alim_w.nr_seq_tipo_alimento.delete;
	nut_genero_alim_w.qt_conversao.delete;
	nut_genero_alim_w.qt_fator_coccao.delete;
	nut_genero_alim_w.qt_fator_correcao.delete;
	nut_genero_alim_w.nr_seq_genero_origem_imp.delete;

	fetch c01 bulk collect
	into    nut_genero_alim_w.nr_sequencia,
		nut_genero_alim_w.cd_estabelecimento,
		nut_genero_alim_w.cd_estab_origem_imp,
		nut_genero_alim_w.cd_material,
		nut_genero_alim_w.cd_unidade_medida,
		nut_genero_alim_w.ds_genero,
		nut_genero_alim_w.dt_atualizacao,
		nut_genero_alim_w.ie_arred_req,
		nut_genero_alim_w.ie_gerar_solic_compra,
		nut_genero_alim_w.ie_mostra_item_extra,
		nut_genero_alim_w.ie_situacao,
		nut_genero_alim_w.nm_usuario,
		nut_genero_alim_w.nr_seq_receita_origem_imp,
		nut_genero_alim_w.nr_seq_tabela,
		nut_genero_alim_w.nr_seq_tipo_alimento,
		nut_genero_alim_w.qt_conversao,
		nut_genero_alim_w.qt_fator_coccao,
		nut_genero_alim_w.qt_fator_correcao,
		nut_genero_alim_w.nr_seq_genero_origem_imp
	limit 	pls_util_pck.qt_registro_transacao_w;

	exit when nut_genero_alim_w.nr_sequencia.count = 0;

	forall gen_alim in nut_genero_alim_w.nr_sequencia.first .. nut_genero_alim_w.nr_sequencia.last
	insert into nut_genero_alim(   nr_sequencia,
				    cd_estabelecimento,
				    cd_estab_origem_imp,
				    cd_material,
				    cd_unidade_medida,
				    ds_genero,
				    dt_atualizacao,
				    ie_arred_req,
				    ie_gerar_solic_compra,
				    ie_mostra_item_extra,
				    ie_situacao,
				    nm_usuario,
				    nr_seq_receita_origem_imp,
				    nr_seq_tabela,
				    nr_seq_tipo_alimento,
				    qt_conversao,
				    qt_fator_coccao,
				    qt_fator_correcao,
				    nr_seq_genero_origem_imp)
	values ( nextval('nut_genero_alim_seq'),
	    cd_estabelecimento_w,
	    cd_estab_p,
	    nut_genero_alim_w.cd_material(gen_alim),
	    nut_genero_alim_w.cd_unidade_medida(gen_alim),
	    nut_genero_alim_w.ds_genero(gen_alim),
	    clock_timestamp(),
	    nut_genero_alim_w.ie_arred_req(gen_alim),
	    nut_genero_alim_w.ie_gerar_solic_compra(gen_alim),
	    nut_genero_alim_w.ie_mostra_item_extra(gen_alim),
	    nut_genero_alim_w.ie_situacao(gen_alim),
	    nm_usuario_p,
	    nut_genero_alim_w.nr_seq_receita_origem_imp(gen_alim),
	    cd_tab_comp_alim_p,
	    nut_genero_alim_w.nr_seq_tipo_alimento(gen_alim),
	    nut_genero_alim_w.qt_conversao(gen_alim),
	    nut_genero_alim_w.qt_fator_coccao(gen_alim),
	    nut_genero_alim_w.qt_fator_correcao(gen_alim),
	    nut_genero_alim_w.nr_sequencia(gen_alim));
	
	commit;

exception
when others then
	CALL gravar_log_nutricao(68628, 'Erro imp genero: '||substr(dbms_utility.format_call_stack,1,1500)
				||' Estab orig: '||cd_estab_p, nm_usuario_p);
end;

end loop;
close c01;

open c02;
loop
begin	
	nut_comp_nutricional_w.dt_atualizacao.delete;
	nut_comp_nutricional_w.ie_informacao.delete;
	nut_comp_nutricional_w.nm_usuario.delete;
	nut_comp_nutricional_w.nr_seq_apresent.delete;
	nut_comp_nutricional_w.nr_seq_nutriente.delete;
	nut_comp_nutricional_w.nr_sequencia.delete;
	nut_comp_nutricional_w.qt_composicao.delete;
	nut_comp_nutricional_w.nr_seq_genero.delete;
	
	fetch c02 bulk collect
	into    nut_comp_nutricional_w.dt_atualizacao,
	    nut_comp_nutricional_w.ie_informacao,
	    nut_comp_nutricional_w.nm_usuario,
	    nut_comp_nutricional_w.nr_seq_apresent,
	    nut_comp_nutricional_w.nr_seq_nutriente,
	    nut_comp_nutricional_w.nr_sequencia,
	    nut_comp_nutricional_w.qt_composicao,
	    nut_comp_nutricional_w.nr_seq_genero
	limit	pls_util_pck.qt_registro_transacao_w;

	exit when nut_comp_nutricional_w.nr_sequencia.count = 0;

	forall nut_comp_nut in nut_comp_nutricional_w.nr_sequencia.first .. nut_comp_nutricional_w.nr_sequencia.last
	insert into nut_comp_nutricional(  dt_atualizacao,
					ie_informacao,
					nm_usuario,
					nr_seq_apresent,
					nr_seq_nutriente,
					nr_sequencia,
					qt_composicao,
					nr_seq_gen_alim)
	values (clock_timestamp(),
		nut_comp_nutricional_w.ie_informacao(nut_comp_nut),
		nm_usuario_p,
		nut_comp_nutricional_w.nr_seq_apresent(nut_comp_nut),
		nut_comp_nutricional_w.nr_seq_nutriente(nut_comp_nut),
		nextval('nut_comp_nutricional_seq'),
		nut_comp_nutricional_w.qt_composicao(nut_comp_nut),
		nut_comp_nutricional_w.nr_seq_genero(nut_comp_nut));
	commit;

exception
when others then
	CALL gravar_log_nutricao(68629, 'Erro imp comp nut: '||substr(dbms_utility.format_call_stack,1,1500)
				||' Estab orig: '||cd_estab_p, nm_usuario_p);
end;

end loop;
close c02;
	
open c03;
loop
begin
	nut_grupo_genero_w.dt_atualizacao.delete;
	nut_grupo_genero_w.dt_atualizacao_nrec.delete;
	nut_grupo_genero_w.nr_seq_grupo.delete;
	nut_grupo_genero_w.nr_sequencia.delete;
	nut_grupo_genero_w.nr_seq_genero.delete;

	fetch 	c03 bulk collect
	into    nut_grupo_genero_w.dt_atualizacao,
		nut_grupo_genero_w.dt_atualizacao_nrec,
		nut_grupo_genero_w.nr_seq_grupo,
		nut_grupo_genero_w.nr_sequencia,
		nut_grupo_genero_w.nr_seq_genero
	limit 	pls_util_pck.qt_registro_transacao_w;

	exit when nut_grupo_genero_w.nr_sequencia.count = 0;

	forall nut_gr_gen in nut_grupo_genero_w.nr_sequencia.first .. nut_grupo_genero_w.nr_sequencia.last
	insert into nut_grupo_genero(dt_atualizacao,
				dt_atualizacao_nrec,
				nr_seq_grupo,
				nr_sequencia,
				nr_seq_genero,
				nm_usuario)
	values (   clock_timestamp(),
		clock_timestamp(),
		nut_grupo_genero_w.nr_seq_grupo(nut_gr_gen),
		nextval('nut_grupo_genero_seq'),
		nut_grupo_genero_w.nr_seq_genero(nut_gr_gen),
		nm_usuario_p);
		commit;
		
exception
when others then
	CALL gravar_log_nutricao(68630, 'Erro imp grup nut: '||substr(dbms_utility.format_call_stack,1,1500)
				||' Estab orig: '||cd_estab_p, nm_usuario_p);
end;

end loop;
close c03;

if (ie_importar_receitas_p = 'S') then
	CALL nut_imp_receita_estab(	cd_estabelecimento_w,
			cd_estab_p,
			nm_usuario_p,
			cd_tab_comp_alim_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_imp_genero_alim_estab (cd_estab_p bigint, cd_tab_comp_alim_p bigint, ie_importar_receitas_p text, nm_usuario_p text) FROM PUBLIC;

