-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hpms_proposal_request_pck.wsuite_cancel_proposal ( nr_seq_proposta_p pls_proposta_online.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Ends the proposal process.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  x]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 



BEGIN

update	pls_proposta_online
set	ie_status	= 'C',
	ie_estagio	= 'PE',
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_proposta_p;

CALL hpms_proposal_request_pck.wsuite_generate_hist_proposal(nr_seq_proposta_p, null, wheb_mensagem_pck.get_texto(1107272,'NM_USUARIO=' || nm_usuario_p||'.'), nm_usuario_p, 'N');

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_proposal_request_pck.wsuite_cancel_proposal ( nr_seq_proposta_p pls_proposta_online.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
