-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_atualiza_status_protocolo (nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE



ie_status_w			varchar(01);
ie_novo_status_w		varchar(01);
qt_item_faturamento_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_item_faturamento_w
from	med_faturamento
where	nr_seq_protocolo	= nr_seq_protocolo_p;

if (qt_item_faturamento_w > 0) then
	begin

	select	ie_status
	into STRICT	ie_status_w
	from	med_prot_convenio
	where	nr_sequencia		= nr_seq_protocolo_p;

	if (ie_status_w		= '1') then
		ie_novo_status_w	:= '2';
	else
		ie_novo_status_w	:= '1';
	end if;

	update	med_prot_convenio
	set	ie_status		= ie_novo_status_w,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_protocolo_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_atualiza_status_protocolo (nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
