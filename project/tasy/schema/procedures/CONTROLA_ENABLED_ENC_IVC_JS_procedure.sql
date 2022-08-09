-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE controla_enabled_enc_ivc_js ( nr_sequencia_p bigint, nm_usuario_p text, ie_existe_p INOUT text) AS $body$
DECLARE


nr_prescricao_w	bigint;
nr_seq_procedimento_w	bigint;
ie_exite_w	varchar(1);


BEGIN

ie_exite_w := 'S';

select 	max(nr_prescricao),
	max(nr_seq_procedimento)
into STRICT	nr_prescricao_w,
	nr_seq_procedimento_w
from 	prescr_proc_hor
where 	nr_sequencia = nr_sequencia_p;

if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '' AND nr_seq_procedimento_w IS NOT NULL AND nr_seq_procedimento_w::text <> '') then
	begin
		select  coalesce(max('S'),'N')
		into STRICT	ie_exite_w
		from 	prescr_proc_hor
		where   nr_prescricao  = nr_prescricao_w
		and     nr_seq_procedimento  = nr_seq_procedimento_w
		and     coalesce(dt_suspensao::text, '') = ''
		and	ie_status_ivc <> 'I'
		and	ie_status_ivc <> 'N';

	end;
end if;

ie_existe_p := ie_exite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE controla_enabled_enc_ivc_js ( nr_sequencia_p bigint, nm_usuario_p text, ie_existe_p INOUT text) FROM PUBLIC;
