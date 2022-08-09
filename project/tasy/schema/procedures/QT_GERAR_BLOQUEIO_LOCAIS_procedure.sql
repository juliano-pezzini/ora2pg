-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_gerar_bloqueio_locais (dt_inicial_p timestamp, dt_final_p timestamp, hr_inicial_p text, hr_final_p text, ds_observacao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


hr_inicial_w	timestamp;
hr_final_w	timestamp;
nr_seq_local_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	qt_local
	where	coalesce(ie_situacao,'A') = 'A';


BEGIN

if (hr_inicial_p IS NOT NULL AND hr_inicial_p::text <> '') then
	hr_inicial_w	:= to_date('30/12/1899 '||hr_inicial_p,'dd/mm/yyyy hh24:mi:ss');
else
	hr_inicial_w	:= null;
end if;

if (hr_final_p IS NOT NULL AND hr_final_p::text <> '') then
	hr_final_w	:= to_date('30/12/1899 '||hr_final_p,'dd/mm/yyyy hh24:mi:ss');
else
	hr_final_w	:= null;
end if;

open C01;
loop
fetch C01 into
	nr_seq_local_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into qt_bloqueio(
				 nr_sequencia,
				 nr_seq_local,
				 dt_atualizacao,
				 nm_usuario,
				 dt_atualizacao_nrec,
				 nm_usuario_nrec,
				 dt_inicial,
				 dt_final,
				 hr_inicio_bloqueio,
				 hr_final_bloqueio,
				 ds_observacao)
			values ( nextval('qt_bloqueio_seq'),
				 nr_seq_local_w,
				 clock_timestamp(),
				 nm_usuario_p,
				 clock_timestamp(),
				 nm_usuario_p,
				 dt_inicial_p,
				 dt_final_p,
				 hr_inicial_w,
				 hr_final_w,
				 ds_observacao_p);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_gerar_bloqueio_locais (dt_inicial_p timestamp, dt_final_p timestamp, hr_inicial_p text, hr_final_p text, ds_observacao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
