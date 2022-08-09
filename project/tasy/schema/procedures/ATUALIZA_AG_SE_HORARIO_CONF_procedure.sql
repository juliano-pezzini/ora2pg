-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_ag_se_horario_conf ( nr_seq_agenda_int_p bigint, ie_status_p text) AS $body$
DECLARE

							
nr_seq_agenda_exame_w	agenda_integrada_item.nr_seq_agenda_exame%type;
nr_seq_agenda_cons_w	agenda_integrada_item.nr_seq_agenda_cons%type;
cd_pessoa_fisica_w	varchar(10);
nm_paciente_w		varchar(60);
dt_nascimento_w		timestamp;
qt_idade_w		smallint;
qt_idade_meses_w	bigint;
						
C01 CURSOR FOR
	SELECT	a.nr_seq_agenda_exame,
			a.nr_seq_agenda_cons
	FROM 	agenda_integrada_item a
	WHERE ((a.nr_seq_agenda_exame IS NOT NULL AND a.nr_seq_agenda_exame::text <> '')
	or		(a.nr_seq_agenda_cons IS NOT NULL AND a.nr_seq_agenda_cons::text <> ''))
	and		a.nr_seq_agenda_int	= nr_seq_agenda_int_p;

BEGIN	

/* ie_status_p  R - Rervada / A - Agendado */

select	max(b.cd_pessoa_fisica),
		max(b.nm_paciente),
		max(to_date(substr(obter_dados_pf(cd_pessoa_fisica_w,'DN'),1,10),'dd/mm/yyyy')),
		max((substr(obter_dados_pf(cd_pessoa_fisica_w,'I'),1,3))::numeric ),
		max((obter_idade(to_date(obter_dados_pf(cd_pessoa_fisica_w,'DN'),'dd/mm/yyyy'),clock_timestamp(),'MM'))::numeric )
into STRICT	cd_pessoa_fisica_w,
		nm_paciente_w,
		dt_nascimento_w,
		qt_idade_w,
		qt_idade_meses_w
from	agenda_integrada b
where	b.nr_sequencia	= nr_seq_agenda_int_p;

OPEN C01;
LOOP
FETCH C01 INTO
      nr_seq_agenda_exame_w,
      nr_seq_agenda_cons_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	if (nr_seq_agenda_exame_w IS NOT NULL AND nr_seq_agenda_exame_w::text <> '') then
		update 	agenda_paciente a
		set	a.cd_pessoa_fisica	= cd_pessoa_fisica_w,
			a.nm_paciente		= nm_paciente_w,
			a.dt_nascimento_pac	= dt_nascimento_w,
			a.qt_idade_paciente	= qt_idade_w,
			a.qt_idade_meses	= qt_idade_meses_w,
			a.dt_atualizacao	= clock_timestamp(),
			a.nm_usuario_reserva	= CASE WHEN ie_status_p='R' THEN null  ELSE a.nm_usuario_reserva END ,
			a.dt_reserva		= CASE WHEN ie_status_p='R' THEN null  ELSE a.dt_reserva END ,
			a.ie_status_agenda	= CASE WHEN ie_status_p='R' THEN 'N'  ELSE a.ie_status_agenda END
		where	a.nr_sequencia		= nr_seq_agenda_exame_w;
	else
		update 	agenda_consulta a
		set	a.cd_pessoa_fisica	= cd_pessoa_fisica_w,
			a.nm_paciente		= nm_paciente_w,
			a.dt_nascimento_pac	= dt_nascimento_w,
			a.qt_idade_pac		= qt_idade_w,
			a.dt_atualizacao	= clock_timestamp(),
			a.ie_status_agenda	= CASE WHEN ie_status_p='R' THEN 'N'  ELSE a.ie_status_agenda END
		where	a.nr_sequencia		= nr_seq_agenda_cons_w;
	end if;
END LOOP;
CLOSE C01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_ag_se_horario_conf ( nr_seq_agenda_int_p bigint, ie_status_p text) FROM PUBLIC;
