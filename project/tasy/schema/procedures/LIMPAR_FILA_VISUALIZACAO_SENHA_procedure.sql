-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function limpar_fila_visualizacao_senha as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE limpar_fila_visualizacao_senha (nr_seq_monitor_p bigint, nr_seq_pac_senha_fila_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL limpar_fila_visualizacao_senha_atx ( ' || quote_nullable(nr_seq_monitor_p) || ',' || quote_nullable(nr_seq_pac_senha_fila_p) || ',' || quote_nullable(nr_sequencia_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE limpar_fila_visualizacao_senha_atx (nr_seq_monitor_p bigint, nr_seq_pac_senha_fila_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN

-- apagar outras chamadas da mesma senha

--if 	((nr_seq_pac_senha_fila_p > 0) and (nr_sequencia_p > 0)) then		
  delete FROM fila_visualizacao_senha a
   where a.nr_seq_monitor = nr_seq_monitor_p
	 and a.nr_seq_pac_senha_fila = nr_seq_pac_senha_fila_p
	 and a.nr_sequencia <> nr_sequencia_p;
--end if;


-- apagar chamadas em excesso (para nao acumular dados na tabela, permitindo sempre um consulta rapida)
DELETE FROM fila_visualizacao_senha a
 WHERE coalesce(a.nr_seq_monitor, nr_seq_monitor_p) = nr_seq_monitor_p
   AND a.ie_situacao = 'I'
   AND a.nr_sequencia < (SELECT	MIN(y.nr_sequencia)
				           FROM (SELECT b.nr_sequencia, row_number() over (ORDER BY nr_sequencia DESC) nrlinha
					               FROM fila_visualizacao_senha b
					              WHERE b.nr_seq_monitor = nr_seq_monitor_p
					                AND b.ie_situacao = 'I') y
				          WHERE y.nrlinha = 10);		
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_fila_visualizacao_senha (nr_seq_monitor_p bigint, nr_seq_pac_senha_fila_p bigint, nr_sequencia_p bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE limpar_fila_visualizacao_senha_atx (nr_seq_monitor_p bigint, nr_seq_pac_senha_fila_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
