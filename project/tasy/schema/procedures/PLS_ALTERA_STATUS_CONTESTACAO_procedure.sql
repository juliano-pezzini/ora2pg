-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_altera_status_contestacao ( nr_seq_contestacao_p pls_lote_contestacao.nr_sequencia%type, ie_status_p pls_lote_contestacao.ie_status%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Altera o status da contestação

	Foi criado uam rotina separada, pois alguns status podem precisar realizar algumas operações

	Por exemplo, quando a contestação for concluida, todas as contas em discussão deverão
	ter o seu status alterado para "[E] - Discussao encerrada"

	Atenção, NÃO DEVERÁ TER COMMIT, essa rotina atualmente é chamada por trigger,
	portanto ela não poderá ter commit.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

	NÃO DEVERÁ TER COMMIT, essa rotina atualmente é chamada por trigger,
	portanto ela não poderá ter commit.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/-- Carrega os lotes de discussão da contestação
c01 CURSOR(	nr_seq_contestacao_pc	pls_lote_contestacao.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_lote_discussao	a
	where	a.nr_seq_lote_contest	= nr_seq_contestacao_pc
	and	a.ie_status		= 'F';

BEGIN

-- se for concluido
if (ie_status_p = 'C') then

	-- busca todos os lotes de discussão que estiverem fechados ou cancelados, e atualiza o status das contas da discussão (não a conta médica) para "[E] - Discussao encerrada"
	for r_c01_w in c01(nr_seq_contestacao_p) loop

		update	pls_contestacao_discussao
		set	ie_status	= 'E',
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_seq_lote	= r_c01_w.nr_sequencia;
	end loop;

	-- atualiza o status
	update	pls_lote_contestacao
	set	ie_status	= ie_status_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_contestacao_p;

else

	-- apenas atualiza o status passado
	update	pls_lote_contestacao
	set	ie_status	= ie_status_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_contestacao_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_altera_status_contestacao ( nr_seq_contestacao_p pls_lote_contestacao.nr_sequencia%type, ie_status_p pls_lote_contestacao.ie_status%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

