-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_limpar_base_implant ( ds_senha_p bigint, nr_atendimento_p bigint, qt_tabelas_limpas_p INOUT bigint) AS $body$
DECLARE


nm_tabela_w		varchar(50);
nm_atributo_w		varchar(50);
ds_comando_w		varchar(2000);
qt_reg_w		bigint;
ie_acao_w		varchar(1);
ds_set_update_w	varchar(255);
ds_senha_w		bigint;
nr_atendimento_w	bigint;

sofar_w bigint := 0;
total_work_w bigint := 100;
n_cleanupdb_pck_w bigint := 0;
nm_fase_atualizacao_w cloud_upgrade_log.nm_fase_atualizacao%type := 'DATABASE_CLEANUP';

/* ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO ATENCAO 
ao alterar o cursor c01, eh necessario alterar o SQL dentro do CorSis_FN, pois faz a verificacao se este SQL retorna algo para executar esta procedure*/
C01 CURSOR FOR
SELECT	a.nm_tabela,
	a.ie_acao,
	a.ds_set_update
from	tabela_sistema b,
	tabela_limpeza a
where	a.nm_tabela	= b.nm_tabela
and	dt_avaliacao	> clock_timestamp() - interval '2 days'
and	b.qt_registros_atual > 0
order by nr_seq_limpeza, a.nm_tabela;


BEGIN

SELECT COUNT(1)
INTO STRICT n_cleanupdb_pck_w
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'CLEANUPDB_PCK'
AND STATUS = 'VALID';

  Select	count(1) into STRICT total_work_w
    from	tabela_sistema b,
            tabela_limpeza a
    where	a.nm_tabela	= b.nm_tabela
    and	dt_avaliacao	> clock_timestamp() - interval '2 days'
    and	b.qt_registros_atual > 0;

  select count(trigger_name) into STRICT sofar_w
	from user_triggers
	where status = 'ENABLED';

  total_work_w := total_work_w + (sofar_w * 2);

  select count(1) into STRICT sofar_w
	from user_constraints
	where status = 'ENABLED';

  total_work_w := total_work_w + (sofar_w * 2);

  SELECT count(1) into STRICT sofar_w
  FROM   tabela_sistema;

  total_work_w := total_work_w + sofar_w;
select     max(8501 +
   campo_numerico(to_char(clock_timestamp(),'yyyy')) +
   campo_numerico(to_char(clock_timestamp(),'mm')) +
   campo_numerico(to_char(clock_timestamp(),'dd')))
into STRICT	ds_senha_w
;
select	count(*)
into STRICT	nr_atendimento_w
from	atendimento_paciente;

qt_tabelas_limpas_p := 0;

if (ds_senha_p = ds_senha_w) and (nr_atendimento_w = nr_atendimento_p) then
	update aplicacao_tasy
	set ie_status_aplicacao = 'I';
	commit;

    if (n_cleanupdb_pck_w > 1) then
        EXECUTE 'begin cleanupdb_pck.cleanupdb_init; end;';
        EXECUTE 'begin cleanupdb_pck.init_progress(:nm_fase_atualizacao_w,0,:total_work_w); end;' using nm_fase_atualizacao_w, total_work_w;
    end if;

	CALL Tasy_Disable_Trigger();
	CALL Tasy_Disable_Constraint();

	open c01;
	loop
	fetch c01 into
		nm_tabela_w,
		ie_acao_w,
		ds_set_update_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			if (ie_acao_w = 'T') then
				ds_comando_w := 'truncate table ' || nm_tabela_w;
			elsif (ie_acao_w = 'U') then
				ds_comando_w := 'update ' || nm_tabela_w ||
					' set ' || ds_set_update_w;
			elsif (ie_acao_w in ('D','E')) then
				ds_comando_w := 'delete from ' || nm_tabela_w || ds_set_update_w;
			else
				ds_comando_w := 'select 1 from dual ';
			end	if;
			qt_reg_w := obter_valor_dinamico(ds_comando_w, qt_reg_w);
			qt_tabelas_limpas_p := qt_tabelas_limpas_p + 1;
            if (n_cleanupdb_pck_w > 1) then
              EXECUTE 'begin cleanupdb_pck.add_progress(nm_fase_atualizacao_w, 1); end;';
            end if;
		exception
		when others then
			null;
		end;
	end loop;
	close c01;

	CALL Tasy_Enable_Constraint();
	CALL Tasy_Enable_Trigger();

	update aplicacao_tasy
	set ie_status_aplicacao = 'A';
	commit;

	--tasy_consistir_base;
    
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_limpar_base_implant ( ds_senha_p bigint, nr_atendimento_p bigint, qt_tabelas_limpas_p INOUT bigint) FROM PUBLIC;

