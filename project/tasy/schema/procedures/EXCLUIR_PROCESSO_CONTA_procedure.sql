-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_processo_conta ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, nm_usuario_p conta_pac_deducao_conv.nm_usuario%type) AS $body$
DECLARE


qt_processada_w		bigint;


BEGIN

if (pkg_i18n.get_user_locale = 'es_AR') then
	CALL undo_account_processing(nr_interno_conta_p, nm_usuario_p);
else
	if (pkg_i18n.get_user_locale = 'es_CO') then
	    CALL processar_conta_col(nr_interno_conta_p,nm_usuario_p);
	else
	    CALL excluir_itens_processados(nr_interno_conta_p);
	end if;

	select	count(a.nr_sequencia)
	into STRICT	qt_processada_w
	from	conta_pac_deducao_conv a
	where	(a.dt_processamento IS NOT NULL AND a.dt_processamento::text <> '')
	and	nr_seq_conta_orig = nr_interno_conta_p;

	if (qt_processada_w > 0) then
		update	conta_pac_deducao_conv
		set		dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p,
				nr_seq_conta_des  = NULL,
				dt_processamento  = NULL,
				vl_calculado  = NULL,
				vl_calculado_com_imp  = NULL,
				vl_calculado_sem_imp  = NULL
		where	nr_seq_conta_orig = nr_interno_conta_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_processo_conta ( nr_interno_conta_p conta_paciente.nr_interno_conta%type, nm_usuario_p conta_pac_deducao_conv.nm_usuario%type) FROM PUBLIC;
