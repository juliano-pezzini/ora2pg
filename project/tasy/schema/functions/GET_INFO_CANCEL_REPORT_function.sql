-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_info_cancel_report (nr_prescricao_p prescr_proc_auditoria.nr_prescricao%type, nr_seq_prescricao_p prescr_proc_auditoria.nr_sequencia_prescricao%type, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


nm_usuario_w		prescr_proc_auditoria.nm_usuario%type;
dt_cancelamento_w	prescr_proc_auditoria.dt_atualizacao%type;


BEGIN

select	max(nm_usuario),
	max(dt_atualizacao)
into STRICT	nm_usuario_w,
	dt_cancelamento_w
from	prescr_proc_auditoria ppa
where	ppa.nr_prescricao = nr_prescricao_p
and	ppa.nr_sequencia_prescricao = nr_seq_prescricao_p;

if (ie_tipo_retorno_p	= 'U') then
	return	obter_nome_pf(obter_cod_pf_usuario(nm_usuario_w));
elsif (ie_tipo_retorno_p	= 'D') then
	return to_char(dt_cancelamento_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_info_cancel_report (nr_prescricao_p prescr_proc_auditoria.nr_prescricao%type, nr_seq_prescricao_p prescr_proc_auditoria.nr_sequencia_prescricao%type, ie_tipo_retorno_p text) FROM PUBLIC;

