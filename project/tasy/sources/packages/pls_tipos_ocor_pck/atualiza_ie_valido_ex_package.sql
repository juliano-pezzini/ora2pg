-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_tipos_ocor_pck.atualiza_ie_valido_ex ( nr_id_transacao_ex_p pls_selecao_ex_ocor_cta.nr_id_transacao%type, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_filtro_p pls_tipos_ocor_pck.dados_filtro) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Todo registro em que no processamento dos filtros de excecao tiver algum registro
	casado em alguma parte do seu atendimento, invalida o registro original da tabela
	de selecao que esta valido.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 -
 Alteracao:	Descricao da alteracao.
Motivo:	Descricao do motivo.
 ------------------------------------------------------------------------------------------------------------------

 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


tb_seq_w	pls_util_cta_pck.t_number_table;

-- busca todo mundo que esta valido na tabela de selecao e que algum registro do atendimento

-- casou na regra de excecao.

-- logo abaixo invalida os registros

c01 CURSOR(	nr_id_transacao_ex_pc	pls_selecao_ex_ocor_cta.nr_id_transacao%type,
		nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type) FOR
	SELECT	a.nr_sequencia nr_seq_selecao
	from	pls_selecao_ocor_cta a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S'
	and	exists (SELECT	1
			from	pls_selecao_ex_ocor_cta b
			where	b.nr_id_transacao = nr_id_transacao_ex_pc
			and	b.nr_seq_segurado = a.nr_seq_segurado
			and	b.cd_guia_referencia = a.cd_guia_referencia
			and	b.ie_valido = 'S');

-- busca todo mundo que esta valido na tabela de selecao e que algum registro da conta principal

-- casou na regra de excecao.

-- logo abaixo invalida os registros

c02 CURSOR(	nr_id_transacao_ex_pc	pls_selecao_ex_ocor_cta.nr_id_transacao%type,
		nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type) FOR
	SELECT	a.nr_sequencia nr_seq_selecao
	from	pls_selecao_ocor_cta a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S'
	and	exists (SELECT	1
			from	pls_selecao_ex_ocor_cta b,
				pls_conta		c
			where	b.nr_id_transacao = nr_id_transacao_ex_pc
			and	b.ie_valido = 'S'
			and	c.nr_seq_conta_princ = b.nr_seq_conta
			and	a.nr_seq_conta = c.nr_sequencia);


BEGIN

-- quando for para validar todo o atendimento

if (dados_filtro_p.ie_valida_todo_atend = 'S') then

	open c01(nr_id_transacao_ex_p, nr_id_transacao_p);
	loop
		tb_seq_w.delete;

		fetch c01 bulk collect into tb_seq_w
		limit pls_util_pck.qt_registro_transacao_w;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			update	pls_selecao_ocor_cta
			set	ie_valido = 'N'
			where	nr_sequencia = tb_seq_w(i);

		
	end loop;
	close c01;

-- quando for conta principal

elsif (dados_filtro_p.ie_valida_conta_princ = 'S') then

	open c02(nr_id_transacao_ex_p, nr_id_transacao_p);
	loop
		tb_seq_w.delete;

		fetch c02 bulk collect into tb_seq_w
		limit pls_util_pck.qt_registro_transacao_w;

		exit when tb_seq_w.count = 0;

		forall i in tb_seq_w.first .. tb_seq_w.last
			update	pls_selecao_ocor_cta
			set	ie_valido = 'N'
			where	nr_sequencia = tb_seq_w(i);

		
	end loop;
	close c02;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tipos_ocor_pck.atualiza_ie_valido_ex ( nr_id_transacao_ex_p pls_selecao_ex_ocor_cta.nr_id_transacao%type, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_filtro_p pls_tipos_ocor_pck.dados_filtro) FROM PUBLIC;
