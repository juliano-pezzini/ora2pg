-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_creden_prestador_pck.gerar_qualificacoes ( nr_seq_credenciamento_p pls_creden_prestador.nr_sequencia%type, nr_seq_prestador_p pls_prestador_proc.nr_seq_prestador%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

C01 CURSOR FOR
	SELECT	dt_inicio_vigencia,
		dt_fim_vigencia,
		ie_acreditacao,
		ie_tipo_acreditacao,
		ie_nivel_acred_ona,
		nr_seq_instituicao_acred
	from	pls_cred_prest_qualif
	where	nr_seq_credenciamento = nr_seq_credenciamento_p;
BEGIN
for c01_w in C01 loop
	begin
	insert	into	pls_prestador_qualif(	nr_sequencia, nr_seq_prestador, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			ie_acreditacao, ie_tipo_acreditacao, ie_nivel_acred_ona,
			dt_inicio_vigencia, dt_fim_vigencia, nr_seq_instituicao_acred )
		values (nextval('pls_prestador_qualif_seq'), nr_seq_prestador_p, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			c01_w.ie_acreditacao, c01_w.ie_tipo_acreditacao, c01_w.ie_nivel_acred_ona,
			c01_w.dt_inicio_vigencia, c01_w.dt_fim_vigencia, c01_w.nr_seq_instituicao_acred );
	end;
end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_creden_prestador_pck.gerar_qualificacoes ( nr_seq_credenciamento_p pls_creden_prestador.nr_sequencia%type, nr_seq_prestador_p pls_prestador_proc.nr_seq_prestador%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;