-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_ajustar_ocorre_atend ( nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


vl_dominio_w			varchar(15);
ds_valor_dominio_w		varchar(255);
nr_seq_tipo_ocorrencia_w	bigint;
ds_ocorrencia_w			varchar(2);

C01 CURSOR FOR
	SELECT	vl_dominio,
		ds_valor_dominio
	from	valor_dominio
	where	cd_dominio = 3182
	order by 1;


BEGIN

open C01;
loop
fetch C01 into
	vl_dominio_w,
	ds_valor_dominio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	nextval('pls_tipo_ocorrencia_seq')
	into STRICT	nr_seq_tipo_ocorrencia_w
	;

	select	coalesce(max('N'),'S')
	into STRICT	ds_ocorrencia_w
	from	pls_tipo_ocorrencia
	where	upper(ds_tipo_ocorrencia) like upper(ds_valor_dominio_w);

	if (ds_ocorrencia_w = 'S') then
		insert into pls_tipo_ocorrencia(nr_sequencia, ie_situacao, cd_estabelecimento,
			ds_tipo_ocorrencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec)
		values (nr_seq_tipo_ocorrencia_w, 'A', cd_estabelecimento_p,
			ds_valor_dominio_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(),nm_usuario_p);

		update	pls_evento_ocorrencia
		set	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_w
		where	ie_tipo_ocorrencia	= vl_dominio_w;

		update	pls_atendimento_evento
		set	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_w
		where	ie_tipo_ocorrencia	= vl_dominio_w;
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
-- REVOKE ALL ON PROCEDURE pls_baca_ajustar_ocorre_atend ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

