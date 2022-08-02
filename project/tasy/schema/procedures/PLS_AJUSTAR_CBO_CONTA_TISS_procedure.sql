-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_cbo_conta_tiss () AS $body$
DECLARE


nr_seq_conta_w				pls_util_cta_pck.t_number_table;
nr_seq_cbo_saude_novo_w			pls_util_cta_pck.t_number_table;
nr_seq_cbo_saude_ant_w			pls_util_cta_pck.t_number_table;
nr_seq_cbo_saude_aux_w			pls_conta.nr_seq_cbo_saude%type;
index_w					integer	:= 0;
qt_registros_w				integer	:= 0;

C01 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_conta,
		b.nr_seq_cbo_saude,
		b.cd_medico_executor
	from	pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_seq_protocolo	= a.nr_sequencia
	and	trunc(a.dt_mes_competencia,'Month')	>= to_date('01/06/2014')
	and	b.ie_status		= 'F'
	and	b.ie_tipo_guia		= '3'
	and	a.ie_origem_protocolo	not in ('A','Z')
	and	(b.cd_medico_executor IS NOT NULL AND b.cd_medico_executor::text <> '')
	and	(b.nr_seq_cbo_saude IS NOT NULL AND b.nr_seq_cbo_saude::text <> '')
	and	exists (	SELECT	1
				from	cbo_saude_tiss		x
				where	x.nr_seq_cbo_saude	= b.nr_seq_cbo_saude
				and	x.ie_versao		<> '3.02.00');

C02 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_conta,
		b.nr_seq_cbo_saude,
		b.CD_MEDICO_SOLICITANTE
	from	pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_seq_protocolo	= a.nr_sequencia
	and	trunc(a.dt_mes_competencia,'Month')	>= to_date('01/06/2014')
	and	b.ie_status		= 'F'
	and	b.ie_tipo_guia		= '3'
	and	a.ie_origem_protocolo	not in ('A','Z')
	and	(b.CD_MEDICO_SOLICITANTE IS NOT NULL AND b.CD_MEDICO_SOLICITANTE::text <> '')
	and	(b.nr_seq_cbo_saude IS NOT NULL AND b.nr_seq_cbo_saude::text <> '')
	and	exists (	SELECT	1
				from	cbo_saude_tiss		x
				where	x.nr_seq_cbo_saude	= b.nr_seq_cbo_saude
				and	x.ie_versao		<> '3.02.00');
BEGIN

select	count(1)
into STRICT	qt_registros_w
from	user_tables
where	table_name	= 'LOG_MONIT_CBO_SAUDE';

if ( qt_registros_w = 0 ) then
	CALL exec_sql_dinamico('TASY_IMP','create TABLE LOG_MONIT_CBO_SAUDE( NR_SEQ_CONTA	NUMBER(10), NR_SEQ_CBO_SAUDE NUMBER(10), NR_SEQ_CBO_SAUDE_NOVO NUMBER(10))');
end if;

for c01_w in c01 loop
	nr_seq_cbo_saude_aux_w		:= pls_obter_cbo_medico(c01_w.cd_medico_executor);

	if (nr_seq_cbo_saude_aux_w IS NOT NULL AND nr_seq_cbo_saude_aux_w::text <> '') and (nr_seq_cbo_saude_aux_w <> c01_w.nr_seq_cbo_saude) then
		index_w				:= index_w + 1;
		nr_seq_conta_w(index_w)		:= c01_w.nr_seq_conta;
		nr_seq_cbo_saude_novo_w(index_w)	:= nr_seq_cbo_saude_aux_w;
		nr_seq_cbo_saude_ant_w(index_w)	:= c01_w.nr_seq_cbo_saude;
	end if;


	if (index_w	>= 4000) then

		for i in nr_seq_conta_w.first..nr_seq_conta_w.count loop
			CALL exec_sql_dinamico('TASY_IMP', 'insert into LOG_MONIT_CBO_SAUDE( NR_SEQ_CONTA,NR_SEQ_CBO_SAUDE,NR_SEQ_CBO_SAUDE_NOVO) '||
					' values ( '  || nr_seq_conta_w(i) || ',' || nr_seq_cbo_saude_ant_w(i) || ','|| nr_seq_cbo_saude_novo_w(i) || ')');
		end loop;

		commit;

		forall i in nr_seq_conta_w.first..nr_seq_conta_w.last
			update	pls_conta
			set	nr_seq_cbo_saude	= nr_seq_cbo_saude_novo_w(i)
			where	nr_sequencia		= nr_seq_conta_w(i);

		commit;

		nr_seq_conta_w.delete;
		nr_seq_cbo_saude_novo_w.delete;
		nr_seq_cbo_saude_ant_w.delete;

		index_w	:= 0;
	end if;
end loop;

if (nr_seq_conta_w.count > 0) then
	forall i in nr_seq_conta_w.first..nr_seq_conta_w.last
		update	pls_conta
		set	nr_seq_cbo_saude	= nr_seq_cbo_saude_novo_w(i)
		where	nr_sequencia		= nr_seq_conta_w(i);

	commit;

	for i in nr_seq_conta_w.first..nr_seq_conta_w.count loop
		CALL exec_sql_dinamico('TASY_IMP', 'insert into LOG_MONIT_CBO_SAUDE( NR_SEQ_CONTA,NR_SEQ_CBO_SAUDE,NR_SEQ_CBO_SAUDE_NOVO) '||
				' values ( '  || nr_seq_conta_w(i) || ',' || nr_seq_cbo_saude_ant_w(i) || ','|| nr_seq_cbo_saude_novo_w(i) || ')');
	end loop;

	commit;

	nr_seq_conta_w.delete;
	nr_seq_cbo_saude_novo_w.delete;
	nr_seq_cbo_saude_ant_w.delete;
end if;

nr_seq_conta_w.delete;
nr_seq_cbo_saude_novo_w.delete;
nr_seq_cbo_saude_ant_w.delete;


for c02_w in c02 loop
	nr_seq_cbo_saude_aux_w		:= pls_obter_cbo_medico(c02_w.CD_MEDICO_SOLICITANTE);

	if (nr_seq_cbo_saude_aux_w IS NOT NULL AND nr_seq_cbo_saude_aux_w::text <> '') and (nr_seq_cbo_saude_aux_w <> c02_w.nr_seq_cbo_saude) then
		index_w				:= index_w + 1;
		nr_seq_conta_w(index_w)		:= c02_w.nr_seq_conta;
		nr_seq_cbo_saude_novo_w(index_w)	:= nr_seq_cbo_saude_aux_w;
		nr_seq_cbo_saude_ant_w(index_w)	:= c02_w.nr_seq_cbo_saude;
	end if;


	if (index_w	>= 4000) then

		for i in nr_seq_conta_w.first..nr_seq_conta_w.count loop
			CALL exec_sql_dinamico('TASY_IMP', 'insert into LOG_MONIT_CBO_SAUDE( NR_SEQ_CONTA,NR_SEQ_CBO_SAUDE,NR_SEQ_CBO_SAUDE_NOVO) '||
					' values ( '  || nr_seq_conta_w(i) || ',' || nr_seq_cbo_saude_ant_w(i) || ','|| nr_seq_cbo_saude_novo_w(i) || ')');
		end loop;

		commit;

		forall i in nr_seq_conta_w.first..nr_seq_conta_w.last
			update	pls_conta
			set	nr_seq_cbo_saude	= nr_seq_cbo_saude_novo_w(i)
			where	nr_sequencia		= nr_seq_conta_w(i);

		commit;

		nr_seq_conta_w.delete;
		nr_seq_cbo_saude_novo_w.delete;
		nr_seq_cbo_saude_ant_w.delete;

		index_w	:= 0;
	end if;
end loop;

if (nr_seq_conta_w.count > 0) then
	forall i in nr_seq_conta_w.first..nr_seq_conta_w.last
		update	pls_conta
		set	nr_seq_cbo_saude	= nr_seq_cbo_saude_novo_w(i)
		where	nr_sequencia		= nr_seq_conta_w(i);

	commit;

	for i in nr_seq_conta_w.first..nr_seq_conta_w.count loop
		CALL exec_sql_dinamico('TASY_IMP', 'insert into LOG_MONIT_CBO_SAUDE( NR_SEQ_CONTA,NR_SEQ_CBO_SAUDE,NR_SEQ_CBO_SAUDE_NOVO) '||
				' values ( '  || nr_seq_conta_w(i) || ',' || nr_seq_cbo_saude_ant_w(i) || ','|| nr_seq_cbo_saude_novo_w(i) || ')');
	end loop;

	commit;

	nr_seq_conta_w.delete;
	nr_seq_cbo_saude_novo_w.delete;
	nr_seq_cbo_saude_ant_w.delete;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_cbo_conta_tiss () FROM PUBLIC;

