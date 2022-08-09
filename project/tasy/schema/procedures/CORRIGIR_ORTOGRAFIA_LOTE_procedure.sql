-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE corrigir_ortografia_lote ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


/*

ie_acao_p

C	Confirmar correção ortográfica
D	Desfazer confirmação da correção

*/
nm_tabela_origem_w		varchar(50);
ie_diferenca_w			varchar(1);

nm_atributo_w			varchar(50);
nm_tabela_w			varchar(50);
nr_seq_visao_w			bigint;
nr_seq_objeto_w			bigint;
nr_seq_obj_filtro_w		bigint;
nr_seq_cor_w			bigint;
cd_dominio_w			integer;
vl_dominio_w			varchar(15);
cd_funcao_w			integer;
nr_seq_parametro_w		integer;
nr_seq_relatorio_w		bigint;
nr_seq_campo_relat_w		bigint;
nr_seq_param_relat_w		bigint;
nr_seq_ind_gestao_w		analise_ortografica.nr_seq_ind_gestao%type;
nr_seq_ind_gestao_atrib_w	analise_ortografica.nr_seq_ind_gestao_atrib%type;
nr_seq_subind_gestao_w		analise_ortografica.nr_seq_subind_gestao%type;
nr_seq_subind_gestao_atrib_w	analise_ortografica.nr_seq_subind_gestao_atrib%type;
cd_interface_w			interface.cd_interface%type;
nr_seq_referencia_w		analise_ortografica.nr_seq_referencia%type;
cd_tipo_lote_contabil_w		analise_ortografica.cd_tipo_lote_contabil%type;
cd_expressao_w			dic_expressao.cd_expressao%type;

ds_campo_w		varchar(255);
ds_conteudo_campo_w	varchar(4000);

c01 CURSOR FOR
SELECT	a.ie_diferenca,
	a.nm_tabela_origem,
	a.nr_seq_visao,
	a.nr_seq_objeto,
	a.nr_seq_obj_filtro,
	a.nr_seq_cor,
	a.cd_dominio,
	a.vl_dominio,
	a.cd_funcao,
	a.nr_seq_parametro,
	a.nm_atributo,
	a.nm_tabela,
	a.nr_seq_relatorio,
	a.nr_seq_campo_relat,
	a.nr_seq_param_relat,
	a.ds_campo,
	a.ds_conteudo_campo,
	a.nr_seq_ind_gestao,
	a.nr_seq_ind_gestao_atrib,
	a.nr_seq_subind_gestao,
	a.nr_seq_subind_gestao_atrib,
	a.cd_interface,
	a.nr_seq_referencia,
	a.cd_tipo_lote_contabil,
	a.cd_expressao
from	analise_ortografica a
where	coalesce(a.ie_diferenca,'N')	= 'S'
and	a.nr_seq_lote		= nr_seq_lote_p
and	coalesce(ie_acao_p,'C')	= 'C'

union

select	b.ie_diferenca,
	b.nm_tabela_origem,
	b.nr_seq_visao,
	b.nr_seq_objeto,
	b.nr_seq_obj_filtro,
	b.nr_seq_cor,
	b.cd_dominio,
	b.vl_dominio,
	b.cd_funcao,
	b.nr_seq_parametro,
	b.nm_atributo,
	b.nm_tabela,
	b.nr_seq_relatorio,
	b.nr_seq_campo_relat,
	b.nr_seq_param_relat,
	b.ds_campo,
	b.ds_conteudo_campo,
	b.nr_seq_ind_gestao,
	b.nr_seq_ind_gestao_atrib,
	b.nr_seq_subind_gestao,
	b.nr_seq_subind_gestao_atrib,
	b.cd_interface,
	b.nr_seq_referencia,
	b.cd_tipo_lote_contabil,
	b.cd_expressao
from	analise_ortografica b,
	analise_ortografica a
where	a.nr_seq_origem		= b.nr_sequencia
and	coalesce(a.ie_diferenca,'N')	= 'S'
and	a.nr_seq_lote		= nr_seq_lote_p
and	coalesce(ie_acao_p,'C')	= 'D';


BEGIN

open	c01;
loop
fetch	c01 into
	ie_diferenca_w,
	nm_tabela_origem_w,
	nr_seq_visao_w,
	nr_seq_objeto_w,
	nr_seq_obj_filtro_w,
	nr_seq_cor_w,
	cd_dominio_w,
	vl_dominio_w,
	cd_funcao_w,
	nr_seq_parametro_w,
	nm_atributo_w,
	nm_tabela_w,
	nr_seq_relatorio_w,
	nr_seq_campo_relat_w,
	nr_seq_param_relat_w,
	ds_campo_w,
	ds_conteudo_campo_w,
	nr_seq_ind_gestao_w,
	nr_seq_ind_gestao_atrib_w,
	nr_seq_subind_gestao_w,
	nr_seq_subind_gestao_atrib_w,
	cd_interface_w,
	nr_seq_referencia_w,
	cd_tipo_lote_contabil_w,
	cd_expressao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (nm_tabela_origem_w	= 'TABELA_ATRIBUTO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update tabela_atributo' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nm_atributo = :nm_atributo and nm_tabela = :nm_tabela',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nm_atributo=' || nm_atributo_w || ';nm_tabela=' || nm_tabela_w || ';');

	elsif (nm_tabela_origem_w	= 'TABELA_VISAO_ATRIBUTO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update tabela_visao_atributo' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nm_atributo = :nm_atributo and nr_sequencia = :nr_seq_visao',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nm_atributo=' || nm_atributo_w || ';nr_seq_visao=' || nr_seq_visao_w || ';');

	elsif (nm_tabela_origem_w	= 'DIC_OBJETO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update dic_objeto' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_sequencia = :nr_seq_objeto',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_objeto=' || nr_seq_objeto_w || ';');

	elsif (nm_tabela_origem_w	= 'DIC_OBJETO_FILTRO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update dic_objeto_filtro' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_sequencia = :nr_seq_obj_filtro and nr_seq_objeto = :nr_seq_objeto',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_obj_filtro=' || nr_seq_obj_filtro_w || ';nr_seq_objeto=' || nr_seq_objeto_w || ';');

	elsif (nm_tabela_origem_w	= 'TASY_PADRAO_COR') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update tasy_padrao_cor' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_sequencia = :nr_seq_cor',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_cor=' || nr_seq_cor_w || ';');

	elsif (nm_tabela_origem_w	= 'VALOR_DOMINIO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update valor_dominio' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where cd_dominio = :cd_dominio and vl_dominio = :vl_dominio',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';cd_dominio=' || cd_dominio_w || ';vl_dominio=' || vl_dominio_w || ';');

	elsif (nm_tabela_origem_w	= 'FUNCAO_PARAMETRO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update funcao_parametro' ||
					' set ' || ds_campo_w || ' = ' || chr(39) || ds_conteudo_campo_w || chr(39) ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where cd_funcao = :cd_funcao and nr_sequencia = :nr_seq_parametro',
					'nm_usuario=' || nm_usuario_p || ';cd_funcao=' || cd_funcao_w || ';nr_seq_parametro=' || nr_seq_parametro_w || ';');

	elsif (nm_tabela_origem_w	= 'RELATORIO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update relatorio' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_sequencia = :nr_seq_relatorio',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_relatorio=' || nr_seq_relatorio_w || ';');

	elsif (nm_tabela_origem_w	= 'BANDA_RELAT_CAMPO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update banda_relat_campo a' ||
					' set a.' || ds_campo_w || ' = :ds_campo' ||
					', a.dt_atualizacao = sysdate' ||
					', a.nm_usuario = :nm_usuario' ||
					' where a.nr_sequencia = :nr_seq_campo_relat' ||
					' and exists (select 1 from banda_relatorio x where x.nr_seq_relatorio = :nr_seq_relatorio and x.nr_sequencia = a.nr_seq_banda)',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_campo_relat=' || nr_seq_campo_relat_w || ';nr_seq_relatorio=' || nr_seq_relatorio_w || ';');

	elsif (nm_tabela_origem_w	= 'RELATORIO_PARAMETRO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update relatorio_parametro' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_seq_relatorio = :nr_seq_relatorio and nr_sequencia = :nr_seq_param_relat',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_relatorio=' || nr_seq_relatorio_w || ';nr_seq_param_relat=' || nr_seq_param_relat_w || ';');

	elsif (nm_tabela_origem_w	= 'DOMINIO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update dominio' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where cd_dominio = :cd_dominio',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';cd_dominio=' || cd_dominio_w || ';');

	elsif (nm_tabela_origem_w	= 'INDICADOR_GESTAO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update indicador_gestao' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_sequencia = :nr_seq_ind_gestao',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_ind_gestao=' || nr_seq_ind_gestao_w || ';');

	elsif (nm_tabela_origem_w	= 'INDICADOR_GESTAO_ATRIB') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update indicador_gestao_atrib' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_seq_ind_gestao = :nr_seq_ind_gestao' ||
					' and nr_sequencia = :nr_seq_ind_gestao_atrib',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_ind_gestao=' || nr_seq_ind_gestao_w || ';nr_seq_ind_gestao_atrib=' || nr_seq_ind_gestao_atrib_w || ';');

	elsif (nm_tabela_origem_w	= 'SUBINDICADOR_GESTAO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update subindicador_gestao' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_seq_indicador = :nr_seq_ind_gestao' ||
					' and nr_sequencia = :nr_seq_subind_gestao',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_ind_gestao=' || nr_seq_ind_gestao_w || ';nr_seq_subind_gestao=' || nr_seq_subind_gestao_w || ';');

	elsif (nm_tabela_origem_w	= 'SUBINDICADOR_GESTAO_ATRIB') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update subindicador_gestao_atrib' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_seq_subindicador = :nr_seq_subind_gestao' ||
					' and nr_sequencia = :nr_seq_subind_gestao_atrib',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_subind_gestao=' || nr_seq_subind_gestao_w || ';nr_seq_subind_gestao_atrib=' || nr_seq_subind_gestao_atrib_w || ';');

	elsif (nm_tabela_origem_w	= 'INTERFACE') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update interface' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where cd_interface = :cd_interface',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';cd_interface=' || cd_interface_w || ';');

	elsif (nm_tabela_origem_w	= 'FUNCAO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update funcao' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where cd_funcao = :cd_funcao',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';cd_funcao=' || cd_funcao_w || ';');

	elsif (nm_tabela_origem_w	= 'TIPO_LOTE_CONTABIL') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update tipo_lote_contabil' ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where cd_tipo_lote_contabil = :cd_tipo_lote_contabil',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';cd_tipo_lote_contabil=' || cd_tipo_lote_contabil_w || ';');

	elsif (nm_tabela_origem_w	= 'DIC_EXPRESSAO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update	dic_expressao' ||
					' set ' || ds_campo_w || '= :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario= :nm_usuario' ||
					' where	cd_expressao	= :cd_expressao',
					'ds_campo='|| ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';cd_expressao=' || cd_expressao_w || ';');

	elsif (nm_tabela_origem_w	= 'ANVISA_FORMA_FORMACEUTICA') or (nm_tabela_origem_w	= 'ANVISA_VIA_ADMINISTRACAO') or (nm_tabela_origem_w	= 'CLASSIFICACAO_PARAMETRO') or (nm_tabela_origem_w	= 'CONSISTENCIA_LIB_PEPO') or (nm_tabela_origem_w	= 'EHR_ARQUETIPO') or (nm_tabela_origem_w	= 'EHR_CEFALOCAUDAL') or (nm_tabela_origem_w	= 'EHR_DOENCA') or (nm_tabela_origem_w	= 'EHR_ELEMENTO') or (nm_tabela_origem_w	= 'EHR_ELEMENTO_VISUAL') or (nm_tabela_origem_w	= 'EHR_ENTIDADE_TASY') or (nm_tabela_origem_w	= 'EHR_ESPECIALIDADE') or (nm_tabela_origem_w	= 'EHR_GRUPO_ELEMENTO') or (nm_tabela_origem_w	= 'EHR_SUBGRUPO_ELEMENTO') or (nm_tabela_origem_w	= 'EHR_UNIDADE_MEDIDA') or (nm_tabela_origem_w	= 'FANEP_ITEM') or (nm_tabela_origem_w	= 'FICHA_FINANC_ITEM') or (nm_tabela_origem_w	= 'INCONSISTENCIA') or (nm_tabela_origem_w	= 'INCONSISTENCIA_ESCRIT') or (nm_tabela_origem_w	= 'MAN_SEVERIDADE') or (nm_tabela_origem_w	= 'OFT_ACAO') or (nm_tabela_origem_w	= 'OFTALMOLOGIA_ITEM') or (nm_tabela_origem_w	= 'PEP_ACAO') or (nm_tabela_origem_w	= 'PEPO_ACAO') or (nm_tabela_origem_w	= 'PEPO_ITEM') or (nm_tabela_origem_w	= 'PERGUNTA_RECUP_SENHA') or (nm_tabela_origem_w	= 'PRONTUARIO_ITEM') or (nm_tabela_origem_w	= 'PRONTUARIO_PASTA') or (nm_tabela_origem_w	= 'REGRA_CONSISTE_ONC') or (nm_tabela_origem_w	= 'REGRA_CONSISTE_PRESCR') or (nm_tabela_origem_w	= 'REGRA_CONSISTE_SAE') or (nm_tabela_origem_w	= 'SAEP_ITEM') or (nm_tabela_origem_w	= 'SAME_OPERACAO') or (nm_tabela_origem_w	= 'TIPO_AMPUTACAO') or (nm_tabela_origem_w	= 'TIPO_LOCALIZAR') or (nm_tabela_origem_w	= 'TIPO_LOCALIZAR_ATRIBUTO') or (nm_tabela_origem_w	= 'DIC_EXPRESSAO') then

		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'update ' || nm_tabela_origem_w ||
					' set ' || ds_campo_w || ' = :ds_campo' ||
					', dt_atualizacao = sysdate' ||
					', nm_usuario = :nm_usuario' ||
					' where nr_sequencia = :nr_seq_referencia',
					'ds_campo=' || ds_conteudo_campo_w || ';nm_usuario=' || nm_usuario_p || ';nr_seq_referencia=' || nr_seq_referencia_w || ';');

	end if;

end	loop;
close	c01;

CALL confirmar_correcao_ortografica(nr_seq_lote_p,ie_acao_p,nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE corrigir_ortografia_lote ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
