-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_data_quota_parc (nr_seq_quota_parc_p bigint, dt_vencimento_p timestamp, ie_inconsistencia_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_escrituracao_w	bigint;
nr_parcela_w		integer;
dt_vencimento_ant_w	timestamp;
dt_vencimento_pro_w	timestamp;


BEGIN
ie_inconsistencia_p := 'N';

if (nr_seq_quota_parc_p IS NOT NULL AND nr_seq_quota_parc_p::text <> '') then
	select	max(nr_parcela),
		max(nr_seq_escrituracao)
	into STRICT	nr_parcela_w,
		nr_seq_escrituracao_w
	from	pls_escrit_quota_parcela
	where	nr_sequencia = nr_seq_quota_parc_p;

	select	max(dt_vencimento)
	into STRICT	dt_vencimento_pro_w
	from	pls_escrit_quota_parcela
	where	nr_seq_escrituracao	= nr_seq_escrituracao_w
	and	nr_parcela		= nr_parcela_w + 1;

	if (trunc(dt_vencimento_p,'dd') > trunc(dt_vencimento_pro_w,'dd')) then
		ie_inconsistencia_p := 'S';
	end if;

	if (nr_parcela_w > 1) then
		select	max(dt_vencimento)
		into STRICT	dt_vencimento_ant_w
		from	pls_escrit_quota_parcela
		where	nr_seq_escrituracao	= nr_seq_escrituracao_w
		and	nr_parcela		= nr_parcela_w - 1;

		if (trunc(dt_vencimento_p,'dd') < trunc(dt_vencimento_ant_w,'dd')) then
			ie_inconsistencia_p := 'S';
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_data_quota_parc (nr_seq_quota_parc_p bigint, dt_vencimento_p timestamp, ie_inconsistencia_p INOUT text, nm_usuario_p text) FROM PUBLIC;

