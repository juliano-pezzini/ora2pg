-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_tipo_medida ( nr_seq_laudo_p bigint, nr_seq_grupo_medida_p bigint) RETURNS varchar AS $body$
DECLARE



nr_seq_tipo_w	bigint;
ds_lista_tipo_w	varchar(255);


c01 CURSOR FOR
SELECT	c.nr_sequencia nr_seq_tipo
from   	laudo_medida_grupo_item d,
	tipo_medida_laudo c,
	medida_exame_laudo b,
	laudo_paciente_medida a
where  	a.nr_seq_medida = b.nr_sequencia
and    	b.nr_seq_tipo_medida = c.nr_sequencia
and    	c.nr_sequencia = d.nr_tipo_medida
and    	d.nr_seq_grupo_medida =  nr_seq_grupo_medida_p
and    	a.nr_seq_laudo  =  nr_seq_laudo_p
and	(nr_seq_grupo_medida_p IS NOT NULL AND nr_seq_grupo_medida_p::text <> '')
group by coalesce(c.nr_seq_apresent,999), c.nr_sequencia

union

select	c.nr_sequencia nr_seq_tipo
from   tipo_medida_laudo c, medida_exame_laudo b, laudo_paciente_medida a
where  a.nr_seq_medida = b.nr_sequencia
and    b.nr_seq_tipo_medida = c.nr_sequencia
and    a.nr_seq_laudo  =  nr_seq_laudo_p
and	coalesce(nr_seq_grupo_medida_p::text, '') = ''
group by coalesce(c.nr_seq_apresent,999),c.nr_sequencia;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_tipo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ds_lista_tipo_w IS NOT NULL AND ds_lista_tipo_w::text <> '') then
		ds_lista_tipo_w := substr(ds_lista_tipo_w || ', ',1,255);
	end if;

	ds_lista_tipo_w	:= substr(ds_lista_tipo_w || nr_seq_tipo_w,1,255);

	end;
end loop;
close c01;


return	ds_lista_tipo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_tipo_medida ( nr_seq_laudo_p bigint, nr_seq_grupo_medida_p bigint) FROM PUBLIC;

