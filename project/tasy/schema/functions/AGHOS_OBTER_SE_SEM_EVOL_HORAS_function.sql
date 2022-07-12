-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION aghos_obter_se_sem_evol_horas ( nr_seq_solicitacao_p bigint, qt_horas_p bigint) RETURNS varchar AS $body$
DECLARE


qt_horas_solicitacao_w	double precision;
ie_alerta_evol_w	varchar(1);


BEGIN
select (clock_timestamp() - dt_atualizacao_nrec)
into STRICT	qt_horas_solicitacao_w
from	solicitacao_tasy_aghos
where	nr_sequencia = nr_seq_solicitacao_p;

If	(qt_horas_solicitacao_w > (qt_horas_p/24)) then
	begin
		select	'N'
		into STRICT	ie_alerta_evol_w
		from	evolucao_tasy_aghos
		where	nr_seq_solicitacao = nr_seq_solicitacao_p  LIMIT 1;
	exception
		when 	no_data_found then
			ie_alerta_evol_w := 'S';
		when 	others then
			ie_alerta_evol_w := 'N';
	end;
Else
	ie_alerta_evol_w := 'N';
End if;

return	ie_alerta_evol_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION aghos_obter_se_sem_evol_horas ( nr_seq_solicitacao_p bigint, qt_horas_p bigint) FROM PUBLIC;

