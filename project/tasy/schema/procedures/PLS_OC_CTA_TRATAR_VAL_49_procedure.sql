-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_49 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de duplicidade de guia
------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
!!!!!!!!
CUIDADO REDOBRADO AO ALTERAR ESSA VALIDAÇÃO, ELA PREVINE QUE A MESMA CONTA SEJA
PAGA DUAS VEZES!
ALÉM DISSO, QUALQUER RESTRICAO A MAIS QUE FOR CRIADA NO SELECT, DEVE SER PARAMETRIZAVEL
E POR PADRAO NAO FAZER.
!!!!!!!!
------------------------------------------------------------------------------------------------------------------
dlehmkuhl OS 688483 - 14/04/2014 -

Alteração:  Modificada a forma de trabalho em relação a atualização dos campos de controle
    que basicamente decidem se a ocorrência será ou não gerada. Foi feita também a
    substituição da rotina obterX_seX_geraX.

Motivo: Necessário realizar essas alterações para corrigir bugs principalmente no que se
    refere a questão de aplicação de filtros (passo anterior ao da validação). Também
    tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
    para não inviabilizar a nova solicitação que diz que a exceção deve verificar todo
    o atendimento.
------------------------------------------------------------------------------------------------------------------
dlehmkuhl OS 688483 - 14/04/2014 -

Alteração:  Alterado para não utilizar group by e habing no exists.

Motivo: A ocorrência só seria gerada quando houvesse a partir de 3 guias iguais e além disso
    como o comando está em um exists é muito mais rápido verificarmos sem agrupar.
------------------------------------------------------------------------------------------------------------------
jjkruk OS 754395 - 01/07/2014 -

Alteração:  Incluida validacao por nr_documento
Motivo:     Validar se o documento ja foi apresentado para contas de reembolso
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_sql_w           	 	varchar(4000);
ds_sql_2_w          		varchar(4000);
ds_sql_2_aux_w          	varchar(4000);
ds_sql_2_original_w     	varchar(4000);
nr_seq_selecao_w        	dbms_sql.number_table;
ds_observacao_w         	dbms_sql.varchar2_table;
nr_seq_conta_w          	dbms_sql.number_table;
nr_documento_w          	dbms_sql.varchar2_table;
cd_guia_pesquisa_w      	dbms_sql.varchar2_table;
cd_guia_prestador_w     	dbms_sql.varchar2_table;
cd_guia_ref_w     		dbms_sql.varchar2_table;
cd_guia_prestador_imp_w     	dbms_sql.varchar2_table;
nr_seq_segurado_w       	dbms_sql.number_table;
nr_seq_prestador_exec_w     	dbms_sql.varchar2_table;
nr_seq_prestador_exec_imp_w 	dbms_sql.varchar2_table;
nr_seq_lote_conta_w     	dbms_sql.number_table;
nr_protocolo_prestador_w    	dbms_sql.varchar2_table;
nr_seq_protocolo_w      	dbms_sql.number_table;
ie_origem_conta_w       	dbms_sql.varchar2_table;
ie_tipo_faturamento_w       	dbms_sql.varchar2_table;
ie_tipo_faturamento_imp_w       dbms_sql.varchar2_table;
cd_senha_w      		dbms_sql.varchar2_table;
cd_senha_imp_w      		dbms_sql.varchar2_table;
dados_tb_selecao_w      	pls_tipos_ocor_pck.dados_table_selecao_ocor;
v_cur               		pls_util_pck.t_cursor;

var_cur_w           		integer;
var_exec_w          		integer;
var_retorno_w           	integer;
nr_idx_w            		integer := 0;

-- Informações da validação de situação inativa do prestador
C02 CURSOR(    nr_seq_oc_cta_comb_p    dados_regra_p.nr_sequencia%type) FOR
SELECT  a.nr_sequencia  nr_seq_validacao,
	a.ie_restringe_segurado,
	a.ie_mesmo_prestador,
	a.ie_considera_cta_cancelada,
	a.ie_considera_prot_rejeitado,
	a.ie_mesma_apresentacao,
	a.ie_documento,
	coalesce(a.ie_mesmo_protocolo,'N') ie_mesmo_protocolo,
	coalesce(a.ie_mesmo_tipo_faturamento,'N') ie_mesmo_tipo_faturamento,
	coalesce(a.ie_mesma_senha,'N') ie_mesma_senha,
	coalesce(a.ie_conta_glosada,'N') ie_conta_glosada
from    pls_oc_cta_val_duplic_guia a
where   a.nr_seq_oc_cta_comb    = nr_seq_oc_cta_comb_p;
BEGIN
-- Deve se ter a informação da regra para que a validação seja aplicada.
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then
    /* Select Básico */

    ds_sql_w    :=  'select a.nr_sequencia nr_seq_selecao, ' || pls_util_pck.enter_w ||
                '   	null ds_observacao, ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.nr_sequencia nr_seq_conta, ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.nr_documento, ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.cd_guia_pesquisa, ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.cd_guia_prestador , ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.cd_guia_prestador_imp , ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.nr_seq_segurado , ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.nr_seq_lote_conta, ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.nr_protocolo_prestador, ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.nr_seq_protocolo, ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.ie_origem_conta,  ' ||pls_tipos_ocor_pck.enter_w||
                '   	b.nr_seq_prestador_exec,  ' ||pls_tipos_ocor_pck.enter_w||
		'   	b.nr_seq_prestador_exec_imp,  ' ||pls_tipos_ocor_pck.enter_w||
		'   	nvl(b.ie_tipo_faturamento,''T'') ie_tipo_faturamento, ' ||pls_tipos_ocor_pck.enter_w||
		'   	nvl(b.ie_tipo_faturamento_imp,''T'') ie_tipo_faturamento_imp, ' ||pls_tipos_ocor_pck.enter_w||
		'   	b.cd_senha,  ' ||pls_tipos_ocor_pck.enter_w||
		'   	b.cd_senha_imp,  ' ||pls_tipos_ocor_pck.enter_w||
		'   	b.cd_guia_ref ' ||pls_tipos_ocor_pck.enter_w||
                'from   pls_conta_v         b, ' || pls_util_pck.enter_w ||
                '   	pls_oc_cta_selecao_ocor_v a ' || pls_util_pck.enter_w ||
                'where  a.nr_seq_conta = b.nr_sequencia ' || pls_util_pck.enter_w ||
                'and    a.ie_valido = ' || pls_util_pck.aspas_w || 'S' || pls_util_pck.aspas_w || pls_util_pck.enter_w ||
                'and    a.nr_id_transacao = :nr_id_transacao ' || pls_util_pck.enter_w;

    -- Buscar os dados da regra de validação conforme montado pelo usuário.
    for r_C02_w in C02(dados_regra_p.nr_sequencia) loop

        ds_sql_2_w  := '    select  ''Protocolo '' || to_char(x.nr_seq_protocolo) || '' do lote ('' || to_char(x.nr_seq_lote_conta) || ' ||
                        ' ''), importado por '' || nvl(x.nm_usuario_conta_nrec,x.nm_usuario_prot_nrec) || '' em '' || to_char(x.dt_atualizacao_prot_nrec,''dd/mm/yyyy hh24:mi:ss'') ds_obervacao ' ||pls_tipos_ocor_pck.enter_w||
                   '    from    pls_conta_v x ' || pls_util_pck.enter_w ||
                   '    where   x.nr_sequencia <> :nr_seq_conta ' || pls_util_pck.enter_w;

        -- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
        CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

        if (r_C02_w.ie_documento = 'D') then
		ds_sql_2_w := ds_sql_2_w || '   and x.nr_documento = :nr_documento ' || pls_util_pck.enter_w;
        elsif (r_C02_w.ie_documento = 'G') then
		ds_sql_2_w := ds_sql_2_w || '   and x.cd_guia_pesquisa = :cd_guia_pesquisa ' || pls_util_pck.enter_w;
        elsif (r_C02_w.ie_documento = 'P') then
		ds_sql_2_w := ds_sql_2_w || '   and x.cd_guia_prestador = :cd_guia_prestador ' || pls_util_pck.enter_w;
	elsif (r_C02_w.ie_documento = 'R') then
		ds_sql_2_w := ds_sql_2_w || '   and x.cd_guia_ref = :cd_guia_ref ' || pls_util_pck.enter_w;
        end if;

        -- Restricoes conforme regra (restricoes do subselect)
        if (r_C02_w.ie_restringe_segurado = 'S') then
            ds_sql_2_w := ds_sql_2_w || '   and     x.nr_seq_segurado = :nr_seq_segurado' || pls_util_pck.enter_w;
        end if;

        if (r_C02_w.ie_mesmo_prestador = 'S') then

		if (dados_regra_p.ie_evento = 'IMP') then
			ds_sql_2_w := ds_sql_2_w || '   and     x.nr_seq_prestador_exec_imp = :nr_seq_prestador_exec_imp' || pls_util_pck.enter_w;
		else
			ds_sql_2_w := ds_sql_2_w || '   and     x.nr_seq_prestador_exec = :nr_seq_prestador_exec' || pls_util_pck.enter_w;
		end if;
        end if;

        if (r_C02_w.ie_considera_cta_cancelada = 'N') then
		ds_sql_2_w := ds_sql_2_w || '   and     x.ie_status <> ' || pls_util_pck.aspas_w || 'C' || pls_util_pck.aspas_w || pls_util_pck.enter_w;
        end if;
        if (r_C02_w.ie_considera_prot_rejeitado = 'N') then
		ds_sql_2_w := ds_sql_2_w || '   and     x.ie_situacao_protocolo <> ' || pls_util_pck.aspas_w || 'RE' || pls_util_pck.aspas_w || pls_util_pck.enter_w;
        end if;

        if (r_C02_w.ie_mesma_apresentacao = 'S') then
            ds_sql_2_w := ds_sql_2_w || '   and  ((x.nr_seq_lote_conta is null) or (x.nr_seq_lote_conta <> :nr_seq_lote_conta)) '|| pls_util_pck.enter_w;
        end if;

        if (r_C02_w.ie_mesmo_protocolo = 'S') then
            ds_sql_2_w := ds_sql_2_w || '   and     x.nr_seq_protocolo = :nr_seq_protocolo' || pls_util_pck.enter_w;
        end if;

	if (r_C02_w.ie_mesmo_tipo_faturamento = 'S') then
		if (dados_regra_p.ie_evento = 'IMP') then
			ds_sql_2_w := ds_sql_2_w || '   and     x.ie_tipo_faturamento_imp = :ie_tipo_faturamento_imp' || pls_util_pck.enter_w;
		else
			ds_sql_2_w := ds_sql_2_w || '   and     x.ie_tipo_faturamento = :ie_tipo_faturamento' || pls_util_pck.enter_w;
		end if;
	end if;

	if (r_C02_w.ie_mesma_senha = 'S') then
		if (dados_regra_p.ie_evento = 'IMP') then
			ds_sql_2_w := ds_sql_2_w || '   and     x.cd_senha_imp = :cd_senha_imp' || pls_util_pck.enter_w;
		else
			ds_sql_2_w := ds_sql_2_w || '   and     x.cd_senha = :cd_senha' || pls_util_pck.enter_w;
		end if;
	end if;

	if (r_C02_w.ie_conta_glosada = 'S') then
		ds_sql_2_w := ds_sql_2_w || '   and     x.ie_glosa <> ''S'' 	' || pls_util_pck.enter_w;
	end if;

	begin
            open v_cur for EXECUTE ds_sql_w using   nr_id_transacao_p;
            loop
                nr_seq_selecao_w.delete;
                ds_observacao_w.delete;
                nr_seq_conta_w.delete;
                nr_documento_w.delete;
                cd_guia_pesquisa_w.delete;
                cd_guia_prestador_w.delete;
                cd_guia_prestador_imp_w.delete;
                nr_seq_segurado_w.delete;
                nr_seq_lote_conta_w.delete;
                nr_protocolo_prestador_w.delete;
                ie_origem_conta_w.delete;
		nr_seq_prestador_exec_w.delete;
		nr_seq_prestador_exec_imp_w.delete;
		ie_tipo_faturamento_w.delete;
		ie_tipo_faturamento_imp_w.delete;
		cd_senha_w.delete;
		cd_senha_imp_w.delete;
		cd_guia_ref_w.delete;
                fetch v_cur bulk collect
                into    nr_seq_selecao_w, ds_observacao_w,nr_seq_conta_w,
			nr_documento_w,cd_guia_pesquisa_w,cd_guia_prestador_w,
			cd_guia_prestador_imp_w, nr_seq_segurado_w,nr_seq_lote_conta_w,
			nr_protocolo_prestador_w, nr_seq_protocolo_w, ie_origem_conta_w,
			nr_seq_prestador_exec_w, nr_seq_prestador_exec_imp_w, ie_tipo_faturamento_w,
			ie_tipo_faturamento_imp_w, cd_senha_w, cd_senha_imp_w, cd_guia_ref_w
                limit pls_util_cta_pck.qt_registro_transacao_w;
                exit when nr_seq_selecao_w.count = 0;

                if (nr_seq_selecao_w.count > 0) then
                    for i in nr_seq_selecao_w.first..nr_seq_selecao_w.last loop
                        ds_sql_2_aux_w      := '';
                        ds_sql_2_original_w := '';

                        --aaschlote 24/07/2015 OS 914546 - Caso a origem da conta seja A500 ou A700, só verifica contas esses tipos, senão verifica outros tipos de conta que não seja A500 ou A700
                        if (ie_origem_conta_w(i) in ('A','Z')) then
                            ds_sql_2_aux_w  := '    and     x.ie_origem_conta  in (''A'',''Z'') ' || pls_util_pck.enter_w;
                        else
                            ds_sql_2_aux_w  := '    and     x.ie_origem_conta  not in (''A'',''Z'') ' || pls_util_pck.enter_w;
                        end if;

			-- se a conta enviada for "Total", deve olhar todas as guias, senão deve olhar apenas as guias do tipo "total".
			-- é importante para os casos onde os prestadores enviem guias parciais e complementares
			if (dados_regra_p.ie_evento = 'IMP') then
				if (pls_obter_tipo_faturamento(ie_tipo_faturamento_imp_w(i)) <> 'T') then
					ds_sql_2_aux_w := ds_sql_2_aux_w || '    and	nvl(x.ie_tipo_faturamento, ''T'') = ''T'' ' || pls_util_pck.enter_w;
				end if;
			else
				if (ie_tipo_faturamento_w(i) <> 'T') then
					ds_sql_2_aux_w := ds_sql_2_aux_w || '    and	nvl(x.ie_tipo_faturamento, ''T'') = ''T'' ' || pls_util_pck.enter_w;
				end if;
			end if;

                        ds_sql_2_original_w := ds_sql_2_w || ds_sql_2_aux_w||' order by nr_sequencia';

                        var_cur_w := dbms_sql.open_cursor;
                        dbms_sql.parse(var_cur_w, ds_sql_2_original_w, 1);
                        dbms_sql.bind_variable(var_cur_w, ':nr_seq_conta', nr_seq_conta_w(i));

                        if (r_C02_w.ie_documento = 'D') then
				dbms_sql.bind_variable(var_cur_w, ':nr_documento', nr_documento_w(i));
                        elsif (r_C02_w.ie_documento = 'G') then
				dbms_sql.bind_variable(var_cur_w, ':cd_guia_pesquisa', cd_guia_pesquisa_w(i));
                        elsif (r_C02_w.ie_documento = 'P') then
				dbms_sql.bind_variable(var_cur_w, ':cd_guia_prestador', cd_guia_prestador_w(i));
			elsif (r_C02_w.ie_documento = 'R') then
				dbms_sql.bind_variable(var_cur_w, ':cd_guia_ref', cd_guia_ref_w(i));
                        end if;

                        if (r_C02_w.ie_restringe_segurado = 'S') then
                            dbms_sql.bind_variable(var_cur_w, ':nr_seq_segurado', nr_seq_segurado_w(i));
                        end if;

                        if (r_C02_w.ie_mesmo_prestador = 'S') then

				if (dados_regra_p.ie_evento = 'IMP') then
					dbms_sql.bind_variable(var_cur_w, ':nr_seq_prestador_exec_imp', nr_seq_prestador_exec_imp_w(i));
				else
					dbms_sql.bind_variable(var_cur_w, ':nr_seq_prestador_exec', nr_seq_prestador_exec_w(i));
				end if;
                        end if;

                        if (r_C02_w.ie_mesma_apresentacao = 'S') then
                            dbms_sql.bind_variable(var_cur_w, ':nr_seq_lote_conta', nr_seq_lote_conta_w(i));
                        end if;

                        if (r_C02_w.ie_mesmo_protocolo = 'S') then
                            dbms_sql.bind_variable(var_cur_w, ':nr_seq_protocolo', nr_seq_protocolo_w(i));
                        end if;

			if (r_C02_w.ie_mesmo_tipo_faturamento = 'S') then
				if (dados_regra_p.ie_evento = 'IMP') then
					dbms_sql.bind_variable(var_cur_w, ':ie_tipo_faturamento_imp', ie_tipo_faturamento_imp_w(i));
				else
					dbms_sql.bind_variable(var_cur_w, ':ie_tipo_faturamento', ie_tipo_faturamento_w(i));
				end if;
			end if;

			if (r_C02_w.ie_mesma_senha = 'S') then
				if (dados_regra_p.ie_evento = 'IMP') then
					dbms_sql.bind_variable(var_cur_w, ':cd_senha_imp', cd_senha_imp_w(i));
				else
					dbms_sql.bind_variable(var_cur_w, ':cd_senha', cd_senha_w(i));
				end if;
			end if;

                        dbms_sql.define_column(var_cur_w, 1, ds_observacao_w(i),255);

                        var_exec_w := dbms_sql.execute(var_cur_w);

                        loop
                            var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
                            exit when var_retorno_w = 0;

                            dbms_sql.column_value(var_cur_w, 1, ds_observacao_w(i));

                        end loop;
                        dbms_sql.close_cursor(var_cur_w);

                        if ((ds_observacao_w(i) IS NOT NULL AND (ds_observacao_w(i))::text <> '')) then
                            dados_tb_selecao_w.ie_valido(nr_idx_w)      := 'S';
                            dados_tb_selecao_w.nr_seq_selecao(nr_idx_w) := nr_seq_selecao_w(i);
                            dados_tb_selecao_w.ds_observacao(nr_idx_w)  := ds_observacao_w(i);

                            if (nr_idx_w = pls_util_cta_pck.qt_registro_transacao_w) then
                                CALL pls_tipos_ocor_pck.gerencia_selecao_validacao( dados_tb_selecao_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
                                                        'SEQ', dados_tb_selecao_w.ds_observacao, dados_tb_selecao_w.ie_valido, nm_usuario_p);
                                nr_idx_w := 0;
                                pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_selecao_w);
                            else
                                nr_idx_w := nr_idx_w + 1;
                            end if;
                        end if;

                    end loop;
                end if;

            end loop;
            close v_cur;

            -- Atualizar a situação do item para geração da ocorrência.
            if (nr_idx_w > 0)  then
                CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(  dados_tb_selecao_w.nr_seq_selecao, pls_util_cta_pck.clob_table_vazia_w,
                                        'SEQ', dados_tb_selecao_w.ds_observacao, dados_tb_selecao_w.ie_valido, nm_usuario_p);
            end if;

        exception
        when others then
            --Fecha cursor
            if (v_cur%isopen) then

                close v_cur;
            end if;

            -- Insere o log na tabela e aborta a operação
            CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p,ds_sql_w,nr_id_transacao_p,nm_usuario_p);
        end;
    end loop; -- C02
    -- seta os registros que serão válidos ou inválidos após o processamento
    CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_49 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
