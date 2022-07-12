-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_atendimento_alerta_alert ( nr_seq_atend_alerta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_alert_w		varchar(2000);
nr_seq_tipo_alerta_w	atendimento_alerta.nr_seq_tipo_alerta%type;
nr_seq_alerta_w 	atendimento_alerta.nr_seq_alerta%type;
dt_alerta_w		atendimento_alerta.dt_alerta%type;
ie_allow_free_text_w	tipo_alerta_atend.ie_allow_free_text%type;


BEGIN

begin
select	substr(ds_alerta, 1, 2000),
	dt_alerta,
	nr_seq_tipo_alerta,
	nr_seq_alerta
into STRICT	ds_alert_w,
	dt_alerta_w,
	nr_seq_tipo_alerta_w,
	nr_seq_alerta_w
from	atendimento_alerta
where	nr_sequencia = nr_seq_atend_alerta_p;

exception
when others then
	ds_alert_w := '';
	dt_alerta_w := null;
	nr_seq_tipo_alerta_w := null;
end;

if (nr_seq_tipo_alerta_w IS NOT NULL AND nr_seq_tipo_alerta_w::text <> '') then
	begin

	select 	coalesce(max(ie_allow_free_text),'Y')
	into STRICT	ie_allow_free_text_w
	from	tipo_alerta_atend
	where	nr_sequencia = nr_seq_tipo_alerta_w;

	if (ie_allow_free_text_w = 'N') then

		select 	max(substr(ds_alert, 1, 2000))
		into STRICT 	ds_alert_w
		from 	tipo_alerta_atend_option
		where 	nr_sequencia = nr_seq_alerta_w;

	end if;

	end;
end if;

return pkg_date_formaters.to_varchar(dt_alerta_w, 'shortTime', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_p, nm_usuario_p), null) || ' - ' || ds_alert_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_atendimento_alerta_alert ( nr_seq_atend_alerta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

