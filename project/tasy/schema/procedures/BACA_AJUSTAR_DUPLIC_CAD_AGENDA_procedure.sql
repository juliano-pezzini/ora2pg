-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_duplic_cad_agenda () AS $body$
DECLARE


qt_tabela_w		bigint;
dt_atualizacao_w	varchar(20)	:= to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss');
ds_comando_create_w	varchar(1000);
ds_comando_insert_w	varchar(1000);
ds_agenda_w		varchar(50);
dt_agenda_w		varchar(20);
nr_seq_agenda_w	agenda_consulta.nr_sequencia%type;
cd_pessoa_fisica_w	varchar(10);
nm_pessoa_fisica_w	varchar(60);
nm_paciente_w		varchar(60);

c01 CURSOR FOR
SELECT		substr(a.ds_agenda,1,50),
		to_char(b.dt_agenda,'dd/mm/yyyy hh24:mi:ss'),
		b.nr_sequencia,
		b.cd_pessoa_fisica,
		substr(b.nm_pessoa_fisica,1,60), 
		substr(b.nm_paciente,1,60)
from   	agenda a,
       	agenda_consulta_v b
where  	a.cd_agenda		= b.cd_agenda
and    	b.dt_atualizacao 	> clock_timestamp() - interval '365 days'
and    	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '')
and		b.nm_pessoa_fisica 	<> b.nm_paciente
order by	1,2,5,6,3,4;


BEGIN

select	coalesce(count(*),0)
into STRICT	qt_tabela_w
from	tab
where	upper(tname) = 'MED_AGE_DUPLIC';

if (qt_tabela_w = 0) then
	ds_comando_create_w	:=	'create	table	MED_AGE_DUPLIC	(				'||
					'				ds_agenda		varchar2(50),		'||
					'				dt_agenda		varchar2(20),		'||
					'				nr_seq_agenda		number(10,0),		'||
					'				cd_pessoa_fisica	varchar2(10),		'||
					'				nm_pessoa_fisica	varchar2(60),		'||
					'				nm_paciente		varchar2(60),		'||
					'				dt_atualizacao	varchar2(20),		'||
					'				nm_usuario		varchar2(15))	';
	CALL exec_sql_dinamico('TASY', ds_comando_create_w);
	commit;
end if;

OPEN C01;
LOOP
FETCH C01 into	ds_agenda_w,
		dt_agenda_w,
		nr_seq_agenda_w,
		cd_pessoa_fisica_w,
		nm_pessoa_fisica_w,
		nm_paciente_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
		ds_comando_insert_w	:=	'insert	into	med_age_duplic	(				'||
						'				ds_agenda,					'||
						'				dt_agenda,					'||
						'				nr_seq_agenda,				'||
						'				cd_pessoa_fisica,				'||
						'				nm_pessoa_fisica,				'||
						'				nm_paciente,					'||
						'				dt_atualizacao,				'||
						'				nm_usuario)					'||
						'			values	(						'||
										CHR(39) || ds_agenda_w || CHR(39)	 	 ||','||
										CHR(39) || dt_agenda_w || CHR(39)	 	 ||','||
										nr_seq_agenda_w			  	 ||','||
										CHR(39) || cd_pessoa_fisica_w || CHR(39) 	 ||','||	
										CHR(39) || nm_pessoa_fisica_w || CHR(39)  ||','||	
										CHR(39) || nm_paciente_w      || CHR(39)  ||','||	
										CHR(39) || dt_atualizacao_w   || CHR(39)  ||','||		
										CHR(39) || 'TASY' || CHR(39)  ||')';
		CALL exec_sql_dinamico('TASY', ds_comando_insert_w);
		
		update	agenda_consulta
		set	nm_paciente		= nm_pessoa_fisica_w
		where	nr_sequencia		= nr_seq_agenda_w;
END LOOP;
CLOSE C01;

COMMIT;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_duplic_cad_agenda () FROM PUBLIC;
