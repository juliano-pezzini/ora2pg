-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_esforco_gap (nr_seq_gap_p bigint, qt_tempo_horas_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_pais_w			latam_gap.nr_seq_pais%type;
ie_regra_w			smallint;
ie_gap_w			varchar(1);
qt_reg_w			smallint;
vl_base_w			bigint;
qt_result_horas_w		latam_gap.qt_horas_total%type;
qt_tempo_horas_w		latam_gap_regra_esf.qt_horas_regra%type;
nr_seq_regra_w			latam_gap_regra_esf.nr_seq_regra%type;



BEGIN

select	nr_seq_pais
into STRICT	nr_seq_pais_w
from 	latam_gap
where	nr_sequencia = nr_seq_gap_p;

delete from LATAM_GAP_REGRA_ESF where nr_seq_gap = nr_seq_gap_p;

qt_result_horas_w := 0;
ie_gap_w := 'A';


select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'BF'
and	ie_regra_geral = 'S';

if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'BF'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'BF'
and	ie_regra_geral = 'S';

qt_tempo_horas_w :=  coalesce((qt_tempo_horas_p * vl_base_w)/100,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'BF',
			qt_tempo_horas_w);


		ie_gap_w := 'A';
	END;
END IF;

ie_gap_w := 'A';

select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'DO'
and	ie_regra_geral = 'S';


if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'DO'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'DO'
and	ie_regra_geral = 'S';

qt_tempo_horas_w :=  coalesce((qt_tempo_horas_p * vl_base_w)/100,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'DO',
			coalesce(qt_tempo_horas_w,0));

		ie_gap_w := 'A';
	END;
END IF;

ie_gap_w := 'A';

select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'MA'
and	ie_regra_geral = 'S';


if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'MA'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'MA'
and	ie_regra_geral = 'S';

qt_tempo_horas_w :=  coalesce((qt_tempo_horas_p * vl_base_w)/100,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'MA',
			coalesce(qt_tempo_horas_w,0));

		ie_gap_w := 'A';
	END;
END IF;

ie_gap_w := 'A';

select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'TR'
and	ie_regra_geral = 'S';


if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'TR'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'TR'
and	ie_regra_geral = 'S';

qt_tempo_horas_w :=  coalesce((qt_tempo_horas_p * vl_base_w)/100,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'TR',
			coalesce(qt_tempo_horas_w,0));

		ie_gap_w := 'A';
	END;
END IF;

ie_gap_w := 'A';

select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'VA'
and	ie_regra_geral = 'S';


if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'VA'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'VA'
and	ie_regra_geral = 'S';

qt_tempo_horas_w :=  coalesce((qt_tempo_horas_p * vl_base_w)/100,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'VA',
			coalesce(qt_tempo_horas_w,0));

		ie_gap_w := 'A';
	END;
END IF;

ie_gap_w := 'A';

select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'VE'
and	ie_regra_geral = 'S';


if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'VE'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'VE'
and	ie_regra_geral = 'S';

qt_tempo_horas_w :=  coalesce((qt_tempo_horas_p * vl_base_w)/100,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'VE',
			coalesce(qt_tempo_horas_w,0));
	END;
END IF;

ie_gap_w := 'A';

select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'SI'
and	ie_regra_geral = 'S';


if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'SI'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'SI'
and	ie_regra_geral = 'S';

qt_tempo_horas_w := coalesce((qt_tempo_horas_p * vl_base_w)/100,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'SI',
			coalesce(qt_tempo_horas_w,0));
	END;
END IF;

ie_gap_w := 'A';

select	count(*)
into STRICT	ie_regra_w
from	LATAM_REGRA_ESFORCO
where	nr_seq_gap = nr_seq_gap_p
and	ie_tipo_regra = 'VF'
and	ie_regra_geral = 'S';


if (ie_regra_w = 0) then
	begin
		select	count(*)
		into STRICT	ie_regra_w
		from	LATAM_REGRA_ESFORCO
		where	nr_seq_pais = nr_seq_pais_w
		and	ie_tipo_regra = 'VF'
		and	ie_regra_geral = 'S';

	if (ie_regra_w > 0) then
		begin
			ie_gap_w := 'C';
		end;
	end if;
	end;
else
	begin
		ie_gap_w := 'G';
	end;
end if;

select	max(coalesce(vl_regra,0)),
	max(nr_sequencia)
into STRICT	vl_base_w,
	nr_seq_regra_w
from	latam_regra_esforco
where	((nr_seq_gap = nr_seq_gap_p and ie_gap_w = 'G' ) or (ie_gap_w = 'C' and nr_seq_pais = nr_seq_pais_w) or ( ie_gap_w = 'A' and coalesce(nr_seq_pais::text, '') = '' and coalesce(nr_seq_gap::text, '') = ''))
and	ie_tipo_regra = 'VF'
and	ie_regra_geral = 'S';

qt_tempo_horas_w :=  coalesce(vl_base_w,0);

qt_result_horas_w := qt_result_horas_w + qt_tempo_horas_w;

IF (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') THEN
	BEGIN
		insert into LATAM_GAP_REGRA_ESF(nr_seq_gap,
						nr_seq_regra,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec,
						ie_tipo_regra,
						qt_horas_regra)
		values (nr_seq_gap_p,
			nr_seq_regra_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			'VF',
			coalesce(qt_tempo_horas_w,0));
	END;
END IF;

update	latam_gap a
set	a.qt_horas_total = (SELECT sum(coalesce(b.qt_horas_regra,0)) + coalesce(latam_obter_dados_gap(a.nr_sequencia,'TG'),0) from latam_gap_regra_esf b where b.nr_seq_gap = a.nr_sequencia)
where	a.nr_sequencia = nr_seq_gap_p;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_esforco_gap (nr_seq_gap_p bigint, qt_tempo_horas_p bigint, nm_usuario_p text) FROM PUBLIC;
