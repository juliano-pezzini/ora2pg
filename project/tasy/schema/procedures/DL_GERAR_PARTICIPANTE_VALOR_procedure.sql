-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dl_gerar_participante_valor ( nr_seq_reuniao_p bigint, vl_reuniao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
ie_presente_w		varchar(255);
nr_seq_motivo_aus_w	bigint;
ie_ausencia_w		varchar(255);

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_presente,
		a.nr_seq_motivo_aus
	from	dl_reuniao_socio a
	where	a.nr_seq_reuniao	= nr_seq_reuniao_p
	order by a.nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	ie_presente_w,
	nr_seq_motivo_aus_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_presente_w = 'S') then
		update	dl_reuniao_socio
		set	vl_reuniao	= vl_reuniao_p
		where	nr_sequencia	= nr_sequencia_w
		and	nr_seq_reuniao	= nr_seq_reuniao_p;
	else

		if	(nr_seq_motivo_aus_w IS NOT NULL AND nr_seq_motivo_aus_w::text <> '') then

			select	ie_ausencia
			into STRICT	ie_ausencia_w
			from 	dl_motivo_ausencia
			where 	nr_sequencia	= nr_seq_motivo_aus_w;

			if (ie_ausencia_w = 'J') then
				update	dl_reuniao_socio
				set	vl_reuniao	= vl_reuniao_p
				where	nr_sequencia	= nr_sequencia_w
				and	nr_seq_reuniao	= nr_seq_reuniao_p;
			else
				update	dl_reuniao_socio
				set	vl_reuniao	= 0
				where	nr_sequencia	= nr_sequencia_w
				and	nr_seq_reuniao	= nr_seq_reuniao_p;
			end if;

		else
			update	dl_reuniao_socio
			set	vl_reuniao	= 0
			where	nr_sequencia	= nr_sequencia_w
			and	nr_seq_reuniao	= nr_seq_reuniao_p;
		end if;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dl_gerar_participante_valor ( nr_seq_reuniao_p bigint, vl_reuniao_p bigint, nm_usuario_p text) FROM PUBLIC;

