-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lab_execucao_etapa_html5 ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_etapa_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao_p
	'U' - nm_usuario
	'D' - dt_atualizacao
	'S' - sequencia
*/
nm_usuario_w		varchar(15);
dt_atualizacao_w	timestamp;
nr_sequencia_w		bigint;


BEGIN

nm_usuario_w := '';
dt_atualizacao_w := null;

select coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from 	prescr_proc_etapa
where	nr_prescricao		= nr_prescricao_p
  and	nr_seq_prescricao	= nr_Seq_prescr_p
  and	ie_etapa		= ie_etapa_p;

if (nr_sequencia_w > 0) then
	select	coalesce(max(nm_usuario),''),
		coalesce(max(dt_atualizacao), null)
	into STRICT	nm_usuario_w,
		dt_atualizacao_w
	from 	prescr_proc_etapa
	where	nr_prescricao		= nr_prescricao_p
	  and	nr_seq_prescricao	= nr_Seq_prescr_p
	  and	ie_etapa		= ie_etapa_p
	  and 	nr_sequencia		= nr_sequencia_w;
end if;

if (ie_opcao_p = 'U') then
	return nm_usuario_w;
elsif (ie_opcao_p = 'D') then
	return dt_atualizacao_W;
elsif (ie_opcao_p = 'S') then
	return nr_sequencia_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lab_execucao_etapa_html5 ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_etapa_p text, ie_opcao_p text) FROM PUBLIC;

