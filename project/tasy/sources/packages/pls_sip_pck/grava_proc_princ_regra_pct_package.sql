-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.grava_proc_princ_regra_pct ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nr_seq_pacote_p pls_pacote_proc_princ.nr_seq_pacote%type, tb_cd_procedimento_p INOUT dbms_sql.number_table, tb_ie_origem_proced_p INOUT dbms_sql.number_table, tb_nr_seq_conta_p INOUT dbms_sql.number_table, ie_commit_p text, ie_esvaziar_table_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Grava o procedimento principal do pacote na sip_nv_dados, baseado na regra
	
	Essa rotina apenas grava os registros, nenhuma regra de negocio deve ser inclusa aqui.
	
	Essa rotina e diferente para as demais formas de gravar o procedimento, pois como
	a forma por regra se baseia em algum procedimento da conta em que se encaixa na regra,
	por performance nao e levantado especificamente o pacote por conta, e sim e verificado
	todas as contas, portanto e passado uma chave composta para atualizar o registro
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

-- joga para o banco

forall i in tb_cd_procedimento_p.first..tb_cd_procedimento_p.last
	update	sip_nv_dados
	set	cd_procedimento_pct	= tb_cd_procedimento_p(i),
		ie_origem_proced_pct	= tb_ie_origem_proced_p(i)
	where	nr_seq_lote_sip		= nr_seq_lote_p
	and	nr_seq_conta		= tb_nr_seq_conta_p(i)
	and	nr_seq_pacote		= nr_seq_pacote_p
	and	ie_tipo_despesa		= '4';
	
	
-- se foi marcado para commitar

if (coalesce(ie_commit_p, 'N') = 'S') then

	commit;
end if;


-- se deve esvaziar

if (coalesce(ie_esvaziar_table_p, 'S') = 'S') then

	tb_cd_procedimento_p.delete;
	tb_ie_origem_proced_p.delete;
	tb_nr_seq_conta_p.delete;
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.grava_proc_princ_regra_pct ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nr_seq_pacote_p pls_pacote_proc_princ.nr_seq_pacote%type, tb_cd_procedimento_p INOUT dbms_sql.number_table, tb_ie_origem_proced_p INOUT dbms_sql.number_table, tb_nr_seq_conta_p INOUT dbms_sql.number_table, ie_commit_p text, ie_esvaziar_table_p text) FROM PUBLIC;