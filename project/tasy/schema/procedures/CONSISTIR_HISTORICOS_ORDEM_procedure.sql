-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_historicos_ordem ( nr_sequencia_p bigint, nm_usuario_p text, ds_msg_hist_lib_p INOUT text, ds_msg_dialogo_int_p INOUT text) AS $body$
DECLARE

ds_msg_hist_lib_w		varchar(4000);
ds_msg_dialogo_int_w	varchar(4000);
qt_registros_w		integer;
dt_liberacao_w		timestamp;
ie_classif_interno_w		varchar(1);

BEGIN
select 	count(*)
into STRICT	qt_registros_w
from 	man_tipo_hist c,
	man_ordem_serv_tecnico x
where 	x.nr_seq_ordem_serv = nr_sequencia_p
and 	c.ie_classif_interno = 'E'
and 	c.nr_sequencia = x.nr_seq_tipo
and 	x.nm_usuario = nm_usuario_p;
if (qt_registros_w <> 0) then
	select 	max(x.dt_liberacao)
	into STRICT	dt_liberacao_w
	from 	man_ordem_serv_tecnico x
	where 	x.nr_sequencia = (
				SELECT	max(y.nr_sequencia)
				from 	man_tipo_hist c, man_ordem_serv_tecnico y
                                where 	y.nr_seq_ordem_serv = nr_sequencia_p
				and 	c.nr_sequencia = y.nr_seq_tipo
				and 	c.ie_classif_interno  = 'E'
				and 	y.nm_usuario = nm_usuario_p);
	if (coalesce(dt_liberacao_w::text, '') = '') then
		ds_msg_hist_lib_w := obter_texto_tasy(204991, 1);
	end if;
end if;
select 	max(c.ie_classif_interno)
into STRICT	ie_classif_interno_w
from 	man_tipo_hist c,
	man_ordem_serv_tecnico x
where 	c.nr_sequencia = x.nr_seq_tipo
and 	x.nr_sequencia = (
			SELECT 	max(y.nr_sequencia)
			from 	man_ordem_serv_tecnico y
			where 	y.nr_seq_ordem_serv = nr_sequencia_p
			and 	y.nm_usuario = nm_usuario_p);
if (ie_classif_interno_w = 'I') then
	ds_msg_dialogo_int_w :=	obter_texto_tasy(204994, 1);
end if;
ds_msg_hist_lib_p		:= ds_msg_hist_lib_w;
ds_msg_dialogo_int_p	:= ds_msg_dialogo_int_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_historicos_ordem ( nr_sequencia_p bigint, nm_usuario_p text, ds_msg_hist_lib_p INOUT text, ds_msg_dialogo_int_p INOUT text) FROM PUBLIC;

