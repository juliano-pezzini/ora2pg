-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE mprev_base_cubo_pck.atualizar_pessoas ( nr_seq_regra_p mprev_regra_dados_cubo_ops.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Atualizar a base do cubo para pessoas e beneficiarios.
	Tabelas mprev_pessoa_cubo_ops e mprev_benef_cubo_ops.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
------------------------------------------------------------------------------------------------------------------

jjung 01/04/2014 - Criacao da rotina
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


c_regra_benef CURSOR(nr_seq_regra_dados_pc	mprev_regra_dados_cubo_ben.nr_seq_regra_dados%type) FOR
	SELECT	a.nr_sequencia,
		a.ie_preco,
		a.ie_situacao_contrato,
		a.ie_situacao_atend
	from	mprev_regra_dados_cubo_ben a
	where	a.nr_seq_regra_dados	= nr_seq_regra_dados_pc;

c_pf_end_pessoa CURSOR FOR
	SELECT	a.nr_sequencia,
		b.cd_municipio_ibge,
		b.ie_tipo_complemento,
    		b.sg_estado estado
	from	mprev_pessoa_cubo_ops a,
		compl_pessoa_fisica b
	where 	(b.cd_municipio_ibge IS NOT NULL AND b.cd_municipio_ibge::text <> '')
	and     a.cd_pessoa_fisica = b.cd_pessoa_fisica;	
	
ds_select_completo_w	varchar(4000);	
dados_restricao_w	pls_util_pck.dados_select;

cursor_w		sql_pck.t_cursor;
cursor_benef_w		sql_pck.t_cursor;

dados_regra_w		mprev_base_cubo_pck.dados_regra_benef;
table_pessoa_w		mprev_base_cubo_pck.table_pessoa;
table_benef_w		mprev_base_cubo_pck.table_benef;
table_endereco_pf_w	mprev_base_cubo_pck.table_endereco_pf_cubo;

BEGIN

if (nr_seq_regra_p IS NOT NULL AND nr_seq_regra_p::text <> '') then


	for r_c_regra_benef in c_regra_benef(nr_seq_regra_p) loop
		
		dados_regra_w.nr_sequencia		:= r_c_regra_benef.nr_sequencia;
		dados_regra_w.ie_preco			:= r_c_regra_benef.ie_preco;
		dados_regra_w.ie_situacao_contrato	:= r_c_regra_benef.ie_situacao_contrato;
		dados_regra_w.ie_situacao_atend		:= r_c_regra_benef.ie_situacao_atend;

		cursor_w := mprev_base_cubo_pck.obter_restr_benef('RESTRICAO', 'PESSOA', cursor_w, dados_regra_w, '');
		
		-- Montar select dinamico e criar as pessoas .

		ds_select_completo_w	:=	'select distinct ' || pls_util_pck.enter_w ||
						'	pessoa.cd_pessoa_fisica, ' || pls_util_pck.enter_w ||
						'	pessoa.dt_nascimento dt_nascimento, ' || pls_util_pck.enter_w ||
						'	pessoa.ie_sexo ie_sexo, ' || pls_util_pck.enter_w ||
						'	pessoa.nm_pessoa_fisica nm_pessoa_fisica ' ||
						dados_restricao_w.ds_campos || pls_util_pck.enter_w ||
						'from	pessoa_fisica		pessoa, ' || pls_util_pck.enter_w ||
						'	pls_segurado		benef ' || 
						dados_restricao_w.ds_tabelas || pls_util_pck.enter_w ||
						'where	benef.cd_pessoa_fisica = pessoa.cd_pessoa_fisica ' || pls_util_pck.enter_w ||
						'and	pessoa.dt_nascimento is not null ' || 
						dados_restricao_w.ds_restricao;
						
		cursor_w := mprev_base_cubo_pck.obter_restr_benef('EXECUTAR', 'PESSOA', cursor_w, dados_regra_w, ds_select_completo_w);
		
		
		-- Verificar se o cursor esta aberto.

		if (cursor_w%isopen) then
			begin			
			
			-- Gravar as pessoas na tabela;

			loop
				fetch cursor_w bulk collect
				into	table_pessoa_w.cd_pessoa_fisica, table_pessoa_w.dt_nascimento,
					table_pessoa_w.ie_sexo, table_pessoa_w.nm_pessoa_fisica
				limit current_setting('mprev_base_cubo_pck.qt_reg_commit_w')::integer;
				
				exit when table_pessoa_w.cd_pessoa_fisica.count = 0;
				
				-- Criar pessoas dos beneficiarios

				forall i in table_pessoa_w.cd_pessoa_fisica.first .. table_pessoa_w.cd_pessoa_fisica.last
					insert into mprev_pessoa_cubo_ops(nr_sequencia, nm_usuario, dt_atualizacao,
						cd_pessoa_fisica, nm_pessoa_fisica, dt_nascimento,
						ie_sexo)
					values (nextval('mprev_pessoa_cubo_ops_seq'), nm_usuario_p, clock_timestamp(), 
						table_pessoa_w.cd_pessoa_fisica(i), table_pessoa_w.nm_pessoa_fisica(i), 
						table_pessoa_w.dt_nascimento(i), table_pessoa_w.ie_sexo(i));
				commit;
			end loop;
			close cursor_w;
			
			
			
			-- Montar dados comando.

			cursor_benef_w := mprev_base_cubo_pck.obter_restr_benef('RESTRICAO', 'BENEF', cursor_benef_w, dados_regra_w, '');
			
			-- Montar select dinamico e criar beneficiarios  para as pessoas previamente selecionadas. 

			-- Esta feito desta forma pois pode ter mais de um beneficiario para cada pessoa.

			ds_select_completo_w	:=	'select benef.nr_sequencia nr_seq_segurado, ' || pls_util_pck.enter_w ||
							'	pessoa.nr_sequencia, ' || pls_util_pck.enter_w ||
							'	benef.ie_situacao_atend ie_situacao_atend, ' || pls_util_pck.enter_w ||
							'	benef.dt_inclusao_operadora dt_inclusao_operadora, ' || pls_util_pck.enter_w ||
							'	pls_obter_dados_segurado(benef.nr_sequencia, ''C'') cd_usuario_plano ' ||
							dados_restricao_w.ds_campos || pls_util_pck.enter_w ||
							'from	mprev_pessoa_cubo_ops	pessoa, ' || pls_util_pck.enter_w ||
							'	pls_segurado		benef ' ||
							dados_restricao_w.ds_tabelas || pls_util_pck.enter_w ||
							'where	benef.cd_pessoa_fisica = pessoa.cd_pessoa_fisica ' || 
							dados_restricao_w.ds_restricao;
			
			cursor_benef_w := mprev_base_cubo_pck.obter_restr_benef('EXECUTAR', 'BENEF', cursor_benef_w, dados_regra_w, ds_select_completo_w);
			
			-- se deu tudo certo 

			if (cursor_benef_w%isopen) then
				
				-- Grava os beneficiarios na tabela.

				loop
					fetch 	cursor_benef_w
					bulk collect into	table_benef_w.nr_seq_segurado, table_pessoa_w.nr_sequencia, table_benef_w.ie_situacao_atend,
								table_benef_w.dt_inclusao_plano, table_benef_w.cd_usuario_plano, table_benef_w.ie_preco_plano,
								table_benef_w.ds_preco_plano, table_benef_w.ie_situacao_contrato
					limit	current_setting('mprev_base_cubo_pck.qt_reg_commit_w')::integer;
								
					exit when table_benef_w.nr_seq_segurado.count = 0;
						
					-- Beneficiario 

					forall i in table_pessoa_w.nr_sequencia.first .. table_pessoa_w.nr_sequencia.last
						insert into mprev_benef_cubo_ops(nr_sequencia, nm_usuario, dt_atualizacao,
							nr_seq_pessoa_cubo, nr_seq_segurado, ie_preco_plano,
							ds_preco_plano, ie_situacao_contrato, ie_situacao_atend,
							dt_inclusao_plano, cd_usuario_plano)
						values (nextval('mprev_benef_cubo_ops_seq'), nm_usuario_p, clock_timestamp(),
							table_pessoa_w.nr_sequencia(i), table_benef_w.nr_seq_segurado(i), table_benef_w.ie_preco_plano(i),
							table_benef_w.ds_preco_plano(i), table_benef_w.ie_situacao_contrato(i), table_benef_w.ie_situacao_atend(i),
							table_benef_w.dt_inclusao_plano(i), table_benef_w.cd_usuario_plano(i));
					commit;
				end loop;
				close cursor_benef_w;
			end if;
			
			-- Busca os enderecos das pessoas fisica do cubo

			open c_pf_end_pessoa;
			loop
				
				table_endereco_pf_w.nr_seq_pessoa_cubo.delete;
				table_endereco_pf_w.cd_municipio_ibge.delete;
				table_endereco_pf_w.ie_tipo_complemento.delete;
				table_endereco_pf_w.sg_estado.delete;
				
				fetch 	c_pf_end_pessoa bulk collect
					into	table_endereco_pf_w.nr_seq_pessoa_cubo, 
						table_endereco_pf_w.cd_municipio_ibge,
						table_endereco_pf_w.ie_tipo_complemento,
            			table_endereco_pf_w.sg_estado
				limit	current_setting('mprev_base_cubo_pck.qt_reg_commit_w')::integer;
							
				exit when table_endereco_pf_w.nr_seq_pessoa_cubo.count = 0;								
				
				forall i in table_endereco_pf_w.nr_seq_pessoa_cubo.first .. table_endereco_pf_w.nr_seq_pessoa_cubo.last
					insert into mprev_compl_pessoa_cubo(nr_sequencia, dt_atualizacao, 
							nm_usuario, nr_seq_pessoa_cubo, 
							cd_municipio_ibge, ie_tipo_complemento, sg_estado)
						values (nextval('mprev_compl_pessoa_cubo_seq'), clock_timestamp(), 
							nm_usuario_p, table_endereco_pf_w.nr_seq_pessoa_cubo(i), 
							table_endereco_pf_w.cd_municipio_ibge(i), table_endereco_pf_w.ie_tipo_complemento(i),
              				table_endereco_pf_w.sg_estado(i));
				commit;
			end loop;
			close c_pf_end_pessoa;
			
			exception
			when others then
				null;
			end;
			
		end if;
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_base_cubo_pck.atualizar_pessoas ( nr_seq_regra_p mprev_regra_dados_cubo_ops.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;