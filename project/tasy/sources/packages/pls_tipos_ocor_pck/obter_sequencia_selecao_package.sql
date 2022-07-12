-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_tipos_ocor_pck.obter_sequencia_selecao ( nr_seq_conta_proc_p pls_selecao_ocor_cta.nr_seq_conta_proc%type, nr_seq_conta_mat_p pls_selecao_ocor_cta.nr_seq_conta_mat%type, nr_seq_conta_p pls_selecao_ocor_cta.nr_seq_conta%type, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, ie_filtro_excecao_p pls_oc_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_selecao_ocor_cta.nr_seq_filtro%type, ie_regra_execao_p pls_oc_cta_combinada.ie_excecao%type, ie_filtro_validacao_p text, ie_registro_valido_p text default 'N', cd_guia_referencia_p pls_selecao_ocor_cta.cd_guia_referencia%type default null, nr_seq_segurado_p pls_selecao_ocor_cta.nr_seq_segurado%type default null) RETURNS text AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Retornar a sequencia de determinado item na tabela de selecao.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

jjung - OS 651768 - 18/10/2013 - Criacao da function.
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


cur_w			sql_pck.t_cursor;
dado_bind_w		sql_pck.t_dado_bind;

ds_sql_w		varchar(1000);
nr_sequencia_w		text;


BEGIN

-- Montar o select

ds_sql_w :=	'select	sel.nr_sequencia ' ||
		'from	pls_selecao_ocor_cta sel ' ||
		'where	sel.nr_id_transacao = :nr_id_transacao ';

dado_bind_w := sql_pck.bind_variable(':nr_id_transacao', nr_id_transacao_p, dado_bind_w);

-- Verifica sempre se e necessario obter somente os registros validos

if (ie_registro_valido_p = 'S') then

	ds_sql_w := ds_sql_w || ' and sel.ie_valido = ''S'' ';
end if;

-- Sempre que for filtros deve ser verficiado se o mesmo e de excecao.

if (ie_filtro_validacao_p = 'F') then

	-- O filtro que nao e de excecao so pode alterar os seus proprios registros, se for de excecao pode atualizar os registros de outros filtros.

	if (ie_regra_execao_p = 'N') then

		if (ie_filtro_excecao_p = 'N') then

			ds_sql_w := ds_sql_w || 'and	sel.nr_seq_filtro = :nr_seq_filtro ';
			dado_bind_w := sql_pck.bind_variable(':nr_seq_filtro', nr_seq_filtro_p, dado_bind_w);
		end if;
	end if;
end if;

-- se a conta for informada busca a conta

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	ds_sql_w := ds_sql_w || 'and	sel.nr_seq_conta = :nr_seq_conta ';
	dado_bind_w := sql_pck.bind_variable(':nr_seq_conta', nr_seq_conta_p, dado_bind_w);
end if;

-- Se o procedimento for informado busca o procedimento

if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then

	ds_sql_w := ds_sql_w || 'and	sel.nr_seq_conta_proc = :nr_seq_conta_proc ';
	dado_bind_w := sql_pck.bind_variable(':nr_seq_conta_proc', nr_seq_conta_proc_p, dado_bind_w);

-- Se nao , se o material estiver informado busca o material

elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then

	ds_sql_w := ds_sql_w || 'and	sel.nr_seq_conta_mat = :nr_seq_conta_mat ';
	dado_bind_w := sql_pck.bind_variable(':nr_seq_conta_mat', nr_seq_conta_mat_p, dado_bind_w);
end if;

-- Guia de referencia

if (cd_guia_referencia_p IS NOT NULL AND cd_guia_referencia_p::text <> '') then

	ds_sql_w := ds_sql_w || 'and	sel.cd_guia_referencia = :cd_guia_referencia ';
	dado_bind_w := sql_pck.bind_variable(':cd_guia_referencia', cd_guia_referencia_p, dado_bind_w);
end if;

-- Segurado;

if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then

	ds_sql_w := ds_sql_w || 'and	sel.nr_seq_segurado = :nr_seq_segurado ';
	dado_bind_w := sql_pck.bind_variable(':nr_seq_segurado', nr_seq_segurado_p, dado_bind_w);
end if;

-- Aqui monta o select que ira  retornar  todas as sequencias dos registros separados por virgula.

ds_sql_w :=	'select	pls_admin_cursor.obter_desc_cursor_gigante( cursor ( ' ||
		ds_sql_w || '), ''' || current_setting('pls_tipos_ocor_pck.ds_separador_selecao_w')::varchar(1) || '''' || ') '||
		'from dual';

-- Executar o comando

dado_bind_w := sql_pck.executa_sql_cursor(ds_sql_w, dado_bind_w);

-- Se deu certo a abertura

if (cur_w%isopen) then
	fetch cur_w into nr_sequencia_w;
	close cur_w;
end if;

return nr_sequencia_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_tipos_ocor_pck.obter_sequencia_selecao ( nr_seq_conta_proc_p pls_selecao_ocor_cta.nr_seq_conta_proc%type, nr_seq_conta_mat_p pls_selecao_ocor_cta.nr_seq_conta_mat%type, nr_seq_conta_p pls_selecao_ocor_cta.nr_seq_conta%type, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, ie_filtro_excecao_p pls_oc_cta_filtro.ie_excecao%type, nr_seq_filtro_p pls_selecao_ocor_cta.nr_seq_filtro%type, ie_regra_execao_p pls_oc_cta_combinada.ie_excecao%type, ie_filtro_validacao_p text, ie_registro_valido_p text default 'N', cd_guia_referencia_p pls_selecao_ocor_cta.cd_guia_referencia%type default null, nr_seq_segurado_p pls_selecao_ocor_cta.nr_seq_segurado%type default null) FROM PUBLIC;
