-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_regra_partic_imp_pck.partic_duplic_prest_proc_imp ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
ds_registro_atual_w	varchar(300);
ds_ultimo_registro_w	varchar(300);
ds_observacao_temp_w	varchar(10000);
ds_observacao_w		varchar(30000);
qt_partic_igual_w	integer;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;
nr_indice_w		integer;

c01 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		sel.nr_seq_conta_proc
	from	pls_oc_cta_selecao_imp sel
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_tipo_registro = 'P'
	and	sel.ie_valido = 'S';


c02 CURSOR(	nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type) FOR
	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.cd_profissional_conv cd_medico,
		partic.nr_seq_prestador_conv nr_seq_prestador,
		obter_nome_pf(partic.cd_profissional_conv) nm_medico,
		pls_obter_dados_prestador(partic.nr_seq_prestador_conv, 'N') nm_prestador,
		gp.ds_grau_participacao
	from	pls_conta_proc_imp proc,
		pls_conta_item_equipe_imp partic,
		pls_grau_participacao gp
	where	proc.nr_sequencia = nr_seq_conta_proc_pc
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	gp.nr_sequencia = partic.nr_seq_grau_partic_conv;

c03 CURSOR(	nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type) FOR
	SELECT	proc.nr_sequencia nr_seq_proc,
		proc.nr_seq_conta,
		partic.cd_profissional_conv cd_medico,
		partic.nr_seq_prestador_conv nr_seq_prestador,
		obter_nome_pf(partic.cd_profissional_conv) nm_medico,
		pls_obter_dados_prestador(partic.nr_seq_prestador_conv, 'N') nm_prestador,
		gp.ds_grau_participacao
	from	pls_conta_proc_imp proc,
		pls_conta_item_equipe_imp partic,
		pls_grau_participacao gp
	where	proc.nr_sequencia = nr_seq_conta_proc_pc
	and	partic.nr_seq_conta_proc = proc.nr_sequencia
	and	gp.nr_sequencia = partic.nr_seq_grau_partic_conv;
BEGIN

nr_indice_w := 0;
-- Incializar as listas para cada regra.
SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

-- retorna todos os registros de procedimento e o correspondente na seleção
for r_c01_w in c01(nr_id_transacao_p) loop

	ds_ultimo_registro_w := null;
	ds_observacao_w := null;
	ds_observacao_temp_w := null;
	qt_partic_igual_w := 0;	

	-- aqui verifica o campo do prestador e caso duplicado, verica o medico
	for r_c03_w in c03(r_c01_w.nr_seq_conta_proc) loop

		ds_registro_atual_w := coalesce(to_char(r_c03_w.nr_seq_prestador),0);
		-- para validar o participante usa prestador e médico juntos
		-- a Rio Preto alimenta só o prestador e os demais clientes alimentam os dois campos
		-- se o o prestador e médico executor anterior for igual ao atual significa que já duplicou
		-- primeira comparação sempre dá verdadeiro quando ainda não existe o grau de participação anterior
		if (coalesce(ds_ultimo_registro_w, ds_registro_atual_w) = ds_registro_atual_w) then
			qt_partic_igual_w := qt_partic_igual_w + 1;
		else
			-- se não for igual significa que mudou de partic
			-- verifica se existe duplicidade e se sim grava a observação
			if (qt_partic_igual_w > 1) then
				ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
			end if;

			-- reinicializa as variáveis
			ds_observacao_temp_w := null;
			qt_partic_igual_w := 1;
		end if;

		-- armazena os dados na variável
		ds_observacao_temp_w := substr(ds_observacao_temp_w || 	'Conta: ' || r_c03_w.nr_seq_conta || ' Proc: ' || r_c03_w.nr_seq_proc ||
									' Grau partic: ' || r_c03_w.ds_grau_participacao ||
									' Prest: ' || r_c03_w.nm_prestador ||
									pls_util_pck.enter_w, 1, 10000);
		ds_ultimo_registro_w := ds_registro_atual_w;
	
	end loop;
	
	ds_ultimo_registro_w := null;
	ds_observacao_w := null;
	ds_observacao_temp_w := null;
	
	-- se a participacao e igual, verifica o medico
	if (qt_partic_igual_w > 1) then
	
	qt_partic_igual_w := 0;
	
		-- aqui é verificado a duplicidade do campo cd_medico
		for r_c02_w in c02(r_c01_w.nr_seq_conta_proc) loop

			ds_registro_atual_w := r_c02_w.cd_medico;
				
			-- para validar o participante usa prestador e médico juntos
			-- a Rio Preto alimenta só o prestador e os demais clientes alimentam os dois campos
			-- se o o prestador e médico executor anterior for igual ao atual significa que já duplicou
			-- primeira comparação sempre dá verdadeiro quando ainda não existe o grau de participação anterior
			if (coalesce(ds_ultimo_registro_w, ds_registro_atual_w) = ds_registro_atual_w) then
				qt_partic_igual_w := qt_partic_igual_w + 1;
			else
				-- se não for igual significa que mudou de partic
				-- verifica se existe duplicidade e se sim grava a observação
				if (qt_partic_igual_w > 1) then
					ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
				end if;

				-- reinicializa as variáveis
				ds_observacao_temp_w := null;
				qt_partic_igual_w := 1;
			end if;

			-- armazena os dados na variável
			ds_observacao_temp_w := substr(ds_observacao_temp_w || 	'Conta: ' || r_c02_w.nr_seq_conta || ' Proc: ' || r_c02_w.nr_seq_proc ||
										' Grau partic: ' || r_c02_w.ds_grau_participacao ||
										' Prof: ' || r_c02_w.nm_medico ||
										pls_util_pck.enter_w, 1, 10000);
			ds_ultimo_registro_w := ds_registro_atual_w;
		end loop;

		-- se os últimos partics são iguais grava na observação
		if (qt_partic_igual_w > 1) then
			ds_observacao_w := substr(ds_observacao_w || ds_observacao_temp_w, 1, 30000);
		end if;

		-- se tiver observação significa que deve lançar ocorrência
		if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
			
			-- Alimenta as listas com as informações para gravar no banco todas de uma vez
			tb_seq_selecao_w(nr_indice_w)	:= r_c01_w.nr_seq_selecao;
			tb_observacao_w(nr_indice_w)	:= substr(ds_observacao_w, 1, 2000);
			tb_valido_w(nr_indice_w)	:= 'S';

			if (nr_indice_w >= pls_util_pck.qt_registro_transacao_w) then
				CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
										tb_observacao_w, nr_id_transacao_p,
										'SEQ');	
				
				SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
				nr_indice_w := 0;
			else
				nr_indice_w := nr_indice_w + 1;
			end if;
		end if;
	end if;
end loop;

-- Processa  possíveis sobras nos registros em memória
CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
						tb_observacao_w, nr_id_transacao_p,
						'SEQ');	

SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
						
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_partic_imp_pck.partic_duplic_prest_proc_imp ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
