-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_2_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
-- Aplicar a validação de carteira do beneficiário conforme informado na
-- regra para as contas ou itens que passaram pelos filtros da regra.
-- rotina utilizada apenas para importação XML
i			integer;
ie_gera_ocorrencia_w	varchar(10);
ds_observacao_1_w	varchar(255);
ds_observacao_2_w	varchar(255);
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;

-- Informações da regra de validação da carteira
C01 CURSOR(	nr_seq_oc_cta_comb_p	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_validade_carteira
	from	pls_oc_cta_val_carteira a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

-- Contas que foram aplicadas nos filtros da regra
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	conta.dt_atendimento_conv,
		conta.nr_sequencia,
		(SELECT max(x.dt_validade_carteira)
			from pls_segurado_carteira x
			where x.nr_seq_segurado = conta.nr_seq_segurado_conv) dt_validade_carteira
	from	pls_conta_imp conta
	where	exists (	select 1
				from	pls_oc_cta_selecao_imp a
				where	a.nr_id_transacao = nr_id_transacao_pc
				and  	a.ie_valido = 'S'
				and  	a.nr_seq_conta = conta.nr_sequencia);
BEGIN

if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') and (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '') then

	--Texto : A carteira do segurado está vencida desde
	ds_observacao_1_w := wheb_mensagem_pck.get_texto(369830);
	--Texto : A carteira do segurado é válida até
	ds_observacao_2_w := wheb_mensagem_pck.get_texto(369829);

	for	r_C01_w in C01(nr_seq_combinada_p) loop

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', 'N', nr_id_transacao_p, null);

		SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

		-- Se tiver informação na tabela e a informação for diferente de nenhuma será verificado, caso contrário sai da rotina e nem abre as informações das contas.
		if (r_C01_w.ie_validade_carteira IS NOT NULL AND r_C01_w.ie_validade_carteira::text <> '') then

			i := 0;
			-- Dados da conta
			for	r_C02_w in C02(nr_id_transacao_p) loop

				ie_gera_ocorrencia_w	:= 'N';
				-- Precisa ter alguma informação para que seja comparado com a carteira do benef
				if	(r_C02_w.dt_validade_carteira IS NOT NULL AND r_C02_w.dt_validade_carteira::text <> '' AND r_C02_w.dt_atendimento_conv IS NOT NULL AND r_C02_w.dt_atendimento_conv::text <> '') then
					-- Verificar tipo de geração da ocorrência,  se vencida ou vigente
					if (r_C01_w.ie_validade_carteira = 'VC') then
						-- Se a data de validade for menos que a data de emissao da conta então não é excecao e será gerada a ocorrencia
						if (r_C02_w.dt_atendimento_conv > r_C02_w.dt_validade_carteira) then
										--A carteira do segurado está vencida desde
							tb_observacao_w(i)	:= ds_observacao_1_w || to_char(r_C02_w.dt_validade_carteira, 'dd/mm/yyyy');
							ie_gera_ocorrencia_w	:= 'S';
						end if;
					elsif (r_C01_w.ie_validade_carteira = 'V') then
						-- Se a data de validade for maior que a data de emissao da conta então não é excecao e vai gerar a ocorrencia
						if (r_C02_w.dt_atendimento_conv <= r_C02_w.dt_validade_carteira) then
										--A carteira do segurado é válida até
							tb_observacao_w(i)	:= ds_observacao_2_w || to_char(r_C02_w.dt_validade_carteira, 'dd/mm/yyyy');
							ie_gera_ocorrencia_w	:= 'S';
						end if;
					end if;
				end if;

				-- Caso for para gerar ocorrência inclui os dados da conta na tabela
				if (ie_gera_ocorrencia_w = 'S') then

					-- Passa nr_seq_conta ao invés do nr_seq_selecao, pois será feito validação a nível de conta
					-- isso ocorre pelo motivo que esta validação é a nível de conta e podem existir registros de itens
					-- na tabela de seleção
					-- neste caso todos os itens da conta serão alterados para válidos.
					tb_seq_selecao_w(i)	:= r_C02_w.nr_sequencia;
					tb_valido_w(i)		:= 'S';

					if (i >= pls_util_pck.qt_registro_transacao_w) then
						--Grava as informações na tabela de seleção
						CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
												tb_observacao_w, nr_id_transacao_p,
												'SEQ_CONTA');
						--limpa as variáveis
						SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

						i := 0;
					else
						i := i + 1;
					end if;
				end if;
			end loop; --C02
		end if;
	end loop; -- C01
	--Se tiver alguma informaçõa grava na tabela
	CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
							tb_observacao_w, nr_id_transacao_p,
							'SEQ_CONTA');

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N',
						ie_regra_excecao_p, null,
						nr_id_transacao_p, null);

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_2_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

