-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE administrar_alerta_tasy (cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_sequencia_w		numeric(22);
qt_min_repeticao_w		numeric(22);
qt_seg_limite_w		numeric(22);
qt_seg_proc_w		double precision;
ds_observacao_w		varchar(255);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nm_usuario_w		usuario.nm_usuario%type;

c01 CURSOR FOR
SELECT	nr_sequencia,
	qt_min_repeticao,
	qt_seg_limite,
	cd_estabelecimento
from	alerta_tasy
where	ie_situacao	= 'A'
and	dt_proximo_proc 	<= clock_timestamp();


BEGIN

OPEN C01;
LOOP
FETCH C01 into	
	nr_sequencia_w,
	qt_min_repeticao_w,
	qt_seg_limite_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select 	coalesce(max(nm_usuario),'Job')
	into STRICT 	nm_usuario_w
	from 	usuario
	where 	upper(nm_usuario) = 'JOB';
	
	qt_seg_proc_w := gerar_alerta_tasy(nr_sequencia_w, nm_usuario_w, qt_seg_proc_w);
	if (qt_seg_proc_w > qt_seg_limite_w) then

		--ds_observacao_w	:= substr('Inativado pela procedure (Administrar_alerta_tasy) em ' || to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'),1,255);
		ds_observacao_w	:= substr(replace(obter_desc_expressao_idioma(346396,null,get_seq_language_establishment(cd_estabelecimento_w)),'#@DT_EVENTO#@',to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss')),1,255);

		update	alerta_tasy
		set	ie_situacao = 'I',
			ds_observacao = ds_observacao_w,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = 'Tasy'
		where	nr_sequencia	= nr_sequencia_w;

	else
		update	alerta_tasy
		set	dt_ultimo_proc	= clock_timestamp(),
			dt_proximo_proc	= clock_timestamp() + qt_min_repeticao_w / 1440
		where	nr_sequencia	= nr_sequencia_w;
	end if;
	end;
END LOOP;
CLOSE C01;

COMMIT;

exception
when others then
	null;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE administrar_alerta_tasy (cd_estabelecimento_p bigint) FROM PUBLIC;

