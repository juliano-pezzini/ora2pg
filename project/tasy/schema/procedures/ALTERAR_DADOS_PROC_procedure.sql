-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_dados_proc ( cd_senha_p text, nr_doc_conv_p text, nr_prescricao_p bigint, nr_seq_proc_p bigint) AS $body$
DECLARE

dt_alta_w	timestamp;


BEGIN

if (cd_senha_p IS NOT NULL AND cd_senha_p::text <> '') then

	update	prescr_procedimento
	set 	cd_senha = SUBSTR(cd_senha_p,1,20)
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia = nr_seq_proc_p;

	update	procedimento_paciente
	set	cd_senha = SUBSTR(cd_senha_p,1,20)
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia_prescricao = nr_seq_proc_p;

	update	autorizacao_convenio a
	set	a.cd_senha = SUBSTR(cd_senha_p,1,20)
	where	a.nr_prescricao = nr_prescricao_p;

end if;

if (nr_doc_conv_p IS NOT NULL AND nr_doc_conv_p::text <> '') then

	update	prescr_procedimento
	set	nr_doc_convenio = SUBSTR(nr_doc_conv_p,1,20)
	where	nr_prescricao   = nr_prescricao_p
	and	nr_sequencia    = nr_seq_proc_p;

	update	procedimento_paciente
	set	nr_doc_convenio = SUBSTR(nr_doc_conv_p,1,20)
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia_prescricao = nr_seq_proc_p;

	update	autorizacao_convenio a
	set	a.cd_autorizacao = SUBSTR(nr_doc_conv_p,1,20)
	where	a.nr_prescricao = nr_prescricao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_dados_proc ( cd_senha_p text, nr_doc_conv_p text, nr_prescricao_p bigint, nr_seq_proc_p bigint) FROM PUBLIC;
