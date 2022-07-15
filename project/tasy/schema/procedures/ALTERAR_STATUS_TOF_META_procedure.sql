-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_tof_meta (nr_seq_meta_hor_p bigint, nm_usuario_p text, dt_final_p timestamp default null, ds_motivo_finaliza_p text default null, ie_finalizacao_p bigint default null, nr_seq_meta_atend_p bigint default null, ie_finalizar_p text default 'N') AS $body$
DECLARE

									
qt_reg_w				bigint;
qt_diaria_ating_w		bigint;
qt_diaria_nao_ating_w	bigint;
qt_diaria_parcial_w		bigint;
ie_tipo_meta_w			varchar(3);
ie_status_w				varchar(1);
ie_status_meta_w		varchar(1);
dt_geracao_w			timestamp;
nr_seq_meta_atend_w		bigint;
qt_porcentagem_w		double precision;
nr_sequencia_w          bigint;									
									

BEGIN

nr_sequencia_w := nr_seq_meta_hor_p;
if (coalesce(nr_sequencia_w,0) = 0) then
    Select max(nr_sequencia)
    into STRICT nr_sequencia_w
    from tof_meta_atend_hor
	where nm_usuario  = nm_usuario_p;
end if;

Select  max(nr_seq_meta_atend),
		 max(ie_status),
		 max(dt_geracao)
into STRICT	nr_seq_meta_atend_w,
		ie_status_meta_w,
		dt_geracao_w
from	tof_meta_atend_hor
where	nr_sequencia = nr_sequencia_w;


select  coalesce(max(a.ie_tipo_meta),'X')
into STRICT	ie_tipo_meta_w
from	tof_meta a,
		tof_meta_atend_hor b,
		tof_meta_atend c
where	a.nr_sequencia = c.nr_seq_meta
and		b.nr_seq_meta_atend = c.nr_sequencia
and		b.nr_sequencia = nr_sequencia_w;

if ( ie_tipo_meta_w = 'U') then

	Select  count(*)
	into STRICT	qt_reg_w
	from	tof_meta_atend_hor
	where	nr_seq_meta_atend = nr_seq_meta_atend_w
	and		(ie_status IS NOT NULL AND ie_status::text <> '')
	and		dt_geracao > dt_geracao_w;

	If (qt_reg_w = 0) then
	
		update 	tof_meta_atend
		set		ie_status 	= ie_status_meta_w,
				nm_usuario  = nm_usuario_p
		where	nr_sequencia = nr_seq_meta_atend_w;
		
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

	end if;


elsif (ie_tipo_meta_w = 'D') then

	Select  count(*)
	into STRICT	qt_reg_w
	from	tof_meta_atend_hor
	where	nr_seq_meta_atend = nr_seq_meta_atend_w;
	
	Select  count(*)
	into STRICT	qt_diaria_ating_w
	from	tof_meta_atend_hor
	where	nr_seq_meta_atend = nr_seq_meta_atend_w
	and		ie_status = 'A';
	
	Select  count(*)
	into STRICT	qt_diaria_nao_ating_w
	from	tof_meta_atend_hor
	where	nr_seq_meta_atend = nr_seq_meta_atend_w
	and		ie_status = 'N';
	
	Select  count(*)
	into STRICT	qt_diaria_parcial_w
	from	tof_meta_atend_hor
	where	nr_seq_meta_atend = nr_seq_meta_atend_w
	and		ie_status = 'P';
	
	if (qt_diaria_nao_ating_w > 0) and (qt_reg_w = qt_diaria_nao_ating_w) then
	
		ie_status_w := 'N';
	
	elsif (qt_diaria_nao_ating_w > 0) then
	
		qt_porcentagem_w := abs(qt_reg_w/qt_diaria_nao_ating_w);
		
		if (qt_porcentagem_w < 5) then
		
			ie_status_w := 'P';
		
		else
	
			ie_status_w := 'N';
		
		end if;
		
	elsif (qt_diaria_parcial_w > 0) then
	
		ie_status_w := 'P';
		
	elsif (qt_reg_w <=  qt_diaria_ating_w) then
	
		ie_status_w := 'A';
	
	end if;

	if (ie_status_w IS NOT NULL AND ie_status_w::text <> '') then
	
		update 	tof_meta_atend
		set		ie_status 	= ie_status_w,
				nm_usuario  = nm_usuario_p
		where	nr_sequencia = nr_seq_meta_atend_w;
		
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
				
	
	end if;
	
end if;

if (ie_finalizar_p = 'S') then	
	CALL finalizar_tof_meta_atend(dt_final_p, ds_motivo_finaliza_p, ie_finalizacao_p, nr_seq_meta_atend_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_tof_meta (nr_seq_meta_hor_p bigint, nm_usuario_p text, dt_final_p timestamp default null, ds_motivo_finaliza_p text default null, ie_finalizacao_p bigint default null, nr_seq_meta_atend_p bigint default null, ie_finalizar_p text default 'N') FROM PUBLIC;

