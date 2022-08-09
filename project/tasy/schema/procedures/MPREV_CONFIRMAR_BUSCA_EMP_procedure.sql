-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_confirmar_busca_emp ( nr_seq_busca_emp_p bigint, ie_commit_p text default 'S', nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Confirmar a indicação da Medicina Preventiva. (Busca Empresarial)
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_captacao_w	mprev_captacao.nr_sequencia%type;
nr_seq_captacao_dest_w	mprev_captacao_destino.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	mprev_captacao_destino
	where	nr_seq_captacao = nr_seq_captacao_w;


BEGIN

if (nr_seq_busca_emp_p IS NOT NULL AND nr_seq_busca_emp_p::text <> '') then

	update	mprev_busca_empresarial
	set	dt_confirmacao = clock_timestamp()
	where	nr_sequencia = nr_seq_busca_emp_p;

	update	mprev_captacao
	set	dt_inclusao = clock_timestamp(),
		ie_status = 'P'
	where	nr_seq_busca_emp = nr_seq_busca_emp_p;

	select	max(nr_sequencia)
	into STRICT	nr_seq_captacao_w
	from	mprev_captacao
	where	NR_SEQ_BUSCA_EMP = nr_seq_busca_emp_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_captacao_dest_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			CALL mprev_gerar_resp_dest_capt(nr_seq_captacao_dest_w, nm_usuario_p);
		end;
	end loop;
	close C01;

	if (coalesce(ie_commit_p::text, '') = '') or (ie_commit_p = 'S') then
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_confirmar_busca_emp ( nr_seq_busca_emp_p bigint, ie_commit_p text default 'S', nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
