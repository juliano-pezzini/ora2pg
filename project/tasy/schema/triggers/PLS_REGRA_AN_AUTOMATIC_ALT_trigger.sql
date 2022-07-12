-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_an_automatic_alt ON pls_regra_an_automatic CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_an_automatic_alt() RETURNS trigger AS $BODY$
declare

qt_registros_ant_w		integer	:= 0;
qt_registros_gerar_w		integer	:= 0;
ds_interval_w			varchar(100)	:= 0;
qt_interval_w			double precision;
ds_comando_job_w		varchar(2000);
jobno				bigint;
ds_sqlerrm_w	varchar(4000);

C01 CURSOR FOR
	SELECT	job
	from	job_v
	where	comando	like '%PLS_PROCESSAR_ANALISE_CTA_PEND%';
BEGIN
  BEGIN

--Verifica se é update para buscar os registros anteriores
if (TG_OP = 'UPDATE') then
	qt_registros_ant_w	:= OLD.qt_analise;
end if;

--Verifica se o registro antigo é diferente do novo
if (qt_registros_ant_w <> NEW.qt_analise) then

	--Remove todas as JOBS atuais
	for r_c01_w in C01 loop
		dbms_job.remove(r_C01_w.job);
	end loop;


	qt_registros_gerar_w	:= NEW.qt_analise;
	qt_interval_w		:= 0.100;

	--Aqui faz o loop para criar todas as JOBS conforme a quantidade de processos que o cliente informar
	while(qt_registros_gerar_w > 0) loop

		BEGIN
			--Cria um intervalo a cada 4 segundos para cada JOB
			ds_interval_w		:= '(SYSDATE) + ' || replace(to_char(qt_interval_w),',','.')||'/24';
			ds_comando_job_w	:= 'PLS_PROCESSAR_ANALISE_CTA_PEND(' || pls_util_pck.aspas_w  || 'TASY'|| pls_util_pck.aspas_w|| ',null);';
			DBMS_JOB.SUBMIT(JOBNO,
					ds_comando_job_w,
					LOCALTIMESTAMP + interval '5 days' * (1/24/60/60),
					ds_interval_w);
			commit;
		exception
		when others then
			null;
		end;

		--Incrementa o intervalo
		qt_interval_w	:= qt_interval_w + 0.001;
		--Decrementa o intervalo
		qt_registros_gerar_w	:= qt_registros_gerar_w - 1;

	end loop;

end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_an_automatic_alt() FROM PUBLIC;

CREATE TRIGGER pls_regra_an_automatic_alt
	AFTER INSERT OR UPDATE ON pls_regra_an_automatic FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_an_automatic_alt();
