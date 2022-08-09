-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_conta_proc_imp ( nr_seq_conta_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_procedimento_w			double precision;
qt_inconsistencias_w			bigint;
nr_seq_conta_w				bigint;
ie_status_proc_w			varchar(255);
vl_liberado_proc_w			double precision;
ie_status_conta_w			varchar(255);


BEGIN

begin
select	1
into STRICT	qt_inconsistencias_w
from	ptu_intercambio_consist
where	nr_seq_procedimento	= nr_seq_conta_proc_p  LIMIT 1;
exception
when others then
	qt_inconsistencias_w	:= 0;
end;

select	a.vl_procedimento,
	a.nr_seq_conta,
	a.ie_status,
	a.vl_liberado,
	b.ie_status
into STRICT	vl_procedimento_w,
	nr_seq_conta_w,
	ie_status_proc_w,
	vl_liberado_proc_w,
	ie_status_conta_w
from	pls_conta_proc a,
	pls_conta b
where	a.nr_seq_conta	= b.nr_sequencia
and	a.nr_sequencia	= nr_seq_conta_proc_p;

if (qt_inconsistencias_w = 0) and (vl_procedimento_w <> 0) then
	if (ie_status_proc_w <> 'S') or (vl_liberado_proc_w <> vl_procedimento_w) then
		update	pls_conta_proc
		set	vl_liberado	= vl_procedimento_w,
			ie_status	= 'S'
		where	nr_sequencia	= nr_seq_conta_proc_p
		and	ie_status 	<> 'D';
	end if;

	begin
	select	1
	into STRICT	qt_inconsistencias_w
	from	ptu_intercambio_consist
	where	nr_seq_conta	= nr_seq_conta_w  LIMIT 1;
	exception
	when others then
		qt_inconsistencias_w	:= 0;
	end;

	if (qt_inconsistencias_w = 0) then
		begin
		select	1
		into STRICT	qt_inconsistencias_w
		from	ptu_intercambio_consist  a,
			pls_conta_proc    b
		where	a.nr_seq_procedimento	= b.nr_sequencia
		and	b.nr_seq_conta		= nr_seq_conta_w  LIMIT 1;
		exception
		when others then
			qt_inconsistencias_w	:= 0;
		end;
	end if;

	if (qt_inconsistencias_w = 0) then
		begin
		select	1
		into STRICT	qt_inconsistencias_w
		from	ptu_intercambio_consist  a,
			pls_conta_mat    b
		where	a.nr_seq_material	= b.nr_sequencia
		and	b.nr_seq_conta		= nr_seq_conta_w  LIMIT 1;
		exception
		when others then
			qt_inconsistencias_w	:= 0;
		end;
	end if;

	if (qt_inconsistencias_w = 0) then
		if (ie_status_conta_w <> 'L') then
			update	pls_conta
			set	ie_status	= 'L'
			where	nr_sequencia	= nr_seq_conta_w;
		end if;
	else
		if (ie_status_conta_w <> 'P') then
			update	pls_conta
			set	ie_status	= 'P'
			where	nr_sequencia	= nr_seq_conta_w;
		end if;
	end if;
else
	if (ie_status_conta_w <> 'P') then
		update	pls_conta
		set	ie_status	= 'P'
		where	nr_sequencia	= nr_seq_conta_w;
	end if;

	if (ie_status_proc_w <> 'S') or (vl_liberado_proc_w <> vl_procedimento_w) then
		update	pls_conta_proc
		set	vl_liberado	= vl_procedimento_w,
			ie_status	= 'P'
		where	nr_sequencia	= nr_seq_conta_proc_p
		and	ie_status 	<> 'D';
	end if;
end if;
--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_conta_proc_imp ( nr_seq_conta_proc_p bigint, nm_usuario_p text) FROM PUBLIC;
