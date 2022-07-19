-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_processo_a500 () AS $body$
DECLARE


ie_status_w		ptu_fatura.ie_status%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		ds_sid_processo,
		ds_serial_processo
	from	ptu_fatura
	where	ie_status = 'EI';
	
BEGIN

for r_c01_w in c01 loop
	if (r_c01_w.ds_sid_processo IS NOT NULL AND r_c01_w.ds_sid_processo::text <> '') and (r_c01_w.ds_serial_processo IS NOT NULL AND r_c01_w.ds_serial_processo::text <> '') and (pls_util_pck.obter_se_sessao_ativa(r_c01_w.ds_sid_processo, r_c01_w.ds_serial_processo) = 'N') then
		select	max(ie_status)
		into STRICT	ie_status_w
		from	ptu_fatura
		where	nr_sequencia = r_c01_w.nr_sequencia;
		
		if (ie_status_w = 'EI') then
			update	ptu_fatura
			set	ie_status = 'I',
				ie_lib_import = 'S',
				ds_observacao_inf = ds_observacao_inf || ' - Inconsistente pela JOB'
			where	nr_sequencia = r_c01_w.nr_sequencia;
			commit;
		end if;
	end if;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_processo_a500 () FROM PUBLIC;

