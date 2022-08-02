-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_evento_regra_tempo ( qt_tempo_p bigint, nr_seq_tipo_ocorrencia_p bigint, nr_seq_evento_p bigint, ds_regra_p INOUT text, ds_cor_p INOUT text, qt_tempo_maximo_p INOUT bigint, nr_seq_regra_p INOUT bigint) AS $body$
DECLARE


ds_regra_w		varchar(255);
ds_cor_w		varchar(40);
qt_tempo_maximo_w	bigint;
qt_tempo_maximo_ww	bigint;
nr_seq_regra_w		bigint;
nr_seq_evento_w		bigint;


C01 CURSOR FOR
	SELECT	ds_regra,
			ds_cor,
			qt_tempo_maximo,
			nr_sequencia
	from	(
		SELECT	ds_regra,
				ds_cor,
				qt_tempo_maximo,
				nr_sequencia
		from	pls_regra_tempo_event_ocor
		where	ie_situacao		= 'A'
		and		qt_tempo_maximo		>= qt_tempo_p
		and		nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
		and (pls_obter_se_controle_estab('GA') = 'S' and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento ))
		and		((nr_seq_evento = nr_seq_evento_w)
		or (coalesce(nr_seq_evento::text, '') = ''
		and	not exists (	select 	1
					from 	pls_regra_tempo_event_ocor
					where	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
					and	nr_seq_evento = nr_seq_evento_w)))
		
union all

		select	ds_regra,
				ds_cor,
				qt_tempo_maximo,
				nr_sequencia
		from	pls_regra_tempo_event_ocor
		where	ie_situacao		= 'A'
		and		qt_tempo_maximo		>= qt_tempo_p
		and		nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
		and (pls_obter_se_controle_estab('GA') = 'N')
		and		((nr_seq_evento = nr_seq_evento_w)
		or (coalesce(nr_seq_evento::text, '') = ''
		and	not exists (	select 	1
					from 	pls_regra_tempo_event_ocor
					where	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
					and	nr_seq_evento = nr_seq_evento_w))))
	--and	nvl(nr_seq_evento,nr_seq_evento_w) = nr_seq_evento_w
	order by qt_tempo_maximo desc;


BEGIN
nr_seq_evento_w := coalesce(nr_seq_evento_p,0);
open C01;
loop
fetch C01 into
	ds_regra_w,
	ds_cor_w,
	qt_tempo_maximo_w,
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (coalesce(ds_regra_w::text, '') = '') then
	if (pls_obter_se_controle_estab('GA') = 'S') then
		begin
			select	max(qt_tempo_maximo)
			into STRICT	qt_tempo_maximo_ww
			from	pls_regra_tempo_event_ocor
			where	ie_situacao 		= 'A'
			and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
			and	nr_seq_evento 		= nr_seq_evento_w
			and (cd_estabelecimento 	= wheb_usuario_pck.get_cd_estabelecimento );

			if (coalesce(qt_tempo_maximo_ww,0) > 0) then
				select	nr_sequencia
				into STRICT	nr_seq_regra_w
				from	pls_regra_tempo_event_ocor
				where	ie_situacao 		= 'A'
				and	qt_tempo_maximo 	= qt_tempo_maximo_ww
				and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
				and	nr_seq_evento 		= nr_seq_evento_w
				and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento );
			else
				select	max(qt_tempo_maximo)
				into STRICT	qt_tempo_maximo_ww
				from	pls_regra_tempo_event_ocor
				where	ie_situacao 		= 'A'
				and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
				and	coalesce(nr_seq_evento::text, '') = ''
				and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento );

				select	nr_sequencia
				into STRICT	nr_seq_regra_w
				from	pls_regra_tempo_event_ocor
				where	ie_situacao 		= 'A'
				and	qt_tempo_maximo 	= qt_tempo_maximo_ww
				and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
				and	coalesce(nr_seq_evento::text, '') = ''
				and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento );
			end if;

			select	ds_regra,
				ds_cor,
				qt_tempo_maximo,
				nr_sequencia
			into STRICT	ds_regra_w,
				ds_cor_w,
				qt_tempo_maximo_w,
				nr_seq_regra_w
			from	pls_regra_tempo_event_ocor
			where	nr_sequencia = nr_seq_regra_w;
		exception
		when others then
			ds_regra_w		:= '';
			ds_cor_w		:= 'clBtnFace';
			qt_tempo_maximo_w	:= 0;
			nr_seq_regra_w		:= 0;
		end;
	else
		begin
			select	max(qt_tempo_maximo)
			into STRICT	qt_tempo_maximo_ww
			from	pls_regra_tempo_event_ocor
			where	ie_situacao = 'A'
			and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
			and	nr_seq_evento = nr_seq_evento_w;

			if (coalesce(qt_tempo_maximo_ww,0) > 0) then
				select	nr_sequencia
				into STRICT	nr_seq_regra_w
				from	pls_regra_tempo_event_ocor
				where	ie_situacao = 'A'
				and	qt_tempo_maximo = qt_tempo_maximo_ww
				and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
				and	nr_seq_evento = nr_seq_evento_w;
			else
				select	max(qt_tempo_maximo)
				into STRICT	qt_tempo_maximo_ww
				from	pls_regra_tempo_event_ocor
				where	ie_situacao = 'A'
				and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
				and	coalesce(nr_seq_evento::text, '') = '';

				select	nr_sequencia
				into STRICT	nr_seq_regra_w
				from	pls_regra_tempo_event_ocor
				where	ie_situacao = 'A'
				and	qt_tempo_maximo = qt_tempo_maximo_ww
				and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_p
				and	coalesce(nr_seq_evento::text, '') = '';
			end if;

			select	ds_regra,
				ds_cor,
				qt_tempo_maximo,
				nr_sequencia
			into STRICT	ds_regra_w,
				ds_cor_w,
				qt_tempo_maximo_w,
				nr_seq_regra_w
			from	pls_regra_tempo_event_ocor
			where	nr_sequencia = nr_seq_regra_w;
		exception
		when others then
			ds_regra_w		:= '';
			ds_cor_w		:= 'clBtnFace';
			qt_tempo_maximo_w	:= 0;
			nr_seq_regra_w		:= 0;
		end;
	end if;
end if;

ds_regra_p		:= ds_regra_w;
ds_cor_p		:= ds_cor_w;
qt_tempo_maximo_p	:= qt_tempo_maximo_w;
nr_seq_regra_p		:= nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_evento_regra_tempo ( qt_tempo_p bigint, nr_seq_tipo_ocorrencia_p bigint, nr_seq_evento_p bigint, ds_regra_p INOUT text, ds_cor_p INOUT text, qt_tempo_maximo_p INOUT bigint, nr_seq_regra_p INOUT bigint) FROM PUBLIC;

