-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_cta_redundancia_pck.converte_status_proc_partic ( ie_status_proc_p pls_conta_proc.ie_status%type) RETURNS varchar AS $body$
DECLARE


ie_status_conv_partic_w	pls_proc_participante.ie_status%type;

BEGIN

case(ie_status_proc_p)
	-- em análise (proc) vira aguardando ação do usuário (partic)
	when 'A' then
		ie_status_conv_partic_w := 'U';
	-- consistido (proc) vira aguardando ação do usuário (partic)
	when 'C' then
		ie_status_conv_partic_w := 'U';
	-- cancelado (proc) vira cancelado (partic)
	when 'D' then
		ie_status_conv_partic_w := 'C';
	-- liberado pelo usuário (proc) vira Liberado (partic)
	when 'L' then
		ie_status_conv_partic_w := 'L';
	-- faturamento manual (proc) vira Liberado (partic)
	when 'M' then
		ie_status_conv_partic_w := 'L';
	-- pendente de liberação (proc) vira aguardando ação do usuário (partic)
	when 'P' then
		ie_status_conv_partic_w := 'U';
	-- liberado pelo Sistema (proc) vira liberado (partic)
	when 'S' then
		ie_status_conv_partic_w := 'L';
	-- usuário (aguardando ação) (proc) vira aguardando ação do usuário (partic)
	when 'U' then
		ie_status_conv_partic_w := 'U';
	else
		null;
end case;

return ie_status_conv_partic_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cta_redundancia_pck.converte_status_proc_partic ( ie_status_proc_p pls_conta_proc.ie_status%type) FROM PUBLIC;