-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_motivo_contingencia ( nr_seq_log_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_log_evento_w 	log_integracao.nr_sequencia%type;
ie_status_w		agendamento_integracao.ie_status%type;
ds_erro_w    		varchar(2000);


BEGIN

select	max(a.ie_status)
into STRICT	ie_status_w
from	agendamento_integracao a
where	a.nr_seq_log = nr_seq_log_p;

if (ie_status_w = 'O') then
	select	max(a.nr_sequencia)
	into STRICT 	nr_seq_log_evento_w
	from 	log_integracao_evento a
	where 	a.nr_seq_log = nr_seq_log_p
	and	a.ie_tipo_evento = 'O';

	select	max(a.ds_observacao)
	into STRICT	ds_erro_w
	from	log_integracao_evento a
	where	a.nr_sequencia = nr_seq_log_evento_w;
else
	select	max(a.nr_sequencia)
	into STRICT 	nr_seq_log_evento_w
	from 	log_integracao_evento a
	where 	a.nr_seq_log = nr_seq_log_p
	and	a.ie_tipo_evento = 'C';

	select	substr(max(a.ds_observacao),1,2000)
	into STRICT	ds_erro_w
	from	log_integracao_evento a
	where	a.nr_sequencia = nr_seq_log_evento_w;
end if;

return	ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_motivo_contingencia ( nr_seq_log_p bigint) FROM PUBLIC;

