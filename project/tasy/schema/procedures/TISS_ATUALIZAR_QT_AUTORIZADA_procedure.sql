-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_atualizar_qt_autorizada (nr_sequencia_autor_p text, cd_procedimento_p text, qt_autorizada_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


cd_procedimento_w		varchar(20);
nr_sequencia_w		bigint;
qt_autorizada_w		double precision;
qt_solicitada_w		double precision;
ds_tipo_w		varchar(1);
qt_aprovada_w		double precision;

c01 CURSOR FOR
SELECT	nr_sequencia,
	qt_solicitada,
	'P'
from	procedimento_autorizado
where	nr_sequencia_autor	= nr_sequencia_autor_p
and (cd_procedimento		= (cd_procedimento_w)::numeric  or
	cd_procedimento_tuss		= cd_procedimento_w or
	cd_procedimento_convenio	= cd_procedimento_p)
and	coalesce(qt_autorizada,0) 		= 0

union

select	nr_sequencia,
	qt_solicitada,
	'M'
from	material_autorizado
where	nr_sequencia_autor	= nr_sequencia_autor_p
and (cd_material		= (cd_procedimento_w)::numeric  or
	cd_material_convenio	= cd_procedimento_w)
and	coalesce(qt_autorizada,0) 		= 0;


BEGIN

select	ltrim(replace(cd_procedimento_p,'.',''),'0'),
	(replace(qt_autorizada_p,'.',','))::numeric
into STRICT	cd_procedimento_w,
	qt_autorizada_w
;

	open	c01;
	loop
	fetch	c01 into
		nr_sequencia_w,
		qt_solicitada_w,
		ds_tipo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if (qt_solicitada_w > qt_autorizada_w) then
		qt_aprovada_w := qt_autorizada_w;
		qt_autorizada_w := 0;
	else
		qt_aprovada_w :=  qt_solicitada_w;
		qt_autorizada_w := qt_autorizada_w  - qt_solicitada_w;
	end if;

	if (coalesce(ds_tipo_w,'P') = 'M') then

		if (coalesce(qt_autorizada_w,0) > 0)then

			update	material_autorizado
			set	qt_autorizada	= qt_aprovada_w,
				ds_observacao	= substr(ds_observacao_p,1,1999),
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_sequencia_w;
		end if;


	else
		if (coalesce(qt_autorizada_w,0) > 0)then

			update	procedimento_autorizado
			set	qt_autorizada	= qt_aprovada_w,
				ds_observacao	= substr(ds_observacao_p,1,1999),
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_sequencia_w;
		end if;

	end if;

end	loop;
close	c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_atualizar_qt_autorizada (nr_sequencia_autor_p text, cd_procedimento_p text, qt_autorizada_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
