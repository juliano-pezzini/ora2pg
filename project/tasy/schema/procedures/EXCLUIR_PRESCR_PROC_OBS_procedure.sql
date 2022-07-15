-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_prescr_proc_obs ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_seq_prescricao_p bigint) AS $body$
DECLARE


			qt_registros bigint;

BEGIN

delete from prescr_procedimento_obs
where	nr_sequencia = nr_sequencia_p;

commit;

select count(nr_prescricao)
  into STRICT qt_registros
	from prescr_procedimento_obs
	where nr_prescricao=nr_prescricao_p;


if (qt_registros=0) then

	UPDATE prescr_procedimento
	SET ie_status_execucao = '20'
	WHERE nr_prescricao = nr_prescricao_p
	AND  nr_sequencia 	= nr_seq_prescricao_p;

	COMMIT;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_prescr_proc_obs ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;

