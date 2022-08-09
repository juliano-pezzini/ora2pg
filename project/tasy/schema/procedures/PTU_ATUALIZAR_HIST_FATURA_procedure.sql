-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_atualizar_hist_fatura ( nr_seq_fatura_p bigint, ie_tipo_historico_p bigint, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


ds_call_stack_w		varchar(4000);

BEGIN


ds_call_stack_w := substr(sqlerrm || ' ' || DBMS_UTILITY.FORMAT_CALL_STACK,1,4000);

update	ptu_fatura_historico
set	ie_acao_executada	= 'S',
	dt_historico		= clock_timestamp(),
	ds_call_stack		= ds_call_stack_w
where	ie_tipo_historico	= ie_tipo_historico_p
and	nr_seq_fatura		= nr_seq_fatura_p;

/* William - OS 405855 - Adicionado ie_commit_p */

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_atualizar_hist_fatura ( nr_seq_fatura_p bigint, ie_tipo_historico_p bigint, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
