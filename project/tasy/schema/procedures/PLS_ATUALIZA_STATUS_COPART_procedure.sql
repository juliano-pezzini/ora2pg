-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_status_copart ( nr_seq_copart_p pls_conta_coparticipacao.nr_seq_conta%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualiza o status da conta de coparticipação para a cobrança da mensalidade
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [x] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
if (nr_seq_copart_p IS NOT NULL AND nr_seq_copart_p::text <> '') then
	update	pls_conta_coparticipacao
	set	ie_status_mensalidade = 'L',
		ie_status_coparticipacao = 'S',
		ie_gerar_mensalidade = 'S'
	where	nr_sequencia = nr_seq_copart_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_status_copart ( nr_seq_copart_p pls_conta_coparticipacao.nr_seq_conta%type) FROM PUBLIC;

