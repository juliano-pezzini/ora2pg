-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_seq_brasindice_preco () AS $body$
DECLARE


qt_registros_w		bigint;
qt_reg_atualizacao_w	bigint;
i			bigint;

cd_laboratorio_w	varchar(6);
cd_medicamento_w	varchar(6);
cd_apresentacao_w	varchar(6);
dt_inicio_vigencia_w	timestamp;
ie_tipo_preco_w		varchar(3);

C01 CURSOR FOR
	SELECT	cd_laboratorio,
		cd_medicamento,
		cd_apresentacao,
		dt_inicio_vigencia,
		ie_tipo_preco
	from	brasindice_preco
	where	coalesce(nr_sequencia::text, '') = ''
	and 	i < 150000
	order by cd_laboratorio,
		cd_medicamento,
		cd_apresentacao,
		dt_inicio_vigencia,
		ie_tipo_preco;


BEGIN

begin

select 	count(*)
into STRICT	qt_registros_w
from 	brasindice_preco
where	coalesce(nr_sequencia::text, '') = '';

if (qt_registros_w > 0) then

	i:= 0;
	qt_reg_atualizacao_w:= 0;

	open C01;
	loop
	fetch C01 into
		cd_laboratorio_w,
		cd_medicamento_w,
		cd_apresentacao_w,
		dt_inicio_vigencia_w,
		ie_tipo_preco_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		update	brasindice_preco
		set	nr_sequencia = nextval('brasindice_preco_seq')
		where	coalesce(nr_sequencia::text, '') = ''
		and 	cd_laboratorio = cd_laboratorio_w
		and 	cd_medicamento = cd_medicamento_w
		and 	cd_apresentacao = cd_apresentacao_w
		and 	dt_inicio_vigencia = dt_inicio_vigencia_w
		and 	ie_tipo_preco = ie_tipo_preco_w;

		qt_reg_atualizacao_w:= qt_reg_atualizacao_w + 1;
		i:= i + 1;

		if (qt_reg_atualizacao_w > 10000) then
			commit;
			qt_reg_atualizacao_w:= 0;
		end if;

		end;
	end loop;
	close C01;

end if;

exception
	when others then
	qt_registros_w:= 0;
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_seq_brasindice_preco () FROM PUBLIC;
