-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
-- Gera para Serviços 
CREATE OR REPLACE PROCEDURE ptu_gerar_tabela_a1200_pck.gerar_a1200_serv ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
nr_seq_ptu_pacote_w	ptu_pacote.nr_sequencia%type;
cd_unimed_origem_w	pls_congenere.cd_cooperativa%type;
dados_reg_w		dados_reg;
dados_servico_w		dados_servico;
qt_registro_w		integer;
	
-- Pacote	 
C01 CURSOR FOR 
	SELECT	a.cd_tabela_servico, 
		a.dt_negociacao, 
		a.dt_publicacao 
	from	tabela_servico a 
	where	ie_gerar_a1200 = 'S' 
	and	(a.dt_negociacao IS NOT NULL AND a.dt_negociacao::text <> '') 
	and	(a.dt_publicacao IS NOT NULL AND a.dt_publicacao::text <> '') 
	and	a.ie_situacao = 'A';

-- Regras do pacote	 
C02 CURSOR(cd_tabela_servico_pc	tabela_servico.cd_tabela_servico%type) FOR 
	SELECT	a.nr_seq_prestador, 
		coalesce(pls_obter_dados_prestador(a.nr_seq_prestador,'A400'),'0') cd_prest_a400, 
		substr(pls_obter_dados_prestador(a.nr_seq_prestador,'N'),1,40) nm_prestador 
	from	ptu_prestador_servico a 
	where	a.cd_tabela_servico	= cd_tabela_servico_pc 
	and	(a.nr_seq_prestador IS NOT NULL AND a.nr_seq_prestador::text <> '') 
	
union
 
	SELECT	g.nr_seq_prestador, 
		coalesce(pls_obter_dados_prestador(g.nr_seq_prestador,'A400'),'0') cd_prest_a400, 
		substr(pls_obter_dados_prestador(g.nr_seq_prestador,'N'),1,40) nm_prestador 
	from	ptu_prestador_servico a, 
		pls_preco_prestador g 
	where	a.nr_seq_grupo_prestador = g.nr_seq_grupo 
	and	a.cd_tabela_servico = cd_tabela_servico_pc 
	and	(a.nr_seq_grupo_prestador IS NOT NULL AND a.nr_seq_grupo_prestador::text <> '') 
	group by a.nr_seq_prestador, 
		g.nr_seq_prestador;

-- Serviços do pacote			 
C03 CURSOR(	cd_tabela_servico_pc	tabela_servico.cd_tabela_servico%type, 
		nr_seq_pacote_reg_pc	ptu_pacote_reg.nr_sequencia%type) FOR  --ptu_pacote_servico 
	SELECT 	1 ie_tipo_tabela, 
		a.cd_procedimento, 
		'N' ie_honorario, 
		1 ie_principal, 
		(SELECT	ptu_gerar_tabela_a1200_pck.obter_tipo_item(coalesce(max(x.ie_classificacao),0),'P') 
		 from	procedimento x 
	 	 where	x.cd_procedimento = a.cd_procedimento 
		 and	x.ie_origem_proced = a.ie_origem_proced) ie_tipo_item, 
		nr_seq_pacote_reg_pc, 
		coalesce(a.vl_servico,0) vl_negociado		 
	from 	preco_servico a 
	where 	a.cd_tabela_servico = cd_tabela_servico_pc;
				
BEGIN 
-- Primeiro gera o pacote 
SELECT * FROM ptu_gerar_tabela_a1200_pck.insere_pacote_a1200(cd_estabelecimento_p, nm_usuario_p, nr_seq_ptu_pacote_w, cd_unimed_origem_w) INTO STRICT nr_seq_ptu_pacote_w, cd_unimed_origem_w;
 
for r_C01_w in C01 loop 
	 
	for r_C02_w in C02(r_C01_w.cd_tabela_servico) loop 
		-- Pega as informações da regra 
		dados_reg_w.nr_seq_pacote	:= nr_seq_ptu_pacote_w;
		dados_reg_w.cd_unimed_prestador	:= cd_unimed_origem_w;
		dados_reg_w.cd_prestador	:= r_C02_w.cd_prest_a400;
		dados_reg_w.nm_prestador	:= r_C02_w.nm_prestador;
		dados_reg_w.dt_negociacao	:= r_C01_w.dt_negociacao;
		dados_reg_w.dt_publicacao	:= r_C01_w.dt_publicacao;
		 
		-- Insere a regra 
		dados_reg_w := ptu_gerar_tabela_a1200_pck.insere_pacote_reg(dados_reg_w, nm_usuario_p);
		 
		-- Cursor de serviços 
		Open C03(r_C01_w.cd_tabela_servico, dados_reg_w.nr_sequencia);
		loop 
			-- Limpa as variáveis 
			dados_servico_w := ptu_gerar_tabela_a1200_pck.insere_pacote_servico(dados_servico_w, nm_usuario_p);
			 
			-- Feito com fetch por questões de performance 
			-- Tem um parâmetro de entrada no cursor que é feito select em cima dele 
			-- para continuar utilizando o fetch, devido o número de serviços que podem ser gerados 
			-- é interessante utilizar essa estrutura 
			fetch C03 bulk collect into 	dados_servico_w.ie_tipo_tabela, 
							dados_servico_w.cd_servico, 
							dados_servico_w.ie_honorario, 
							dados_servico_w.ie_principal, 
							dados_servico_w.ie_tipo_item, 
							dados_servico_w.nr_seq_pacote_reg, 
							dados_servico_w.vl_servico 
			limit pls_util_pck.qt_registro_transacao_w;
			 
			exit when dados_servico_w.ie_tipo_tabela.count = 0;
			 
			-- Insere na tabela e limpo as variáveis 
			dados_servico_w := ptu_gerar_tabela_a1200_pck.insere_pacote_servico(dados_servico_w, nm_usuario_p);
		end loop;
		close C03;	
	end loop;
	-- Deleta regras sem itens 
	CALL ptu_gerar_tabela_a1200_pck.deleta_reg_sem_item(nr_seq_ptu_pacote_w);
end loop;
 
select	count(1) 
into STRICT	qt_registro_w 
from	ptu_pacote_reg 
where	nr_seq_pacote	= nr_seq_ptu_pacote_w;
 
if (qt_registro_w = 0) then 
	delete	FROM ptu_pacote 
	where	nr_sequencia	= nr_seq_ptu_pacote_w;
end if;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_tabela_a1200_pck.gerar_a1200_serv ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
