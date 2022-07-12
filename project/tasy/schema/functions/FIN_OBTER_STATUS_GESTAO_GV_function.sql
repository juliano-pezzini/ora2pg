-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fin_obter_status_gestao_gv ( nr_seq_gv_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(50) := wheb_mensagem_pck.get_texto(803053);
ie_retorno_w		varchar(5) := '1';
ie_etapa_viagem_w		varchar(10);
dt_receb_fin_w		timestamp;
dt_aprov_fin_w		timestamp;
dt_receb_proj_w		timestamp;


BEGIN
select	max(a.ie_etapa_viagem),
	max(a.dt_receb_fin),
	max(a.dt_aprov_fin),
	max(a.dt_receb_proj)
into STRICT	ie_etapa_viagem_w,
	dt_receb_fin_w,
	dt_aprov_fin_w,
	dt_receb_proj_w
from	via_viagem a
where	a.nr_sequencia = nr_seq_gv_p;

if ((coalesce(dt_aprov_fin_w,null) IS NOT NULL AND (coalesce(dt_aprov_fin_w,null))::text <> '')) then
	ie_retorno_w := '6';
elsif ((coalesce(dt_receb_fin_w,null) IS NOT NULL AND (coalesce(dt_receb_fin_w,null))::text <> '')) then
	ie_retorno_w := '5';
elsif (coalesce(ie_etapa_viagem_w,'X') = '5') then
	ie_retorno_w := '4';
elsif ((coalesce(dt_receb_proj_w,null) IS NOT NULL AND (coalesce(dt_receb_proj_w,null))::text <> '')) then
	ie_retorno_w := '3';
elsif (coalesce(ie_etapa_viagem_w,'X') = '8') then
	ie_retorno_w := '2';
else	ie_retorno_w := '1';
end if;

if (ie_opcao_p = 'C') then
	ds_retorno_w := ie_retorno_w;
elsif (ie_retorno_w = '1') then
	ds_retorno_w := wheb_mensagem_pck.get_texto(803053);
elsif (ie_retorno_w = '2') then
	ds_retorno_w := wheb_mensagem_pck.get_texto(803054);
elsif (ie_retorno_w = '3') then
	ds_retorno_w := wheb_mensagem_pck.get_texto(803055);
elsif (ie_retorno_w = '4') then
	ds_retorno_w := wheb_mensagem_pck.get_texto(803056);
elsif (ie_retorno_w = '5') then
	ds_retorno_w := wheb_mensagem_pck.get_texto(803057);
elsif (ie_retorno_w = '6') then
	ds_retorno_w := wheb_mensagem_pck.get_texto(803058);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fin_obter_status_gestao_gv ( nr_seq_gv_p bigint, ie_opcao_p text) FROM PUBLIC;
