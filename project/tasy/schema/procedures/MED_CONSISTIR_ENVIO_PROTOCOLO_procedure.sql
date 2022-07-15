-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_consistir_envio_protocolo (nr_seq_protocolo_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE



cd_convenio_w		integer;
nr_seq_plano_w		bigint;
ie_beneficiario_w	varchar(01);
cd_cgc_w		varchar(14);
cd_medico_w		varchar(10);
cd_interface_w		integer;
qt_item_tipo_guia_w	bigint;
qt_item_guia_w		bigint;


BEGIN

select	cd_convenio,
	nr_seq_plano,
	ie_beneficiario,
	cd_cgc,
	cd_medico
into STRICT	cd_convenio_w,
	nr_seq_plano_w,
	ie_beneficiario_w,
	cd_cgc_w,
	cd_medico_w
from	med_prot_convenio
where	nr_sequencia	= nr_seq_protocolo_p;

select	count(*)
into STRICT	qt_item_tipo_guia_w
from	med_faturamento
where	nr_seq_protocolo	= nr_seq_protocolo_p
and	coalesce(ie_tipo_guia::text, '') = '';


select	count(*)
into STRICT	qt_item_guia_w
from	med_faturamento
where	nr_seq_protocolo	= nr_seq_protocolo_p
and	coalesce(cd_guia::text, '') = '';

if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then
	begin

	select	coalesce(max(cd_interface),0)
	into STRICT	cd_interface_w
	from	med_plano
	where	cd_convenio	= cd_convenio_w
	and	nr_sequencia	= nr_seq_plano_w
	and	cd_medico	= cd_medico_w;

	end;
else
	begin

	select	coalesce(max(cd_interface),0)
	into STRICT	cd_interface_w
	from	med_plano
	where	cd_convenio	= cd_convenio_w
	and	cd_medico	= cd_medico_w;

	end;
end if;

if (cd_interface_w = 0) then
	ds_erro_p	:= ds_erro_p || wheb_mensagem_pck.get_texto(285632) || chr(13) || chr(10); -- 'Interface não informada'
end if;

if (ie_beneficiario_w = 'C') and (coalesce(cd_cgc_w::text, '') = '') then
	ds_erro_p	:= ds_erro_p || wheb_mensagem_pck.get_texto(285633) || chr(13) || chr(10); -- 'Clínica não informada'
end if;

if (qt_item_tipo_guia_w > 0) then
	ds_erro_p	:= ds_erro_p || wheb_mensagem_pck.get_texto(285634) || chr(13) || chr(10); -- 'Existem itens sem tipo de guia informada'
end if;

if (qt_item_guia_w > 0) then
	ds_erro_p	:= ds_erro_p || wheb_mensagem_pck.get_texto(285635) || chr(13) || chr(10); -- 'Existem itens sem guia informada'
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_consistir_envio_protocolo (nr_seq_protocolo_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

