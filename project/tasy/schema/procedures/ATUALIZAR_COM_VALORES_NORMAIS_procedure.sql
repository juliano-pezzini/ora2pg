-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_com_valores_normais (nr_seq_laudo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_medida_w		bigint;
ie_tipo_valor_w		varchar(2);
ds_valor_w		varchar(255);
cd_valor_w		integer;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_medida
	from	medida_exame_laudo b,
		laudo_paciente_medida a
	where	a.nr_seq_medida = b.nr_sequencia
	  and	a.nr_seq_laudo	= nr_seq_laudo_p
	  and	coalesce(a.ds_valor_medida::text, '') = ''
	  and	b.ie_tipo_valor in ('S','SN');


BEGIN

open C01;
loop
fetch C01 into	nr_sequencia_w,
		nr_seq_medida_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	coalesce(max(ds_valor),null),
		coalesce(max(cd_valor),null)
	into STRICT	ds_valor_w,
		cd_valor_w
	from medida_laudo_opcao
	where nr_seq_medida = nr_seq_medida_w
	  and ie_prioridade = (	SELECT min(ie_prioridade)
				from medida_laudo_opcao
				where nr_seq_medida = nr_seq_medida_w);

	update	laudo_paciente_medida
	set	ds_valor_medida = ds_valor_w,
		qt_medida	= cd_valor_w
	where	nr_sequencia	= nr_sequencia_w;

end loop;
close C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_com_valores_normais (nr_seq_laudo_p bigint, nm_usuario_p text) FROM PUBLIC;
