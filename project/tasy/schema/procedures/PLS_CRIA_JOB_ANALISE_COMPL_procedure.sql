-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cria_job_analise_compl () AS $body$
DECLARE


jobno			bigint;
qt_reg_w		bigint;
ds_comando_job_w	varchar(2000);


BEGIN

-- verifica se existem jobs ativas, se tiver alguma job parada j?? faz a limpeza da mesma
qt_reg_w := pls_obter_qt_job_ativa('PLS_PROCES_CTA_ANALISE_COMPL', qt_reg_w);

if (qt_reg_w = 0) then
	begin
		ds_comando_job_w	:= 'PLS_PROCES_CTA_ANALISE_COMPL;';
		DBMS_JOB.SUBMIT(JOBNO,
				ds_comando_job_w,
				clock_timestamp() + interval '5 days' * (1/24/60/60),
				'(SYSDATE) + 0.1/24');
		commit;
	exception
	when others then
		null;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cria_job_analise_compl () FROM PUBLIC;
