-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ws_gerar_prescr_proc_compl ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE


-- IE_OPCAO_P = Domain 8503
ie_registra_proc_integ_w	lab_parametro.ie_registra_proc_integ%type;


BEGIN

select	coalesce(max(ie_registra_proc_integ), 'N')
into STRICT	ie_registra_proc_integ_w
from	lab_parametro
where	cd_estabelecimento = (SELECT cd_estabelecimento from prescr_medica where nr_prescricao = nr_prescricao_p);

if (coalesce(ie_registra_proc_integ_w, 'N') = 'S') then
	CALL gerar_prescr_proc_compl(nr_prescricao_p, nr_sequencia_p, nm_usuario_p, ie_opcao_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ws_gerar_prescr_proc_compl ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

