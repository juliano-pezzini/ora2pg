-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function sepse_proc_integracao as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE sepse_proc_integracao () AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL sepse_proc_integracao_atx ()';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE sepse_proc_integracao_atx () AS $body$
DECLARE
erro_w varchar(2000);
dt_atual_w timestamp := clock_timestamp() - (2/1440);

c01 CURSOR FOR
	SELECT distinct nr_atendimento,
		cd_pessoa_fisica,
		nm_usuario
	from w_sepse_procedimento
	where (nm_usuario IS NOT NULL AND nm_usuario::text <> '')
	and (nr_atendimento IS NOT NULL AND nr_atendimento::text <> '')
	and dt_atualizacao < dt_atual_w;

BEGIN

for procs in c01
loop
	begin
		CALL gerar_escala_sepse(procs.nr_atendimento,procs.cd_pessoa_fisica,0,procs.nm_usuario,null);
		exception
		when others then
			erro_w := sqlerrm;
			CALL gravar_log_tasy(99992,SUBSTR('Erro na Integração ao gerar SEPSE = ' || erro_w,1,2000),wheb_usuario_pck.get_nm_usuario);
	end;
end loop;

delete FROM w_sepse_procedimento where dt_atualizacao < dt_atual_w;
commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sepse_proc_integracao () FROM PUBLIC; -- REVOKE ALL ON PROCEDURE sepse_proc_integracao_atx () FROM PUBLIC;

