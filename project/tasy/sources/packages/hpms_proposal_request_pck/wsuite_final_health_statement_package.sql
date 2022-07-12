-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hpms_proposal_request_pck.wsuite_final_health_statement (nr_seq_proposta_p pls_proposta_online.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ x] Outros: HTML5
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_benef_online
	where	nr_seq_prop_online	= nr_seq_proposta_p;

BEGIN

for C01_w in C01 loop
	begin
	update	pls_declaracao_segurado
	set	ie_status			= 'L',
		nm_usuario			= nm_usuario_p,
		dt_atualizacao			= clock_timestamp()
	where	nr_seq_prop_benef_online	= C01_w.nr_sequencia;
	end;
end loop;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_proposal_request_pck.wsuite_final_health_statement (nr_seq_proposta_p pls_proposta_online.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;