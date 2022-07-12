-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Faz verificacaes relativas a geracao ou n_o de p_s-estabelecido e atualiza a IE_GERA_VALOR_POS_ESTAB em cada _tem

--Percorre inteiramente as tabelas tempor_rias w_pls_conta_pos_proc e w_pls_conta_pos_mat e atualiza conforme resultado da verificacao.



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.identifica_item_elegivel_pos ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


ie_gera_valor_pos_estab_w	varchar(2);
nr_seq_conta_anterior_w		pls_conta.nr_sequencia%type;
tb_item_w			pls_util_cta_pck.t_number_table;
tb_congenere_w			pls_util_cta_pck.t_number_table;
tb_gera_w			pls_util_cta_pck.t_varchar2_table_5;
ie_tipo_plano_w			pls_plano.ie_preco%type;
nr_seq_congenere_w		pls_intercambio.nr_seq_oper_congenere%type;
ie_horario_rescisao_w		pls_parametros.ie_horario_rescisao%type;
dt_validade_carteira_w		pls_segurado_carteira.dt_validade_carteira%type;
nr_via_solicitacao_w		pls_segurado_carteira.nr_via_solicitacao%type;
ie_calculo_pos_estab_w		pls_parametros.ie_calculo_pos_estab%type;
ie_tipo_congenere_w		pls_congenere.ie_tipo_congenere%type;
i				integer := 0;
qt_devolucao_carteira_w		integer := 0;
qt_regra_int_w			integer := 0;
dt_item_base_w			timestamp;
dt_limite_utilizacao_w		timestamp;

C01 CURSOR FOR
	SELECT	proc.nr_sequencia nr_seq_conta_Proc,
		proc.nr_seq_conta,
		conta.ie_tipo_conta,
		seg.nr_seq_intercambio,
		(	SELECT 	coalesce(max(ie_tipo_repasse),'X')
			from 	pls_intercambio
			where	nr_sequencia = seg.nr_seq_intercambio) ie_tipo_repasse,
		seg.nr_sequencia nr_seq_segurado,
		conta.dt_atendimento_referencia,
		pls_obter_produto_benef(conta.nr_seq_segurado, conta.dt_atendimento_referencia) nr_seq_plano,
		coalesce(seg.nr_seq_ops_congenere, seg.nr_seq_congenere) nr_seq_congenere_seg,
		prot.nr_seq_congenere nr_seq_congenere_prot,
		proc.dt_item,
		trunc(proc.dt_item) dt_item_trunc,
		seg.dt_limite_utilizacao,
		trunc(seg.dt_limite_utilizacao) dt_limite_utilizacao_trunc,
		pls_obter_carteira_segurado(seg.nr_sequencia) cd_usuario_plano,
		seg.ie_tipo_segurado
	from	w_pls_conta_pos_proc 	proc,
		pls_conta		conta,
		pls_protocolo_conta	prot,
		pls_segurado		seg
	where	proc.nr_seq_conta     = conta.nr_sequencia
	and	conta.nr_seq_segurado = seg.nr_sequencia
	and	conta.nr_seq_protocolo= prot.nr_sequencia
	order by proc.nr_seq_conta;

C02 CURSOR FOR
	SELECT	mat.nr_sequencia nr_seq_conta_mat,
		mat.nr_seq_conta,
		conta.ie_tipo_conta,
		seg.nr_seq_intercambio,
		(	SELECT 	coalesce(max(ie_tipo_repasse),'X')
			from 	pls_intercambio
			where	nr_sequencia = seg.nr_seq_intercambio) ie_tipo_repasse,
		conta.nr_seq_segurado,	
		conta.dt_atendimento_referencia,
		pls_obter_produto_benef(conta.nr_seq_segurado, conta.dt_atendimento_referencia) nr_seq_plano,
		coalesce(seg.nr_seq_ops_congenere, seg.nr_seq_congenere) nr_seq_congenere_seg,
		prot.nr_seq_congenere nr_seq_congenere_prot,
		mat.dt_item,
		trunc(mat.dt_item) dt_item_trunc,
		seg.dt_limite_utilizacao,
		trunc(seg.dt_limite_utilizacao) dt_limite_utilizacao_trunc,
		pls_obter_carteira_segurado(seg.nr_sequencia) cd_usuario_plano,
		seg.ie_tipo_segurado
	from	w_pls_conta_pos_mat 	mat,
		pls_conta		conta,
		pls_protocolo_conta	prot,
		pls_segurado		seg
	where	mat.nr_seq_conta      = conta.nr_sequencia
	and	conta.nr_seq_segurado = seg.nr_sequencia
	and	conta.nr_seq_protocolo= prot.nr_sequencia
	order by mat.nr_seq_conta;
	
BEGIN
	select 	coalesce(max(ie_horario_rescisao), 'N'),
		coalesce(max(ie_cobranca_pos),'N'),
		coalesce(max(ie_calculo_pos_estab),'C'),	
		coalesce(max(ie_preco_interc_congenere),'I'),
		coalesce(max(ie_pos_estab_faturamento),'N'),
		coalesce(max(ie_geracao_pos_estabelecido),'F'),
		coalesce(max(current_setting('pls_pos_estabelecido_pck.ie_controle_pos_estabelecido_w')::pls_parametros.ie_controle_pos_estabelecido%type), 'N')
	into STRICT	ie_horario_rescisao_w,
		current_setting('pls_pos_estabelecido_pck.ie_cobranca_pos_w')::pls_parametros.ie_cobranca_pos%type,
		ie_calculo_pos_estab_w,
		current_setting('pls_pos_estabelecido_pck.ie_preco_interc_congenere_w')::pls_parametros.ie_preco_interc_congenere%type,
		current_setting('pls_pos_estabelecido_pck.ie_pos_estab_faturamento_w')::pls_parametros.ie_pos_estab_faturamento%type,
		current_setting('pls_pos_estabelecido_pck.ie_geracao_pos_estabelecido_w')::pls_parametros.ie_geracao_pos_estabelecido%type,
		current_setting('pls_pos_estabelecido_pck.ie_controle_pos_estabelecido_w')::pls_parametros.ie_controle_pos_estabelecido%type
	from	pls_parametros
	where	cd_estabelecimento	= cd_estabelecimento_p;

	select 	count(1)
	into STRICT	qt_regra_int_w
	from 	pls_regra_intercambio
	where 	ie_tipo_regra = 'CE';
	
	PERFORM set_config('pls_pos_estabelecido_pck.ie_calculo_pos_estab_sistema_w', ie_calculo_pos_estab_w, false);
	
	
	--Seta inicialmente com um n_mero diferente de qualquer sequencia poss_vel para uma conta, para a l_gica de verificacao ser adequada.

	nr_seq_conta_anterior_w := -999;
	tb_gera_w.delete;
	tb_item_w.delete;
	tb_congenere_w.delete;
	for r_c01_w in C01 loop
	
		select 	max(ie_preco)
		into STRICT 	ie_tipo_plano_w
		from	pls_plano
		where 	nr_sequencia = r_c01_w.nr_seq_plano;
		
		--Como nesse momento basta saber se h_ uma cong_nere e n_o ser necess_rio definir qual ela _ com precis_o, apemas busca  a congenere do interc_mbio,

		--caso n_o tiver informada no segurado e tamb_m na conta. Tal situacao acaba ocorrendo na rotina original de p_s-estabelecido.

		nr_seq_congenere_w := coalesce(r_c01_w.nr_seq_congenere_seg, r_c01_w.nr_seq_congenere_prot);
		if ( coalesce(nr_seq_congenere_w::text, '') = '' and  (r_c01_w.nr_seq_intercambio IS NOT NULL AND r_c01_w.nr_seq_intercambio::text <> '')) then
			
			select	nr_seq_oper_congenere
			into STRICT	nr_seq_congenere_w
			from	pls_intercambio
			where	nr_sequencia = r_c01_w.nr_seq_intercambio;
			
		end if;
		
		ie_tipo_congenere_w := null;
		select	max(ie_tipo_congenere)
		into STRICT	ie_tipo_congenere_w
		from	pls_congenere
		where	nr_sequencia = nr_seq_congenere_w;
		
		--incluido tratamento qt_regra_int_w devido a necessidade da unimed s_o jos_ do rio preto, que da forma como estava o tratamento hoje para as cooperativas m_dicas acabava sendo aplicada a regra da unimed origem

		--Nesse caso aqui, prioriza a congenere vinda do protocolo, apenas considerando a do segurado quando a primeira n_o existir

		if ( ie_tipo_congenere_w = 'OP') and (r_c01_w.ie_tipo_segurado = 'T') and ( qt_regra_int_w = 0) then
			nr_seq_congenere_w := coalesce(r_c01_w.nr_seq_congenere_prot,nr_seq_congenere_w );
		end if;
		
		tb_congenere_w(i) := nr_seq_congenere_w;
		tb_item_w(i) := r_c01_w.nr_seq_conta_proc;
		--Para fazer as verificacaes apenas quando esta passando por uma conta diferente, pois cada conta pode ser verificada

		--in_meras vezes, dependendo da quantidade de itens, assim _ mais perform_tico. 

		if (r_c01_w.nr_seq_conta <> nr_seq_conta_anterior_w ) then
			ie_gera_valor_pos_estab_w := 'N';
			
			--Se tipo de conta = C(Interc_mbio cobran_a) ent_o verifica ainda se repassa valor for <> 'P' , a_ nesse caso pode geraro

			if (r_c01_w.ie_tipo_conta = 'C' and r_c01_w.ie_tipo_repasse <> 'P') then
				ie_gera_valor_pos_estab_w := 'S';
				
			--Se tipo de conta = O(Operadora) ent_o verifica ainda se tipo plano = 2 ou 3 e tam_bem se o segurado possui congenere, 

			--a_ nesse caso pode gerar   2  - P_s-estabelecido por rateio e 3 - P_s-estabelecido por custo operacional

			elsif (r_c01_w.ie_tipo_conta = 'I') then
								
				if (ie_tipo_plano_w in (2,3) and (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '')) then
					ie_gera_valor_pos_estab_w := 'S';
				end if;
				
			--Se tipo de conta = O(Operadora) ent_o verifica ainda se tipo plano = 2 ou 3, a_ nesse caso pode gerar

			elsif (r_c01_w.ie_tipo_conta = 'O') then
			
				if (ie_tipo_plano_w in (2,3)) then
					ie_gera_valor_pos_estab_w := 'S';
				end if;
			
			end if;
		end if;
		
		--ie_cobranca_pos_w se deve cobrar como P_s estabelecido do benefici_rio, os procedimentos e materiais apresentados na conta, 

		--que possuem data maior do que a data de rescis_o do benefici_rio, e que ainda n_o devolveram a carteirinha. 

		if ( ie_tipo_plano_w = 1 and current_setting('pls_pos_estabelecido_pck.ie_cobranca_pos_w')::pls_parametros.ie_cobranca_pos%type = 'S' ) then
		
			--Para definir se _ interc_mbio cobran_a

			if	((nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') and (r_c01_w.ie_tipo_segurado in ('R','T','I','C','H'))) then
			
				if (r_c01_w.ie_tipo_conta = 'C' and r_c01_w.ie_tipo_repasse <> 'P') then
					ie_calculo_pos_estab_w := 'IC';
					
				elsif (r_c01_w.ie_tipo_conta = 'I' and ie_tipo_plano_w in ('2','3')) then
					ie_calculo_pos_estab_w := 'IC';
				end if;
			end if;
				
			--Apenas prosseguir_ com as verificacaes no caso de n_o ser determinado como Interc_mbio cobran_a

			if (ie_calculo_pos_estab_w <> 'IC') then
			
				--Identifica se ser_ validada a hora da rescis_o do benefici_rio, no momento de identificar 

				if (ie_horario_rescisao_w = 'S') then
					dt_item_base_w := r_C01_w.dt_item;
					dt_limite_utilizacao_w := r_c01_w.dt_limite_utilizacao;
				else
					dt_item_base_w := r_C01_w.dt_item_trunc;
					dt_limite_utilizacao_w := r_c01_w.dt_limite_utilizacao_trunc;
				end if;
				
				--Verifica se limite utilizacao do benefici_rio _ inferior a data do item. Aqui n_o se preocupa

				--no caso de ser nulo pois se o if falhar, apenas n_o far_ as verificacaes(nesse caso desnecess_rio)

				if ( dt_limite_utilizacao_w < dt_item_base_w)  then
						
					ie_gera_valor_pos_estab_w := 'N';

					select	max(dt_validade_carteira),
						max(nr_via_solicitacao)
					into STRICT	dt_validade_carteira_w,
						nr_via_solicitacao_w
					from	pls_segurado_carteira
					where	nr_seq_segurado		= r_c01_w.nr_seq_segurado;
					
					--Atribuo fim dia para a data base para n_o precisar truncar a data de devolucao da carteirinha no selecet

					dt_item_base_w := fim_dia(dt_item_base_w);
					
					select	count(a.nr_sequencia)
					into STRICT	qt_devolucao_carteira_w
					from	pls_carteira_devolucao	a,
						pls_cart_lote_devolucao	b
					where	b.nr_sequencia			= a.nr_seq_lote
					and	a.cd_usuario_plano		= r_c01_w.cd_usuario_plano
					and	a.nr_via 			= nr_via_solicitacao_w
					and	a.dt_validade_carteira		= dt_validade_carteira_w
					and	b.dt_devolucao			< dt_item_base_w;
					
					if (qt_devolucao_carteira_w = 0) then
					
						ie_gera_valor_pos_estab_w := 'SB';
					end if;
						
				end if;
			end if;
		end if;
		
		tb_gera_w(i) := ie_gera_valor_pos_estab_w;
		
		if ( i > pls_util_cta_pck.qt_registro_transacao_w) then
			CALL pls_pos_estabelecido_pck.atualiza_item_gera_pos_estab( tb_item_w, tb_gera_w, tb_congenere_w, 'P');
			i := 0;
			tb_gera_w.delete;
			tb_item_w.delete;
			tb_congenere_w.delete;
		else
			i := i + 1;
		end if;
		nr_seq_conta_anterior_w := r_c01_w.nr_seq_conta;
	end loop;
	
	--Se sobrou registro nas estruturas, persiste no banco.

	CALL pls_pos_estabelecido_pck.atualiza_item_gera_pos_estab(tb_item_w, tb_gera_w, tb_congenere_w, 'P');
	tb_gera_w.delete;
	tb_item_w.delete;
	tb_congenere_w.delete;
	i := 0;
	
	--Agora verificar_ os materiais, ent_o reseta a conta anterior para n_o correr risco de falhar na verificacao.

	--Optado por dividir a verificacao em cursor de procedimentos e outro de materiais, devido a simplicidade de 

	--controlar as estruturas de atualizacao. Em termos de performance, isso n_o dever_ causar impacto significativo.

	nr_seq_conta_anterior_w := -999;
	ie_gera_valor_pos_estab_w:= 'N';
	for r_c02_w in C02 loop
		
		tb_item_w(i) := r_c02_w.nr_seq_conta_mat;
		
		select 	max(ie_preco)
		into STRICT 	ie_tipo_plano_w
		from	pls_plano
		where 	nr_sequencia = r_c02_w.nr_seq_plano;
		
		--Como nesse momento basta saber se h_ uma cong_nere e n_o ser necess_rio definir qual ela _ com precis_o, apemas busca  a congenere do interc_mbio,

		--caso n_o tiver informada no segurado e tamb_m na conta. Tal situacao acaba ocorrendo na rotina original de p_s-estabelecido.

		nr_seq_congenere_w := coalesce(r_c02_w.nr_seq_congenere_seg, r_c02_w.nr_seq_congenere_prot);
		if ( coalesce(nr_seq_congenere_w::text, '') = '' and  (r_c02_w.nr_seq_intercambio IS NOT NULL AND r_c02_w.nr_seq_intercambio::text <> '')) then
			
			select	nr_seq_oper_congenere
			into STRICT	nr_seq_congenere_w
			from	pls_intercambio
			where	nr_sequencia = r_c02_w.nr_seq_intercambio;
			
		end if;
		
		ie_tipo_congenere_w := null;
		select	max(ie_tipo_congenere)
		into STRICT	ie_tipo_congenere_w
		from	pls_congenere
		where	nr_sequencia = nr_seq_congenere_w;
		
		--incluido tratamento qt_regra_int_w devido a necessidade da unimed s_o jos_ do rio preto, que da forma como estava o tratamento hoje para as cooperativas m_dicas acabava sendo aplicada a regra da unimed origem

		--Nesse caso aqui, prioriza a congenere vinda do protocolo, apenas considerando a do segurado quando a primeira n_o existir

		if (ie_tipo_congenere_w = 'OP') and (r_c02_w.ie_tipo_segurado = 'T') and ( qt_regra_int_w = 0) then
			nr_seq_congenere_w := coalesce(r_c02_w.nr_seq_congenere_prot, nr_seq_congenere_w );
		end if;
		
		tb_congenere_w(i) := nr_seq_congenere_w;
		
		--Para fazer as verificacaes apenas quando esta passando por uma conta diferente, pois cada conta pode ser verificada

		--in_meras vezes, dependendo da quantidade de itens, assim _ mais perform_tico. 

		if (r_c02_w.nr_seq_conta <> nr_seq_conta_anterior_w ) then
			
			ie_gera_valor_pos_estab_w := 'N';
						
			--Se tipo de conta = C(Interc_mbio cobran_a) ent_o verifica ainda se repassa valor for <> 'P' , a_ nesse caso pode geraro

			if (r_c02_w.ie_tipo_conta = 'C' and r_c02_w.ie_tipo_repasse <> 'P') then
				ie_gera_valor_pos_estab_w := 'S';
				
			--Se tipo de conta = O(Operadora) ent_o verifica ainda se tipo plano = 2 ou 3 e tam_bem se o segurado possui congenere, 

			--a_ nesse caso pode gerar   2  - P_s-estabelecido por rateio e 3 - P_s-estabelecido por custo operacional

			elsif (r_c02_w.ie_tipo_conta = 'I') then
								
				if (ie_tipo_plano_w in (2,3) and (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '')) then
					ie_gera_valor_pos_estab_w := 'S';
				end if;
				
			--Se tipo de conta = O(Operadora) ent_o verifica ainda se tipo plano = 2 ou 3, a_ nesse caso pode gerar

			elsif (r_c02_w.ie_tipo_conta = 'O') then
			
				if (ie_tipo_plano_w in (2,3)) then
					ie_gera_valor_pos_estab_w := 'S';
				end if;
			
			end if;
		end if;
		
		--ie_cobranca_pos_w se deve cobrar como P_s estabelecido do benefici_rio, os procedimentos e materiais apresentados na conta, 

		--que possuem data maior do que a data de rescis_o do benefici_rio, e que ainda n_o devolveram a carteirinha. 

		if ( ie_tipo_plano_w = 1 and current_setting('pls_pos_estabelecido_pck.ie_cobranca_pos_w')::pls_parametros.ie_cobranca_pos%type = 'S' ) then

				
			--Para definir se _ interc_mbio cobran_a

			if	((nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') and (r_c02_w.ie_tipo_segurado in ('R','T','I','C','H'))) then
			
				if (r_c02_w.ie_tipo_conta = 'C' and r_c02_w.ie_tipo_repasse <> 'P') then
					ie_calculo_pos_estab_w := 'IC';
					
				elsif (r_c02_w.ie_tipo_conta = 'I' and ie_tipo_plano_w in ('2','3')) then
					ie_calculo_pos_estab_w := 'IC';
				end if;
			end if;
				
			--Apenas prosseguir_ com as verificacaes no caso de n_o ser determinado como Interc_mbio cobran_a

			if (ie_calculo_pos_estab_w <> 'IC') then
			
				--Identifica se ser_ validada a hora da rescis_o do benefici_rio, no momento de identificar 

				if (ie_horario_rescisao_w = 'S') then
					dt_item_base_w := r_C02_w.dt_item;
					dt_limite_utilizacao_w := r_c02_w.dt_limite_utilizacao;
				else
					dt_item_base_w := r_C02_w.dt_item_trunc;
					dt_limite_utilizacao_w := r_c02_w.dt_limite_utilizacao_trunc;
				end if;
				
				--Verifica se limite utilizacao do benefici_rio _ inferior a data do item. Aqui n_o se preocupa

				--no caso de ser nulo pois se o if falhar, apenas n_o far_ as verificacaes(nesse caso desnecess_rio)

				if (dt_limite_utilizacao_w < dt_item_base_w)  then
						
					ie_gera_valor_pos_estab_w := 'N';

					select	max(dt_validade_carteira),
						max(nr_via_solicitacao)
					into STRICT	dt_validade_carteira_w,
						nr_via_solicitacao_w
					from	pls_segurado_carteira
					where	nr_seq_segurado		= r_c02_w.nr_seq_segurado;
					
					--Atribuo fim dia para a data base para n_o precisar truncar a data de devolucao da carteirinha no selecet

					dt_item_base_w := fim_dia(dt_item_base_w);
					
					select	count(a.nr_sequencia)
					into STRICT	qt_devolucao_carteira_w
					from	pls_carteira_devolucao	a,
						pls_cart_lote_devolucao	b
					where	b.nr_sequencia			= a.nr_seq_lote
					and	a.cd_usuario_plano		= r_c02_w.cd_usuario_plano
					and	a.nr_via 			= nr_via_solicitacao_w
					and	a.dt_validade_carteira		= dt_validade_carteira_w
					and	b.dt_devolucao			< dt_item_base_w;
					
					if (qt_devolucao_carteira_w = 0) then
					
						ie_gera_valor_pos_estab_w := 'SB';
					end if;
						
				end if;
			end if;
		end if;
		
		tb_gera_w(i) := ie_gera_valor_pos_estab_w;
		
		if ( i > pls_util_cta_pck.qt_registro_transacao_w) then
			CALL pls_pos_estabelecido_pck.atualiza_item_gera_pos_estab(tb_item_w, tb_gera_w, tb_congenere_w, 'M');
			tb_gera_w.delete;
			tb_item_w.delete;
			tb_congenere_w.delete;
			i := 0;
		else
			i := i + 1;
		end if;
		nr_seq_conta_anterior_w := r_c02_w.nr_seq_conta;
	end loop;
	
	CALL pls_pos_estabelecido_pck.atualiza_item_gera_pos_estab(tb_item_w, tb_gera_w, tb_congenere_w, 'M');
	
	--_ partir daqui essas estruturas n_o sao mais usadas, por_m s_o limpas para desalocar.

	tb_gera_w.delete;
	tb_item_w.delete;
	tb_congenere_w.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.identifica_item_elegivel_pos ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
