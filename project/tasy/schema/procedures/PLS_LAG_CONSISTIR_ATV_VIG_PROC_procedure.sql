-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lag_consistir_atv_vig_proc ( nr_seq_lote_guia_imp_p bigint, nr_seq_lote_proc_imp_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Consistir se o 'Procedimento, inativo ou fora de vigência'.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_procedimento_w	varchar(10);
ie_proc_ativo_w		varchar(1);
ie_origem_proced_w	bigint;
dt_autorizacao_w	timestamp;


BEGIN

begin
	select	dt_autorizacao
	into STRICT	dt_autorizacao_w
	from	pls_lote_anexo_guias_imp
	where	nr_sequencia	= nr_seq_lote_guia_imp_p;
exception
when others then
	dt_autorizacao_w	:= clock_timestamp();
end;

begin
	select	cd_procedimento,
		ie_origem_proced
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w
	from	pls_lote_anexo_proc_imp
	where	nr_sequencia = nr_seq_lote_proc_imp_p;
exception
when others then
	cd_procedimento_w := null;
end;

if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
	ie_proc_ativo_w	:= pls_obter_se_proc_ativo(cd_procedimento_w, ie_origem_proced_w, dt_autorizacao_w);

	/* jtonon - 05/06/13 / N = O procedimento não está ativo. / D = O procedimento está fora da data de vigência. */

	if (ie_proc_ativo_w in ('N','D')) then
		CALL pls_inserir_anexo_glosa_aut('9920', nr_seq_lote_guia_imp_p, nr_seq_lote_proc_imp_p, null, '', nm_usuario_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lag_consistir_atv_vig_proc ( nr_seq_lote_guia_imp_p bigint, nr_seq_lote_proc_imp_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) FROM PUBLIC;

